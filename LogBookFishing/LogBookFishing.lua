---@type LBF_SettingsDefaults
local LBF_SettingsDefaults = LB_ModuleLoader:ImportModule("LBF_SettingsDefaults")

---@type LBF_EventHandler
local LBF_EventHandler = LB_ModuleLoader:ImportModule("LBF_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookFishing")

function LogBookFishing:OnInitialize()
	LogBookFishing.db = LibStub("AceDB-3.0"):New("LogBookFishingDB", LBF_SettingsDefaults:Load(), true)
	LogBookFishing.key = UnitName("player") .. " - " .. GetRealmName()
	LogBookFishing.db.global.data.locale["esUS"] = nil
end

function LogBookFishing:Initialize()
	LBF_EventHandler:StartFishingModuleEvents()
end

---@param message string
---@return string string
function LogBookFishing:i18n(message)
	local locale = GetLocale()
	LogBookFishing.db.global.data.locale[locale] = {
		old = {
		},
		new = {
		}
	}
	return tostring(L[message])
end

function LogBookFishing:Print(message)
	print("|cffffffffLog|r|cff57b6ffBook|r|cffa27be0Fishing|r: " .. message)
end