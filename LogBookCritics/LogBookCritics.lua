---@type LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:ImportModule("LBC_SettingsDefaults")

---@type LBC_EventHandler
local LBC_EventHandler = LB_ModuleLoader:ImportModule("LBC_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookCritics")

function LogBookCritics:OnInitialize()
	LogBookCritics.db = LibStub("AceDB-3.0"):New("LogBookCriticsDB", LBC_SettingsDefaults:Load(), true)
	LogBookCritics.key = UnitName("player") .. " - " .. GetRealmName()
	LogBookCritics.db.global.data.locale["esUS"] = nil
end

function LogBookCritics:Initialize()
	LBC_EventHandler:StartCriticsModuleEvents()
end

---@param message string
---@return string string
function LogBookCritics:i18n(message)
	local locale = GetLocale()
	if LogBookCritics.db.global.data.locale[locale] == nil then
		LogBookCritics.db.global.data.locale[locale] = {
			old = {
			},
			new = {
			}
		}
	end
	if LogBookCritics.db.global.data.locale["esUS"] == nil then
		LogBookCritics.db.global.data.locale["esUS"] = {
			all = {
			},
		}
	end
	
	LogBookCritics.db.global.data.locale[locale].old = L
	local oldLocales = LogBookCritics.db.global.data.locale[locale].old
	table.sort(oldLocales, function(a, b)
		return a:lower() < b:lower()
	end)

	LogBookCritics.db.global.data.locale[locale].old = oldLocales
	LogBookCritics.db.global.data.locale["esUS"].all[message] = true

	if not LB_CustomFunctions:TableHasKey(L, message) then
		LogBookCritics.db.global.data.locale[locale].new[message] = message
	end

	local newLocales = LB_CustomFunctions:SyncTableEntries(LogBookCritics.db.global.data.locale[locale].new,
		LogBookCritics.db.global.data.locale[locale].old)

	table.sort(newLocales, function(v1, v2) return v1 < v2 end)
	LogBookCritics.db.global.data.locale[locale].new = newLocales
	return tostring(L[message])
end
