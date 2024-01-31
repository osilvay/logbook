---@class LBL_LootTooltip
local LBL_LootTooltip = LB_ModuleLoader:CreateModule("LBL_LootTooltip")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LBL_Database
local LBL_Database = LB_ModuleLoader:ImportModule("LBL_Database")

local GameTooltip = GameTooltip

function LBL_LootTooltip:Initialize()
  hooksecurefunc(GameTooltip, "SetBagItem", LBL_LootTooltip.SetBagItem)
  hooksecurefunc(GameTooltip, "SetInventoryItem", LBL_LootTooltip.SetInventoryItem)
  hooksecurefunc(GameTooltip, "SetAuctionItem", LBL_LootTooltip.SetAuctionItem)
  if GameTooltip.SetItemKey then
    hooksecurefunc(GameTooltip, "SetItemKey", LBL_LootTooltip.SetItemKey)
  end
  hooksecurefunc(GameTooltip, "SetHyperlink", LBL_LootTooltip.SetHyperlink)
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

function LBL_LootTooltip.SetBagItem(self, bag, slot)
  if (not slot) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  --[[
  if not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled then return end

  local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
  if C_Item.DoesItemExist(itemLocation) then
    local item = {
      itemID = C_Item.GetItemID(itemLocation)
    }
    LBL_LootTooltip.ShowTooltip(item)
  end
  ]]
  GameTooltip:Show()
end

function LBL_LootTooltip.SetInventoryItem(self, unit, slot)
  if (not slot) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  if not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled then return end
  --[[
  local item = {
    itemID = GetInventoryItemID(unit, slot)
  }
  LBL_LootTooltip.ShowTooltip(item)
  ]]
  GameTooltip:Show()
end

function LBL_LootTooltip.SetAuctionItem(self, type, index)
  if (not index) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  if not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled then return end
  --[[
  local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, itemID, _ = GetAuctionItemInfo(type, index);
  local item = {
    itemID = itemID
  }
  LBL_LootTooltip.ShowTooltip(item)
  ]]
  GameTooltip:Show()
end

function LBL_LootTooltip.SetItemKey(self, itemID, itemLevel, itemSuffix)
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  --[[
  local info = C_TooltipInfo.GetItemKey(itemID, itemLevel, itemSuffix)
  if info == nil then return end
  local item = {
    itemID = itemID
  }
  LBL_LootTooltip.ShowTooltip(item)
  ]]
  GameTooltip:Show()
end

function LBL_LootTooltip.SetHyperlink(self, itemLink)
  if not LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown) then return end
  --[[
  local itemID = GetItemInfoFromHyperlink(itemLink)
  if itemID == nil then return end
  local item = {
    itemID = itemID
  }
  LBL_LootTooltip.ShowTooltip(item)
  ]]
  GameTooltip:Show()
end

---Create list of items in tooltip
---@param list table
---@param totalEntries number
---@param numEntries number
function LBL_LootTooltip.ProcessEntryList(list, totalEntries, numEntries)
  local index = 1
  --[[
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
      local percentageText = string.format("|cfff1f1f1%s|r|cffc1c1c1.|r|cffa1a1a1%s|r", percentageValues[1], percentageValues[2] or "0")
      local leftTextLine = string.format(" + |T%d:0|t %s |cff91c1f1x|r|cff6191f1%d|r", newItemIcon, newItemLink, quantity)
      local rightTextLine = string.format("%s", percentageText) .. "|cfff1b131%|r"
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
  ]]
end

---Show tooltip
---@param item table
function LBL_LootTooltip.ShowTooltip(item)
  local itemID = item.itemID
  --[[
  local dbItemInfo = LBE_Database:EntryExistsInItemsDatabase(itemID)
  local dbEssenceInfo = LBE_Database:EntryExistsInEssencesDatabase(itemID)

  local isEssence, isItem = false, false
  if dbItemInfo == nil and dbEssenceInfo == nil then
    return
  elseif dbItemInfo == nil then
    isEssence = true
  elseif dbEssenceInfo == nil then
    isItem = true
  end

  --LogBook:Debug(string.format("isEssence = %s - isItem = %s", tostring(isEssence), tostring(isItem)))
  if (not isEssence == nil and not isItem == nil) or (isEssence and isItem) then return end

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
    LBL_LootTooltip.ProcessEntryList(list, totalItems, numItems)
  elseif isItem then
    local currentItem = LogBookEnchanting.db.global.data.items[itemID] or {}
    local essencesInItem = currentItem.Essences or {}
    local numDifferentEssences = LB_CustomFunctions:TableLength(essencesInItem)
    local totalEssences = 0
    local list = {}

    for _, currentEssenceInfo in pairs(essencesInItem) do
      table.insert(list, currentEssenceInfo)
      totalEssences = totalEssences + currentEssenceInfo.Quantity
    end
    table.sort(list, function(a, b) return a.Quantity < b.Quantity end)
    if totalEssences > 0 and numDifferentEssences > 0 then
      if isShowTitle then
        titleText = string.format("%s |cff999999(%d %s)|r", titleText, numDifferentEssences, LogBookEnchanting:LBE_i18n("essences"))
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(titleText, itemIDText)
      end
      LBL_LootTooltip.ProcessEntryList(list, totalEssences, numDifferentEssences)
    end
  end
  ]]
end
