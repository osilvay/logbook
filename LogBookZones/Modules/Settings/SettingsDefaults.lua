---@class LBZ_SettingsDefaults
local LBZ_SettingsDefaults = LB_ModuleLoader:CreateModule("LBZ_SettingsDefaults");

function LBZ_SettingsDefaults:Load()
  return {
    global = {
      data = {
        characters = {
        },
        zones = { -- all zones
        },
        locale = {
        }
      },
      characters = {
        char = {
          info = {
          },
          zones = {
          },
          paths = {
          }
        },
      },
    },
    char = {
      general = {
        zones = {
          trackingEnabled = true,
          trackInFlight = false,
          showZoneMessagesInChat = true,
          showZoneMessagesOnScreen = true,
          autoTrackingEnabled = true,
          timeAutoTracking = 30,
          enablePathOverlay = true
        },
      },
    },
  }
end
