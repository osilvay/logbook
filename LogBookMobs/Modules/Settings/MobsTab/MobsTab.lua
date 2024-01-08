---@class LBM_Settings
local LBM_Settings = LB_ModuleLoader:CreateModule("LBM_Settings");

---@type LBM_SettingsDefaults
local LBM_SettingsDefaults = LB_ModuleLoader:ImportModule("LBM_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

LBM_Settings.mobs_tab = { ... }
local optionsDefaults = LBM_SettingsDefaults:Load()

function LBM_Settings:Initialize()
    return {
        name = LogBookMobs:i18n("Mobs"),
        order = 2,
        type = "group",
        args = {
            mobs_header = {
                type = "header",
                order = 1,
                name = "|cffc1c1f1" .. LogBookMobs:i18n("Mobs settings") .. "|r",
            },
            tracking = {
                type = "group",
                order = 2,
                inline = true,
                name = LogBookMobs:i18n("Tracking"),
                args = {
                    trackingEnabled = {
                        type = "toggle",
                        order = 1,
                        name = LogBookMobs:i18n("Enable tracking"),
                        desc = LogBookMobs:i18n("Toggle tracking mobs."),
                        width = 1.2,
                        disabled = false,
                        get = function() return LogBookMobs.db.char.general.mobs.trackingEnabled end,
                        set = function(info, value)
                            LogBookMobs.db.char.general.mobs.trackingEnabled = value
                        end,
                    },
                },
            },
        },
    }
end
