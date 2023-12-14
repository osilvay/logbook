---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings");

---@type LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:ImportModule("LB_SettingsDefaults");

LB_Settings.tabs.general = { ... }
local optionsDefaults = LB_SettingsDefaults:Load()

function LB_Settings.tabs.general:Initialize()
    return {
        name = LogBook:i18n("General"),
        order = 1,
        type = "group",
        args = {
            bitacora_header = {
                type = "header",
                order = 1,
                name = LogBook:i18n("General settings"),
            },
            --[[tracking = {
                type = "group",
                order = 2,
                inline = true,
                name = LogBook:i18n("Tracking"),
                args = {
                    trackCritics = {
                        type = "toggle",
                        order = 3.1,
                        name = LogBook:i18n("Track critics"),
                        desc = "Toggles the tracking of critical hits and eals. By default = " ..
                            tostring(optionsDefaults.char.general.trackCritics),
                        width = 1.5,
                        disabled = false,
                        get = function() return LogBook.db.char.general.trackCritics end,
                        set = function(info, value)
                            LogBook.db.char.general.trackCritics = value
                        end,
                    },
                },
            },]]
        },
    }
end
