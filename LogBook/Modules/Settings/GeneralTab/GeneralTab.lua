---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings");

---@type LB_SettingsDefaults
local LB_SettingsDefaults = LB_ModuleLoader:ImportModule("LB_SettingsDefaults");

---@type LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:ImportModule("LB_SlashCommands")

LB_Settings.tabs.general = { ... }
local optionsDefaults = LB_SettingsDefaults:Load()

function LB_Settings.tabs.general:Initialize()
    return {
        name = LogBook:i18n("General"),
        order = 1,
        type = "group",
        args = {
            header = {
                type = "header",
                order = 1,
                name = "|cffc1c1f1" .. LogBook:i18n("General settings") .. "|r",
            },
        },
    }
end
