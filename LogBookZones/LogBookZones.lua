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
	if LogBookZones.db.global.data.locale[locale] == nil then
		LogBookZones.db.global.data.locale[locale] = {
			old = {
			},
			new = {
			}
		}
	end
	if LogBookZones.db.global.data.locale["esUS"] == nil then
		LogBookZones.db.global.data.locale["esUS"] = {
			all = {
			},
		}
	end
	
	LogBookZones.db.global.data.locale[locale].old = L
	local oldLocales = LogBookZones.db.global.data.locale[locale].old
	table.sort(oldLocales, function(a, b)
		return a:lower() < b:lower()
	end)

	LogBookZones.db.global.data.locale[locale].old = oldLocales
	LogBookZones.db.global.data.locale["esUS"].all[message] = true

	if not LB_CustomFunctions:TableHasKey(L, message) then
		LogBookZones.db.global.data.locale[locale].new[message] = message
	end

	local newLocales = LB_CustomFunctions:SyncTableEntries(LogBookZones.db.global.data.locale[locale].new,
		LogBookZones.db.global.data.locale[locale].old)

	table.sort(newLocales, function(v1, v2) return v1 < v2 end)
	LogBookZones.db.global.data.locale[locale].new = newLocales
	return tostring(L[message])
end
