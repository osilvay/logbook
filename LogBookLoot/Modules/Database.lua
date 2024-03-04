---@class LBL_Database
local LBL_Database = LB_ModuleLoader:CreateModule("LBL_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LBZ_Database
local LBZ_Database = LB_ModuleLoader:ImportModule("LBZ_Database")

local items = {}

function LBL_Database:Initialize()
  C_Timer.After(1, function()
    LBL_Database:UpdateDatabase(false)
  end)
end

local updateDbTimeoutTicker = nil
---Starts auto update database
function LBL_Database:StartAutoUpdateDatabase()
  local updateDbTimeout = LogBookLoot.db.char.general.loot.updateDbTimeout
  if updateDbTimeoutTicker == nil then
    local message = string.format(LogBook:LB_i18n("Starting database auto update: %s"), LogBookLoot:MessageWithAddonColor(LogBookLoot:LBL_i18n("Loot")))
    LogBook:Print(message)
    updateDbTimeoutTicker = C_Timer.NewTicker(updateDbTimeout * 60, function()
      LBL_Database:UpdateDatabase()
    end)
  end
end

---Cancels auto update database
function LBL_Database:CancelAutoUpdateDatabase()
  if updateDbTimeoutTicker ~= nil then
    local message = string.format(LogBook:LB_i18n("Cancelling database auto update: %s"), LogBookLoot:MessageWithAddonColor(LogBookLoot:LBL_i18n("Loot")))
    LogBook:Print(message)
    updateDbTimeoutTicker:Cancel()
    updateDbTimeoutTicker = nil
  end
end

---Update enchanting database
---@param silent? boolean
function LBL_Database:UpdateDatabase(silent)
  if silent == nil then silent = false end
  local lootDb = LogBookLoot.db.global.data.loot
  items = {}

  for itemID, currentLoot in pairs(lootDb) do
    local isTradeSkill = currentLoot["IsTradeSkill"] or false
    local mobs = currentLoot["Mobs"] or {}

    if itemID ~= 0 then
      local processedMobs = {}
      if not LB_CustomFunctions:TableIsEmpty(mobs) then
        for mobIndex, mobData in pairs(mobs) do
          table.insert(processedMobs, LBL_Database:ProcessMobsInItem(itemID, mobIndex, mobData))
        end
      end

      local tradeskills = {}
      local tradeSkillInfo = currentLoot["TradeSkillInfo"] or {}
      if isTradeSkill and not LB_CustomFunctions:TableIsEmpty(tradeSkillInfo) then
        tradeskills = LBL_Database:ProcessTradeSkillInItem(itemID, tradeSkillInfo)
      end

      local result = LBL_Database:ProcessResult(processedMobs, tradeskills)
      items[itemID] = {
        ItemName = currentLoot.ItemName,
        ItemLink = currentLoot.ItemLink,
        Quality = currentLoot.Quality,
        Mobs = processedMobs,
        TradeSkill = tradeskills,
        Result = result
      }
    end
  end
  LogBookLoot.db.global.data.items = items

  if not silent then
    local message = string.format(LogBook:LB_i18n("%s database update: %s"), LogBookLoot:MessageWithAddonColor(LogBookLoot:LBL_i18n("Loot")), string.format("|cff03f303%s|r", LogBook:LB_i18n("Done!")))
    LogBook:Print(message)
  end
end

---Update mob list in item
---@param itemID number
---@param mobIndex string
---@param mobData table
---@return table
function LBL_Database:ProcessMobsInItem(itemID, mobIndex, mobData)
  local mobIndexValues = {}
  local indexValue = 1
  for value in string.gmatch(mobIndex, "([^:]+)") do
    mobIndexValues[indexValue] = value
    indexValue = indexValue + 1
  end
  local quantity = mobData.Quantity or 0

  -- arreglo de cantidad
  if quantity > 9999999 then quantity = 10000 end

  local mobQuality = LogBookMobs.db.global.data.mobs[mobIndex]["mobData"]["mobQuality"] or ""

  return {
    Name = mobIndexValues[1],
    Level = mobIndexValues[2],
    Quality = mobQuality,
    MobIndex = mobIndex,
    GUID = mobData.GUID,
    IsCreature = mobData.IsCreature,
    Quantity = quantity,
  }
end

---Proccess tradeskills
---@param itemID string
---@param tradeSkillInfo table
---@return table
function LBL_Database:ProcessTradeSkillInItem(itemID, tradeSkillInfo)
  local result = {}
  if tradeSkillInfo ~= nil then
    if tradeSkillInfo.name == "Herbalism" or tradeSkillInfo.name == "Mining" or tradeSkillInfo.name == "Fishing" or tradeSkillInfo.name == "Skinning" then
      local from = tradeSkillInfo.from or {}
      result[tradeSkillInfo.name] = {}
      local zones = {}

      for zoneIndex, zoneInfo in pairs(from) do
        local zoneIndexValues = LB_CustomFunctions:SplitString(zoneIndex, "(%s+)- ")
        if zoneInfo.Quantity > 999999 then zoneInfo.Quantity = 1 end
        if zoneInfo.MapID == nil then
          if zoneIndexValues[1] ~= nil and zoneIndexValues[2] ~= nil then
            local savedZoneInfo = LBZ_Database:GetZoneInfoFromZoneIndex(zoneIndexValues[1] .. " - " .. zoneIndexValues[2])
            zoneInfo.MapID = savedZoneInfo.mapID or nil
          end
        end

        if zoneInfo.MapID ~= nil then
          local zone = {
            ZoneIndex = zoneIndex,
            Continent = zoneIndexValues[1],
            Zone = zoneIndexValues[2],
            Subzone = zoneIndexValues[3],
            MapID = zoneInfo.MapID,
            Quantity = zoneInfo.Quantity
          }
          table.insert(zones, zone)
        end
      end
      result[tradeSkillInfo.name] = {
        Zones = zones
      }
    end
  end
  return result
end

---Process mob results for item
---@param mobList table
---@param tradeskills table
---@return table
function LBL_Database:ProcessResult(mobList, tradeskills)
  local result = {}

  -- process mobs
  local processedMobNames = {}
  local totalEntries = 0
  for _, mobData in pairs(mobList) do
    local mobName = mobData.Name
    local quality = mobData.Quality
    local savedMob = processedMobNames[mobData.Name] or {}
    local quantity = (savedMob.Quantity or 0) + (mobData.Quantity or 0)

    processedMobNames[mobName] = {
      Quantity = quantity,
      Quality = quality
    }
    totalEntries = totalEntries + mobData.Quantity
  end

  -- process tradeskills
  local processedTradeskills = {}
  local continents = {}

  for tradeskill, tradeskillInfo in pairs(tradeskills) do
    if tradeskill == "Mining" or tradeskill == "Herbalism" or tradeskill == "Fishing" or tradeskill == "Skinning" then
      local zones = tradeskillInfo.Zones or {}
      local savedContients = {}
      for _, zoneInfo in pairs(zones) do
        local zoneIndex = zoneInfo.Continent .. " - " .. zoneInfo.Zone
        local parentMapID = continents[zoneIndex] or nil
        if parentMapID == nil then
          local mapInfo = C_Map.GetMapInfo(zoneInfo.MapID)
          parentMapID = mapInfo.parentMapID
          continents[zoneIndex] = parentMapID
        end

        local savedContinent = savedContients[parentMapID] or {}
        local savedZone = savedContinent[zoneInfo.MapID] or {}
        local quantity = (savedZone.Quantity or 0) + (zoneInfo.Quantity or 0)
        savedContinent[zoneInfo.MapID] = {
          MapID = zoneInfo.MapID,
          ParentMapID = parentMapID,
          Continent = zoneInfo.Continent,
          Zone = zoneInfo.Zone,
          Quantity = quantity,
        }
        savedContients[parentMapID] = savedContinent
        totalEntries = totalEntries + zoneInfo.Quantity
      end
      processedTradeskills[tradeskill] = savedContients
    end
  end

  -- process percentages
  --- mobs
  for mobName, mobData in pairs(processedMobNames) do
    local percent = string.format("%.2f", (mobData.Quantity * 100) / totalEntries)
    processedMobNames[mobName]["Percent"] = percent
  end

  --- tradeskills
  for tradeskill, tradeskillData in pairs(processedTradeskills) do
    if tradeskill == "Mining" or tradeskill == "Herbalism" or tradeskill == "Fishing" or tradeskill == "Skinning" then
      for parentMapID, ContinentInfo in pairs(tradeskillData) do
        local allZonesInfo = {}
        for _, zoneInfo in pairs(ContinentInfo) do
          local percent = string.format("%.2f", (zoneInfo.Quantity * 100) / totalEntries)
          zoneInfo["Percent"] = percent
          table.insert(allZonesInfo, zoneInfo)
        end
        tradeskillData[parentMapID] = allZonesInfo
      end
    end
    processedTradeskills[tradeskill] = tradeskillData
  end

  result = {
    MobNames = processedMobNames,
    Tradeskills = processedTradeskills,
    Total = totalEntries
  }
  return result
end

---Table lenth
---@return table entries
function LBL_Database:GetNumEntries()
  local lootDb = LogBookLoot.db.global.data.loot or {}
  local characters = LogBookLoot.db.global.characters or {}
  local totals = 0
  for _, character in pairs(characters) do
    local data = character.loot or {}
    local parcial = LB_CustomFunctions:TableLength(data)
    totals = totals + parcial
  end
  return {
    [LogBookLoot:LBL_i18n("Total")] = LB_CustomFunctions:TableLength(lootDb),
    [LogBookLoot:LBL_i18n("Saved values")] = totals,
  }
end
