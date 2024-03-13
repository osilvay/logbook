---@class LBE_Settings
local LBE_Settings = LB_ModuleLoader:CreateModule("LBE_Settings");

---@type LBE_SettingsDefaults
local LBE_SettingsDefaults = LB_ModuleLoader:ImportModule("LBE_SettingsDefaults");

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

---@type LBE_Database
local LBE_Database = LB_ModuleLoader:ImportModule("LBE_Database")

LBE_Settings.enchanting_tab = { ... }
local optionsDefaults = LBE_SettingsDefaults:Load()
local currentCharacters = {}
local _LBE_Settings = {}
local addonStats = {}

function LBE_Settings:Initialize()
  return {
    name = LogBookEnchanting:LBE_i18n("Enchanting"),
    order = 3,
    type = "group",
    args = {
      stats_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Stats"), 0, LogBookEnchanting:GetAddonColor()),
      stats = LB_CustomConfig:CreateStatsConfig("LogBookEnchanting", LBE_Database:GetNumEntries(), 0.1),
      enchanting_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Settings"), 1, LogBookEnchanting:GetAddonColor()),
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookEnchanting:LBE_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookEnchanting:LBE_i18n("Enable tracking"),
            desc = LogBookEnchanting:LBE_i18n("Toggle tracking enchanting."),
            width = "full",
            disabled = false,
            get = function()
              return LogBookEnchanting.db.char.general.enchanting.trackingEnabled
            end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.trackingEnabled = value
            end,
          },
        },
      },
      tooltip_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Tooltips"), 3, LogBookEnchanting:GetAddonColor()),
      toltips = {
        type = "group",
        order = 4,
        inline = true,
        name = " ",
        args = {
          tooltipsEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookEnchanting:LBE_i18n("Enable tooltips"),
            desc = LogBookEnchanting:LBE_i18n("Toggle showing enchanting tooltips."),
            width = "full",
            disabled = false,
            get = function() return LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled = value
            end,
          },
          showTitle = {
            type = "toggle",
            order = 2,
            name = LogBookEnchanting:LBE_i18n("Show title"),
            desc = LogBookEnchanting:LBE_i18n("Toggle showing title."),
            width = "full",
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.showTitle end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.showTitle = value
            end,
          },
          showItemID = {
            type = "toggle",
            order = 3,
            name = LogBookEnchanting:LBE_i18n("Show ItemID"),
            desc = LogBookEnchanting:LBE_i18n("Toggle showing item ids."),
            width = "full",
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.showItemID end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.showItemID = value
            end,
          },
          zeroValues = {
            type = "toggle",
            order = 3.1,
            name = LogBookLoot:LBL_i18n("Show zero values"),
            desc = LogBookLoot:LBL_i18n("Toggle showing zero values."),
            width = "full",
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.zeroValues end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.zeroValues = value
            end,
          },
          itemsToShow = {
            type = "range",
            order = 4,
            name = LogBookEnchanting:LBE_i18n("Items to show"),
            desc = LogBookEnchanting:LBE_i18n("Items to show in tooltip."),
            width = "full",
            min = 1,
            max = 20,
            step = 1,
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.itemsToShow end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.itemsToShow = value
            end,
          },
          showExpectedEssences = {
            type = "toggle",
            order = 5,
            name = LogBookEnchanting:LBE_i18n("Show expected essences"),
            desc = LogBookEnchanting:LBE_i18n("Toggle showing of expected essences on items."),
            width = "full",
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.showExpectedEssences end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.showExpectedEssences = value
            end,
          },
          showRealEssences = {
            type = "toggle",
            order = 6,
            name = LogBookEnchanting:LBE_i18n("Show real essences"),
            desc = LogBookEnchanting:LBE_i18n("Toggle showing of real essences on items."),
            width = "full",
            disabled = function() return (not LogBookEnchanting.db.char.general.enchanting.tooltipsEnabled); end,
            get = function() return LogBookEnchanting.db.char.general.enchanting.showRealEssences end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.showRealEssences = value
            end,
          },
          pressKeyDownGroup = _LBE_Settings:CreateKeyDownDropdownConfig(7)
        },
      },
      database_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Database"), 88, LogBookEnchanting:GetAddonColor()),
      database = {
        type = "group",
        order = 89,
        inline = true,
        name = "",
        args = {
          autoUpdateDb = {
            type = "toggle",
            order = 1,
            name = LogBook:LB_i18n("Auto update database"),
            desc = LogBook:LB_i18n("Toggle update database automatically."),
            width = "full",
            disabled = false,
            get = function() return LogBookEnchanting.db.char.general.enchanting.autoUpdateDb end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.autoUpdateDb = value
              if value then
                C_Timer.After(0.1, function()
                  LBE_Database:StartAutoUpdateDatabase()
                end)
              else
                C_Timer.After(0.1, function()
                  LBE_Database:CancelAutoUpdateDatabase()
                end)
              end
            end,
          },
          updateDbTimeout = {
            type = "range",
            order = 2,
            name = LogBook:LB_i18n("Database update time"),
            desc = LogBook:LB_i18n("Sets how often the database is updated (in minutes)."),
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
            name = LogBook:LB_i18n("Manual database update"),
            desc = LogBook:LB_i18n("Update database manually."),
            width = "full",
            disabled = false,
            func = function() return LBE_Database:UpdateDatabase() end,
          },
        }
      },
      maintenance_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Maintenance"), 98, LogBookEnchanting:GetAddonColor()),
      maintenance = {
        type = "group",
        order = 99,
        inline = true,
        name = "",
        args = {
          deleteCharacterData = LB_CustomConfig:CreateDeleteChararterConfig(_LBE_Settings.CreateCharactersDropdown(), _LBE_Settings.DeleteCharacterEntry, currentCharacters, 1)
        },
      },
    },
  }
end

function _LBE_Settings.CreateCharactersDropdown()
  local characters = LogBookEnchanting.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBE_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookEnchanting.db.global.characters[character] = {}
  LogBookEnchanting.db.global.data.characters[character] = false
  ReloadUI()
end

function _LBE_Settings:CreateKeyDownDropdownConfig(order)
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
        get = function() return LogBookEnchanting.db.char.general.enchanting.pressKeyDown end,
        set = function(info, value)
          LogBookEnchanting.db.char.general.enchanting.pressKeyDown = value
        end,
      }
    }
  }
end
