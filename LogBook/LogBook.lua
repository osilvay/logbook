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
  LogBook.key = UnitName("player") .. " - " .. GetRealmName()
  LogBook.started = false
  LB_EventHandler:RegisterEarlyEvents()
end

---On enable addon
function LogBook:OnEnable()
end

---Error message
function LogBook:Error(message)
  LogBook:Print("|cfffc8686[ERROR]|r " .. message)
end

---Warning message
function LogBook:Warning(message)
  if LogBook:IsDebugEnabled() then
    LogBook:Print("|cfffcb986[WARNING]|r " .. message)
  end
end

---Info message
function LogBook:Info(message)
  if LogBook:IsDebugEnabled() then
    LogBook:Print("|cff86f0fc[INFO]|r " .. message)
  end
end

---Debug message
function LogBook:Debug(message)
  if LogBook:IsDebugEnabled() then
    if message == nil then message = 'nil' end
    LogBook:Print("|cfffcfc86[DEBUG]|r " .. message)
  end
end

---Log message
function LogBook:Log(message)
  if LogBook:IsDebugEnabled() then
    LogBook:Print("|cffb2fc86[LOG]|r " .. message)
  end
end

---Dump message
function LogBook:Dump(message)
  if LogBook:IsDebugEnabled() then
    if message == nil then
      LogBook:Print("|cffb3b2b8[DUMP]|r nil")
    end
    LogBook:Print("|cffb3b2b8[DUMP]|r " .. LB_CustomFunctions:Dump(message))
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
  LogBook.db.global.data.locale[locale] = {
    old = {
    },
    new = {
    }
  }
  return tostring(L[message])
end

---Prints message
---@param message string
function LogBook:Print(message)
  print("|cffffffffLog|r|cff57b6ffBook|r: " .. message)
end

local cachedTitle
---Get addon version info
function LogBook:GetAddonVersionInfo()
  if (not cachedTitle) then
    local _, title, _, _, _ = C_AddOns.GetAddOnInfo("LogBook")
    cachedTitle = title
  end
  -- %d = digit, %p = punctuation character, %x = hexadecimal digits.
  local major, minor, patch, _ = string.match(cachedTitle, "(%d+)%p(%d+)%p(%d+)")
  return tonumber(major), tonumber(minor), tonumber(patch)
end

---Get addon version string
function LogBook:GetAddonVersionString()
  local major, minor, patch = LogBook:GetAddonVersionInfo()
  return "v" .. tostring(major) .. "." .. tostring(minor) .. "." .. tostring(patch)
end
