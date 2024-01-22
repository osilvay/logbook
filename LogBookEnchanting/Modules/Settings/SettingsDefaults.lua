---@class LBE_SettingsDefaults
local LBE_SettingsDefaults = LB_ModuleLoader:CreateModule("LBE_SettingsDefaults");

function LBE_SettingsDefaults:Load()
  return {
    global = {
      data = {
        characters = {
        },
        items = {    -- all enchanting
        },
        essences = { -- all enchanting
        },
        locale = {
        }
      },
      characters = {
        char = {
          info = {
          },
          enchanting = { -- personal enchanting
          },
        },
      },
    },
    char = {
      general = {
        enchanting = {
          trackingEnabled = true,
          tooltipsEnabled = true,
          showItemID = false,
          autoUpdateDb = true,
          showTitle = true,
          updateDbTimeout = 15,
          itemsToShow = 5,
          pressKeyDown = "2_alt"
        },
      },
    },
  }
end
