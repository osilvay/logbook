---@class LBC_Settings
local LBC_Settings = LB_ModuleLoader:CreateModule("LBC_Settings");

---@type LBC_SettingsDefaults
local LBC_SettingsDefaults = LB_ModuleLoader:ImportModule("LBC_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

---@type LBC_SplashCriticsWindow
local LBC_SplashCriticsWindow = LB_ModuleLoader:ImportModule("LBC_SplashCriticsWindow");

LBC_Settings.critics_tab = { ... }
local optionsDefaults = LBC_SettingsDefaults:Load()
local colorIcon = "|TInterface\\AddOns\\LogBook\\Images\\color:16:16|t"
local LibDialog = LibStub("LibDialog-1.0")
local currentCharacters = {}
local _LBC_Settings = {}

function LBC_Settings:Initialize()
  return {
    name = LogBookCritics:LBC_i18n("Critics"),
    order = 2,
    type = "group",
    args = {
      critics_header = {
        type = "header",
        order = 1,
        name = "|cffc1c1f1" .. LogBookCritics:LBC_i18n("Critics settings") .. "|r",
      },
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookCritics:LBC_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookCritics:LBC_i18n("Enable tracking"),
            desc = LogBookCritics:LBC_i18n("Toggle tracking hits and heals."),
            width = "full",
            disabled = false,
            get = function() return LogBookCritics.db.char.general.critics.trackingEnabled end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.trackingEnabled = value
              if not value then
                LogBookCritics.db.char.general.critics.trackHeals = false
                LogBookCritics.db.char.general.critics.trackHits = false
                LogBookCritics.db.char.general.critics.trackAttacks = false
              else
                LogBookCritics.db.char.general.critics.trackHeals = true
                LogBookCritics.db.char.general.critics.trackHits = true
                LogBookCritics.db.char.general.critics.trackAttacks = true
              end
            end,
          },
          trackHeals = {
            type = "toggle",
            order = 3,
            name = LogBookCritics:LBC_i18n("Tracking heals"),
            desc = LogBookCritics:LBC_i18n("Toggle tracking heals."),
            width = "full",
            disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
            get = function() return LogBookCritics.db.char.general.critics.trackHeals end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.trackHeals = value
            end,
          },
          trackHits = {
            type = "toggle",
            order = 4,
            name = LogBookCritics:LBC_i18n("Tracking hits"),
            desc = LogBookCritics:LBC_i18n("Toggle tracking hits."),
            width = "full",
            disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
            get = function() return LogBookCritics.db.char.general.critics.trackHits end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.trackHits = value
            end,
          },
          trackAttacks = {
            type = "toggle",
            order = 4,
            name = LogBookCritics:LBC_i18n("Tracking attacks"),
            desc = LogBookCritics:LBC_i18n("Toggle tracking attacks."),
            width = "full",
            disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
            get = function() return LogBookCritics.db.char.general.critics.trackAttacks end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.trackAttacks = value
            end,
          },

        },
      },
      screen_header = {
        type = "header",
        order = 3,
        name = "|cffc1c1f1" .. LogBookCritics:LBC_i18n("Messages") .. "|r",
      },
      screenMessages = {
        type = "group",
        order = 4,
        inline = true,
        name = LogBookCritics:LBC_i18n("Screen"),
        args = {
          unlockTextFrame = {
            type = "toggle",
            order = 1,
            name = LogBookCritics:LBC_i18n("Unlock text frame"),
            desc = LogBookCritics:LBC_i18n("Toggle text frame lock."),
            width = "full",
            get = function() return LogBookCritics.db.char.general.critics.unlockTextFrame end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.unlockTextFrame = value
              if value then
                LBC_SplashCriticsWindow.UnlockTextMessage(LogBookCritics:LBC_i18n("Test message"))
              else
                LBC_SplashCriticsWindow.LockTextMessage(LogBookCritics:LBC_i18n("Test message"))
              end
            end,
          },
          messageDuration = {
            type = "range",
            order = 2,
            name = LogBookCritics:LBC_i18n("Message duration"),
            desc = LogBookCritics:LBC_i18n("Duration of messages on screen."),
            width = "full",
            min = 1,
            max = 5,
            step = 1,
            disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
            get = function() return LogBookCritics.db.char.general.critics.messageDuration end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.messageDuration = value
            end,
          },
          screenMessages = {
            type = "group",
            order = 3,
            inline = false,
            width = "full",
            name = LogBookCritics:LBC_i18n("Screen position"),
            args = {
              screenPositionX = {
                type = "range",
                order = 1,
                width = "full",
                min = tonumber(string.format("%.1f", -GetScreenWidth() / 2)),
                max = tonumber(string.format("%.1f", GetScreenWidth() / 2)),
                step = 0.1,
                name = LogBookCritics:LBC_i18n("Position X"),
                desc = LogBookCritics:LBC_i18n("Screen position X."),
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
                get = function() return LogBookCritics.db.char.general.critics.splashFrameOffset.xOffset end,
                set = function(info, value)
                  LogBookCritics.db.char.general.critics.unlockTextFrame = true
                  LBC_SplashCriticsWindow.UnlockTextMessage(LogBookCritics:LBC_i18n("Test message"))
                  LogBookCritics.db.char.general.critics.splashFrameOffset.xOffset = value
                  LBC_SplashCriticsWindow:UpdateSplashCriticsWindowPoint()
                end,
              },
              screenPositionY = {
                type = "range",
                order = 2,
                width = "full",
                min = tonumber(string.format("%.1f", -GetScreenHeight() / 2)),
                max = tonumber(string.format("%.1f", GetScreenHeight() / 2)),
                step = 0.1,
                name = LogBookCritics:LBC_i18n("Position Y"),
                desc = LogBookCritics:LBC_i18n("Screen position Y."),
                disabled = function() return (not LogBookCritics.db.char.general.critics.trackingEnabled); end,
                get = function() return LogBookCritics.db.char.general.critics.splashFrameOffset.yOffset end,
                set = function(info, value)
                  LogBookCritics.db.char.general.critics.unlockTextFrame = true
                  LBC_SplashCriticsWindow.UnlockTextMessage(LogBookCritics:LBC_i18n("Test message"))
                  LogBookCritics.db.char.general.critics.splashFrameOffset.yOffset = value
                  LBC_SplashCriticsWindow:UpdateSplashCriticsWindowPoint()
                end,
              }
            }
          },
        },
      },
      maintenance_header = {
        type = "header",
        order = 5,
        name = "|cffc1c1f1" .. LogBook:LB_i18n("Maintenance") .. "|r",
      },
      maintenance = {
        type = "group",
        order = 6,
        inline = true,
        name = LogBook:LB_i18n("Delete character data") .. " |cffff3300(" .. LogBook:LB_i18n("Reload required") .. ")|r",
        args = {
          deleteCharacterData = {
            type = "select",
            order = 2,
            width = "full",
            name = LogBook:LB_i18n("Character"),
            desc = LogBook:LB_i18n("Character name."),
            values = _LBC_Settings.CreateCharactersDropdown(),
            disabled = false,
            get = function() return nil end,
            set = function(info, value)
              LogBookCritics.db.char.general.critics.deleteCharacterData = value
              LB_CustomPopup:CreatePopup(LogBook:LB_i18n("Delete character"), string.format(LogBook:LB_i18n("Are you sure you want to delete the character %s?"), currentCharacters[value]), function()
                _LBC_Settings.DeleteCharacterEntry(value)
              end)
            end,
          }
        },
      },
      hit_tab = LBC_Settings._HitTab(),
      heal_tab = LBC_Settings._HealTab(),
      attack_tab = LBC_Settings._AttackTab()
    },
  }
end

function LBC_Settings._HealTab()
  return {
    type = "group",
    order = 3,
    name = LogBookCritics:LBC_i18n("Healings"),
    disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
    args = {
      healings_header = {
        type = "header",
        order = 0,
        name = "|cffc1c1f1" .. LogBookCritics:LBC_i18n("Healings") .. "|r",
      },
      --------------------------------------------------------------------------------------------------
      trackNormalHeals = {
        type = "toggle",
        order = 1,
        name = LogBookCritics:LBC_i18n("Normal heals"),
        desc = LogBookCritics:LBC_i18n("Toggle tracking normal heals."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        get = function() return LogBookCritics.db.char.general.critics.trackNormalHeals end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackNormalHeals = value
        end,
      },
      healNormalColor = {
        type = "color",
        order = 2,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of normal heals text."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HEAL_NORMAL"), true)
          LogBookCritics.db.char.general.critics.healNormalColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.healNormalColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.healNormalColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.healNormalColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.healNormalColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackCriticalHeals = {
        type = "toggle",
        order = 3,
        name = LogBookCritics:LBC_i18n("Critical heals"),
        desc = LogBookCritics:LBC_i18n("Toggle tracking critical heals."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        get = function() return LogBookCritics.db.char.general.critics.trackCriticHeals end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackCriticHeals = value
        end,
      },
      healCriticalColor = {
        type = "color",
        order = 4,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of critical heals text."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HEAL_CRITICAL"), true)
          LogBookCritics.db.char.general.critics.healCriticalColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.healCriticalColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.healCriticalColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.healCriticalColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.healCriticalColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackHighestHeals = {
        type = "toggle",
        order = 5,
        name = LogBookCritics:LBC_i18n("Highest values"),
        desc = LogBookCritics:LBC_i18n("Toggle traking highest healing values."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        get = function() return LogBookCritics.db.char.general.critics.trackHighestHeals end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackHighestHeals = value
        end,
      },
      highestHealColor = {
        type = "color",
        order = 6,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of highest healing values."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HIGHEST_HEAL"), true)
          LogBookCritics.db.char.general.critics.highestHealColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.highestHealColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.highestHealColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.highestHealColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.highestHealColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackLowestHeals = {
        type = "toggle",
        order = 7,
        name = LogBookCritics:LBC_i18n("Lowest values"),
        desc = LogBookCritics:LBC_i18n("Toggle traking lowest healing values."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        get = function() return LogBookCritics.db.char.general.critics.trackLowestHeals end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackLowestHeals = value
        end,
      },
      lowestHealColor = {
        type = "color",
        order = 8,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of lowest healing values."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHeals); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("LOWEST_HEAL"), true)
          LogBookCritics.db.char.general.critics.lowestHealColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.lowestHealColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.lowestHealColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.lowestHealColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.lowestHealColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
    },
  }
end

function LBC_Settings._HitTab()
  return {
    type = "group",
    order = 4,
    name = LogBookCritics:LBC_i18n("Harmful"),
    disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
    args = {
      maintenance_header = {
        type = "header",
        order = 0,
        name = "|cffc1c1f1" .. LogBookCritics:LBC_i18n("Harmful") .. "|r",
      },
      trackNormalHits = {
        type = "toggle",
        order = 1,
        name = LogBookCritics:LBC_i18n("Normal damage"),
        desc = LogBookCritics:LBC_i18n("Toggle tracking normal damage."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        get = function() return LogBookCritics.db.char.general.critics.trackNormalHits end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackNormalHits = value
        end,
      },
      hitNormalColor = {
        type = "color",
        order = 2,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of normal damage text."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HIT_NORMAL"), true)
          LogBookCritics.db.char.general.critics.hitNormalColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.hitNormalColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.hitNormalColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.hitNormalColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.hitNormalColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackCriticalHits = {
        type = "toggle",
        order = 3,
        name = LogBookCritics:LBC_i18n("Critical damage"),
        desc = LogBookCritics:LBC_i18n("Toggle tracking critical damage."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        get = function() return LogBookCritics.db.char.general.critics.trackCriticalHits end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackCriticalHits = value
        end,
      },
      hitCriticalColor = {
        type = "color",
        order = 4,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of critical damage text."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HIT_CRITICAL"), true)
          LogBookCritics.db.char.general.critics.hitCriticalColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.hitCriticalColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.hitCriticalColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.hitCriticalColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.hitCriticalColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackHighestHits = {
        type = "toggle",
        order = 5,
        name = LogBookCritics:LBC_i18n("Highest values"),
        desc = LogBookCritics:LBC_i18n("Toggle traking highest damage values."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        get = function() return LogBookCritics.db.char.general.critics.trackHighestHits end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackHighestHits = value
        end,
      },
      highestHitColor = {
        type = "color",
        order = 6,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of highest damage values."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HIGHEST_HIT"), true)
          LogBookCritics.db.char.general.critics.highestHitColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.highestHitColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.highestHitColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.highestHitColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.highestHitColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackLowestHits = {
        type = "toggle",
        order = 7,
        name = LogBookCritics:LBC_i18n("Lowest values"),
        desc = LogBookCritics:LBC_i18n("Toggle traking lowest damage values."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        get = function() return LogBookCritics.db.char.general.critics.trackLowestHits end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackLowestHits = value
        end,
      },
      lowestHitColor = {
        type = "color",
        order = 8,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of lowest damage values."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackHits); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("LOWEST_HIT"), true)
          LogBookCritics.db.char.general.critics.lowestHitColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.lowestHitColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.lowestHitColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.lowestHitColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.lowestHitColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
    },
  }
end

function LBC_Settings._AttackTab()
  return {
    type = "group",
    order = 4,
    name = LogBookCritics:LBC_i18n("White hits"),
    disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
    args = {
      maintenance_header = {
        type = "header",
        order = 0,
        name = "|cffc1c1f1" .. LogBookCritics:LBC_i18n("White hits") .. "|r",
      },
      trackNormalAttacks = {
        type = "toggle",
        order = 1,
        name = LogBookCritics:LBC_i18n("Normal white hits"),
        desc = LogBookCritics:LBC_i18n("Toggle tracking normal white hits."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        get = function() return LogBookCritics.db.char.general.critics.trackNormalAttacks end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackNormalAttacks = value
        end,
      },
      attackNormalColor = {
        type = "color",
        order = 2,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of normal white hits text."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("ATTACK_NORMAL"), true)
          LogBookCritics.db.char.general.critics.attackNormalColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.attackNormalColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.attackNormalColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.attackNormalColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.attackNormalColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackCriticalAttacks = {
        type = "toggle",
        order = 3,
        name = LogBookCritics:LBC_i18n("Critical white hits"),
        desc = LogBookCritics:LBC_i18n("Toggle tracking critical white hits."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        get = function() return LogBookCritics.db.char.general.critics.trackCriticalAttacks end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackCriticalAttacks = value
        end,
      },
      attackCriticalColor = {
        type = "color",
        order = 4,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of critical white hits text."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("ATTACK_CRITICAL"), true)
          LogBookCritics.db.char.general.critics.attackCriticalColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.attackCriticalColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.attackCriticalColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.attackCriticalColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.attackCriticalColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackHighestAttacks = {
        type = "toggle",
        order = 5,
        name = LogBookCritics:LBC_i18n("Highest values"),
        desc = LogBookCritics:LBC_i18n("Toggle traking highest white hits values."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        get = function() return LogBookCritics.db.char.general.critics.trackHighestAttacks end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackHighestAttacks = value
        end,
      },
      highestAttackColor = {
        type = "color",
        order = 6,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of highest white hits values."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("HIGHEST_ATTACK"), true)
          LogBookCritics.db.char.general.critics.highestAttackColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.highestAttackColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.highestAttackColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.highestAttackColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.highestAttackColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
      --------------------------------------------------------------------------------------------------
      trackLowestAttacks = {
        type = "toggle",
        order = 7,
        name = LogBookCritics:LBC_i18n("Lowest values"),
        desc = LogBookCritics:LBC_i18n("Toggle traking lowest white hits values."),
        width = 1.85,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        get = function() return LogBookCritics.db.char.general.critics.trackLowestAttacks end,
        set = function(info, value)
          LogBookCritics.db.char.general.critics.trackLowestAttacks = value
        end,
      },
      lowestAttackColor = {
        type = "color",
        order = 8,
        name = colorIcon,
        desc = LogBookCritics:LBC_i18n("Change color of lowest white hits values."),
        descStyle = "inline",
        width = 0.3,
        disabled = function() return (not LogBookCritics.db.char.general.critics.trackAttacks); end,
        hasAlpha = true,
        get = function()
          local rgb = LB_CustomColors:HexToRgb(LB_CustomColors:CustomColors("LOWEST_ATTACK"), true)
          LogBookCritics.db.char.general.critics.lowestAttackColor = {
            red = rgb.r,
            green = rgb.g,
            blue = rgb.b,
            alpha = rgb.a
          }
          return rgb.r, rgb.g, rgb.b, rgb.a
        end,
        set = function(_, red, green, blue, alpha)
          LogBookCritics.db.char.general.critics.lowestAttackColor.red = tonumber(string.format("%.3f", red))
          LogBookCritics.db.char.general.critics.lowestAttackColor.green = tonumber(string.format("%.3f", green))
          LogBookCritics.db.char.general.critics.lowestAttackColor.blue = tonumber(string.format("%.3f", blue))
          LogBookCritics.db.char.general.critics.lowestAttackColor.alpha = tonumber(string.format("%.3f", alpha))
        end
      },
    },
  }
end

function _LBC_Settings.CreateCharactersDropdown()
  local characters = LogBookCritics.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBC_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookCritics.db.global.characters[character] = {}
  LogBookCritics.db.global.data.characters[character] = false
  ReloadUI()
end
