---@class LBZ_Settings
local LBZ_Settings = LB_ModuleLoader:CreateModule("LBZ_Settings");

---@type LBZ_SettingsDefaults
local LBZ_SettingsDefaults = LB_ModuleLoader:ImportModule("LBZ_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

LBZ_Settings.zones_tab = { ... }
local optionsDefaults = LBZ_SettingsDefaults:Load()

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
                order = 2,
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
                            if not value then
                                LogBookZones.db.char.general.zones.trackInFlight = false
                            else
                                LogBookZones.db.char.general.zones.trackInFlight = true
                            end
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
                    showZoneMessages = {
                        type = "toggle",
                        order = 2,
                        name = LogBookZones:i18n("Zone messages in chat box"),
                        desc = LogBookZones:i18n("Show zone change messages in chat box."),
                        width = 2,
                        disabled = function() return (not LogBookZones.db.char.general.zones.showZoneMessages); end,
                        get = function() return LogBookZones.db.char.general.zones.showZoneMessages end,
                        set = function(info, value)
                            LogBookZones.db.char.general.zones.showZoneMessages = value
                        end,
                    },
                    showZoneChanges = {
                        type = "toggle",
                        order = 2,
                        name = LogBookZones:i18n("Zone changes on screen"),
                        desc = LogBookZones:i18n("Show zone change messages on screen."),
                        width = 2,
                        disabled = function() return (not LogBookZones.db.char.general.zones.showZoneChanges); end,
                        get = function() return LogBookZones.db.char.general.zones.trackIshowZoneChangesnFlight end,
                        set = function(info, value)
                            LogBookZones.db.char.general.zones.showZoneChanges = value
                        end,
                    },
                },
            },
        },
    }
end
