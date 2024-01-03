---@class LBF_Settings
local LBF_Settings = LB_ModuleLoader:CreateModule("LBF_Settings");

---@type LBF_SettingsDefaults
local LBF_SettingsDefaults = LB_ModuleLoader:ImportModule("LBF_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

LBF_Settings.fishing_tab = { ... }
local optionsDefaults = LBF_SettingsDefaults:Load()

function LBF_Settings:Initialize()
    return {
        name = LogBookFishing:i18n("Fishing"),
        order = 2,
        type = "group",
        args = {
            fishing_header = {
                type = "header",
                order = 1,
                name = LogBookFishing:i18n("Fishing settings"),
            },
            tracking = {
                type = "group",
                order = 2,
                inline = true,
                name = LogBookFishing:i18n("Tracking"),
                args = {
                    trackingEnabled = {
                        type = "toggle",
                        order = 1,
                        name = LogBookFishing:i18n("Enable tracking"),
                        desc = LogBookFishing:i18n("Toggle tracking fishing."),
                        width = 1.2,
                        disabled = false,
                        get = function() return LogBookFishing.db.char.general.fishing.trackingEnabled end,
                        set = function(info, value)
                            LogBookFishing.db.char.general.fishing.trackingEnabled = value
                        end,
                    },
                },
            },
        },
    }
end
