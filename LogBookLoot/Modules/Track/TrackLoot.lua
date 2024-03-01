---@class LBL_TrackLoot
local LBL_TrackLoot = LB_ModuleLoader:CreateModule("LBL_TrackLoot")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:ImportModule("LB_CustomSounds")

---@type LBM_TrackMobs
local LBM_TrackMobs = LB_ModuleLoader:ImportModule("LBM_TrackMobs")

---@type LBZ_TrackZones
local LBZ_TrackZones = LB_ModuleLoader:ImportModule("LBZ_TrackZones")

---@type LBE_Database
local LBE_Database = LB_ModuleLoader:ImportModule("LBE_Database")

local MaxLootReadyCount = 0
local LootingInProgress = false
local Loots = {}
local RecentLoots = {}
local TradeskillUsed = nil
local CopperPerSilver = 10
local SilverPerGold = 100
local TradeSkillInfo = {}
local IsTradeSkill = false
local ItemLockedInfo = {}
local IsItemLocked = false

local allProfessionID = {
}

function LBL_TrackLoot:Initialize()
  allProfessionID = {
    Enchanting = {
      spellID = { 13262, 7412, 7413, 13920, 7411 },
      professionName = LogBookLoot:LBL_i18n("Enchanting")
    },
    Herbalism = {
      spellID = { 2383, 2368, 3570, 11993, 2366 },
      professionName = LogBookLoot:LBL_i18n("Herbalism")
    },
    Skinning = {
      spellID = { 8617, 8618, 10768, 8613 },
      professionName = LogBookLoot:LBL_i18n("Skinning")
    },
    Mining = {
      spellID = { 2580, 2576, 3564, 10248, 2575, 2656 },
      professionName = LogBookLoot:LBL_i18n("Mining")
    },
    Fishing = {
      spellID = { 7731, 7620, 7732, 18248 },
      professionName = LogBookLoot:LBL_i18n("Fishing")
    },
  }
end

---Process LOOT_READY
function LBL_TrackLoot:ProcessLootReady()
  MaxLootReadyCount = math.max(MaxLootReadyCount, GetNumLootItems())
  LootingInProgress = true

  for i = 1, GetNumLootItems() do
    local lootLink = GetLootSlotLink(i)
    local _, lootName, lootQuantity, currencyID, lootQuality, locked, IsQuestItem, questId = GetLootSlotInfo(i)
    local slotType = GetLootSlotType(i)

    local itemID = currencyID
    if itemID == nil
    then
      itemID = LBL_TrackLoot:GetLootId(i)
    end
    --LogBook:Debug("Loot : " .. tostring(itemID))

    -- When ProcessLootReady gets called again before LootClosed, the slot might
    -- not contain valid data.
    if itemID ~= -1 then
      -- LOOT_SLOT_TYPE = https://wowpedia.fandom.com/wiki/API_GetLootSlotType
      if slotType == 2 then --LOOT_SLOT_MONEY / Enum.LootSlotType.Money
        if lootName then
          lootQuantity = LBL_TrackLoot:LootNameToMoney(lootName)
        else
          lootQuantity = 0
        end
        lootName = "Copper"
        lootQuality = -1
        --LogBook:Debug("Money : " .. tostring(lootQuantity))
      elseif slotType == 1 --LOOT_SLOT_ITEM / Enum.LootSlotType.Item
      then
        lootQuality = lootQuality + 1
      end

      local sources = { GetLootSourceInfo(i) }
      --LogBook:Debug(string.format(" %d > quality = %d, name =  %s [%d mobs] - item_id = %d", i, lootQuantity, lootName, #sources / 2, itemID))

      for j = 1, #sources, 2
      do
        local guidType = select(1, strsplit("-", sources[j]))
        --LogBook:Debug("guidType = " .. tostring(guidType))
        --if guidType ~= "Item" then
        if not LBL_TrackLoot:PartOfPreviousLoot(sources[j]) then
          local loot = Loots[itemID]
          local Mobs = {}
          if loot == nil then
            loot = {
              Mobs = {}
            }
            loot.ItemName = lootName
            loot.Quality = lootQuality
            loot.Quantity = lootQuantity
            loot.Type = slotType
            loot.ItemLink = lootLink
            loot.ItemID = itemID
            loot.Time = GetTime()
            loot.IsQuestItem = IsQuestItem
            loot.IsTradeSkill = IsTradeSkill
            loot.TradeSkillInfo = TradeSkillInfo
            if lootLink then
              _, _, loot.Tier = string.find(lootLink, "|A:Professions%-ChatIcon%-Quality%-Tier(%d):")
            end
            Loots[itemID] = loot
          end

          local mobGUID = sources[j]

          local mob = Mobs[mobGUID] or {}
          if next(mob) == nil then
            mob.GUID = mobGUID
          end

          --[[
          local mobQuantity
          if #sources > 2
          then
            mobQuantity = sources[j + 1]
          else
            mobQuantity = lootQuantity
          end
          mob.Quantity = mobQuantity
          loot.Quantity = loot.Quantity + mobQuantity
          ]]

          mob.GUIDType = guidType
          mob.IsCreature = guidType == "Creature" or guidType == "Vehicle"
          if not mob.IsCreature then
            mob.Name = GameTooltipTextLeft1:GetText()
          end

          if mob.IsCreature then
            local mobDetails = LBM_TrackMobs:GetMobDetailsByGUID(mob.GUID) or {}
            --LogBook:Dump(mobDetails)
            if mobDetails ~= nil and mobDetails.mobIndex ~= nil then
              loot.Mobs[mobDetails.mobIndex] = mob
            end
          end

          if IsTradeSkill then
            if TradeSkillInfo.name == "Enchanting" and IsItemLocked then
              ItemLockedInfo.Quantity = loot.Quantity
              ItemLockedInfo.Quality = loot.Quality
              ItemLockedInfo.Items = 1
              TradeSkillInfo.from[ItemLockedInfo.ItemID] = ItemLockedInfo
              loot.TradeSkillInfo = TradeSkillInfo
            elseif TradeSkillInfo.name == "Mining" or TradeSkillInfo.name == "Herbalism" or TradeSkillInfo.name == "Fishing" then
              local ItemFrom = {
                Quality = loot.Quality,
                Quantity = loot.Quantity,
                Items = 1,
              }
              local zoneIndex = LBZ_TrackZones:GetCurrentPersonalZone()
              if zoneIndex == nil then zoneIndex = UNKNOWN end
              ItemFrom.ZoneIndex = zoneIndex
              ItemLockedInfo.Quantity = loot.Quantity
              ItemLockedInfo.Items = 1
              TradeSkillInfo.from[zoneIndex] = ItemFrom
              loot.TradeSkillInfo = TradeSkillInfo
            end
          end

          -- stores item
          --LogBook:Dump(loot)
          LBL_TrackLoot:StoreItemDetails(loot)
        end
        --end
      end
    end
  end
end

---Process LOOT_CLOSED
function LBL_TrackLoot:ProcessLootClosed()
  if LootingInProgress then
    --LogBook:Debug("Closing loot for = " .. (LastTargetIdx or "<no target>"))
    for itemID, loot in pairs(Loots) do
      -- process mobs
      if loot.Mobs then
        for i, mob in pairs(loot.Mobs) do
          if not mob.IsCreature then
            --LogBook:Debug("Loot from : " .. mob.GUID)
          end
        end
      end
    end
  end
  Loots = {}
  Target = {}
  LastTargetIdx = nil
  TradeskillUsed = nil
  LootingInProgress = false
  MaxLootReadyCount = 0
  TradeSkillInfo = {}
  IsTradeSkill = false
  ItemLockedInfo = {}
  IsItemLocked = false
end

--Converts money string in copper
---@param item string
---@return number num
function LBL_TrackLoot:LootNameToMoney(item)
  local i = 0
  local g, s, c = 0, 0, 0
  local money = 0

  local gold = string.find(item, LogBookLoot:LBL_i18n("Gold"))
  if gold then
    g = tonumber(string.sub(item, 0, gold - 1)) or 0
    item = string.sub(item, gold + string.len(LogBookLoot:LBL_i18n("Gold")), string.len(item))
    money = money + ((g or 0) * SilverPerGold * CopperPerSilver)
  end

  local silver = string.find(item, LogBookLoot:LBL_i18n("Silver"))
  if silver then
    s = tonumber(string.sub(item, 0, silver - 1)) or 0
    item = string.sub(item, silver + string.len(LogBookLoot:LBL_i18n("Silver")), string.len(item))
    print(item)
    money = money + ((s or 0) * CopperPerSilver)
  end

  local copper = string.find(item, LogBookLoot:LBL_i18n("Copper"))
  if copper then
    c = tonumber(string.sub(item, 0, copper - 1)) or 0
    money = money + (c or 0)
  end
  return money
end

---Get itemId from loot
---@param slot number
---@return number num
function LBL_TrackLoot:GetLootId(slot)
  local link = GetLootSlotLink(slot)
  if link
  then
    return LBL_TrackLoot:GetItemId(link)
  end
  return 0
end

---Get itemId from itemLink
---@param itemLinkOrId string
---@return number itemLinkOrId
function LBL_TrackLoot:GetItemId(itemLinkOrId)
  if type(itemLinkOrId) == "string" then
    _, _, itemLinkOrId = string.find(itemLinkOrId, "|Hitem:(%d*):(%d*):(%d*):")
  end
  return tonumber(itemLinkOrId) or -1
end

---Get itemId from itemLink
---@param guid string
---@return boolean itemLinkOrId
function LBL_TrackLoot:PartOfPreviousLoot(guid)
  for _, corpseGUID in pairs(RecentLoots) do
    if corpseGUID == guid
    then
      return true
    end
  end
  return false
end

---Stores item
---@param loot table
function LBL_TrackLoot:StoreItemDetails(loot)
  if loot then
    local itemID = loot.ItemID
    local savedLoot = LogBookLoot.db.global.data.loot[itemID]

    --corrections
    if savedLoot then
      -- quantity
      local currentQuantity = (savedLoot.Quantity or 0) + (loot.Quantity or 0)
      loot.Quantity = currentQuantity

      -- mobs
      local savedMobs = savedLoot.Mobs
      local currentMobs = loot.Mobs
      if currentMobs then
        for mobIndex, mob in pairs(currentMobs) do
          if savedMobs[mobIndex] ~= nil then
            local savedMob = savedMobs[mobIndex]
            local mobCurrentQuantity = (savedMob.Quantity or 0) + (mob.Quantity or 0)
            mob.Quantity = mobCurrentQuantity
          end
          savedMobs[mobIndex] = mob
        end
      end
      --LogBook:Dump(savedMobs)
      loot.Mobs = savedMobs

      -- tradeskill
      local currentTradeSkillInfo = loot.TradeSkillInfo
      local savedTradeSkillInfo = savedLoot.TradeSkillInfo
      if savedTradeSkillInfo == nil then
        savedTradeSkillInfo = {}
      end
      if loot.IsTradeSkill and currentTradeSkillInfo ~= nil then
        local savedFrom = savedTradeSkillInfo.from
        if savedFrom == nil then
          savedFrom = {}
        end
        local currentFrom = currentTradeSkillInfo.from
        if currentTradeSkillInfo.name == "Enchanting" then
          --LogBook:Dump(loot)
          for currentItemID, currentItemLockedInfo in pairs(currentFrom) do
            if savedFrom[currentItemID] == nil then
              savedFrom[currentItemID] = currentItemLockedInfo
            else
              local newItems = (currentFrom[currentItemID].Items or 0) + (savedFrom[currentItemID].Items or 0)
              local newQuantity = (currentFrom[currentItemID].Quantity or 0) + (savedFrom[currentItemID].Quantity or 0)
              savedFrom[currentItemID].Items = newItems
              savedFrom[currentItemID].Quantity = newQuantity
            end
          end
        elseif TradeSkillInfo.name == "Mining" or TradeSkillInfo.name == "Herbalism" or TradeSkillInfo.name == "Fishing" then
          for currentZoneIndex, currentCurrentZone in pairs(currentFrom) do
            if savedFrom[currentZoneIndex] == nil then
              savedFrom[currentZoneIndex] = {
                Items = currentCurrentZone.Items,
                Quantity = currentCurrentZone.Quantity
              }
            else
              local newItems = (currentFrom[currentZoneIndex].Items or 0) + (savedFrom[currentZoneIndex].Items or 0)
              local newQuantity = (currentFrom[currentZoneIndex].Quantity or 0) + (savedFrom[currentZoneIndex].Quantity or 0)
              savedFrom[currentZoneIndex] = {
                Items = newItems,
                Quantity = newQuantity
              }
            end
          end
        end
        savedTradeSkillInfo.from = savedFrom
        savedTradeSkillInfo.name = currentTradeSkillInfo.name
        savedTradeSkillInfo.spellID = currentTradeSkillInfo.spellID

        local _, itemLink, itemQuality, itemLevel, itemMinLevel = GetItemInfo(itemID)
        if savedTradeSkillInfo.Quality == nil then savedTradeSkillInfo.Quality = itemQuality end
        if savedTradeSkillInfo.ItemLink == nil then savedTradeSkillInfo.Quality = itemLink end
        if savedTradeSkillInfo.ItemLevel == nil then savedTradeSkillInfo.Quality = itemLevel end
        if savedTradeSkillInfo.ItemMinLevel == nil then savedTradeSkillInfo.Quality = itemMinLevel end

        loot.TradeSkillInfo = savedTradeSkillInfo
      end
    end
    LogBookLoot.db.global.data.loot[itemID] = loot
    LBE_Database:UpdateDatabase(true)
  end
end

function LBL_TrackLoot:ProcessUnitSpellCastSucceeded(unitTarget, spellID)
  if unitTarget == "player" then
    local proffesionName = LBL_TrackLoot:FindProfessionBySpellId(spellID)
    --LogBook:Debug(proffesionName .. " : " .. spellID)
    if proffesionName ~= "" then
      IsTradeSkill = true
      TradeSkillInfo = {
        name = proffesionName,
        spellID = spellID,
        from = {}
      }
    end
  end
end

---Find proffesion by spellId
---@param spellID string
---@return string profession
function LBL_TrackLoot:FindProfessionBySpellId(spellID)
  for profession, professionInfo in pairs(allProfessionID) do
    for _, professionID in pairs(professionInfo.spellID) do
      if spellID == professionID then
        return profession
      end
    end
  end
  --LogBook:Debug("Profession with spellID = " .. spellID .. " not found.")
  return ""
end

---Process chat msg loot
---@param text string
---@param notPlayerName string
---@param playerName string
function LBL_TrackLoot:ProcessChatMsgLoot(text, notPlayerName, playerName)
  if (UnitName("player")) == playerName or (string.len(playerName) == 0 and UnitName("player") == notPlayerName) then
    --LogBook:Dump(TradeSkillInfo)
    local itemId = tonumber(string.match(text, "item:(%d+)"))
    --LogBook:Debug(string.format("itemId = %s, playerName = %s", itemId, playerName))
  end
end

---Process item locked
---@param bagOrSlotIndex number
---@param slotIndex number
function LBL_TrackLoot:ProcessItemLocked(bagOrSlotIndex, slotIndex)
  --LogBook:Debug("Lock item : " .. tostring(bagOrSlotIndex) .. " - " .. tostring(slotIndex))
  if bagOrSlotIndex == nil or slotIndex == nil then
    IsItemLocked = true
    ItemLockedInfo = {
    }
  else
    local containerInfo = C_Container.GetContainerItemInfo(bagOrSlotIndex, slotIndex)
    --LogBook:Dump(containerInfo)
    IsItemLocked = true
    ItemLockedInfo = {
      ItemName = containerInfo.itemName,
      ItemID = containerInfo.itemID,
      Quality = containerInfo.quality,
    }
  end
end
