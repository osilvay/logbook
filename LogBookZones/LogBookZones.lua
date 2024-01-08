---@type LBZ_SettingsDefaults
local LBZ_SettingsDefaults = LB_ModuleLoader:ImportModule("LBZ_SettingsDefaults")

---@type LBZ_EventHandler
local LBZ_EventHandler = LB_ModuleLoader:ImportModule("LBZ_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookZones")

function LogBookZones:OnInitialize()
	LogBookZones.db = LibStub("AceDB-3.0"):New("LogBookZonesDB", LBZ_SettingsDefaults:Load(), true)
	LogBookZones.key = UnitName("player") .. " - " .. GetRealmName()
	LogBookZones.db.global.data.locale["esUS"] = nil
end

function LogBookZones:Initialize()
	LBZ_EventHandler:StartZonesModuleEvents()
end

---@param message string
---@return string string
function LogBookZones:i18n(message)
	local locale = GetLocale()
	LogBookZones.db.global.data.locale[locale] = {
		old = {
		},
		new = {
		}
	}
	return tostring(L[message])
end

function LogBookZones:Print(message)
	print("|cffffffffLog|r|cff57b6ffBook|r|cff4fe368Zones|r: " .. message)
end