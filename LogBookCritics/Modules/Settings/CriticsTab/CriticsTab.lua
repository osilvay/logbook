---@class LBC_Settings
local LBC_Settings = LB_ModuleLoader:CreateModule("LBC_Settings");

---@type LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:ImportModule("LBC_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LBC_SplashCriticsWindow
local LBC_SplashCriticsWindow = LB_ModuleLoader:ImportModule("LBC_SplashCriticsWindow");

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
                    trackingEnabled = {
                        type = "toggle",
                        order = 1,
                        name = LogBookCritics:i18n("Enable tracking"),
                        desc = LogBookCritics:i18n("Toggles tracking hits and heals."),
                        width = 1.5,
                        disabled = false,
                        get = function() return LogBookCritics.db.char.general.critics.trackingEnabled end,
                        set = function(info, value)
                            LogBookCritics.db.char.general.critics.trackingEnabled = value
                            if not value then
                                LogBookCritics.db.char.general.critics.trackHeals = false
                                LogBookCritics.db.char.general.critics.trackHits = false
                            else
                                LogBookCritics.db.char.general.critics.trackHeals = true
                                LogBookCritics.db.char.general.critics.trackHits = true
                            end
                        end,
                    },
                    spacerH1 = LB_CustomFrames:HorizontalSpacer(1.5, 0.05),
                    unlockTextFrame = {
                        type = "toggle",
                        order = 2,
                        name = LogBookCritics:i18n("Unlock text frame"),
                        desc = LogBookCritics:i18n("Toggle text frame lock."),
                        width = 1.5,
                        get = function() return LogBookCritics.db.char.general.critics.unlockTextFrame end,
                        set = function(info, value)
                            LogBookCritics.db.char.general.critics.unlockTextFrame = value
                            if value then
                                LogBookCritics.db.char.general.critics.textFrameBgColorAlpha = 0.1
                                LBC_SplashCriticsWindow.UnlockTextMessage(LogBookCritics:i18n("Test message"))
                            else
                                LogBookCritics.db.char.general.critics.textFrameBgColorAlpha = 0.0
                                LBC_SplashCriticsWindow.LockTextMessage(LogBookCritics:i18n("Test message"))
                            end
                        end,
                    },
                    trackHeals = {
                        type = "toggle",
                        order = 3,
                        name = LogBookCritics:i18n("Tracking heals"),
                        desc = LogBookCritics:i18n("Toggle tracking heals."),
                        width = 1.5,
                        disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
                        get = function() return LogBookCritics.db.char.general.critics.trackHeals end,
                        set = function(info, value)
                            LogBookCritics.db.char.general.critics.trackHeals = value
                        end,
                    },
                    spacerH2 = LB_CustomFrames:HorizontalSpacer(3.5, 0.05),
                    trackHits = {
                        type = "toggle",
                        order = 4,
                        name = LogBookCritics:i18n("Tracking hits"),
                        desc = LogBookCritics:i18n("Toggle tracking hits."),
                        width = 1.5,
                        disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
                        get = function() return LogBookCritics.db.char.general.critics.trackHits end,
                        set = function(info, value)
                            LogBookCritics.db.char.general.critics.trackHits = value
                        end,
                    },
                    trackSwings = {
                        type = "toggle",
                        order = 4,
                        name = LogBookCritics:i18n("Tracking swings"),
                        desc = LogBookCritics:i18n("Toggle tracking swings."),
                        width = 1.5,
                        disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
                        get = function() return LogBookCritics.db.char.general.critics.trackSwings end,
                        set = function(info, value)
                            LogBookCritics.db.char.general.critics.trackSwings = value
                        end,
                    },

                },
            },
            critics_tabs = {
                name = LogBookCritics:i18n("Tracking groups"),
                order = 3,
                type = "group",
                args = {
                    hit_tab = LBC_Settings._HitTab(),
                    heal_tab = LBC_Settings._HealTab(),
                    swing_tab = LBC_Settings._SwingTab()
                }
            },
        },
    }
end

function LBC_Settings._HealTab()
    return {
        type = "group",
        order = 3,
        name = LogBookCritics:i18n("Healings"),
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        args = {
            --------------------------------------------------------------------------------------------------
            trackNormalHeals = {
                type = "toggle",
                order = 1,
                name = LogBookCritics:i18n("Track normal heals"),
                desc = LogBookCritics:i18n("Toggle tracking normal heals."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                get = function() return LogBookCritics.db.char.general.critics.trackNormalHeals end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackNormalHeals = value
                end,
            },
            trackCriticalHeals = {
                type = "toggle",
                order = 2,
                name = LogBookCritics:i18n("Track critical heals"),
                desc = LogBookCritics:i18n("Toggle tracking critical heals."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                get = function() return LogBookCritics.db.char.general.critics.trackCriticHeals end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackCriticHeals = value
                end,
            },
            --------------------------------------------------------------------------------------------------
            healNormalColor = {
                type = "color",
                order = 3,
                name = LogBookCritics:i18n("Normal heals text color"),
                desc = LogBookCritics:i18n("Change color of normal heals text."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.healNormalColor.red
                    local green = LogBookCritics.db.char.general.critics.healNormalColor.green
                    local blue = LogBookCritics.db.char.general.critics.healNormalColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.healNormalColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.healNormalColor.red = red
                    LogBookCritics.db.char.general.critics.healNormalColor.green = green
                    LogBookCritics.db.char.general.critics.healNormalColor.blue = blue
                    LogBookCritics.db.char.general.critics.healNormalColor.alpha = alpha
                end
            },
            healCriticalColor = {
                type = "color",
                order = 4,
                name = LogBookCritics:i18n("Critical heals text color"),
                desc = LogBookCritics:i18n("Change color of critical heals text."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.healCriticalColor.red
                    local green = LogBookCritics.db.char.general.critics.healCriticalColor.green
                    local blue = LogBookCritics.db.char.general.critics.healCriticalColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.healCriticalColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.healCriticalColor.red = red
                    LogBookCritics.db.char.general.critics.healCriticalColor.green = green
                    LogBookCritics.db.char.general.critics.healCriticalColor.blue = blue
                    LogBookCritics.db.char.general.critics.healCriticalColor.alpha = alpha
                end
            },
            --------------------------------------------------------------------------------------------------
            trackHighestHeals = {
                type = "toggle",
                order = 5,
                name = LogBookCritics:i18n("Track highest values"),
                desc = LogBookCritics:i18n("Toggles traking |cFF40E040highest|r healing values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                get = function() return LogBookCritics.db.char.general.critics.trackHighestHeals end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackHighestHeals = value
                end,
            },
            trackLowestHeals = {
                type = "toggle",
                order = 6,
                name = LogBookCritics:i18n("Track lowest values"),
                desc = LogBookCritics:i18n("Toggles traking |cFFE04040lowest|r healing values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                get = function() return LogBookCritics.db.char.general.critics.trackLowestHeals end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackLowestHeals = value
                end,
            },
            --------------------------------------------------------------------------------------------------
            highestHealColor = {
                type = "color",
                order = 7,
                name = LogBookCritics:i18n("Highest values color"),
                desc = LogBookCritics:i18n("Change color of |cFF40E040highest|r values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.highestHealColor.red
                    local green = LogBookCritics.db.char.general.critics.highestHealColor.green
                    local blue = LogBookCritics.db.char.general.critics.highestHealColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.highestHealColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.highestHealColor.red = red
                    LogBookCritics.db.char.general.critics.highestHealColor.green = green
                    LogBookCritics.db.char.general.critics.highestHealColor.blue = blue
                    LogBookCritics.db.char.general.critics.highestHealColor.alpha = alpha
                end
            },
            lowestHealColor = {
                type = "color",
                order = 8,
                name = LogBookCritics:i18n("Lowest values color"),
                desc = LogBookCritics:i18n("Change color of |cFFE04040lowest|r values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.lowestHealColor.red
                    local green = LogBookCritics.db.char.general.critics.lowestHealColor.green
                    local blue = LogBookCritics.db.char.general.critics.lowestHealColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.lowestHealColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.lowestHealColor.red = red
                    LogBookCritics.db.char.general.critics.lowestHealColor.green = green
                    LogBookCritics.db.char.general.critics.lowestHealColor.blue = blue
                    LogBookCritics.db.char.general.critics.lowestHealColor.alpha = alpha
                end
            },
        },
    }
end

function LBC_Settings._HitTab()
    return {
        type = "group",
        order = 4,
        name = LogBookCritics:i18n("Harmful"),
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        args = {
            trackNormalHits = {
                type = "toggle",
                order = 1,
                name = LogBookCritics:i18n("Track normal hits"),
                desc = LogBookCritics:i18n("Toggle tracking normal hits."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                get = function() return LogBookCritics.db.char.general.critics.trackNormalHits end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackNormalHits = value
                end,
            },
            trackCriticalHits = {
                type = "toggle",
                order = 2,
                name = LogBookCritics:i18n("Track critical hits"),
                desc = LogBookCritics:i18n("Toggle tracking critical hits."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                get = function() return LogBookCritics.db.char.general.critics.trackCriticalHits end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackCriticalHits = value
                end,
            },
            --------------------------------------------------------------------------------------------------
            hitNormalColor = {
                type = "color",
                order = 3,
                name = LogBookCritics:i18n("Normal hits text color"),
                desc = LogBookCritics:i18n("Change color of normal hits text."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.hitNormalColor.red
                    local green = LogBookCritics.db.char.general.critics.hitNormalColor.green
                    local blue = LogBookCritics.db.char.general.critics.hitNormalColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.hitNormalColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.hitNormalColor.red = red
                    LogBookCritics.db.char.general.critics.hitNormalColor.green = green
                    LogBookCritics.db.char.general.critics.hitNormalColor.blue = blue
                    LogBookCritics.db.char.general.critics.hitNormalColor.alpha = alpha
                end
            },
            hitCriticalColor = {
                type = "color",
                order = 4,
                name = LogBookCritics:i18n("Critical hits text color"),
                desc = LogBookCritics:i18n("Change color of critical hits text."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.hitCriticalColor.red
                    local green = LogBookCritics.db.char.general.critics.hitCriticalColor.green
                    local blue = LogBookCritics.db.char.general.critics.hitCriticalColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.hitCriticalColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.hitCriticalColor.red = red
                    LogBookCritics.db.char.general.critics.hitCriticalColor.green = green
                    LogBookCritics.db.char.general.critics.hitCriticalColor.blue = blue
                    LogBookCritics.db.char.general.critics.hitCriticalColor.alpha = alpha
                end
            },
            --------------------------------------------------------------------------------------------------
            trackHighestHits = {
                type = "toggle",
                order = 5,
                name = LogBookCritics:i18n("Track highest values"),
                desc = LogBookCritics:i18n("Toggles traking |cFF40E040highest|r hit values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                get = function() return LogBookCritics.db.char.general.critics.trackHighestHits end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackHighestHits = value
                end,
            },
            trackLowestHits = {
                type = "toggle",
                order = 6,
                name = LogBookCritics:i18n("Track lowest values"),
                desc = LogBookCritics:i18n("Toggles traking |cFFE04040lowest|r hit values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                get = function() return LogBookCritics.db.char.general.critics.trackLowestHits end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackLowestHits = value
                end,
            },
            --------------------------------------------------------------------------------------------------
            highestHitColor = {
                type = "color",
                order = 7,
                name = LogBookCritics:i18n("Highest values color"),
                desc = LogBookCritics:i18n("Change color of |cFF40E040highest|r values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.highestHitColor.red
                    local green = LogBookCritics.db.char.general.critics.highestHitColor.green
                    local blue = LogBookCritics.db.char.general.critics.highestHitColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.highestHitColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.highestHitColor.red = red
                    LogBookCritics.db.char.general.critics.highestHitColor.green = green
                    LogBookCritics.db.char.general.critics.highestHitColor.blue = blue
                    LogBookCritics.db.char.general.critics.highestHitColor.alpha = alpha
                end
            },
            lowestHitColor = {
                type = "color",
                order = 8,
                name = LogBookCritics:i18n("Lowest values color"),
                desc = LogBookCritics:i18n("Change color of |cFFE04040lowest|r values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.lowestHitColor.red
                    local green = LogBookCritics.db.char.general.critics.lowestHitColor.green
                    local blue = LogBookCritics.db.char.general.critics.lowestHitColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.lowestHitColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.lowestHitColor.red = red
                    LogBookCritics.db.char.general.critics.lowestHitColor.green = green
                    LogBookCritics.db.char.general.critics.lowestHitColor.blue = blue
                    LogBookCritics.db.char.general.critics.lowestHitColor.alpha = alpha
                end
            },
        },
    }
end

function LBC_Settings._SwingTab()
    return {
        type = "group",
        order = 4,
        name = LogBookCritics:i18n("Weapon swings"),
        disabled =  function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
        args = {
            trackNormalSwings = {
                type = "toggle",
                order = 1,
                name = LogBookCritics:i18n("Track normal swings"),
                desc = LogBookCritics:i18n("Toggle tracking normal swings."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                get = function() return LogBookCritics.db.char.general.critics.trackNormalSwings end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackNormalSwings = value
                end,
            },
            trackCriticalSwings = {
                type = "toggle",
                order = 2,
                name = LogBookCritics:i18n("Track critical swings"),
                desc = LogBookCritics:i18n("Toggle tracking critical swings."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                get = function() return LogBookCritics.db.char.general.critics.trackCriticalSwings end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackCriticalSwings = value
                end,
            },
            --------------------------------------------------------------------------------------------------
            swingNormalColor = {
                type = "color",
                order = 3,
                name = LogBookCritics:i18n("Normal swings text color"),
                desc = LogBookCritics:i18n("Change color of normal swings text."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.swingNormalColor.red
                    local green = LogBookCritics.db.char.general.critics.swingNormalColor.green
                    local blue = LogBookCritics.db.char.general.critics.swingNormalColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.swingNormalColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.swingNormalColor.red = red
                    LogBookCritics.db.char.general.critics.swingNormalColor.green = green
                    LogBookCritics.db.char.general.critics.swingNormalColor.blue = blue
                    LogBookCritics.db.char.general.critics.swingNormalColor.alpha = alpha
                end
            },
            swingCriticalColor = {
                type = "color",
                order = 4,
                name = LogBookCritics:i18n("Critical swings text color"),
                desc = LogBookCritics:i18n("Change color of critical swings text."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.swingCriticalColor.red
                    local green = LogBookCritics.db.char.general.critics.swingCriticalColor.green
                    local blue = LogBookCritics.db.char.general.critics.swingCriticalColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.swingCriticalColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.swingCriticalColor.red = red
                    LogBookCritics.db.char.general.critics.swingCriticalColor.green = green
                    LogBookCritics.db.char.general.critics.swingCriticalColor.blue = blue
                    LogBookCritics.db.char.general.critics.swingCriticalColor.alpha = alpha
                end
            },
            --------------------------------------------------------------------------------------------------
            trackHighestSwing = {
                type = "toggle",
                order = 5,
                name = LogBookCritics:i18n("Track highest values"),
                desc = LogBookCritics:i18n("Toggles traking |cFF40E040highest|r hit values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                get = function() return LogBookCritics.db.char.general.critics.trackHighestSwing end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackHighestSwing = value
                end,
            },
            trackLowestSwing = {
                type = "toggle",
                order = 6,
                name = LogBookCritics:i18n("Track lowest values"),
                desc = LogBookCritics:i18n("Toggles traking |cFFE04040lowest|r hit values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                get = function() return LogBookCritics.db.char.general.critics.trackLowestSwing end,
                set = function(info, value)
                    LogBookCritics.db.char.general.critics.trackLowestSwing = value
                end,
            },
            --------------------------------------------------------------------------------------------------
            highestSwingColor = {
                type = "color",
                order = 7,
                name = LogBookCritics:i18n("Highest values color"),
                desc = LogBookCritics:i18n("Change color of |cFF40E040highest|r values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.highestSwingColor.red
                    local green = LogBookCritics.db.char.general.critics.highestSwingColor.green
                    local blue = LogBookCritics.db.char.general.critics.highestSwingColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.highestSwingColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.highestSwingColor.red = red
                    LogBookCritics.db.char.general.critics.highestSwingColor.green = green
                    LogBookCritics.db.char.general.critics.highestSwingColor.blue = blue
                    LogBookCritics.db.char.general.critics.highestSwingColor.alpha = alpha
                end
            },
            lowestSwingColor = {
                type = "color",
                order = 8,
                name = LogBookCritics:i18n("Lowest values color"),
                desc = LogBookCritics:i18n("Change color of |cFFE04040lowest|r values."),
                width = 1.4,
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackSwings); end,
                hasAlpha = true,
                get = function()
                    local red = LogBookCritics.db.char.general.critics.lowestSwingColor.red
                    local green = LogBookCritics.db.char.general.critics.lowestSwingColor.green
                    local blue = LogBookCritics.db.char.general.critics.lowestSwingColor.blue
                    local alpha = LogBookCritics.db.char.general.critics.lowestSwingColor.alpha
                    return red, green, blue, alpha
                end,
                set = function(_, red, green, blue, alpha)
                    LogBookCritics.db.char.general.critics.lowestSwingColor.red = red
                    LogBookCritics.db.char.general.critics.lowestSwingColor.green = green
                    LogBookCritics.db.char.general.critics.lowestSwingColor.blue = blue
                    LogBookCritics.db.char.general.critics.lowestSwingColor.alpha = alpha
                end
            },
        },
    }
end