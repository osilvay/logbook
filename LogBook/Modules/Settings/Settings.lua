---@class LB_Settings
local LB_Settings = LB_ModuleLoader:CreateModule("LB_Settings")

---@type LBC_Settings
local LBC_Settings = LB_ModuleLoader:ImportModule("LBC_Settings")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:ImportModule("LB_SettingsDefaults");

-- Forward declaration
LB_Settings.tabs = { ... }

---@type AceGUIFrame, AceGUIFrame
LogBookSettingsFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

function LB_Settings:Initialize()
	local optionsTable = _CreateSettingsTable()
	AceConfigRegistry:RegisterOptionsTable("LogBook", optionsTable)
	AceConfigDialog:AddToBlizOptions("LogBook", "LogBook");
	if not LogBookSettingsFrame then
		--LogBook:Debug(LogBook:i18n("Creating settings frame"))

		---@type AceGUIFrame, AceGUIFrame
		local logBookSettingsFrame = AceGUI:Create("Frame");
		logBookSettingsFrame:Hide()
		AceConfigDialog:SetDefaultSize("LogBook", 600, 520)
		AceConfigDialog:Open("LogBook", logBookSettingsFrame) -- load the options into configFrame
		logBookSettingsFrame:SetTitle("|cffffffffLog|r|cff57b6ffBook|r |cff57ff68v0.0.1|r")
		logBookSettingsFrame:SetLayout("Fill")
		logBookSettingsFrame:EnableResize(false)
		logBookSettingsFrame:SetStatusText(LogBook:i18n("LogBook settings window"))
		logBookSettingsFrame:Hide()
		logBookSettingsFrame:SetCallback("OnClose", function(widget)
			PlaySound(840)
		end)
		--[[
		-- spellID
		---@type AceGUILabel
		local spellIDLabel = AceGUI:Create("Label")
		spellIDLabel:SetWidth(40)
		spellIDLabel:SetHeight(40)
		spellIDLabel:SetPoint("TOPRIGHT", logBookSettingsFrame.frame, "TOPRIGHT", -20, -10)
		spellIDLabel:SetText("")
		spellIDLabel:SetImage(LB_CustomFunctions:GetCustomIcon("BOOK_5"))
		spellIDLabel:SetImageSize(40, 40)
		spellIDLabel:SetColor(224, 224, 224)
		logBookSettingsFrame:AddChild(spellIDLabel)
]]

		--[[
		-- image as icon
		---@type AceGUIIcon
		local logBookIcon = AceGUI:Create("Icon")
		logBookIcon:SetWidth(32)
		logBookIcon:SetHeight(32)
		logBookIcon:SetImage(LB_CustomFunctions:GetCustomIcon("BOOK_5"))
		logBookIcon:SetImageSize(32, 32)
		logBookIcon:SetPoint("TOPRIGHT", logBookSettingsFrame.frame, "TOPRIGHT", -20, -10)
		logBookIcon:SetCallback("OnEnter", function()
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetText("LogBook")
			GameTooltip:Show()
		end)
		logBookIcon:SetCallback("OnLeave", function()
			GameTooltip:Hide()
		end)
		logBookSettingsFrame:AddChild(logBookIcon)
		]]

		logBookSettingsFrame:Hide()
		LogBookSettingsFrame = logBookSettingsFrame;

		-- Add the frame as a global variable under the name `MyGlobalFrameName`
		_G["LogBookSettingsFrame"] = LogBookSettingsFrame.frame
		-- Register the global variable `MyGlobalFrameName` as a "special frame"
		-- so that it is closed when the escape key is pressed.
		table.insert(UISpecialFrames, "LogBookSettingsFrame");
	else
	end
end

---@return table
_CreateSettingsTable = function()
	local general_tab = LB_Settings.tabs.general:Initialize()
	local advanced_tab = LB_Settings.tabs.advanced:Initialize()
	local critics_tab = nil
	if CriticsWindowFrame ~= nil then
		critics_tab = LBC_Settings:Initialize()
	end

	return {
		name = "LogBook",
		handler = LogBook,
		type = "group",
		childGroups = "tab",
		args = {
			general_tab = general_tab,
			critics_tab = critics_tab,
			advanced_tab = advanced_tab,
			profiles_tab = LibStub("AceDBOptions-3.0"):GetOptionsTable(LogBook.db)
		}
	}
end

-- Generic function to hide the config frame.
function LB_Settings:HideSettingsFrame()
	if LogBookSettingsFrame and LogBookSettingsFrame:IsShown() then
		LogBookSettingsFrame:Hide();
	end
end

-- Open the configuration window
function LB_Settings:OpenSettingsFrame()
	if not LogBookSettingsFrame then return end
	if not LogBookSettingsFrame:IsShown() then
		PlaySound(882)
		--LogBook:Debug("Show Config frame")
		LogBookSettingsFrame:Show()
	else
		--LogBook:Debug("Hide Config frame")
		LogBookSettingsFrame:Hide()
	end
end

function LB_Settings:CreateSettingsFrame()
end

function LB_Settings:RebuildFrame()
	if LogBookSettingsFrame ~= nil then
		--LogBook:Debug(LogBook:i18n("Refreshing settings frame"))
		--AceGUI:Release(LogBookSettingsFrame)
		--AceConfigDialog:Close(LogBookSettingsFrame)
		LB_Settings:Initialize()
	end
end
