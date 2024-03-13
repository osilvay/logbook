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
          zeroValues = true,
          pressKeyDown = "1_none",
          updateDbTimeout = 15,
          itemsToShow = 10,
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
            ["1"] = true,
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true
          },
          tradeskillsEnabled = {
            ["Enchanting"] = true,
            ["Herbalism"] = true,
            ["Skinning"] = true,
            ["Mining"] = true,
            ["Fishing"] = true,
          },
          quantitySort = "desc",
          qualitySort = "desc",
          nameSort = "asc",
        },
      },
    },
  }
end
