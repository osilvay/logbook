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
          updateDbTimeout = 15,
          itemsToShow = 5,
          unitClassification = {
            ["1_normal"] = true,
            ["2_rare"] = true,
            ["3_elite"] = true,
            ["4_rareelite"] = true,
            ["5_boss"] = true,
            ["6_worldboss"] = true,
          },
          itemQuality = {
            ["0"] = false,
            ["1"] = false,
            ["2"] = false,
            ["3"] = false,
            ["4"] = false,
            ["5"] = false,
            ["6"] = false,
            ["7"] = false,
            ["8"] = false
          }
        },
      },
    },
  }
end
