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
      tooltip_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Tooltips"), 3, LogBookLoot:GetAddonColor()),
      toltips = {
        type = "group",
        order = 4,
        inline = true,
        name = " ",
        args = {
          tooltipsEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookLoot:LBL_i18n("Enable tooltips"),
            desc = LogBookLoot:LBL_i18n("Toggle showing loot tooltips."),
            width = "full",
            disabled = false,
            get = function() return LogBookLoot.db.char.general.loot.tooltipsEnabled end,
            set = function(info, value)
              LogBookLoot.db.char.general.loot.tooltipsEnabled = value
            end,
          },
          showTitle = {
            type = "toggle",
            order = 2,
            name = LogBookLoot:LBL_i18n("Show title"),
            desc = LogBookLoot:LBL_i18n("Toggle showing title."),
            width = "full",
            disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
            get = function() return LogBookLoot.db.char.general.loot.showTitle end,
            set = function(info, value)
              LogBookLoot.db.char.general.loot.showTitle = value
            end,
          },
          showItemID = {
            type = "toggle",
            order = 3,
            name = LogBookLoot:LBL_i18n("Show ItemID"),
            desc = LogBookLoot:LBL_i18n("Toggle showing item ids."),
            width = "full",
            disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
            get = function() return LogBookLoot.db.char.general.loot.showItemID end,
            set = function(info, value)
              LogBookLoot.db.char.general.loot.showItemID = value
            end,
          },
          pressKeyDownGroup = _LBL_Settings:CreateKeyDownDropdownConfig(5)
        },
      },
      maintenance_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Maintenance"), 98, LogBookFishing:GetAddonColor()),
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

function _LBL_Settings:CreateKeyDownDropdownConfig(order)
  return {
    type = "group",
    order = order,
    inline = true,
    name = "",
    args = {
      pressKeyDown = {
        type = "select",
        order = 1,
        width = 1.2,
        name = LogBook:LB_i18n("Press key to show"),
        values = LB_CustomConfig:KeyDownDropdownConfig(),
        disabled = false,
        get = function() return LogBookLoot.db.char.general.loot.pressKeyDown end,
        set = function(info, value)
          LogBookLoot.db.char.general.loot.pressKeyDown = value
        end,
      }
    }
  }
end
