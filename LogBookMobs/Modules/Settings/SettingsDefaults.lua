---@class LBM_SettingsDefaults
local LBM_SettingsDefaults = LB_ModuleLoader:CreateModule("LBM_SettingsDefaults");

function LBM_SettingsDefaults:Load()
  return {
    global = {
      data = {
        characters = {
        },
        mobs = { -- all mobs
        },
        locale = {
        }
      },
      characters = {
        char = {
          info = {
          },
          mobs = { -- personal mobs
          },
        },
      },
      cache = {
        mobs = { -- all mobs
        },
      }
    },
    char = {
      general = {
        mobs = {
          trackingEnabled = true,
          tooltipsEnabled = true,
          showTitle = true,
          showItemID = true,
          pressKeyDown = "2_alt",
        },
      },
    },
  }
end
