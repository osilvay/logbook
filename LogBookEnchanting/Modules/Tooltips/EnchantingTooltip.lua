---@class LBE_EnchantingTooltip
local LBE_EnchantingTooltip = LB_ModuleLoader:CreateModule("LBE_EnchantingTooltip")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LBE_Database
local LBE_Database = LB_ModuleLoader:ImportModule("LBE_Database")

local GameTooltip = GameTooltip

function LBE_EnchantingTooltip:Initialize()
  hooksecurefunc(GameTooltip, "SetBagItem", LBE_EnchantingTooltip.SetBagItem)
  hooksecurefunc(GameTooltip, "SetInventoryItem", LBE_EnchantingTooltip.SetInventoryItem)
  hooksecurefunc(GameTooltip, "SetAuctionItem", LBE_EnchantingTooltip.SetAuctionItem)
  --[[
  SetBuybackItem
  SetMerchantItem
  SetInventoryItem
  SetRecipeReagentItem
  SetTradeSkillItem
  SetCraftItem
  SetLootItem
  SetSendMailItem
  SetInboxItem
  SetTradePlayerItem
  SetTradeTargetItem
  SetAuctionItem
  SetItemKey
  ]]
end

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
end

---Show tooltip
---@param item table
function LBE_EnchantingTooltip.ShowTooltip(item)
  local itemID = item.itemID
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
    LBE_EnchantingTooltip.ProcessEntryList(list, totalItems, numItems)
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
      LBE_EnchantingTooltip.ProcessEntryList(list, totalEssences, numDifferentEssences)
    end
  end
end
