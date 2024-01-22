---@class LBE_EnchantingTooltip
local LBE_EnchantingTooltip = LB_ModuleLoader:CreateModule("LBE_EnchantingTooltip")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LBE_Database
local LBE_Database = LB_ModuleLoader:ImportModule("LBE_Database")

local GameTooltip = GameTooltip

function LBE_EnchantingTooltip.AddEnchantingTooltip(self, bag, slot)
  if (not slot) then return end
  local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
  if C_Item.DoesItemExist(itemLocation) then
    local itemID = C_Item.GetItemID(itemLocation)

    local dbItemInfo = LBE_Database:ItemExistsInItemsDatabase(itemID)
    local dbEssenceInfo = LBE_Database:ItemExistsInEssencesDatabase(itemID)
    --LogBook:Dump(dbItemInfo)
    --LogBook:Dump(dbEssenceInfo)

    local isEssence, isItem = false, false
    if dbItemInfo == nil and dbEssenceInfo == nil then
      return
    elseif dbItemInfo == nil then
      isEssence = true
    elseif dbEssenceInfo == nil then
      isItem = true
    end

    --LogBook:Debug(string.format("%s - %s", tostring(isEssence), tostring(isItem)))
    local keyPressed = LB_CustomFunctions:IsKeyPressed(LogBookEnchanting.db.char.general.enchanting.pressKeyDown)
    if (not isEssence == nil and not isItem == nil) or (isEssence and isItem) or not keyPressed then return end

    local itemName = C_Item.GetItemName(itemLocation)
    local itemLink = C_Item.GetItemLink(itemLocation)
    local itemCount = C_Item.GetStackCount(itemLocation)
    local itemInfo = {
      itemName = itemName,
      itemID = itemID,
      itemLink = itemLink,
      itemCount = itemCount
    }
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

      LBE_EnchantingTooltip.ProcessItemList(list, totalItems, numItems)
    elseif isItem then
      local currentItem = LogBookEnchanting.db.global.data.items[itemID] or {}
      local essencesInItem = currentItem.Essences or {}
      local numEssences = LB_CustomFunctions:TableLength(essencesInItem)
      local totalEssences = 0
      local list = {}
      for _, currentEssenceInfo in pairs(essencesInItem) do
        table.insert(list, currentEssenceInfo)
        totalEssences = totalEssences + currentEssenceInfo.Quantity
      end
      table.sort(list, function(a, b) return a.Quantity < b.Quantity end)

      if isShowTitle then
        titleText = string.format("%s |cff999999(%d %s)|r", titleText, numEssences, LogBookEnchanting:LBE_i18n("essences"))
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(titleText, itemIDText)
      end
      LBE_EnchantingTooltip.ProcessItemList(list, totalEssences, numEssences)
    end

    GameTooltip:Show()
  end
end

---Create list of items in tooltip
---@param list table
---@param totalEntries number
---@param numEntries number
function LBE_EnchantingTooltip.ProcessItemList(list, totalEntries, numEntries)
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
    local percentageText = string.format("|cfff1f1f1%s|r|cff919191.%s|r", percentageValues[1], percentageValues[2] or "0")
    local leftTextLine = string.format(" + |T%d:0|t %s |cff91c1f1x|r |cFFFFF311%d|r", currentItemInfo.ItemIcon, currentItemInfo.ItemLink, quantity)
    local rightTextLine = string.format("%s", percentageText) .. " |cffc19101%|r"
    GameTooltip:AddDoubleLine(leftTextLine, rightTextLine)
    index = index + 1
    if index > LogBookEnchanting.db.char.general.enchanting.itemsToShow then
      if numEntries > LogBookEnchanting.db.char.general.enchanting.itemsToShow then
        GameTooltip:AddLine(string.format(" + %d %s...", (numEntries - LogBookEnchanting.db.char.general.enchanting.itemsToShow), LogBook:LB_i18n("more")))
      end
      break
    end
  end
end
