---@class LBE_Database
local LBE_Database = LB_ModuleLoader:CreateModule("LBE_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

local essences = {}
local items = {}

function LBE_Database:Initialize()
  C_Timer.After(0.1, function()
    LBE_Database:UpdateDatabase(false)
  end)
end

local updateDbTimeoutTicker = nil
---Starts auto update database
function LBE_Database:StartAutoUpdateDatabase()
  local updateDbTimeout = LogBookEnchanting.db.char.general.enchanting.updateDbTimeout
  if updateDbTimeoutTicker == nil then
    local message = string.format(LogBook:LB_i18n("Starting database auto update: %s"), LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting")))
    LogBook:Print(message)
    updateDbTimeoutTicker = C_Timer.NewTicker(updateDbTimeout * 60, function()
      LBE_Database:UpdateDatabase()
    end)
  end
end

---Cancels auto update database
function LBE_Database:CancelAutoUpdateDatabase()
  if updateDbTimeoutTicker ~= nil then
    local message = string.format(LogBook:LB_i18n("Cancelling database auto update: %s"), LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting")))
    LogBook:Print(message)
    updateDbTimeoutTicker:Cancel()
    updateDbTimeoutTicker = nil
  end
end

---Update enchanting database
---@param silent? boolean
function LBE_Database:UpdateDatabase(silent)
  if silent == nil then silent = false end
  local lootDb = LogBookLoot.db.global.data.loot
  essences = {}
  items = {}

  -- leo esencias
  for itemID, currentEssence in pairs(lootDb) do
    local isTradeSkill = currentEssence["IsTradeSkill"] or false
    local tradeSkillInfo = currentEssence["TradeSkillInfo"] or {}
    local tradeSkillName = tradeSkillInfo.name or ""

    -- si es encantamiento la proceso
    if isTradeSkill and tradeSkillInfo ~= nil and tradeSkillName == "Enchanting" then
      local _, eItemLink, eItemQuality, eItemLevel, eItemMinLevel = GetItemInfo(itemID)
      currentEssence.Quality                                      = eItemQuality
      currentEssence.ItemLink                                     = eItemLink
      currentEssence.ItemLevel                                    = eItemLevel
      currentEssence.ItemMinLevel                                 = eItemMinLevel

      local from                                                  = tradeSkillInfo.from

      -- leo objetos de esencias
      for currentItemID, itemInEssence in pairs(from) do
        local _, itemLink, itemQuality, itemLevel, itemMinLevel = GetItemInfo(currentItemID)
        itemInEssence.Quality = itemQuality
        itemInEssence.ItemLink = itemLink
        itemInEssence.ItemLevel = itemLevel
        itemInEssence.ItemMinLevel = itemMinLevel

        -- añado a bbdd de objetos y esencias
        essences[itemID] = LBE_Database:UpdateEssenceWithItems(itemID, itemInEssence, currentEssence)
        items[currentItemID] = LBE_Database:UpdateItemWithEssences(currentItemID, itemInEssence, currentEssence)
      end
    end
  end
  LogBookEnchanting.db.global.data.items = items
  LogBookEnchanting.db.global.data.essences = essences

  if not silent then
    local message = string.format(LogBook:LB_i18n("%s database update: %s"), LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting")), string.format("|cff03f303%s|r", LogBook:LB_i18n("Done!")))
    LogBook:Print(message)
  end
end

---Table lenth
function LBE_Database:GetNumEntries()
  local itemsDb = LogBookEnchanting.db.global.data.items
  local essencesDb = LogBookEnchanting.db.global.data.essences
  if itemsDb == nil then itemsDb = {} end
  if essencesDb == nil then essencesDb = {} end
  return {
    [LogBookEnchanting:LBE_i18n("Items")] = LB_CustomFunctions:TableLength(itemsDb),
    [LogBookEnchanting:LBE_i18n("Essences")] = LB_CustomFunctions:TableLength(essencesDb),
  }
end

---Item exists in database
---@param itemID number
---@return table|nil itemInfo
function LBE_Database:ItemExistsInItemsDatabase(itemID)
  if itemID == nil then return end
  if items[itemID] ~= nil then
    return items[itemID]
  else
    return nil
  end
end

---Item exists in essences database
---@param itemID number
---@return table|nil itemInfo
function LBE_Database:ItemExistsInEssencesDatabase(itemID)
  if itemID == nil then return end
  if essences[itemID] ~= nil then
    return essences[itemID]
  else
    return nil
  end
end

---Update essences in item
---@param currentItemID number
---@param itemInEssence table
---@return table essencesInItem
function LBE_Database:UpdateItemWithEssences(currentItemID, itemInEssence, currentEssence)
  local savedItem = items[currentItemID] or {
    ItemName = itemInEssence.ItemName,
    ItemID = itemInEssence.ItemID,
    Quality = itemInEssence.Quality,
    Quantity = itemInEssence.Essences,
    ItemLink = itemInEssence.ItemLink,
    ItemLevel = itemInEssence.ItemLevel,
    ItemMinLevel = itemInEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(itemInEssence.ItemID)
  }

  if savedItem.Items ~= nil then savedItem.Items = nil end
  local savedEssences = savedItem.Essences or {}
  local currentEssenceItemID = currentEssence.ItemID
  local currentSavedEssence = savedEssences[currentEssenceItemID] or {}
  local newQuantity = (itemInEssence.Essences or 0) + (currentSavedEssence.Quantity or 0)

  savedEssences[currentEssenceItemID] = {
    Items = itemInEssence.Items,
    ItemID = currentEssence.ItemID,
    ItemName = currentEssence.ItemName,
    Quantity = newQuantity,
    Quality = currentEssence.Quality,
    ItemLink = currentEssence.ItemLink,
    ItemLevel = currentEssence.ItemLevel,
    ItemMinLevel = currentEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(currentEssence.ItemID)
  }
  savedItem.Essences = savedEssences
  return savedItem
end

---Update essences in item
---@param itemID number
---@param itemInEssence table
---@return table essencesInItem
function LBE_Database:UpdateEssenceWithItems(itemID, itemInEssence, currentEssence)
  local savedEssence = essences[itemID] or {
    ItemName = currentEssence.ItemName,
    ItemID = currentEssence.ItemID,
    Quantity = currentEssence.Quantity,
    Quality = currentEssence.Quality,
    ItemLink = currentEssence.ItemLink,
    ItemLevel = currentEssence.ItemLevel,
    ItemMinLevel = currentEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(currentEssence.ItemID)
  }
  local savedItems = savedEssence.Items or {}
  local currentItemID = itemInEssence.ItemID
  local currentSavedItem = savedItems[currentItemID] or {}

  local newQuantity = (itemInEssence.Items or 0) + (currentSavedItem.Quantity or 0)
  savedItems[currentItemID] = {
    ItemID = itemInEssence.ItemID,
    ItemName = itemInEssence.ItemName,
    Quantity = newQuantity,
    Quality = itemInEssence.Quality,
    ItemLink = itemInEssence.ItemLink,
    ItemLevel = itemInEssence.ItemLevel,
    ItemMinLevel = itemInEssence.ItemMinLevel,
    ItemIcon = GetItemIcon(itemInEssence.ItemID)
  }
  savedEssence.Items = savedItems
  return savedEssence
end
