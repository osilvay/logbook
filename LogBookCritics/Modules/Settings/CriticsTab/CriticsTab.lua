---@class LBC_Settings
local LBC_Settings = LB_ModuleLoader:CreateModule("LBC_Settings");

---@type LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:ImportModule("LBC_SettingsDefaults");

LBC_Settings.critics_tab = { ... }
local optionsDefaults = LBC_SettingsDefaults:Load()

function LBC_Settings:Initialize()
    return {
        name = LogBookCritics:i18n("Critics"),
        order = 2,
        type = "group",
        args = {
            critics_header = {
                type = "header",
                order = 1,
                name = LogBookCritics:i18n("Critics settings"),
            },
            tracking = {
                type = "group",
                order = 2,
                inline = true,
                name = LogBookCritics:i18n("Tracking"),
                args = {
                    trackCritics = {
                        type = "toggle",
                        order = 3.1,
                        name = LogBookCritics:i18n("Track critics"),
                        desc = "Toggles the tracking of critical hits and eals. By default = " .. tostring(optionsDefaults.char.general.trackCritics),
                        width = 1.5,
                        disabled = false,
                        get = function() return LogBookCritics.db.char.general.trackCritics end,
                        set = function(info, value)
                            LogBookCritics.db.char.general.trackCritics = value
                        end,
                    },
                },
            },
        },
    }
end
