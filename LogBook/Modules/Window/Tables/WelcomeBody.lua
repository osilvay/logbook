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
		bodyContainer:SetHeight(240)
		bodyContainer:SetTitle(LogBook:i18n("Main plugins"))
		bodyContainer:SetLayout("Flow")
		bodyContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 10, -40)
		parentFrame:AddChild(bodyContainer)
	end

	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- loot container
	---@type AceGUIInlineGroup
	local lootContainer = AceGUI:Create("InlineGroup")
	lootContainer:SetWidth(150)
	lootContainer:SetHeight(200)
	lootContainer:SetAutoAdjustHeight(false)
	lootContainer:SetLayout("Flow")
	lootContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:i18n("Loot")))
	lootContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, 0)
	bodyContainer:AddChild(lootContainer)

	--Options button
	---@type AceGUIInteractiveLabel
	local lootButton = AceGUI:Create("InteractiveLabel")
	local lootIcon_a = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_misc_bag_10_red_a:64:64|t"
	local lootIcon = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_misc_bag_10_red:64:64|t"
	local lootText = string.format("|cffc1c1c1%s|r", LogBook:i18n("Allows you to track loot and items crafted with trading skills."))
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

	-- separator
	---@type AceGUIInlineGroup
	local lootSeparator = AceGUI:Create("SimpleGroup")
	lootSeparator:SetWidth(10)
	lootSeparator:SetHeight(170)
	lootSeparator:SetLayout("Fill")
	bodyContainer:AddChild(lootSeparator)

	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- fishing container
	---@type AceGUIInlineGroup
	local fishingContainer = AceGUI:Create("InlineGroup")
	fishingContainer:SetWidth(150)
	fishingContainer:SetHeight(200)
	fishingContainer:SetAutoAdjustHeight(false)
	fishingContainer:SetLayout("Flow")
	fishingContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:i18n("Fishing")))
	fishingContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, 0)
	bodyContainer:AddChild(fishingContainer)

	--Options button
	---@type AceGUIInteractiveLabel
	local fishingButton = AceGUI:Create("InteractiveLabel")
	local fishingIcon_a = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_fishingpole_02_a:64:64|t"
	local fishingIcon = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\Inv_fishingpole_02:64:64|t"
	local fishingText = string.format("|cffc1c1c1%s|r", LogBook:i18n("Allows you to track fish from pools and wreckages."))
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

	-- separator
	---@type AceGUIInlineGroup
	local fishingSeparator = AceGUI:Create("SimpleGroup")
	fishingSeparator:SetWidth(10)
	fishingSeparator:SetHeight(170)
	fishingSeparator:SetLayout("Fill")
	bodyContainer:AddChild(fishingSeparator)

	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- critics container
	---@type AceGUIInlineGroup
	local criticsContainer = AceGUI:Create("InlineGroup")
	criticsContainer:SetWidth(150)
	criticsContainer:SetHeight(200)
	criticsContainer:SetAutoAdjustHeight(false)
	criticsContainer:SetLayout("Flow")
	criticsContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:i18n("Critics")))
	criticsContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, 0)
	bodyContainer:AddChild(criticsContainer)

	--Options button
	---@type AceGUIInteractiveLabel
	local criticsButton = AceGUI:Create("InteractiveLabel")
	local criticsIcon_a = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\ability_thunderclap_a:64:64|t"
	local criticsIcon = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\ability_thunderclap:64:64|t"
	local criticsText = string.format("|cffc1c1c1%s|r", LogBook:i18n("Allows you to track hits or healing, both normal and critical."))
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

	-- separator
	---@type AceGUIInlineGroup
	local criticsSeparator = AceGUI:Create("SimpleGroup")
	criticsSeparator:SetWidth(10)
	criticsSeparator:SetHeight(170)
	criticsSeparator:SetLayout("Fill")
	bodyContainer:AddChild(criticsSeparator)

	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- zones container
	---@type AceGUIInlineGroup
	local zonesContainer = AceGUI:Create("InlineGroup")
	zonesContainer:SetWidth(150)
	zonesContainer:SetHeight(200)
	zonesContainer:SetAutoAdjustHeight(false)
	zonesContainer:SetLayout("Flow")
	zonesContainer:SetTitle(string.format("|c%s%s|r", itemColor, LogBook:i18n("Zones")))
	zonesContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, 0)
	bodyContainer:AddChild(zonesContainer)

	--Options button
	---@type AceGUIInteractiveLabel
	local zonesButton = AceGUI:Create("InteractiveLabel")
	local zonesIcon_a = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\Achievement_zones_01_a:64:64|t"
	local zonesIcon = "      " .. "|TInterface\\AddOns\\LogBook\\Images\\Achievement_zones_01:64:64|t"
	local zonesText = string.format("|cffc1c1c1%s|r", LogBook:i18n("Allows you to track zones."))
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

	-- separator
	---@type AceGUIInlineGroup
	local zonesSeparator = AceGUI:Create("SimpleGroup")
	zonesSeparator:SetWidth(10)
	zonesSeparator:SetHeight(170)
	zonesSeparator:SetLayout("Fill")
	bodyContainer:AddChild(zonesSeparator)

	-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-- end
end