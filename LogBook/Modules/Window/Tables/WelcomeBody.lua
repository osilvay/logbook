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
		bodyContainer:SetWidth(500)
		bodyContainer:SetHeight(240)
		bodyContainer:SetTitle(LogBook:i18n("Main plugins"))
		bodyContainer:SetLayout("Flow")
		bodyContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 0, -20)
		parentFrame:AddChild(bodyContainer)
	end

	-- fishing container
	---@type AceGUIInlineGroup
	local fishingContainer = AceGUI:Create("InlineGroup")
	fishingContainer:SetWidth(150)
	fishingContainer:SetHeight(200)
	fishingContainer:SetAutoAdjustHeight(false)
	fishingContainer:SetLayout("Flow")
	fishingContainer:SetTitle(string.format("|cffffffff%s|r", LogBook:i18n("Fishing")))
	fishingContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, 0)
	bodyContainer:AddChild(fishingContainer)

	--[[
	--Options button
	---@type AceGUIInteractiveLabel
	local fishingButton = AceGUI:Create("InteractiveLabel")
	local fishingIcon_a = "|TInterface\\AddOns\\LogBook\\Images\\Inv_fishingpole_02_a:92:92|t"
	local fishingIcon = "|TInterface\\AddOns\\LogBook\\Images\\Inv_fishingpole_02:92:92|t"
	local fishingText = string.format("|cffc1c1c1%s|r", LogBook:i18n("Allows you to track fish from pools and wreckages."))
	local Fishingformatted = "%s\n\n%s\n"
	fishingButton:SetWidth(140)
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
	end)
	fishingContainer:AddChild(fishingButton)

	-- separator
	---@type AceGUIInlineGroup
	local separator1 = AceGUI:Create("SimpleGroup")
	separator1:SetWidth(25)
	separator1:SetHeight(170)
	separator1:SetLayout("Fill")
	bodyContainer:AddChild(separator1)
	]]
	
	-- critics container
	---@type AceGUIInlineGroup
	local criticsContainer = AceGUI:Create("InlineGroup")
	criticsContainer:SetWidth(150)
	criticsContainer:SetHeight(200)
	criticsContainer:SetAutoAdjustHeight(false)
	criticsContainer:SetLayout("Flow")
	criticsContainer:SetTitle(string.format("|cffffffff%s|r", LogBook:i18n("Critics")))
	criticsContainer:SetPoint("TOPLEFT", bodyContainer.frame, "TOPLEFT", 0, 0)
	bodyContainer:AddChild(criticsContainer)

	--Options button
	---@type AceGUIInteractiveLabel
	local criticsButton = AceGUI:Create("InteractiveLabel")
	local criticsIcon_a = "|TInterface\\AddOns\\LogBook\\Images\\ability_thunderclap_a:92:92|t"
	local criticsIcon = "|TInterface\\AddOns\\LogBook\\Images\\ability_thunderclap:92:92|t"
	local criticsText = string.format("|cffc1c1c1%s|r", LogBook:i18n("Allows you to track hits or healing, both normal and critical."))
	local Fishingformatted = "%s\n\n%s\n"
	criticsButton:SetWidth(140)
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
