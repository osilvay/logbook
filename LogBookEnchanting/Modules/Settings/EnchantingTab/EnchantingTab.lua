---@class LBE_Settings
local LBE_Settings = LB_ModuleLoader:CreateModule("LBE_Settings");

---@type LBE_SettingsDefaults
local LBE_SettingsDefaults = LB_ModuleLoader:ImportModule("LBE_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

LBE_Settings.enchanting_tab = { ... }
local optionsDefaults = LBE_SettingsDefaults:Load()
local currentCharacters = {}
local _LBE_Settings = {}

function LBE_Settings:Initialize()
  return {
    name = LogBookEnchanting:i18n("Enchanting"),
    order = 3,
    type = "group",
    args = {
      enchanting_header = {
        type = "header",
        order = 1,
        name = "|cffc1c1f1" .. LogBookEnchanting:i18n("Enchanting settings") .. "|r",
      },
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookEnchanting:i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookEnchanting:i18n("Enable tracking"),
            desc = LogBookEnchanting:i18n("Toggle tracking enchanting."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookEnchanting.db.char.general.enchanting.trackingEnabled end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.trackingEnabled = value
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
            values = _LBE_Settings.CreateCharactersDropdown(),
            disabled = false,
            get = function() return nil end,
            set = function(info, value)
              LogBookEnchanting.db.char.general.enchanting.deleteCharacterData = value
              LB_CustomPopup:CreatePopup(LogBook:i18n("Delete character"), string.format(LogBook:i18n("Are you sure you want to delete the character %s?"), currentCharacters[value]), function()
                _LBE_Settings.DeleteCharacterEntry(value)
              end)
            end,
          }
        },
      },
    },
  }
end

function _LBE_Settings.CreateCharactersDropdown()
  local characters = LogBookEnchanting.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBE_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookEnchanting.db.global.characters[character] = {}
  LogBookEnchanting.db.global.data.characters[character] = false
  ReloadUI()
end
