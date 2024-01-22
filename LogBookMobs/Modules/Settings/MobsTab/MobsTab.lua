---@class LBM_Settings
local LBM_Settings = LB_ModuleLoader:CreateModule("LBM_Settings");

---@type LBM_SettingsDefaults
local LBM_SettingsDefaults = LB_ModuleLoader:ImportModule("LBM_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

LBM_Settings.mobs_tab = { ... }
local optionsDefaults = LBM_SettingsDefaults:Load()
local currentCharacters = {}
local _LBM_Settings = {}

function LBM_Settings:Initialize()
  return {
    name = LogBookMobs:LBM_i18n("Mobs"),
    order = 6,
    type = "group",
    args = {
      mobs_header = {
        type = "header",
        order = 1,
        name = "|cffc1c1f1" .. LogBookMobs:LBM_i18n("Mobs settings") .. "|r",
      },
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookMobs:LBM_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookMobs:LBM_i18n("Enable tracking"),
            desc = LogBookMobs:LBM_i18n("Toggle tracking mobs."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookMobs.db.char.general.mobs.trackingEnabled end,
            set = function(info, value)
              LogBookMobs.db.char.general.mobs.trackingEnabled = value
            end,
          },
        },
      },
      maintenance_header = {
        type = "header",
        order = 98,
        name = "|cffc1c1f1" .. LogBook:LB_i18n("Maintenance") .. "|r",
      },
      maintenance = {
        type = "group",
        order = 99,
        inline = true,
        name = LogBook:LB_i18n("Delete character data") .. " |cffff3300(" .. LogBook:LB_i18n("Reload required") .. ")|r",
        args = {
          deleteCharacterData = {
            type = "select",
            order = 90,
            width = "full",
            name = LogBook:LB_i18n("Character"),
            desc = LogBook:LB_i18n("Character name."),
            values = _LBM_Settings.CreateCharactersDropdown(),
            disabled = false,
            get = function() return nil end,
            set = function(info, value)
              LogBookMobs.db.char.general.enchanting.deleteCharacterData = value
              LB_CustomPopup:CreatePopup(LogBook:LB_i18n("Delete character"), string.format(LogBook:LB_i18n("Are you sure you want to delete the character %s?"), currentCharacters[value]), function()
                _LBM_Settings.DeleteCharacterEntry(value)
              end)
            end,
          }
        },
      },
    },
  }
end

function _LBM_Settings.CreateCharactersDropdown()
  local characters = LogBookMobs.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBM_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookMobs.db.global.characters[character] = {}
  LogBookMobs.db.global.data.characters[character] = false
  ReloadUI()
end
