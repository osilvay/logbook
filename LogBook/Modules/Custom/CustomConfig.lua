---@class LB_CustomConfig
local LB_CustomConfig = LB_ModuleLoader:CreateModule("LB_CustomConfig")
local _LB_CustomConfig = {}

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames");

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions");

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors");

---@type LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:ImportModule("LB_CustomPopup")

---Generate delete character dropdown config
---@param characterList table
---@param deleteCharacterFn function
---@param currentCharacterList table
---@return table config
function LB_CustomConfig:CreateDeleteChararterConfig(characterList, deleteCharacterFn, currentCharacterList, order)
  return {
    type = "group",
    order = order,
    inline = true,
    name = "",
    args = {
      deleteCharacterData = {
        type = "select",
        order = 1,
        width = "full",
        name = LogBook:LB_i18n("Delete character data") .. " |cffff3300(" .. LogBook:LB_i18n("Reload required") .. ")|r",
        values = characterList,
        disabled = false,
        get = function() return nil end,
        set = function(info, value)
          LB_CustomPopup:CreatePopup(LogBook:LB_i18n("Delete character"), string.format(LogBook:LB_i18n("Are you sure you want to delete the character %s?"), currentCharacterList[value]) .. " |cffff3300" .. LogBook:LB_i18n("Reload required") .. "|r...", function()
            deleteCharacterFn(value)
          end)
        end,
      }
    }
  }
end

---Generate memory config
---@param addonToCheck string
---@param numEntries table
---@return table config
function LB_CustomConfig:CreateMemoryConfig(addonToCheck, numEntries, order)
  local addonStats = LB_CustomFunctions:UpdateMemoryUsageForAddon(addonToCheck)
  return {
    type = "group",
    order = order,
    inline = true,
    name = LogBook:LB_i18n("Memory usage"),
    args = {
      addonName = {
        type = "description",
        order = 1,
        width = 1,
        hidden = false,
        name = LogBook:LB_i18n("Addon")
      },
      addonNameValue = {
        type = "description",
        order = 1.1,
        width = 1,
        hidden = false,
        name = function()
          --local addonStats = LB_CustomFunctions:UpdateMemoryUsageForAddon(addonToCheck)
          if addonStats == nil or addonStats["disabled"] then
            return LB_CustomColors:Colorize(LB_CustomColors:CustomColors("DISABLED"), LogBook:LB_i18n("Disabled"))
          else
            return LB_CustomColors:Colorize(LB_CustomColors:CustomColors("ENABLED"), LogBook:LB_i18n("Enabled"))
          end
        end
      },
      entriesInDb = LB_CustomConfig:CreateEntriesConfig(LogBook:LB_i18n("Entries"), 2, numEntries),
      memoryUsageKb = {
        type = "description",
        order = 3,
        width = 1,
        hidden = false,
        name = LogBook:LB_i18n("Use in KB")
      },
      memoryUsageKbValue = {
        type = "description",
        order = 3.1,
        width = 1,
        hidden = false,
        name = function()
          return LB_CustomColors:ColorizeByValue(tostring(addonStats["totalMemInKb"]), addonStats["totalMemInKb"], 4096) .. " KB"
        end
      },
      memoryUsageMb = {
        type = "description",
        order = 4,
        width = 1,
        hidden = false,
        name = LogBook:LB_i18n("Use in MB")
      },
      memoryUsageMbValue = {
        type = "description",
        order = 4.1,
        width = 1,
        hidden = false,
        name = function()
          return LB_CustomColors:ColorizeByValue(tostring(addonStats["totalMemInMb"]), addonStats["totalMemInMb"], 4) .. " MB"
        end
      }
    }
  }
end

---Generate delete character dropdown config
---@param addonToCheck string
---@param numEntries table
---@return table config
function LB_CustomConfig:CreateStatsConfig(addonToCheck, numEntries, order)
  return {
    type = "group",
    order = order,
    inline = true,
    name = "",
    args = {
      addonMemoryUsage = LB_CustomConfig:CreateMemoryConfig(addonToCheck, numEntries, 1),
    },
  }
end

---Generate header config
---@param header string
---@param order number
---@param color? string
---@return table config
function LB_CustomConfig:CreateHeaderConfig(header, order, color)
  if color == nil then color = "fff1c100" end
  return {
    type = "header",
    order = order,
    name = string.format("|c%s%s|r", color, header),
  }
end

function LB_CustomConfig:CreateEntriesConfig(header, order, entries)
  local argEntries = {}
  local entryIndex = 1
  for title, value in pairs(entries) do
    argEntries["entryIndex" .. entryIndex] = {
      type = "description",
      order = entryIndex,
      width = 1,
      hidden = false,
      name = title
    }
    argEntries["entryValue" .. entryIndex] = {
      type = "description",
      order = entryIndex + 0.1,
      width = 1,
      hidden = false,
      name = function()
        return LB_CustomColors:Colorize(LB_CustomColors:CustomColors("NAME"), tostring(value))
      end
    }
    entryIndex = entryIndex + 1
  end

  return {
    type = "group",
    order = order,
    inline = true,
    name = "",
    args = argEntries
  }
end

---Create key dropdown config
function LB_CustomConfig:KeyDownDropdownConfig()
  return {
    ["1_none"] = LogBook:LB_i18n("None"),
    ["2_alt"] = LogBook:LB_i18n("Alt"),
    ["3_shift"] = LogBook:LB_i18n("Shift"),
    ["4_control"] = LogBook:LB_i18n("Control"),
    ["5_altShift"] = LogBook:LB_i18n("Alt + Shift"),
    ["6_altControl"] = LogBook:LB_i18n("Alt + Control"),
    ["7_altShiftControl"] = LogBook:LB_i18n("Alt + Shift + Control"),
    ["8_shiftControl"] = LogBook:LB_i18n("Shift + Control"),
  }
end

---Create key drop down config group
---@param order number
---@param disabled? boolean
---@return table
function LB_CustomConfig:CreateKeyDownDropdownConfig(order, disabled)
  return {
    type = "group",
    order = order,
    inline = true,
    name = "",
    args = {
      pressKeyDown = {
        type = "select",
        order = 1,
        width = 1,
        name = LogBook:LB_i18n("Press key to show"),
        values = LB_CustomConfig:KeyDownDropdownConfig(),
        disabled = false,
        get = function() return LogBookLoot.db.char.general.loot.pressKeyDown end,
        set = function(info, value)
          LogBookLoot.db.char.general.loot.pressKeyDown = value
        end,
      }
    }
  }
end
