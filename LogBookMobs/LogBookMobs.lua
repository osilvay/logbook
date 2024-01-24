---@type LBM_SettingsDefaults
local LBM_SettingsDefaults = LB_ModuleLoader:ImportModule("LBM_SettingsDefaults")

---@type LBM_EventHandler
local LBM_EventHandler = LB_ModuleLoader:ImportModule("LBM_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookMobs")
local AddonColor = "ff5be3de"

function LogBookMobs:OnInitialize()
  LogBookMobs.db = LibStub("AceDB-3.0"):New("LogBookMobsDB", LBM_SettingsDefaults:Load(), true)
  LogBookMobs.key = UnitName("player") .. " - " .. GetRealmName()
  LogBookMobs.db.global.data.locale["esUS"] = nil
end

function LogBookMobs:Initialize()
  LBM_EventHandler:StartMobsModuleEvents()
end

---@param message string
---@return string string
function LogBookMobs:LBM_i18n(message)
  local locale = GetLocale()
  LogBookMobs.db.global.data.locale[locale] = {
    old = {
    },
    new = {
    }
  }
  return tostring(L[message])
end

function LogBookMobs:Print(message)
  print("|cffffffffLog|r|cff57b6ffBook|r|cff5be3deMobs|r: " .. message)
end

---Gets addon color
function LogBookMobs:GetAddonColor()
  return AddonColor
end
