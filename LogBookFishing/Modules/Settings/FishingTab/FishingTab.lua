---@class LBF_Settings
local LBF_Settings = LB_ModuleLoader:CreateModule("LBF_Settings");

---@type LBF_SettingsDefaults
local LBF_SettingsDefaults = LB_ModuleLoader:ImportModule("LBF_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

LBF_Settings.fishing_tab = { ... }
local optionsDefaults = LBF_SettingsDefaults:Load()
local currentCharacters = {}
local _LBF_Settings = {}

function LBF_Settings:Initialize()
  return {
    name = LogBookFishing:i18n("Fishing"),
    order = 4,
    type = "group",
    args = {
      fishing_header = {
        type = "header",
        order = 1,
        name = "|cffc1c1f1" .. LogBookFishing:i18n("Fishing settings") .. "|r",
      },
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookFishing:i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookFishing:i18n("Enable tracking"),
            desc = LogBookFishing:i18n("Toggle tracking fishing."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookFishing.db.char.general.fishing.trackingEnabled end,
            set = function(info, value)
              LogBookFishing.db.char.general.fishing.trackingEnabled = value
            end,
          },
        },
      },
      maintenance_header = {
        type = "header",
        order = 5,
        name = "|cffc1c1f1" .. LogBook:i18n("Maintenance") .. "|r",
      },
      maintenance = {
        type = "group",
        order = 6,
        inline = true,
        name = LogBook:i18n("Delete character data") .. " |cffff3300(" .. LogBook:i18n("Reload required") .. ")|r",
        args = {
          deleteCharacterData = {
            type = "select",
            order = 2,
            width = "full",
            name = LogBook:i18n("Character"),
            desc = LogBook:i18n("Character name."),
            values = _LBF_Settings.CreateCharactersDropdown(),
            disabled = false,
            get = function() return nil end,
            set = function(info, value)
              LogBookFishing.db.char.general.enchanting.deleteCharacterData = value
              LB_CustomPopup:CreatePopup(LogBook:i18n("Delete character"), string.format(LogBook:i18n("Are you sure you want to delete the character %s?"), currentCharacters[value]), function()
                _LBF_Settings.DeleteCharacterEntry(value)
              end)
            end,
          }
        },
      },
    },
  }
end

function _LBF_Settings.CreateCharactersDropdown()
  local characters = LogBookFishing.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBF_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookFishing.db.global.characters[character] = {}
  LogBookFishing.db.global.data.characters[character] = false
  ReloadUI()
end
