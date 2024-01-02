---@type LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:ImportModule("LBL_SettingsDefaults")

---@type LBL_EventHandler
local LBL_EventHandler = LB_ModuleLoader:ImportModule("LBL_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookLoot")

function LogBookLoot:OnInitialize()
	--LogBook:Debug(LogBookLoot:i18n("Initializing loot module"))
	LogBookLoot.db = LibStub("AceDB-3.0"):New("LogBookLootDB", LBL_SettingsDefaults:Load(), true)
	LogBookLoot.key = UnitName("player") .. " - " .. GetRealmName()
	LogBookLoot.db.global.data.locale["esUS"] = nil
	LBL_EventHandler:StartLootModuleEvents()
end

---@param message string
---@return string string
function LogBookLoot:i18n(message)
	local locale = GetLocale()
	if LogBookLoot.db.global.data.locale[locale] == nil then
		LogBookLoot.db.global.data.locale[locale] = {
			old = {
			},
			new = {
			}
		}
	end
	if LogBookLoot.db.global.data.locale["esUS"] == nil then
		LogBookLoot.db.global.data.locale["esUS"] = {
			all = {
			},
		}
	end
	
	LogBookLoot.db.global.data.locale[locale].old = L
	local oldLocales = LogBookLoot.db.global.data.locale[locale].old
	table.sort(oldLocales, function(a, b)
		return a:lower() < b:lower()
	end)

	LogBookLoot.db.global.data.locale[locale].old = oldLocales
	LogBookLoot.db.global.data.locale["esUS"].all[message] = true

	if not LB_CustomFunctions:TableHasKey(L, message) then
		LogBookLoot.db.global.data.locale[locale].new[message] = message
	end

	local newLocales = LB_CustomFunctions:SyncTableEntries(LogBookLoot.db.global.data.locale[locale].new,
		LogBookLoot.db.global.data.locale[locale].old)

	table.sort(newLocales, function(v1, v2) return v1 < v2 end)
	LogBookLoot.db.global.data.locale[locale].new = newLocales
	return tostring(L[message])
end
