---@type LBE_SettingsDefaults
local LBE_SettingsDefaults = LB_ModuleLoader:ImportModule("LBE_SettingsDefaults")

---@type LBE_EventHandler
local LBE_EventHandler = LB_ModuleLoader:ImportModule("LBE_EventHandler");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

local L = LibStub("AceLocale-3.0"):GetLocale("LogBookEnchanting")
local AddonColor = "fff078ee"

function LogBookEnchanting:OnInitialize()
  LogBookEnchanting.db = LibStub("AceDB-3.0"):New("LogBookEnchantingDB", LBE_SettingsDefaults:Load(), true)
  LogBookEnchanting.key = UnitName("player") .. " - " .. GetRealmName()
  LogBookEnchanting.db.global.data.locale["esUS"] = nil
end

function LogBookEnchanting:Initialize()
  LBE_EventHandler:StartEnchantingModuleEvents()
end

---@param message string
---@return string string
function LogBookEnchanting:LBE_i18n(message)
  local locale = GetLocale()
  LogBookEnchanting.db.global.data.locale[locale] = {
    old = {
    },
    new = {
    }
  }
  return tostring(L[message])
end

function LogBookEnchanting:Print(message)
  print("|cffffffffLog|r|cff57b6ffBook|r|cfff078eeEnchanting|r: " .. message)
end

---Return addon colored
---@param message? string
function LogBookEnchanting:MessageWithAddonColor(message)
  if message == nil then
    return AddonColor
  else
    return string.format("|c%s%s|r", AddonColor, message)
  end
end

---Gets addon color
function LogBookEnchanting:GetAddonColor()
  return AddonColor
end
