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

---Show tooltip
---@param item table
function LBL_LootTooltip.ShowTooltip(item)
  local itemID = item.itemID
  local currentItem = LogBookLoot.db.global.data.items[itemID] or {}
  local results = currentItem.Result or {}
  local mobNames = results.MobNames or {}

  -- filter by item quality
  local itemQualities = LogBookLoot.db.char.general.loot.itemQuality or {}
  local itemQualityList = {}

  for k, itemQualityValue in pairs(itemQualities) do
    if itemQualityValue then
      table.insert(itemQualityList, k)
    end
  end

  if not LB_CustomFunctions:TableHasValue(itemQualityList, tostring(currentItem.Quality)) then return end

  -- filter by unit classification
  local unitClassifications = LogBookLoot.db.char.general.loot.unitClassification or {}
  local unitClassificationList = {}
  if unitClassifications ~= nil and not LB_CustomFunctions:TableIsEmpty(unitClassifications) then
    for k, unitClassificationValue in pairs(unitClassifications) do
      local unitClassificationKey = {}
      local unitClassificationIndex = 1
      for value in string.gmatch(k, "([^_]+)") do
        unitClassificationKey[unitClassificationIndex] = value
        unitClassificationIndex = unitClassificationIndex + 1
      end
      if unitClassificationValue then
        table.insert(unitClassificationList, unitClassificationKey[2])
      end
    end
  end
  local list = {}

  for mobName, currentMob in pairs(mobNames) do
    if LB_CustomFunctions:TableHasValue(unitClassificationList, currentMob.Quality) then
      list[mobName] = currentMob
    end
  end
  results.MobNames = list

  -- process mobs
  LBL_LootTooltip:DrawTradeskillList(itemID, results)

  -- process tradeskills
  LBL_LootTooltip:DrawMobList(itemID, results)
end

---Draws mob list
---@param itemID string
---@param results table
function LBL_LootTooltip:DrawMobList(itemID, results)
  --- preprocess mobs
  local mobNames = results.MobNames or {}
  local mobList = {}
  for mobName, currentMob in pairs(mobNames) do
    currentMob.Name = currentMob
    if (currentMob.Quantity == 0 and LogBookLoot.db.char.general.loot.zeroValues) or currentMob.Quantity > 0 then
      table.insert(mobList, {
        Name = mobName,
        Quantity = currentMob.Quantity,
        Percent = currentMob.Percent,
        Quality = currentMob.Quality,
      })
    end
  end
  LB_CustomFunctions:SortMultipleValues(mobList, { name = "Quantity", direction = "desc" }, { name = "Quality", direction = "desc" }, { name = "Name", direction = "asc" })

  -- draw tooltip
  local numMobItems = LB_CustomFunctions:TableLength(mobList)
  local currentPercent = 0
  local currentIndex = 0

  -- title
  local isShowItemID = LogBookLoot.db.char.general.loot.showItemID
  local isShowTitle = LogBookLoot.db.char.general.loot.showTitle
  local itemIDText = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("ROWID"), tostring(itemID))
  if not isShowItemID then
    itemIDText = ""
  end
  local titleText = LogBookLoot:MessageWithAddonColor(LogBookLoot:LBL_i18n("Loot"))

  if isShowTitle then
    titleText = string.format("%s |cff999999(%d %s)|r", titleText, numMobItems or 0, LogBookLoot:LBL_i18n("loots"))
    GameTooltip:AddLine(" ")
    GameTooltip:AddDoubleLine(titleText, itemIDText)
  end

  for _, mobNameData in pairs(mobList) do
    currentPercent = currentPercent + mobNameData.Percent
    local unitColor = LB_CustomColors:CustomUnitClassificationColors(mobNameData.Quality)
    local unit_icon = "|TInterface\\AddOns\\LogBook\\Images\\" .. mobNameData.Quality .. ":16:16|t"

    local percentageText = string.format("|cfff1f1f1%s|r", mobNameData.Percent)
    local leftTextLine = string.format("%s |c%s%s|r |cff91c1f1x|r |cff6191f1%d|r", unit_icon, unitColor, mobNameData.Name, mobNameData.Quantity)
    local rightTextLine = string.format("%s", percentageText) .. " |cfff1b131%|r"
    GameTooltip:AddDoubleLine(leftTextLine, rightTextLine)

    currentIndex = currentIndex + 1
    if currentIndex >= LogBookLoot.db.char.general.loot.itemsToShow then
      if numMobItems > LogBookLoot.db.char.general.loot.itemsToShow then
        --GameTooltip:AddLine(string.format("%d %s...", (numItems - LogBookLoot.db.char.general.loot.itemsToShow), LogBook:LB_i18n("more")))
        local remainingPercent = 0
        if currentPercent > 0 then remainingPercent = 100 - currentPercent end
        local remaining = string.format("%.2f", (numMobItems - LogBookLoot.db.char.general.loot.itemsToShow))
        local leftTotal = string.format("%d %s...", remaining, LogBook:LB_i18n("more"))
        local rightTotal = string.format("|cff919191%s|r", remainingPercent) .. " |cfff1b131%|r"
        GameTooltip:AddDoubleLine(leftTotal, rightTotal)
      end
      break
    end
  end
end

---Draws tradeskill info
---@param itemID any
---@param results any
function LBL_LootTooltip:DrawTradeskillList(itemID, results)
  local tradeskills = results.Tradeskills or {}
  local tradeskillsList = {}
  local contientMapIDs = {}

  for tradeskill, tradeskillInfo in pairs(tradeskills) do
    if tradeskill == "Mining" or tradeskill == "Herbalism" or tradeskill == "Fishing" or tradeskill == "Skinning" then
      local tradeskillZones = {}

      for parentMapID, ContinentInfo in pairs(tradeskillInfo) do
        local newContinentInfo = {}
        for _, zoneInfo in pairs(ContinentInfo) do
          contientMapIDs[parentMapID] = zoneInfo.Continent
          if (zoneInfo.Quantity == 0 and LogBookLoot.db.char.general.loot.zeroValues) or zoneInfo.Quantity > 0 then
            table.insert(newContinentInfo, zoneInfo)
          end
        end
        tradeskillInfo[parentMapID] = newContinentInfo
      end
      LB_CustomFunctions:SortMultipleValues(tradeskillZones, { name = "Quantity", direction = "desc" }, { name = "Zone", direction = "desc" })
      tradeskillsList[tradeskill] = tradeskillInfo
    end
  end

  -- draw tooltip
  local numTradeskillItems = 0
  for _, ContinentInfo in pairs(tradeskillsList) do
    for _, _ in pairs(ContinentInfo) do
      numTradeskillItems = numTradeskillItems + 1
    end
  end

  -- draw tradeskills
  for tradeskill, tradeskillInfo in pairs(tradeskillsList) do
    if tradeskill == "Mining" or tradeskill == "Herbalism" or tradeskill == "Fishing" or tradeskill == "Skinning" then
      -- title
      local isShowItemID = LogBookLoot.db.char.general.loot.showItemID
      local isShowTitle = LogBookLoot.db.char.general.loot.showTitle
      local itemIDText = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("ROWID"), tostring(itemID))
      if not isShowItemID then
        itemIDText = ""
      end
      local titleText = LogBookLoot:MessageWithAddonColor(LogBookLoot:LBL_i18n("Tradeskill"))

      if isShowTitle then
        titleText = string.format("%s |cff999999(%d %s)|r", titleText, numTradeskillItems or 0, LogBookLoot:LBL_i18n("zones"))
        GameTooltip:AddLine(" ")
        GameTooltip:AddDoubleLine(titleText, itemIDText)
      end

      local tradeskill_icon = "|TInterface\\AddOns\\LogBook\\Images\\" .. tradeskill .. ":16:16|t"
      local skillColor      = LB_CustomColors:CustomTradeskillColors(tradeskill)
      local leftZoneTotal   = string.format("%s |c%s%s|r |cff91c1f1|r", tradeskill_icon, skillColor, LogBook:LB_i18n(tradeskill))
      local rightZoneTotal  = "" --string.format("%s", percentageText) .. " |cfff1b131%|r"
      GameTooltip:AddDoubleLine(leftZoneTotal, rightZoneTotal)

      -- continents
      for continentID, continentInfo in pairs(tradeskillInfo) do
        if not LB_CustomFunctions:TableIsEmpty(continentInfo) then
          local continent_icon      = "|TInterface\\AddOns\\LogBook\\Images\\Zones\\" .. continentID .. ":16:16|t"
          local continent_color     = "fff1c100"
          local leftContinentTotal  = string.format("   %s |c%s%s|r |cff91c1f1|r", continent_icon, continent_color, contientMapIDs[continentID])
          local rightContinentTotal = "" --string.format("%s", percentageText) .. " |cfff1b131%|r"
          GameTooltip:AddDoubleLine(leftContinentTotal, rightContinentTotal)

          for _, zoneInfo in pairs(continentInfo) do
            local zone_icon         = "|TInterface\\AddOns\\LogBook\\Images\\Zones\\" .. zoneInfo.MapID .. ":16:16|t"
            local zone_color        = "fff19100"
            local percentageText    = string.format("|cfff1f1f1%s|r", zoneInfo.Percent)
            local leftTextZoneLine  = string.format("      %s |c%s%s|r |cff91c1f1x|r |cff6191f1%d|r", zone_icon, zone_color, zoneInfo.Zone, zoneInfo.Quantity)
            local rightTextZoneLine = string.format("%s", percentageText) .. " |cfff1b131%|r"
            GameTooltip:AddDoubleLine(leftTextZoneLine, rightTextZoneLine)
          end
        end
      end
    end
  end
end
