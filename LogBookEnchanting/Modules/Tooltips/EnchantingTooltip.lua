---@class LBE_EnchantingTooltip
local LBE_EnchantingTooltip = LB_ModuleLoader:CreateModule("LBE_EnchantingTooltip")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LBE_Database
local LBE_Database = LB_ModuleLoader:ImportModule("LBE_Database")

local GameTooltip = GameTooltip

local PercentByQualityAndLevel = {}




function LBE_EnchantingTooltip:Initialize()
  PercentByQualityAndLevel = LBE_Database:GetExpectedDisenchantData()
  hooksecurefunc(GameTooltip, "SetBagItem", LBE_EnchantingTooltip.SetBagItem)
  hooksecurefunc(GameTooltip, "SetInventoryItem", LBE_EnchantingTooltip.SetInventoryItem)
  hooksecurefunc(GameTooltip, "SetAuctionItem", LBE_EnchantingTooltip.SetAuctionItem)
  if GameTooltip.SetItemKey then
    hooksecurefunc(GameTooltip, "SetItemKey", LBE_EnchantingTooltip.SetItemKey)
  end
  hooksecurefunc(GameTooltip, "SetHyperlink", LBE_EnchantingTooltip.SetHyperlink)

  --[[
  SetBuybackItem
  SetMerchantItem
  SetRecipeReagentItem
  SetTradeSkillItem
  SetCraftItem
  SetLootItem
  SetSendMailItem
  SetInboxItem
  SetTradePlayerItem
  SetTradeTargetItem
  ]]
end

---SetBagItem hook
---@param self LBE_EnchantingTooltip
---@param bag number
---@param slot number
function LBE_EnchantingTooltip.SetBagItem(self, bag, slot)
  if (not slot) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  if not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled then return end

  local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
  if C_Item.DoesItemExist(itemLocation) then
    local item = {
      itemID = C_Item.GetItemID(itemLocation)
    }
    LBE_EnchantingTooltip.ShowTooltip(item)
    GameTooltip:Show()
  end
end

---SetInventoryItem hook
---@param self LBE_EnchantingTooltip
---@param unit string
---@param slot number
function LBE_EnchantingTooltip.SetInventoryItem(self, unit, slot)
  if (not slot) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  if not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled then return end
  local item = {
    itemID = GetInventoryItemID(unit, slot)
  }
  LBE_EnchantingTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

---SetAuctionItem hook
---@param self LBE_EnchantingTooltip
---@param type string
---@param index number
function LBE_EnchantingTooltip.SetAuctionItem(self, type, index)
  if (not index) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  if not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled then return end
  local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, itemID, _ = GetAuctionItemInfo(type, index);
  local item = {
    itemID = itemID
  }
  LBE_EnchantingTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

---SetItemKey hook
---@param self LBE_EnchantingTooltip
---@param itemID number
---@param itemLevel number
---@param itemSuffix number
function LBE_EnchantingTooltip.SetItemKey(self, itemID, itemLevel, itemSuffix)
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  local info = C_TooltipInfo.GetItemKey(itemID, itemLevel, itemSuffix)
  if info == nil then return end
  local item = {
    itemID = itemID
  }
  LBE_EnchantingTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

---SetHyperlink hook
---@param self LBE_EnchantingTooltip
---@param itemLink string
function LBE_EnchantingTooltip.SetHyperlink(self, itemLink)
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  local itemID = GetItemInfoFromHyperlink(itemLink)
  if itemID == nil then return end
  local item = {
    itemID = itemID
  }
  LBE_EnchantingTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

---Create list of items in tooltip
---@param list table
---@param totalEntries number
---@param numEntries number
function LBE_EnchantingTooltip.ProcessEntryList(list, totalEntries, numEntries)
  local index = 1
  for _, currentItemInfo in pairs(list) do
    local quantity = currentItemInfo.Quantity
    local percentage = string.format("%.1f", (quantity * 100) / totalEntries)

    local percentageValues = {}
    local percentageIndex = 1
    for value in string.gmatch(percentage, "([^.]+)") do
      percentageValues[percentageIndex] = value
      percentageIndex = percentageIndex + 1
    end

    local _, itemLink = GetItemInfo(currentItemInfo.ItemID)
    local newItemIcon = currentItemInfo.ItemIcon or GetItemIcon(currentItemInfo.ItemID)
    local newItemLink = currentItemInfo.ItemLink or itemLink
    if newItemIcon ~= nil and newItemLink ~= nil then
      local percentageText = string.format("|cfff1f1f1%s|r|cffc1c1c1|r.|cffa1a1a1%s|r", percentageValues[1], percentageValues[2] or "0")
      local leftTextLine = string.format(" + |T%d:0|t %s |cff91c1f1x|r|cff6191f1%d|r", newItemIcon, newItemLink, quantity)
      local rightTextLine = string.format("%s", percentageText) .. " |cfff1b131%|r"
      GameTooltip:AddDoubleLine(leftTextLine, rightTextLine)
      if index > LogBookEnchanting.db.char.general.enchanting.itemsToShow then
        if numEntries > LogBookEnchanting.db.char.general.enchanting.itemsToShow then
          GameTooltip:AddLine(string.format(" + %d %s...", (numEntries - LogBookEnchanting.db.char.general.enchanting.itemsToShow), LogBook:LB_i18n("more")))
        end
        break
      end
      index = index + 1
    end
  end
end

---Show tooltip
---@param item table
function LBE_EnchantingTooltip.ShowTooltip(item)
  local itemID = item.itemID
  local dbItemInfo = LBE_Database:EntryExistsInItemsDatabase(itemID)
  local dbEssenceInfo = LBE_Database:EntryExistsInEssencesDatabase(itemID)
  if itemID == nil then return end
  local isEssence, isItem, isStored = false, false, false
  if dbItemInfo ~= nil then
    isItem = true
    isStored = true
  elseif dbEssenceInfo ~= nil then
    isEssence = true
    isStored = true
  end

  if isEssence == false and isItem == false then
    local _, _, _, _, _, itemType, _, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(itemID)
    --(string.format("%s = itemType", tostring(itemType)))
    if itemType == LogBookEnchanting:LBE_i18n("Armor") or itemType == LogBookEnchanting:LBE_i18n("Weapon") then
      isItem = true
      isStored = false
    end
  end
  --LogBook:Debug(string.format("%s = isEssence = %s, isItem = %s", tostring(itemID), tostring(isEssence), tostring(isItem)))
  --LogBook:Debug(string.format("isEssence = %s - isItem = %s", tostring(isEssence), tostring(isItem)))
  if (not isEssence and not isItem) or (isEssence and isItem) then return end

  local isShowItemID = LogBookEnchanting.db.char.general.enchanting.showItemID
  local isShowTitle = LogBookEnchanting.db.char.general.enchanting.showTitle
  local itemIDText = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("ROWID"), tostring(itemID))
  if not isShowItemID then
    itemIDText = ""
  end
  local titleText = LogBookEnchanting:MessageWithAddonColor(LogBookEnchanting:LBE_i18n("Enchanting"))

  if isEssence then
    local currentEssence = LogBookEnchanting.db.global.data.essences[itemID] or {}
    local itemsInEssence = currentEssence.Items or {}
    local numItems = LB_CustomFunctions:TableLength(itemsInEssence)
    local totalItems = 0
    local list = {}
    for _, currentItemInfo in pairs(itemsInEssence) do
      table.insert(list, currentItemInfo)
      totalItems = totalItems + currentItemInfo.Quantity
    end
    table.sort(list, function(a, b) return a.Quantity > b.Quantity end)

    if isShowTitle then
      titleText = string.format("%s |cff999999(%d %s)|r", titleText, numItems, LogBookEnchanting:LBE_i18n("items"))
      GameTooltip:AddLine(" ")
      GameTooltip:AddDoubleLine(titleText, itemIDText)
    end
    LBE_EnchantingTooltip.ProcessEntryList(list, totalItems, numItems)
  elseif isItem then
    --LogBook:Debug("Process isItem...")
    LBE_EnchantingTooltip.ProcessIsItem(itemID, isShowTitle, titleText, itemIDText)
  end
end

---Process is item
---@param itemID number
---@param isShowTitle boolean
---@param titleText string
---@param itemIDText string
function LBE_EnchantingTooltip.ProcessIsItem(itemID, isShowTitle, titleText, itemIDText)
  if itemID == nil then return end
  if isShowTitle then
    local newTitleText = string.format("%s", titleText)
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(newTitleText, itemIDText)
  end

  if LogBookEnchanting.db.char.general.enchanting.showExpectedEssences then
    local itemExpectedData = LBE_EnchantingTooltip.ProcessIsItemExpectedData(itemID) or {}
    table.sort(itemExpectedData, function(a, b) return a.ItemQuality < b.ItemQuality end)
    --LogBook:Dump(itemExpectedData)

    GameTooltip:AddLine(string.format("|cff999999%s|r", LogBookEnchanting:LBE_i18n("Expected")))
    if LB_CustomFunctions:TableLength(itemExpectedData) == 0 then
      GameTooltip:AddLine(string.format(" |cffff3300%s|r", LogBookEnchanting:LBE_i18n("No data")))
    else
      local expectedIndex = 1
      for _, currentExpecteItem in pairs(itemExpectedData) do
        local quantity = currentExpecteItem.QuantityText
        local percentage = string.format("%.0f", currentExpecteItem.Percent)

        local itemLink = currentExpecteItem.ItemLink
        local itemIcon = GetItemIcon(currentExpecteItem.ItemID)

        if itemLink ~= nil and itemIcon ~= nil then
          local percentageText = string.format("|cfff1f1f1%s|r", percentage or "0")
          local leftTextLine = string.format(" + |T%d:0|t %s |cff6191f1%s|r", itemIcon, itemLink, quantity)
          local rightTextLine = string.format("%s", percentageText) .. " |cfff1b131%|r"
          GameTooltip:AddDoubleLine(leftTextLine, rightTextLine)
          expectedIndex = expectedIndex + 1
        end
      end
    end
  end

  if LogBookEnchanting.db.char.general.enchanting.showRealEssences then
    local itemRealData = LBE_EnchantingTooltip.ProcessIsItemRealData(itemID) or {}
    table.sort(itemRealData, function(a, b) return a.ItemQuality < b.ItemQuality end)

    GameTooltip:AddLine(string.format("|cff999999%s|r", LogBookEnchanting:LBE_i18n("Real")))
    if LB_CustomFunctions:TableLength(itemRealData) == 0 then
      GameTooltip:AddLine(string.format(" |cffff3300%s|r", LogBookEnchanting:LBE_i18n("No data")))
    else
      local realIndex = 1
      for _, currentExpecteItem in pairs(itemRealData) do
        local quantity = currentExpecteItem.QuantityText
        local percentage = string.format("%.0f", currentExpecteItem.Percent)

        local itemLink = currentExpecteItem.ItemLink
        local itemIcon = GetItemIcon(currentExpecteItem.ItemID)

        if itemLink ~= nil and itemIcon ~= nil then
          local percentageText = string.format("|cfff1f1f1%s|r", percentage or "0")
          local leftTextLine = string.format(" + |T%d:0|t %s |cff6191f1%s|r", itemIcon, itemLink, quantity)
          local rightTextLine = string.format("%s", percentageText) .. " |cfff1b131%|r"
          GameTooltip:AddDoubleLine(leftTextLine, rightTextLine)
          realIndex = realIndex + 1
        end
      end
    end
  end
end

---Process is item expected data
---@param itemID number
---@return table
function LBE_EnchantingTooltip.ProcessIsItemExpectedData(itemID)
  local _, _, itemQuality, itemLevel, itemMinLevel, itemType, _, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(itemID)
  local essencesData = {}
  if itemQuality == 2 then
    essencesData = PercentByQualityAndLevel["UNCOMMON"][itemType]
  elseif itemQuality == 3 then
    essencesData = PercentByQualityAndLevel["RARE"][LogBook:LB_i18n("All")]
  end
  if essencesData == nil then return {} end

  local result = {}
  for _, currentData in pairs(essencesData) do
    --LogBook:Debug(string.format("%s, %s = %s - %s", tostring(itemLevel), tostring(itemMinLevel), tostring(currentData.MinILevel), tostring(currentData.MaxILevel)))
    if itemMinLevel == 0 then itemMinLevel = itemLevel end
    if itemMinLevel >= currentData.MinILevel and itemMinLevel <= currentData.MaxILevel then
      for essenceItemID, currentEssenceData in pairs(currentData.ItemIDs) do
        local essenceItemName, essenceItemLink, essenceItemQuality, _, _, _, _, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(essenceItemID)
        --LogBook:Debug(string.format("%s = %s", essenceItemID, essenceItemLink))
        local essenceToAdd = {
          ItemID = essenceItemID,
          ItemName = essenceItemName,
          ItemLink = essenceItemLink,
          ItemQuality = essenceItemQuality,
          Percent = currentEssenceData.Percent,
          QuantityText = currentEssenceData.QuantityText,
        }
        table.insert(result, essenceToAdd)
      end
      break
    end
  end
  return result
end

---Process is item real data
---@param itemID number
---@return table
function LBE_EnchantingTooltip.ProcessIsItemRealData(itemID)
  local currentItem = LogBookEnchanting.db.global.data.items[itemID] or {}
  local essencesInItem = currentItem.Essences or {}
  local totalEssences = 0
  local list = {}

  for _, currentEssenceInfo in pairs(essencesInItem) do
    table.insert(list, currentEssenceInfo)
    totalEssences = totalEssences + currentEssenceInfo.Quantity
  end
  table.sort(list, function(a, b) return a.Quantity < b.Quantity end)

  local result = {}
  for _, currentItemInfo in pairs(list) do
    local itemName, itemLink, itemQuality, _, _, _, _, _, _, _, _, _, _, _, _, _, _ = GetItemInfo(currentItemInfo.ItemID)
    --LogBook:Debug(string.format("%s = %s", currentItemInfo.ItemID, itemLink))
    local quantity = currentItemInfo.Quantity
    local percentage = string.format("%.1f", (quantity * 100) / totalEssences)

    local essenceToAdd = {
      ItemID = currentItemInfo.ItemID,
      ItemName = itemName,
      ItemLink = itemLink,
      ItemQuality = itemQuality,
      Percent = percentage,
      QuantityText = "x" .. tostring(currentItemInfo.Quantity),
    }
    table.insert(result, essenceToAdd)
  end
  return result
end
