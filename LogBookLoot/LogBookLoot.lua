---@type LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:ImportModule("LBL_SettingsDefaults")

---@type LBL_EventHandler
local LBL_EventHandler = LB_ModuleLoader:ImportModule("LBL_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookLoot")
local AddonColor = "ffe38d4f"

function LogBookLoot:OnInitialize()
  LogBookLoot.db = LibStub("AceDB-3.0"):New("LogBookLootDB", LBL_SettingsDefaults:Load(), true)
  LogBookLoot.key = UnitName("player") .. " - " .. GetRealmName()
  LogBookLoot.db.global.data.locale["esUS"] = nil
end

function LogBookLoot:Initialize()
  LBL_EventHandler:StartLootModuleEvents()
end

---@param message string
---@return string string
function LogBookLoot:LBL_i18n(message)
  local locale = GetLocale()
  LogBookLoot.db.global.data.locale[locale] = {
    old = {
    },
    new = {
    }
  }
  return tostring(L[message])
end

function LogBookLoot:Print(message)
  print("|cffffffffLog|r|cff57b6ffBook|r|cffe38d4fLoot|r: " .. message)
end

---Gets addon color
function LogBookLoot:GetAddonColor()
  return AddonColor
end
