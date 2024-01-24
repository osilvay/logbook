---@class LBF_Settings
local LBF_Settings = LB_ModuleLoader:CreateModule("LBF_Settings");

---@type LBF_SettingsDefaults
local LBF_SettingsDefaults = LB_ModuleLoader:ImportModule("LBF_SettingsDefaults");

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

---@type LBF_Database
local LBF_Database = LB_ModuleLoader:ImportModule("LBF_Database")

LBF_Settings.fishing_tab = { ... }
local optionsDefaults = LBF_SettingsDefaults:Load()
local currentCharacters = {}
local _LBF_Settings = {}

function LBF_Settings:Initialize()
  return {
    name = LogBookFishing:LBF_i18n("Fishing"),
    order = 4,
    type = "group",
    args = {
      stats_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Stats"), 0, LogBookFishing:GetAddonColor()),
      stats = LB_CustomConfig:CreateStatsConfig("LogBookFishing", LBF_Database:GetNumEntries(), 0.1),
      fishing_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Settings"), 1, LogBookFishing:GetAddonColor()),
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookFishing:LBF_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookFishing:LBF_i18n("Enable tracking"),
            desc = LogBookFishing:LBF_i18n("Toggle tracking fishing."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookFishing.db.char.general.fishing.trackingEnabled end,
            set = function(info, value)
              LogBookFishing.db.char.general.fishing.trackingEnabled = value
            end,
          },
        },
      },
      tooltip_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Tooltips"), 3, LogBookFishing:GetAddonColor()),
      toltips = {
        type = "group",
        order = 4,
        inline = true,
        name = " ",
        args = {
          tooltipsEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookFishing:LBF_i18n("Enable tooltips"),
            desc = LogBookFishing:LBF_i18n("Toggle showing fishing tooltips."),
            width = "full",
            disabled = false,
            get = function() return LogBookFishing.db.char.general.fishing.tooltipsEnabled end,
            set = function(info, value)
              LogBookFishing.db.char.general.fishing.tooltipsEnabled = value
            end,
          },
          showTitle = {
            type = "toggle",
            order = 2,
            name = LogBookFishing:LBF_i18n("Show title"),
            desc = LogBookFishing:LBF_i18n("Toggle showing title."),
            width = "full",
            disabled = function() return (not LogBookFishing.db.char.general.fishing.tooltipsEnabled); end,
            get = function() return LogBookFishing.db.char.general.fishing.showTitle end,
            set = function(info, value)
              LogBookFishing.db.char.general.fishing.showTitle = value
            end,
          },
          showItemID = {
            type = "toggle",
            order = 3,
            name = LogBookFishing:LBF_i18n("Show ItemID"),
            desc = LogBookFishing:LBF_i18n("Toggle showing item ids."),
            width = "full",
            disabled = function() return (not LogBookFishing.db.char.general.fishing.tooltipsEnabled); end,
            get = function() return LogBookFishing.db.char.general.fishing.showItemID end,
            set = function(info, value)
              LogBookFishing.db.char.general.fishing.showItemID = value
            end,
          },
          pressKeyDownGroup = _LBF_Settings:CreateKeyDownDropdownConfig(5)
        },
      },
      maintenance_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Maintenance"), 98, LogBookFishing:GetAddonColor()),
      maintenance = {
        type = "group",
        order = 99,
        inline = true,
        name = "",
        args = {
          deleteCharacterData = LB_CustomConfig:CreateDeleteChararterConfig(_LBF_Settings.CreateCharactersDropdown(), _LBF_Settings.DeleteCharacterEntry, currentCharacters, 1)
        },
      },
    },
  }
end

function _LBF_Settings.CreateCharactersDropdown()
  local characters = LogBookFishing.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBF_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookFishing.db.global.characters[character] = {}
  LogBookFishing.db.global.data.characters[character] = false
  ReloadUI()
end

function _LBF_Settings:CreateKeyDownDropdownConfig(order)
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
        get = function() return LogBookFishing.db.char.general.fishing.pressKeyDown end,
        set = function(info, value)
          LogBookFishing.db.char.general.fishing.pressKeyDown = value
        end,
      }
    }
  }
end
