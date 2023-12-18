---@type LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:ImportModule("LBC_SettingsDefaults")

---@type LBC_EventHandler
local LBC_EventHandler = LB_ModuleLoader:ImportModule("LBC_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

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
	if not LB_CustomFunctions:TableHasValue(L, message) then
		LogBookCritics.db.global.data.locale[message] = message
	end
	if L[message] ~= nil then
		return tostring(L[message])
	end
	return message
end