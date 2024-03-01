---@class LBL_Database
local LBL_Database = LB_ModuleLoader:CreateModule("LBL_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

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
    if itemID ~= 0 and not LB_CustomFunctions:TableIsEmpty(mobs) then
      local processedMobs = {}
      for mobIndex, mobData in pairs(mobs) do
        table.insert(processedMobs, LBL_Database:UpdateMobsInItem(itemID, mobIndex, mobData))
      end
      local result = LBL_Database:ProcessMobsInItem(processedMobs)
      items[itemID] = {
        ItemName = currentLoot.ItemName,
        ItemLink = currentLoot.ItemLink,
        Quality = currentLoot.Quality,
        Mobs = processedMobs,
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
function LBL_Database:UpdateMobsInItem(itemID, mobIndex, mobData)
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

---Process mob results for item
---@param mobList table
---@return table
function LBL_Database:ProcessMobsInItem(mobList)
  local result = {}
  local mobNames = {}
  local totalEntries = 0
  for _, mobData in pairs(mobList) do
    local mobName = mobData.Name
    local quality = mobData.Quality
    local savedMob = mobNames[mobData.Name] or {}
    local quantity = (savedMob.Quantity or 0) + (mobData.Quantity or 0)

    mobNames[mobName] = {
      Quantity = quantity,
      Quality = quality
    }
    totalEntries = totalEntries + mobData.Quantity
  end
  for mobName, mobData in pairs(mobNames) do
    local percent = string.format("%.2f", (mobData.Quantity * 100) / totalEntries)
    mobNames[mobName]["Percent"] = percent
  end

  result = {
    MobNames = mobNames,
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
