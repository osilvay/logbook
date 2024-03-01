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
  if not LB_CustomFunctions:IsKeyPressed(LogBookLoot.db.char.general.loot.pressKeyDown) then return end
  if not LogBookLoot.db.char.general.loot.tooltipsEnabled then return end

  local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
  if C_Item.DoesItemExist(itemLocation) then
    local item = {
      itemID = C_Item.GetItemID(itemLocation)
    }
    LBL_LootTooltip.ShowTooltip(item)
  end
  GameTooltip:Show()
end

function LBL_LootTooltip.SetInventoryItem(self, unit, slot)
  if (not slot) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookLoot.db.char.general.loot.pressKeyDown) then return end
  if not LogBookLoot.db.char.general.loot.tooltipsEnabled then return end
  local item = {
    itemID = GetInventoryItemID(unit, slot)
  }
  LBL_LootTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

function LBL_LootTooltip.SetAuctionItem(self, type, index)
  if (not index) then return end
  if not LB_CustomFunctions:IsKeyPressed(LogBookLoot.db.char.general.loot.pressKeyDown) then return end
  if not LogBookLoot.db.char.general.loot.tooltipsEnabled then return end
  local _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, itemID, _ = GetAuctionItemInfo(type, index);
  local item = {
    itemID = itemID
  }
  LBL_LootTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

function LBL_LootTooltip.SetItemKey(self, itemID, itemLevel, itemSuffix)
  if not LB_CustomFunctions:IsKeyPressed(LogBookLoot.db.char.general.loot.pressKeyDown) then return end
  if not LogBookLoot.db.char.general.loot.tooltipsEnabled then return end
  local info = C_TooltipInfo.GetItemKey(itemID, itemLevel, itemSuffix)
  if info == nil then return end
  local item = {
    itemID = itemID
  }
  LBL_LootTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

function LBL_LootTooltip.SetHyperlink(self, itemLink)
  if not LB_CustomFunctions:IsKeyPressed(LogBookLoot.db.char.general.loot.pressKeyDown) then return end
  if not LogBookLoot.db.char.general.loot.tooltipsEnabled then return end
  local itemID = GetItemInfoFromHyperlink(itemLink)
  if itemID == nil then return end
  local item = {
    itemID = itemID
  }
  LBL_LootTooltip.ShowTooltip(item)
  GameTooltip:Show()
end

---Create list of items in tooltip
---@param results table
function LBL_LootTooltip.ProcessEntryList(results)
  local totalEntries = results.Total or 0
  local mobNames = results.MobNames or {}
  local numItems = LB_CustomFunctions:TableLength(mobNames)
  local index = 0
  for mobName, mobNameData in pairs(mobNames) do
    local percentageValues = {}
    local percentageIndex = 1
    for value in string.gmatch(mobNameData.Percent, "([^.]+)") do
      percentageValues[percentageIndex] = value
      percentageIndex = percentageIndex + 1
    end

    local unitColor = LB_CustomColors:CustomUnitClassificationColors(mobNameData.Quality)
    local unit_icon = "|TInterface\\AddOns\\LogBook\\Images\\" .. mobNameData.Quality .. ":16:16|t"

    local percentageText = string.format("|cfff1f1f1%s|r|cffc1c1c1.|r|cffa1a1a1%s|r", percentageValues[1], percentageValues[2] or "0")
    local leftTextLine = string.format("%s |c%s%s|r |cff91c1f1x|r |cff6191f1%d|r", unit_icon, unitColor, mobName, mobNameData.Quantity)
    local rightTextLine = string.format("%s", percentageText) .. "|cfff1b131%|r"
    GameTooltip:AddDoubleLine(leftTextLine, rightTextLine)

    if index > LogBookLoot.db.char.general.loot.itemsToShow then
      if numItems > LogBookLoot.db.char.general.loot.itemsToShow then
        GameTooltip:AddLine(string.format("%d %s...", (numItems - LogBookLoot.db.char.general.loot.itemsToShow), LogBook:LB_i18n("more")))
      end
      break
    end
    index = index + 1
  end
end

---Show tooltip
---@param item table
function LBL_LootTooltip.ShowTooltip(item)
  local itemID = item.itemID
  local currentItem = LogBookLoot.db.global.data.items[itemID] or {}
  local results = currentItem.Result or {}
  local mobNames = results.MobNames or {}
  local numItems = LB_CustomFunctions:TableLength(mobNames)

  local isShowItemID = LogBookLoot.db.char.general.loot.showItemID
  local isShowTitle = LogBookLoot.db.char.general.loot.showTitle
  local itemIDText = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("ROWID"), tostring(itemID))
  if not isShowItemID then
    itemIDText = ""
  end
  local titleText = LogBookLoot:MessageWithAddonColor(LogBookLoot:LBL_i18n("Loot"))

  if isShowTitle then
    titleText = string.format("%s |cff999999(%d %s)|r", titleText, numItems or 0, LogBookLoot:LBL_i18n("loots"))
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(titleText, itemIDText)
  end

  LBL_LootTooltip.ProcessEntryList(results)
end
