---@class LB_WelcomeBody
local LB_WelcomeBody = LB_ModuleLoader:CreateModule("LB_WelcomeBody")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LB_WelcomeWindow
local LB_WelcomeWindow = LB_ModuleLoader:ImportModule("LB_WelcomeWindow")

---@type LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:ImportModule("LB_SlashCommands")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local bodyContainer
local itemColor = "ff95e6f5"

---Redraw body container
---@param containerTable table
---@param parentFrame AceGUIFrame
function LB_WelcomeBody:RedrawWelcomeWindowBody(containerTable, parentFrame)
  bodyContainer:ReleaseChildren()
  LB_WelcomeBody:ContainerBodyFrame(containerTable, parentFrame)
end

---Create welcome container body frame
function LB_WelcomeBody:ContainerBodyFrame(containerTable, parentFrame)
  -- table
  if not bodyContainer then
    -- container
    ---@type AceGUIInlineGroup
    bodyContainer = AceGUI:Create("InlineGroup")
    bodyContainer:SetWidth(495)
    bodyContainer:SetHeight(220)
    bodyContainer:SetTitle(LogBook:LB_i18n("Main plugins"))
    bodyContainer:SetLayout("Flow")
    bodyContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 10, -40)
    parentFrame:AddChild(bodyContainer)
  end

  -- ROW 1 ##########################################################################################
  ---@type AceGUISimpleGroup
  local row1 = AceGUI:Create("SimpleGroup")
  row1:SetFullWidth(true)
  row1:SetHeight(200)
  row1:SetAutoAdjustHeight(false)
  row1:SetLayout("Flow")
  bodyContainer:AddChild(row1)

  local modules1 = 1
  C_Timer.NewTicker(0.05, function()
    if modules1 == 1 then
      LB_WelcomeBody:drawCriticsContainer(row1)
      LB_WelcomeBody:drawSeparator(row1, 10)
    elseif modules1 == 2 then
      LB_WelcomeBody:drawEnchantingContainer(row1)
      LB_WelcomeBody:drawSeparator(row1, 10)
    elseif modules1 == 3 then
      LB_WelcomeBody:drawFishingContainer(row1)
    end
    modules1 = modules1 + 1
  end, 3)

  -- ROW 2 ##########################################################################################
  ---@type AceGUISimpleGroup
  local row2 = AceGUI:Create("SimpleGroup")
  row2:SetWidth(495)
  row2:SetHeight(200)
  row2:SetLayout("Flow")
  bodyContainer:AddChild(row2)

  local modules2 = 1
  C_Timer.NewTicker(0.05, function()
    if modules2 == 1 then
      LB_WelcomeBody:drawLootContainer(row2)
      LB_WelcomeBody:drawSeparator(row2, 10)
    elseif modules2 == 2 then
      LB_WelcomeBody:drawMobsContainer(row2)
      LB_WelcomeBody:drawSeparator(row2, 10)
    elseif modules2 == 3 then
      LB_WelcomeBody:drawZonesContainer(row2)
    end
    modules2 = modules2 + 1
  end, 3)
end

function LB_WelcomeBody:drawSeparator(rowContainer, width)
  -- separator
  ---@type AceGUIInlineGroup
  local fishingSeparator = AceGUI:Create("SimpleGroup")
  fishingSeparator:SetWidth(width)
  fishingSeparator:SetHeight(200)
  fishingSeparator:SetLayout("Fill")
  fishingSeparator:SetAutoAdjustHeight(false)
  rowContainer:AddChild(fishingSeparator)
end

function LB_WelcomeBody:drawLootContainer(rowContainer)
  -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- loot container
  ---@type AceGUIInlineGroup
  local lootContainer = AceGUI:Create("InlineGroup")
  lootContainer:SetWidth(150)
  lootContainer:SetHeight(200)
  lootContainer:SetAutoAdjustHeight(false)
  lootContainer:SetLayout("Flow")
  lootContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:LB_i18n("Loot")))
  --lootContainer:SetPoint("TOPLEFT", rowContainer.frame, "TOPLEFT", 0, 0)
  rowContainer:AddChild(lootContainer)

  --Options button
  ---@type AceGUIInteractiveLabel
  local lootButton = AceGUI:Create("InteractiveLabel")
  local lootIcon_a = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_misc_bag_10_red_a:64:64|t"
  local lootIcon = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_misc_bag_10_red:64:64|t"
  local lootText = string.format("|cffc1c1c1%s|r", LogBook:LB_i18n("Allows you to track loot and items crafted with trading skills."))
  local lootformatted = "%s\n\n%s\n"
  lootButton:SetWidth(135)
  lootButton:SetHeight(200)
  lootButton:SetPoint("TOPLEFT", lootContainer.frame, "TOPLEFT", 50, 0)
  lootButton:SetText(string.format(lootformatted, lootIcon_a, lootText))
  lootButton:SetCallback("OnEnter", function(current)
    lootButton:SetText(string.format(lootformatted, lootIcon, lootText))
  end)
  lootButton:SetCallback("OnLeave", function(current)
    lootButton:SetText(string.format(lootformatted, lootIcon_a, lootText))
  end)
  lootButton:SetCallback("OnClick", function(current)
    LB_SlashCommands:OpenLootWindow()
  end)
  lootContainer:AddChild(lootButton)
end

function LB_WelcomeBody:drawFishingContainer(rowContainer)
  -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- fishing container
  ---@type AceGUIInlineGroup
  local fishingContainer = AceGUI:Create("InlineGroup")
  fishingContainer:SetWidth(150)
  fishingContainer:SetHeight(200)
  fishingContainer:SetAutoAdjustHeight(false)
  fishingContainer:SetLayout("Flow")
  fishingContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:LB_i18n("Fishing")))
  --fishingContainer:SetPoint("TOPLEFT", rowContainer.frame, "TOPLEFT", 0, 0)
  rowContainer:AddChild(fishingContainer)

  --Options button
  ---@type AceGUIInteractiveLabel
  local fishingButton = AceGUI:Create("InteractiveLabel")
  local fishingIcon_a = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_fishingpole_02_a:64:64|t"
  local fishingIcon = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_fishingpole_02:64:64|t"
  local fishingText = string.format("|cffc1c1c1%s|r", LogBook:LB_i18n("Allows you to track fish from pools and wreckages."))
  local Fishingformatted = "%s\n\n%s\n"
  fishingButton:SetWidth(135)
  fishingButton:SetHeight(200)
  fishingButton:SetPoint("TOPLEFT", fishingContainer.frame, "TOPLEFT", 50, 0)
  fishingButton:SetText(string.format(Fishingformatted, fishingIcon_a, fishingText))
  fishingButton:SetCallback("OnEnter", function(current)
    fishingButton:SetText(string.format(Fishingformatted, fishingIcon, fishingText))
  end)
  fishingButton:SetCallback("OnLeave", function(current)
    fishingButton:SetText(string.format(Fishingformatted, fishingIcon_a, fishingText))
  end)
  fishingButton:SetCallback("OnClick", function(current)
    LB_SlashCommands:OpenFishingWindow()
  end)
  fishingContainer:AddChild(fishingButton)
end

function LB_WelcomeBody:drawCriticsContainer(rowContainer)
  -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- critics container
  ---@type AceGUIInlineGroup
  local criticsContainer = AceGUI:Create("InlineGroup")
  criticsContainer:SetWidth(150)
  criticsContainer:SetHeight(200)
  criticsContainer:SetAutoAdjustHeight(false)
  criticsContainer:SetLayout("Flow")
  criticsContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:LB_i18n("Critics")))
  --criticsContainer:SetPoint("TOPLEFT", rowContainer.frame, "TOPLEFT", 0, 0)
  rowContainer:AddChild(criticsContainer)

  --Options button
  ---@type AceGUIInteractiveLabel
  local criticsButton = AceGUI:Create("InteractiveLabel")
  local criticsIcon_a = " " .. "|TInterface\\AddOns\\LogBook\\Images\\ability_thunderclap_a:64:64|t"
  local criticsIcon = " " .. "|TInterface\\AddOns\\LogBook\\Images\\ability_thunderclap:64:64|t"
  local criticsText = string.format("|cffc1c1c1%s|r", LogBook:LB_i18n("Allows you to track hits or healing, both normal and critical."))
  local Fishingformatted = "%s\n\n%s\n"
  criticsButton:SetWidth(135)
  criticsButton:SetHeight(200)
  criticsButton:SetPoint("TOPLEFT", criticsContainer.frame, "TOPLEFT", 50, 0)
  criticsButton:SetText(string.format(Fishingformatted, criticsIcon_a, criticsText))
  criticsButton:SetCallback("OnEnter", function(current)
    criticsButton:SetText(string.format(Fishingformatted, criticsIcon, criticsText))
  end)
  criticsButton:SetCallback("OnLeave", function(current)
    criticsButton:SetText(string.format(Fishingformatted, criticsIcon_a, criticsText))
  end)
  criticsButton:SetCallback("OnClick", function(current)
    LB_SlashCommands:OpenCriticsWindow()
  end)
  criticsContainer:AddChild(criticsButton)
end

function LB_WelcomeBody:drawZonesContainer(rowContainer)
  -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- zones container
  ---@type AceGUIInlineGroup
  local zonesContainer = AceGUI:Create("InlineGroup")
  zonesContainer:SetWidth(150)
  zonesContainer:SetHeight(200)
  zonesContainer:SetAutoAdjustHeight(false)
  zonesContainer:SetLayout("Flow")
  zonesContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:LB_i18n("Zones")))
  --zonesContainer:SetPoint("TOPLEFT", rowContainer.frame, "TOPLEFT", 0, 0)
  rowContainer:AddChild(zonesContainer)

  --Options button
  ---@type AceGUIInteractiveLabel
  local zonesButton = AceGUI:Create("InteractiveLabel")
  local zonesIcon_a = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Achievement_zones_01_a:64:64|t"
  local zonesIcon = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Achievement_zones_01:64:64|t"
  local zonesText = string.format("|cffc1c1c1%s|r", LogBook:LB_i18n("Allows you to track zones."))
  local zonesFormatted = "%s\n\n%s\n"
  zonesButton:SetWidth(135)
  zonesButton:SetHeight(200)
  zonesButton:SetPoint("TOPLEFT", zonesContainer.frame, "TOPLEFT", 50, 0)
  zonesButton:SetText(string.format(zonesFormatted, zonesIcon_a, zonesText))
  zonesButton:SetCallback("OnEnter", function(current)
    zonesButton:SetText(string.format(zonesFormatted, zonesIcon, zonesText))
  end)
  zonesButton:SetCallback("OnLeave", function(current)
    zonesButton:SetText(string.format(zonesFormatted, zonesIcon_a, zonesText))
  end)
  zonesButton:SetCallback("OnClick", function(current)
    LB_SlashCommands:OpenZonesWindow()
  end)
  zonesContainer:AddChild(zonesButton)
end

function LB_WelcomeBody:drawMobsContainer(rowContainer)
  -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- zones container
  ---@type AceGUIInlineGroup
  local mobsContainer = AceGUI:Create("InlineGroup")
  mobsContainer:SetWidth(150)
  mobsContainer:SetHeight(200)
  mobsContainer:SetAutoAdjustHeight(false)
  mobsContainer:SetLayout("Flow")
  mobsContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:LB_i18n("Mobs")))
  --zonesContainer:SetPoint("TOPLEFT", rowContainer.frame, "TOPLEFT", 0, 0)
  rowContainer:AddChild(mobsContainer)

  --Options button
  ---@type AceGUIInteractiveLabel
  local mobsButton = AceGUI:Create("InteractiveLabel")
  local mobsIcon_a = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_misc_head_murloc_01_a:64:64|t"
  local mobsIcon = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_misc_head_murloc_01:64:64|t"
  local mobsText = string.format("|cffc1c1c1%s|r", LogBook:LB_i18n("Allows you to track mobs."))
  local mobsFormatted = "%s\n\n%s\n"
  mobsButton:SetWidth(135)
  mobsButton:SetHeight(200)
  mobsButton:SetPoint("TOPLEFT", mobsContainer.frame, "TOPLEFT", 50, 0)
  mobsButton:SetText(string.format(mobsFormatted, mobsIcon_a, mobsText))
  mobsButton:SetCallback("OnEnter", function(current)
    mobsButton:SetText(string.format(mobsFormatted, mobsIcon, mobsText))
  end)
  mobsButton:SetCallback("OnLeave", function(current)
    mobsButton:SetText(string.format(mobsFormatted, mobsIcon_a, mobsText))
  end)
  mobsButton:SetCallback("OnClick", function(current)
    LB_SlashCommands:OpenMobsWindow()
  end)
  mobsContainer:AddChild(mobsButton)
end

function LB_WelcomeBody:drawEnchantingContainer(rowContainer)
  -- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  -- zones container
  ---@type AceGUIInlineGroup
  local enchantingContainer = AceGUI:Create("InlineGroup")
  enchantingContainer:SetWidth(150)
  enchantingContainer:SetHeight(200)
  enchantingContainer:SetAutoAdjustHeight(false)
  enchantingContainer:SetLayout("Flow")
  enchantingContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:LB_i18n("Enchanting")))
  --zonesContainer:SetPoint("TOPLEFT", rowContainer.frame, "TOPLEFT", 0, 0)
  rowContainer:AddChild(enchantingContainer)

  --Options button
  ---@type AceGUIInteractiveLabel
  local enchantingButton = AceGUI:Create("InteractiveLabel")
  local enchantingIcon_a = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_enchant_shardprismaticlarge_a:64:64|t"
  local enchantingIcon = " " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_enchant_shardprismaticlarge:64:64|t"
  local enchantingText = string.format("|cffc1c1c1%s|r", LogBook:LB_i18n("Allows you to track enchanting."))
  local enchantingFormatted = "%s\n\n%s\n"
  enchantingButton:SetWidth(135)
  enchantingButton:SetHeight(200)
  enchantingButton:SetPoint("TOPLEFT", enchantingContainer.frame, "TOPLEFT", 50, 0)
  enchantingButton:SetText(string.format(enchantingFormatted, enchantingIcon_a, enchantingText))
  enchantingButton:SetCallback("OnEnter", function(current)
    enchantingButton:SetText(string.format(enchantingFormatted, enchantingIcon, enchantingText))
  end)
  enchantingButton:SetCallback("OnLeave", function(current)
    enchantingButton:SetText(string.format(enchantingFormatted, enchantingIcon_a, enchantingText))
  end)
  enchantingButton:SetCallback("OnClick", function(current)
    LB_SlashCommands:OpenEnchantingWindow()
  end)
  enchantingContainer:AddChild(enchantingButton)
end
