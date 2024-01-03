---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings");

---@type LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:ImportModule("LB_SettingsDefaults");

LB_Settings.tabs.advanced = { ... }
local optionsDefaults = LB_SettingsDefaults:Load()

function LB_Settings.tabs.advanced:Initialize()
    return {
        name = LogBook:i18n("Advanced"),
        order = 9,
        type = "group",
        args = {
            advanced_header = {
                type = "header",
                order = 1,
                name = "|cffc1c1f1" .. LogBook:i18n("Advanced settings") .. "|r",
            },
            debug = {
                type = "group",
                order = 2,
                inline = true,
                name = LogBook:i18n("Debug"),
                args = {
                    debug = {
                        type = "toggle",
                        order = 2,
                        name = LogBook:i18n("Enable debug"),
                        desc = "Toggle the debug mode",
                        width = 1.5,
                        get = function() return LogBook.db.global.debug; end,
                        set = function(info, value)
                            LogBook.db.global.debug = value
                        end,
                    },
                },
            },
        },
    }
end
