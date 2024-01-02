---@class LBL_Settings
local LBL_Settings = LB_ModuleLoader:CreateModule("LBL_Settings");

---@type LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:ImportModule("LBL_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

LBL_Settings.loot_tab = { ... }
local optionsDefaults = LBL_SettingsDefaults:Load()

function LBL_Settings:Initialize()
    return {
        name = LogBookLoot:i18n("Loot"),
        order = 2,
        type = "group",
        args = {
            loot_header = {
                type = "header",
                order = 1,
                name = LogBookLoot:i18n("Loot settings"),
            },
            tracking = {
                type = "group",
                order = 2,
                inline = true,
                name = LogBookLoot:i18n("Tracking"),
                args = {
                    trackingEnabled = {
                        type = "toggle",
                        order = 1,
                        name = LogBookLoot:i18n("Enable tracking"),
                        desc = LogBookLoot:i18n("Toggle tracking loot."),
                        width = 1.2,
                        disabled = false,
                        get = function() return LogBookLoot.db.char.general.loot.trackingEnabled end,
                        set = function(info, value)
                            LogBookLoot.db.char.general.loot.trackingEnabled = value
                            if not value then
                                LogBookLoot.db.char.general.loot.trackHeals = false
                                LogBookLoot.db.char.general.loot.trackHits = false
                                LogBookLoot.db.char.general.loot.trackAttacks = false
                            else
                                LogBookLoot.db.char.general.loot.trackHeals = true
                                LogBookLoot.db.char.general.loot.trackHits = true
                                LogBookLoot.db.char.general.loot.trackAttacks = true
                            end
                        end,
                    },
                },
            },
        },
    }
end
