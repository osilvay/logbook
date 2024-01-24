---@class LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:CreateModule("LBL_SettingsDefaults");

function LBL_SettingsDefaults:Load()
  return {
    global = {
      data = {
        characters = {
        },
        loot = { -- all loot
        },
        locale = {
        }
      },
      characters = {
        char = {
          info = {
          },
          loot = { -- personal loot
          },
        },
      },
    },
    char = {
      general = {
        loot = {
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
