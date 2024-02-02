---@class LBZ_Settings
local LBZ_Settings = LB_ModuleLoader:CreateModule("LBZ_Settings");

---@type LBZ_SettingsDefaults
local LBZ_SettingsDefaults = LB_ModuleLoader:ImportModule("LBZ_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

---@type LBZ_Track
local LBZ_Track = LB_ModuleLoader:ImportModule("LBZ_Track");

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings");

---@type LB_CustomConfig
local LB_CustomConfig = LB_ModuleLoader:ImportModule("LB_CustomConfig")

---@type LBZ_Database
local LBZ_Database = LB_ModuleLoader:ImportModule("LBZ_Database")

LBZ_Settings.zones_tab = { ... }
local optionsDefaults = LBZ_SettingsDefaults:Load()
local currentCharacters = {}
local _LBZ_Settings = {}

function LBZ_Settings:Initialize()
  return {
    name = LogBookZones:LBZ_i18n("Zones"),
    order = 7,
    type = "group",
    args = {
      stats_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Stats"), 0, LogBookZones:GetAddonColor()),
      stats = LB_CustomConfig:CreateStatsConfig("LogBookZones", LBZ_Database:GetNumEntries(), 0.1),
      zones_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Settings"), 1, LogBookZones:GetAddonColor()),
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookZones:LBZ_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookZones:LBZ_i18n("Enable tracking"),
            desc = LogBookZones:LBZ_i18n("Toggle tracking zones."),
            width = 2,
            disabled = false,
            get = function() return LogBookZones.db.char.general.zones.trackingEnabled end,
            set = function(info, value)
              LogBookZones.db.char.general.zones.trackingEnabled = value
            end,
          },
          trackInFlight = {
            type = "toggle",
            order = 2,
            name = LogBookZones:LBZ_i18n("Zone tracking during flight"),
            desc = LogBookZones:LBZ_i18n("Toggle zone tracking during flights."),
            width = 2,
            disabled = function() return (not LogBookZones.db.char.general.zones.trackingEnabled); end,
            get = function() return LogBookZones.db.char.general.zones.trackInFlight end,
            set = function(info, value)
              LogBookZones.db.char.general.zones.trackInFlight = value
            end,
          },
          showZoneMessagesInChat = {
            type = "toggle",
            order = 3,
            name = LogBookZones:LBZ_i18n("Zone changes in chat box"),
            desc = LogBookZones:LBZ_i18n("Show zone change messages in chat box."),
            width = 2,
            disabled = function() return (not LogBookZones.db.char.general.zones.trackingEnabled); end,
            get = function() return LogBookZones.db.char.general.zones.showZoneMessagesInChat end,
            set = function(info, value)
              LogBookZones.db.char.general.zones.showZoneMessagesInChat = value
            end,
          },
          showZoneMessagesOnScreen = {
            type = "toggle",
            order = 4,
            name = LogBookZones:LBZ_i18n("Zone changes on screen"),
            desc = LogBookZones:LBZ_i18n("Show zone change messages on screen."),
            width = 2,
            disabled = function() return (not LogBookZones.db.char.general.zones.trackingEnabled); end,
            get = function() return LogBookZones.db.char.general.zones.showZoneMessagesOnScreen end,
            set = function(info, value)
              LogBookZones.db.char.general.zones.showZoneMessagesOnScreen = value
            end,
          },
          autoTracking = {
            type = "group",
            order = 5,
            inline = true,
            name = LogBookZones:LBZ_i18n("Auto tracking"),
            args = {
              autoTrackingEnabled = {
                type = "toggle",
                order = 1,
                name = LogBookZones:LBZ_i18n("Enable auto tracking"),
                desc = LogBookZones:LBZ_i18n("Toggle automatic tracking zones."),
                width = 2,
                disabled = function() return (not LogBookZones.db.char.general.zones.trackingEnabled); end,
                get = function() return LogBookZones.db.char.general.zones.autoTrackingEnabled end,
                set = function(info, value)
                  LogBookZones.db.char.general.zones.autoTrackingEnabled = value
                  if value then
                    C_Timer.After(0.5, function()
                      LBZ_Track:StartAutomaticTracking()
                    end)
                  else
                    C_Timer.After(0.5, function()
                      LBZ_Track:StopAutomaticTracking()
                    end)
                  end
                end,
              },
              timeAutoTracking = {
                type = "range",
                order = 2,
                name = LogBookZones:LBZ_i18n("Time (in minutes)"),
                desc = LogBookZones:LBZ_i18n("Time in minutes to check automatic zone changes."),
                width = "full",
                min = 5,
                max = 60,
                step = 5,
                disabled = function() return (not LogBookZones.db.char.general.zones.autoTrackingEnabled); end,
                get = function() return LogBookZones.db.char.general.zones.timeAutoTracking end,
                set = function(info, value)
                  LogBookZones.db.char.general.zones.timeAutoTracking = value
                end,
              },
            },
          },
        },
      },
      overlay_header = LB_CustomConfig:CreateHeaderConfig(LogBookZones:LBZ_i18n("Path overlay"), 3, LogBookZones:GetAddonColor()),
      overlay = {
        type = "group",
        order = 4,
        inline = true,
        name = "",
        args = {
          enablePathOverlay = {
            type = "toggle",
            order = 2,
            name = LogBookZones:LBZ_i18n("Enable path overlay"),
            desc = LogBookZones:LBZ_i18n("Enable path overlay in world map."),
            width = 2,
            disabled = false,
            get = function() return LogBookZones.db.char.general.zones.enablePathOverlay end,
            set = function(info, value)
              LogBookZones.db.char.general.zones.enablePathOverlay = value
            end,
          },
        },
      },
      maintenance_header = LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Maintenance"), 98, LogBookZones:GetAddonColor()),
      maintenance = {
        type = "group",
        order = 99,
        inline = true,
        name = "",
        args = {
          deleteCharacterData = LB_CustomConfig:CreateDeleteChararterConfig(_LBZ_Settings.CreateCharactersDropdown(), _LBZ_Settings.DeleteCharacterEntry, currentCharacters, 1)
        },
      },
    },
  }
end

function _LBZ_Settings.CreateCharactersDropdown()
  local characters = LogBookZones.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBZ_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookZones.db.global.characters[character] = {}
  LogBookZones.db.global.data.characters[character] = false
  ReloadUI()
end
