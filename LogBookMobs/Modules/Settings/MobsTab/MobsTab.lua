---@class LBM_Settings
local LBM_Settings = LB_ModuleLoader:CreateModule("LBM_Settings");

---@type LBM_SettingsDefaults
local LBM_SettingsDefaults = LB_ModuleLoader:ImportModule("LBM_SettingsDefaults");

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

---@type LBM_Database
local LBM_Database = LB_ModuleLoader:ImportModule("LBM_Database")

LBM_Settings.mobs_tab = { ... }
local optionsDefaults = LBM_SettingsDefaults:Load()
local currentCharacters = {}
local _LBM_Settings = {}

function LBM_Settings:Initialize()
  return {
    name = LogBookMobs:LBM_i18n("Mobs"),
    order = 6,
    type = "group",
    args = {
      stats_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Stats"), 0, LogBookMobs:GetAddonColor()),
      stats = LB_CustomConfig:CreateStatsConfig("LogBookMobs", LBM_Database:GetNumEntries(), 0.1),
      mobs_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Settings"), 1, LogBookMobs:GetAddonColor()),
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookMobs:LBM_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookMobs:LBM_i18n("Enable tracking"),
            desc = LogBookMobs:LBM_i18n("Toggle tracking mobs."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookMobs.db.char.general.mobs.trackingEnabled end,
            set = function(info, value)
              LogBookMobs.db.char.general.mobs.trackingEnabled = value
            end,
          },
        },
      },
      tooltip_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Tooltips"), 3, LogBookMobs:GetAddonColor()),
      toltips = {
        type = "group",
        order = 4,
        inline = true,
        name = " ",
        args = {
          tooltipsEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookMobs:LBM_i18n("Enable tooltips"),
            desc = LogBookMobs:LBM_i18n("Toggle showing mobs tooltips."),
            width = "full",
            disabled = false,
            get = function() return LogBookMobs.db.char.general.mobs.tooltipsEnabled end,
            set = function(info, value)
              LogBookMobs.db.char.general.mobs.tooltipsEnabled = value
            end,
          },
          showTitle = {
            type = "toggle",
            order = 2,
            name = LogBookMobs:LBM_i18n("Show title"),
            desc = LogBookMobs:LBM_i18n("Toggle showing title."),
            width = "full",
            disabled = function() return (not LogBookMobs.db.char.general.mobs.tooltipsEnabled); end,
            get = function() return LogBookMobs.db.char.general.mobs.showTitle end,
            set = function(info, value)
              LogBookMobs.db.char.general.mobs.showTitle = value
            end,
          },
          showItemID = {
            type = "toggle",
            order = 3,
            name = LogBookMobs:LBM_i18n("Show ItemID"),
            desc = LogBookMobs:LBM_i18n("Toggle showing item ids."),
            width = "full",
            disabled = function() return (not LogBookMobs.db.char.general.mobs.tooltipsEnabled); end,
            get = function() return LogBookMobs.db.char.general.mobs.showItemID end,
            set = function(info, value)
              LogBookMobs.db.char.general.mobs.showItemID = value
            end,
          },
          pressKeyDownGroup = _LBM_Settings:CreateKeyDownDropdownConfig(5)
        },
      },
      maintenance_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Maintenance"), 98, LogBookMobs:GetAddonColor()),
      maintenance = {
        type = "group",
        order = 99,
        inline = true,
        name = "",
        args = {
          deleteCharacterData = LB_CustomConfig:CreateDeleteChararterConfig(_LBM_Settings.CreateCharactersDropdown(), _LBM_Settings.DeleteCharacterEntry, currentCharacters, 1)
        },
      },
    },
  }
end

function _LBM_Settings.CreateCharactersDropdown()
  local characters = LogBookMobs.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBM_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookMobs.db.global.characters[character] = {}
  LogBookMobs.db.global.data.characters[character] = false
  ReloadUI()
end

function _LBM_Settings:CreateKeyDownDropdownConfig(order)
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
        get = function() return LogBookMobs.db.char.general.mobs.pressKeyDown end,
        set = function(info, value)
          LogBookMobs.db.char.general.mobs.pressKeyDown = value
        end,
      }
    }
  }
end
