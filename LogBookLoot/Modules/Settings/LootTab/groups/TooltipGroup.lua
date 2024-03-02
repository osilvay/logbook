---@class LBL_TooltipGroup
local LBL_TooltipGroup = LB_ModuleLoader:CreateModule("LBL_TooltipGroup");

---@type LB_CustomConfig
local LB_CustomConfig = LB_ModuleLoader:ImportModule("LB_CustomConfig")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

function LBL_TooltipGroup:Header()
  return LB_CustomConfig:CreateHeaderConfig(LogBook:LB_i18n("Tooltips"), 3, LogBookLoot:GetAddonColor())
end

function LBL_TooltipGroup:Config()
  return {
    type = "group",
    order = 4,
    inline = true,
    name = " ",
    args = {
      tooltipsEnabled = {
        type = "toggle",
        order = 1,
        name = LogBookLoot:LBL_i18n("Enable tooltips"),
        desc = LogBookLoot:LBL_i18n("Toggle showing loot tooltips."),
        width = "full",
        disabled = false,
        get = function() return LogBookLoot.db.char.general.loot.tooltipsEnabled end,
        set = function(info, value)
          LogBookLoot.db.char.general.loot.tooltipsEnabled = value
        end,
      },
      showTitle = {
        type = "toggle",
        order = 2,
        name = LogBookLoot:LBL_i18n("Show title"),
        desc = LogBookLoot:LBL_i18n("Toggle showing title."),
        width = "full",
        disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
        get = function() return LogBookLoot.db.char.general.loot.showTitle end,
        set = function(info, value)
          LogBookLoot.db.char.general.loot.showTitle = value
        end,
      },
      showItemID = {
        type = "toggle",
        order = 3,
        name = LogBookLoot:LBL_i18n("Show ItemID"),
        desc = LogBookLoot:LBL_i18n("Toggle showing item ids."),
        width = "full",
        disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
        get = function() return LogBookLoot.db.char.general.loot.showItemID end,
        set = function(info, value)
          LogBookLoot.db.char.general.loot.showItemID = value
        end,
      },
      itemsToShow = {
        type = "range",
        order = 4,
        name = LogBookLoot:LBL_i18n("Items to show"),
        desc = LogBookLoot:LBL_i18n("Items to show in tooltip."),
        width = "full",
        min = 1,
        max = 20,
        step = 1,
        disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
        get = function() return LogBookLoot.db.char.general.loot.itemsToShow end,
        set = function(info, value)
          LogBookLoot.db.char.general.loot.itemsToShow = value
        end,
      },
      unitClassification = {
        type = "multiselect",
        order = 5,
        width = 0.9,
        name = LogBookLoot:LBL_i18n("Unit classification"),
        desc = LogBookLoot:LBL_i18n("Filter by unit classification."),
        values = LBL_TooltipGroup:UnitClassificationDropdownConfig(),
        disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
        get = function(info, entry)
          return LogBookLoot.db.char.general.loot[info[#info]][entry]
        end,
        set = function(info, entry, value)
          LogBookLoot.db.char.general.loot[info[#info]][entry] = value
        end,
      },
      itemQuality = {
        type = "multiselect",
        order = 6,
        width = 0.9,
        name = LogBookLoot:LBL_i18n("Item quality"),
        desc = LogBookLoot:LBL_i18n("Filter by item quality."),
        values = LBL_TooltipGroup:itemQualityDropdownConfig(),
        disabled = function() return (not LogBookLoot.db.char.general.loot.tooltipsEnabled); end,
        get = function(info, entry)
          return LogBookLoot.db.char.general.loot[info[#info]][entry]
        end,
        set = function(info, entry, value)
          LogBookLoot.db.char.general.loot[info[#info]][entry] = value
        end,
      },
      pressKeyDownGroup = LB_CustomConfig:CreateKeyDownDropdownConfig(15, not LogBookLoot.db.char.general.loot.tooltipsEnabled)
    },
  }
end

function LBL_TooltipGroup:UnitClassificationDropdownConfig()
  return {
    ["1_normal"] = "|TInterface\\AddOns\\LogBook\\Images\\normal:16:16|t |c" .. LB_CustomColors:CustomUnitClassificationColors("normal") .. LogBook:LB_i18n("Normal") .. "|r",
    ["2_rare"] = "|TInterface\\AddOns\\LogBook\\Images\\rare:16:16|t |c" .. LB_CustomColors:CustomUnitClassificationColors("rare") .. LogBook:LB_i18n("Rare") .. "|r",
    ["3_elite"] = "|TInterface\\AddOns\\LogBook\\Images\\elite:16:16|t |c" .. LB_CustomColors:CustomUnitClassificationColors("elite") .. LogBook:LB_i18n("Elite") .. "|r",
    ["4_rareelite"] = "|TInterface\\AddOns\\LogBook\\Images\\rareelite:16:16|t |c" .. LB_CustomColors:CustomUnitClassificationColors("rareelite") .. LogBook:LB_i18n("Rare elite") .. "|r",
    ["5_boss"] = "|TInterface\\AddOns\\LogBook\\Images\\boss:16:16|t |c" .. LB_CustomColors:CustomUnitClassificationColors("boss") .. LogBook:LB_i18n("Boss") .. "|r",
    ["6_worldboss"] = "|TInterface\\AddOns\\LogBook\\Images\\worldboss:16:16|t |c" .. LB_CustomColors:CustomUnitClassificationColors("worldboss") .. LogBook:LB_i18n("World boss") .. "|r",
  }
end

function LBL_TooltipGroup:itemQualityDropdownConfig()
  return {
    ["0"] = "|c" .. LB_CustomColors:CustomQualityColors(0) .. LogBook:LB_i18n("Poor") .. "|r",
    ["1"] = "|c" .. LB_CustomColors:CustomQualityColors(1) .. LogBook:LB_i18n("Common") .. "|r",
    ["2"] = "|c" .. LB_CustomColors:CustomQualityColors(2) .. LogBook:LB_i18n("Uncommon") .. "|r",
    ["3"] = "|c" .. LB_CustomColors:CustomQualityColors(3) .. LogBook:LB_i18n("Rare") .. "|r",
    ["4"] = "|c" .. LB_CustomColors:CustomQualityColors(4) .. LogBook:LB_i18n("Epic") .. "|r",
    ["5"] = "|c" .. LB_CustomColors:CustomQualityColors(5) .. LogBook:LB_i18n("Legendary") .. "|r",
    --["6"] = "|c" .. LB_CustomColors:CustomQualityColors(6) .. LogBook:LB_i18n("Artifact") .. "|r",
    --["7"] = "|c" .. LB_CustomColors:CustomQualityColors(7) .. LogBook:LB_i18n("Heirloom") .. "|r",
    --["8"] = "|c" .. LB_CustomColors:CustomQualityColors(8) .. LogBook:LB_i18n("WoW Token") .. "|r"
  }
end
