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
          zones = { -- personal zones
          },
        },
      },
    },
    char = {
      general = {
        zones = {
          trackingEnabled = true,
          trackInFlight = false,
          showZoneChanges = true,
          showZoneMessages = true,
          autoTrackingEnabled = true,
          timeAutoTracking = 5,
        },
      },
    },
  }
end
