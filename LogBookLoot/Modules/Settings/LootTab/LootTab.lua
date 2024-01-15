---@class LBL_Settings
local LBL_Settings = LB_ModuleLoader:CreateModule("LBL_Settings");

---@type LBL_SettingsDefaults
local LBL_SettingsDefaults = LB_ModuleLoader:ImportModule("LBL_SettingsDefaults");

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

LBL_Settings.loot_tab = { ... }
local optionsDefaults = LBL_SettingsDefaults:Load()
local currentCharacters = {}
local _LBL_Settings = {}

function LBL_Settings:Initialize()
  return {
    name = LogBookLoot:LBL_i18n("Loot"),
    order = 5,
    type = "group",
    args = {
      loot_header = {
        type = "header",
        order = 1,
        name = "|cffc1c1f1" .. LogBookLoot:LBL_i18n("Loot settings") .. "|r",
      },
      tracking = {
        type = "group",
        order = 2,
        inline = true,
        name = LogBookLoot:LBL_i18n("Tracking"),
        args = {
          trackingEnabled = {
            type = "toggle",
            order = 1,
            name = LogBookLoot:LBL_i18n("Enable tracking"),
            desc = LogBookLoot:LBL_i18n("Toggle tracking loot."),
            width = 1.2,
            disabled = false,
            get = function() return LogBookLoot.db.char.general.loot.trackingEnabled end,
            set = function(info, value)
              LogBookLoot.db.char.general.loot.trackingEnabled = value
            end,
          },
        },
      },
      maintenance_header = {
        type = "header",
        order = 5,
        name = "|cffc1c1f1" .. LogBook:LB_i18n("Maintenance") .. "|r",
      },
      maintenance = {
        type = "group",
        order = 6,
        inline = true,
        name = LogBook:LB_i18n("Delete character data") .. " |cffff3300(" .. LogBook:LB_i18n("Reload required") .. ")|r",
        args = {
          deleteCharacterData = {
            type = "select",
            order = 2,
            width = "full",
            name = LogBook:LB_i18n("Character"),
            desc = LogBook:LB_i18n("Character name."),
            values = _LBL_Settings.CreateCharactersDropdown(),
            disabled = false,
            get = function() return nil end,
            set = function(info, value)
              LogBookLoot.db.char.general.enchanting.deleteCharacterData = value
              LB_CustomPopup:CreatePopup(LogBook:LB_i18n("Delete character"), string.format(LogBook:LB_i18n("Are you sure you want to delete the character %s?"), currentCharacters[value]), function()
                _LBL_Settings.DeleteCharacterEntry(value)
              end)
            end,
          }
        },
      },
    },
  }
end

function _LBL_Settings.CreateCharactersDropdown()
  local characters = LogBookLoot.db.global.data.characters
  currentCharacters = LB_CustomFunctions:CreateCharacterDropdownList(characters, true, true)
  return currentCharacters
end

function _LBL_Settings.DeleteCharacterEntry(characterKey)
  local character = LB_CustomFunctions:ConvertNewKeyToKey(characterKey)
  LogBookLoot.db.global.characters[character] = {}
  LogBookLoot.db.global.data.characters[character] = false
  ReloadUI()
end
