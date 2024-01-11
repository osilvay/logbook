---@class LBZ_Settings
local LBZ_Settings = LB_ModuleLoader:CreateModule("LBZ_Settings");
local _LBZ_Settings = {}

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

LBZ_Settings.zones_tab = { ... }
local optionsDefaults = LBZ_SettingsDefaults:Load()

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

function LBZ_Settings:Initialize()
  return {
    name = LogBookZones:i18n("Zones"),
    order = 2,
    type = "group",
    args = {
      zones_header = {
        type = "header",
        order = 0,
        name = "|cffc1c1f1" .. LogBookZones:i18n("Zones settings") .. "|r",
      },
      tracking = {
        type = "group",
        order = 1,
        inline = true,
        name = LogBookZones:i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookZones:i18n("Enable tracking"),
            desc = LogBookZones:i18n("Toggle tracking zones."),
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
            name = LogBookZones:i18n("Zone tracking during flight"),
            desc = LogBookZones:i18n("Toggle zone tracking during flights."),
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
            name = LogBookZones:i18n("Zone messages in chat box"),
            desc = LogBookZones:i18n("Show zone change messages in chat box."),
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
            name = LogBookZones:i18n("Zone changes on screen"),
            desc = LogBookZones:i18n("Show zone change messages on screen."),
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
            name = LogBookZones:i18n("Auto tracking"),
            args = {
              autoTrackingEnabled = {
                type = "toggle",
                order = 1,
                name = LogBookZones:i18n("Enable auto tracking"),
                desc = LogBookZones:i18n("Toggle automatic tracking zones."),
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
                name = LogBookZones:i18n("Time (in minutes)"),
                desc = LogBookZones:i18n("Time in minutes to check automatic zone changes."),
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
      maintenance_header = {
        type = "header",
        order = 2,
        name = "|cffc1c1f1" .. LogBookZones:i18n("Maintenance") .. "|r",
      },
      maintenance = {
        type = "group",
        order = 3,
        inline = true,
        name = LogBookZones:i18n("Delete character data"),
        args = {
          deleteCharacterData = {
            type = "select",
            order = 2,
            width = "full",
            name = LogBookZones:i18n("Character"),
            desc = LogBookZones:i18n("Character name."),
            values = _LBZ_Settings.CreateCharactersDropdown(),
            disabled = false,
            get = function(info)
              return LogBookZones.db.char.general.zones.deleteCharacterData
            end,
            set = function(info, value)
              LogBookZones.db.char.general.zones.deleteCharacterData = value
              LB_CustomPopup:CreatePopup(LogBookZones:i18n("Delete entry"), LogBookZones:i18n("Are you sure you want to delete this entry?"), function()
                _LBZ_Settings.DeleteCharacterEntry(value)
              end)
            end,
          }
        },
      },
    },
  }
end

function _LBZ_Settings.CreateCharactersDropdown()
  local characters = LogBookZones.db.global.data.characters
  return LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
end

function _LBZ_Settings.DeleteCharacterEntry(character)
  LogBook:Debug(string.format("Delete %s", character))
end
