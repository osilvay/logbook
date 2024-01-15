---@class LBE_SettingsDefaults
local LBE_SettingsDefaults = LB_ModuleLoader:CreateModule("LBE_SettingsDefaults");

function LBE_SettingsDefaults:Load()
  return {
    global = {
      data = {
        characters = {
        },
        enchanting = { -- all enchanting
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
        },
      },
    },
  }
end
