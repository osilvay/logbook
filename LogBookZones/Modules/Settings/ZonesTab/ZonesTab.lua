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
                order = 1,
                name = LogBookZones:i18n("Zones settings"),
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
                        width = 1.2,
                        disabled = false,
                        get = function() return LogBookZones.db.char.general.zones.trackingEnabled end,
                        set = function(info, value)
                            LogBookZones.db.char.general.zones.trackingEnabled = value
                        end,
                    },
                },
            },
        },
    }
end
