---@class LBL_Settings
local LBL_Settings = LB_ModuleLoader:CreateModule("LBL_Settings");

---@type LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:ImportModule("LBL_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

---@type LB_CustomConfig
local LB_CustomConfig = LB_ModuleLoader:ImportModule("LB_CustomConfig")

---@type LBL_Database
local LBL_Database = LB_ModuleLoader:ImportModule("LBL_Database")

---@type LBL_ConfigGroups
local LBL_ConfigGroups = LB_ModuleLoader:ImportModule("LBL_ConfigGroups")

LBL_Settings.loot_tab = { ... }

local optionsDefaults = LBL_SettingsDefaults:Load()
local currentCharacters = {}
local _LBL_Settings = {}

function LBL_Settings:Initialize()
  return {
    name = LogBookLoot:LBL_i18n("Loot"),
    order = 5,
    type = "group",
    args = {
      stats_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Stats"), 0, LogBookLoot:GetAddonColor()),
      stats = LB_CustomConfig:CreateStatsConfig("LogBookLoot", LBL_Database:GetNumEntries(), 0.1),
      loot_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Settings"), 1, LogBookLoot:GetAddonColor()),
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookLoot:LBL_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookLoot:LBL_i18n("Enable tracking"),
            desc = LogBookLoot:LBL_i18n("Toggle tracking loot."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookLoot.db.char.general.loot.trackingEnabled end,
            set = function(info, value)
              LogBookLoot.db.char.general.loot.trackingEnabled = value
            end,
          },
        },
      },
      tooltip_header = LBL_ConfigGroups:Get("tooltips", "header"),
      toltips = LBL_ConfigGroups:Get("tooltips", "config"),
      database_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Database"), 88, LogBookLoot:GetAddonColor()),
      database = {
        type = "group",
        order = 89,
        inline = true,
        name = "",
        args = {
          autoUpdateDb = {
            type = "toggle",
            order = 1,
            name = LogBookLoot:LBL_i18n("Auto update Database"),
            desc = LogBookLoot:LBL_i18n("Toggle update database automatically."),
            width = "full",
            disabled = false,
            get = function() return LogBookEnchanting.db.char.general.enchanting.autoUpdateDb end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.autoUpdateDb = value
              if value then
                C_Timer.After(0.1, function()
                  LBL_Database:StartAutoUpdateDatabase()
                end)
              else
                C_Timer.After(0.1, function()
                  LBL_Database:CancelAutoUpdateDatabase()
                end)
              end
            end,
          },
          updateDbTimeout = {
            type = "range",
            order = 2,
            name = LogBookLoot:LBL_i18n("Database update time"),
            desc = LogBookLoot:LBL_i18n("Sets how often the enchanting database is updated (in minutes)."),
            width = "full",
            min = 5,
            max = 60,
            step = 1,
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.autoUpdateDb); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.updateDbTimeout end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.updateDbTimeout = value
            end,
          },
          separator_1 = LB_CustomFrames:Spacer(2.5, false),
          executeUpdateDb = {
            type = "execute",
            order = 3,
            name = LogBookLoot:LBL_i18n("Manual database update"),
            desc = LogBookLoot:LBL_i18n("Update loot database manually."),
            width = "full",
            disabled = false,
            func = function() return LBL_Database:UpdateDatabase() end,
          },
        }
      },
      maintenance_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Maintenance"), 98, LogBookLoot:GetAddonColor()),
      maintenance = {
        type = "group",
        order = 99,
        inline = true,
        name = "",
        args = {
          deleteCharacterData = LB_CustomConfig:CreateDeleteChararterConfig(_LBL_Settings.CreateCharactersDropdown(), _LBL_Settings.DeleteCharacterEntry, currentCharacters, 1)
        },
      },
    },
  }
end

function _LBL_Settings.CreateCharactersDropdown()
  local characters = LogBookLoot.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBL_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookLoot.db.global.characters[character] = {}
  LogBookLoot.db.global.data.characters[character] = false
  ReloadUI()
end
