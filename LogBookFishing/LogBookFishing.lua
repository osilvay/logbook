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
	if LogBookFishing.db.global.data.locale[locale] == nil then
		LogBookFishing.db.global.data.locale[locale] = {
			old = {
			},
			new = {
			}
		}
	end
	if LogBookFishing.db.global.data.locale["esUS"] == nil then
		LogBookFishing.db.global.data.locale["esUS"] = {
			all = {
			},
		}
	end
	
	LogBookFishing.db.global.data.locale[locale].old = L
	local oldLocales = LogBookFishing.db.global.data.locale[locale].old
	table.sort(oldLocales, function(a, b)
		return a:lower() < b:lower()
	end)

	LogBookFishing.db.global.data.locale[locale].old = oldLocales
	LogBookFishing.db.global.data.locale["esUS"].all[message] = true

	if not LB_CustomFunctions:TableHasKey(L, message) then
		LogBookFishing.db.global.data.locale[locale].new[message] = message
	end

	local newLocales = LB_CustomFunctions:SyncTableEntries(LogBookFishing.db.global.data.locale[locale].new,
		LogBookFishing.db.global.data.locale[locale].old)

	table.sort(newLocales, function(v1, v2) return v1 < v2 end)
	LogBookFishing.db.global.data.locale[locale].new = newLocales
	return tostring(L[message])
end
