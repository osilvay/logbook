---@type LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:ImportModule("LBC_SettingsDefaults")

---@type LBC_EventHandler
local LBC_EventHandler = LB_ModuleLoader:ImportModule("LBC_EventHandler");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookCritics")

function LogBookCritics:OnInitialize()
	--LogBook:Debug(LogBookCritics:i18n("Initializing critics module"))
	LogBookCritics.db = LibStub("AceDB-3.0"):New("LogBookCriticsDB", LBC_SettingsDefaults:Load(), true)
	LogBookCritics.key = UnitName("player").." - "..GetRealmName()
	LBC_EventHandler:StartCriticsModuleEvents()
end

---@param message string
---@return string string
function LogBookCritics:i18n(message)
	if L[message] ~= nil then
		return tostring(L[message])
	end
	return message
end