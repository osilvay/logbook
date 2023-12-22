---@type LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:ImportModule("LB_SettingsDefaults")

---@type LB_EventHandler
local LB_EventHandler = LB_ModuleLoader:ImportModule("LB_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

local L = LibStub("AceLocale-3.0"):GetLocale("LogBook")

LogBook.DEBUG_CRITICAL = "|cff00f2e6[CRITICAL]|r"
LogBook.DEBUG_ELEVATED = "|cffebf441[ELEVATED]|r"
LogBook.DEBUG_INFO = "|cff00bc32[INFO]|r"
LogBook.DEBUG_DEVELOP = "|cff7c83ff[DEVELOP]|r"
LogBook.DEBUG_SPAM = "|cffff8484[SPAM]|r"

function LogBook:OnInitialize()
	LogBook.db = LibStub("AceDB-3.0"):New("LogBookDB", LB_SettingsDefaults:Load(), true)
	LogBook.key = UnitName("player").." - "..GetRealmName()
	LogBook.started = false
	LB_EventHandler:RegisterEarlyEvents()
end

---On enable addon
function LogBook:OnEnable()
end

---Error message
function LogBook:Error(...)
	LogBook:Print("|cfffc8686[ERROR]|r", ...)
end

---Warning message
function LogBook:Warning(...)
	if LogBook:IsDebugEnabled() then
		LogBook:Print("|cfffcb986[WARNING]|r", ...)
	end
end

---Info message
function LogBook:Info(...)
	if LogBook:IsDebugEnabled() then
		LogBook:Print("|cff86f0fc[INFO]|r", ...)
	end
end

---Debug message
function LogBook:Debug(...)
	if LogBook:IsDebugEnabled() then
		LogBook:Print("|cfffcfc86[DEBUG]|r", ...)
	end
end

---Log message
function LogBook:Log(...)
	if LogBook:IsDebugEnabled() then
		LogBook:Print("|cffb2fc86[LOG]|r", ...)
	end
end

---Dump message
function LogBook:Dump(...)
	if LogBook:IsDebugEnabled() then
		LogBook:Print("|cffb3b2b8[DUMP]|r", LB_CustomFunctions:Dump(...))
	end
end

---Check debug enabled 
function LogBook:IsDebugEnabled()
	if LogBook.db.global.debug == nil then
		return false
	elseif LogBook.db.global.debug then
		--LogBook:Print("IsDebugEnabled = true")
	else
		--LogBook:Print("IsDebugEnabled = false")
	end
	return LogBook.db.global.debug
end

---@param message string
---@return string string
function LogBook:i18n(message)
	local locale = GetLocale()
	if LogBook.db.global.data.locale[locale] == nil then
		LogBook.db.global.data.locale[locale] = {
			old = {
			},
			new = {
			}
		}
	end
	if LogBook.db.global.data.locale["esUS"] == nil then
		LogBook.db.global.data.locale["esUS"] = {
			all = {
			},
		}
	end
	
	LogBook.db.global.data.locale[locale].old = L
	local oldLocales = LogBook.db.global.data.locale[locale].old
	table.sort(oldLocales, function(a, b)
		return a:lower() < b:lower()
	end)

	LogBook.db.global.data.locale[locale].old = oldLocales
	LogBook.db.global.data.locale["esUS"].all[message] = true

	if not LB_CustomFunctions:TableHasKey(L, message) then
		LogBook.db.global.data.locale[locale].new[message] = message
	end

	local newLocales = LB_CustomFunctions:SyncTableEntries(LogBook.db.global.data.locale[locale].new,
	LogBook.db.global.data.locale[locale].old)

	table.sort(newLocales, function(v1, v2) return v1 < v2 end)
	LogBook.db.global.data.locale[locale].new = newLocales
	return tostring(L[message])
end
