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
function LogBookCritics:LBC_i18n(message)
  local locale = GetLocale()
  LogBookCritics.db.global.data.locale[locale] = {
    old = {
    },
    new = {
    }
  }
  return tostring(L[message])
end

function LogBookCritics:Print(message)
  print("|cffffffffLog|r|cff57b6ffBook|r|cfffff757Critics|r: " .. message)
end
