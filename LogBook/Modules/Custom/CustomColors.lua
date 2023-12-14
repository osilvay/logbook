---@class LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:CreateModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---Custom class colors
---@param color_index string
---@return string colorized_string
function LB_CustomColors:CustomClassColors(color_index)
    local customClassColors = {
        DRUID = "FFFF7C0A",
        HUNTER = "FFAAD372",
        MAGE = "FF3FC7EB",
        PALADIN = "FFF48CBA",
        PRIEST = "FFFFFFFF",
        ROGUE = "FFFFF468",
        SHAMAN = "FF0070DD",
        WARLOCK = "FF8788EE",
        WARRIOR = "FFC69B6D",
    };
    return customClassColors[color_index]
end

---Custom class colors
---@param color_index string
---@return string colorized_string
function LB_CustomColors:CustomFactionColors(color_index)
    local customFactionColors = {
        HORDE = "FFc74040",
        ALLIANCE = "FF00d1ff",
    };
    return customFactionColors[color_index]
end

---Custom colors
---@param color_index string
---@return string colorized_string
function LB_CustomColors:CustomColors(color_index)
    local customColors = {
        NAME = "ffffb611",
        LEVEL = "FFFF9811",
        HIT_CRITICAL = "FFF0E91F",
        HIT_NORMAL = "FFFFF599",
        HEAL_CRITICAL = "FF50F01F",
        HEAL_NORMAL = "FFB1FF99",
        HIGHEST_COLOR = "FF40E040",
        LOWEST_COLOR = "FFE04040",
        UNDEFINED_COLOR = "FF999999",
        ZERO_COLOR = "FF991E15",
        ATTACK_NORMAL = "FFC0c0c0",
        ATTACK_CRITICAL = "FFFFFFFF",
        SPELLID_COLOR = "FFB1EBF8",
        TEXT_VALUE = "FFc0c0c0",
        HIGHLIGHTED_COLOR = "ffffcc00",
        DEFAULT_VALUE = "ffffcc00"
    };
    return customColors[color_index]
end

---Converts hex to rgb
---@param hex string
---@return table rgb
function LB_CustomColors:HexToRgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber("0x" .. hex:sub(3, 4)) or 0
    local g = tonumber("0x" .. hex:sub(5, 6)) or 0
    local b = tonumber("0x" .. hex:sub(7, 8)) or 0
    return { r = r, g = g, b = b }
end

---Text colored by class
---@param className string
---@param classFilename string
---@return string colored_class
function LB_CustomColors:GetColoredClass(className, classFilename)
    if not class or not message then return "" end
    return "|c" .. LB_CustomColors:CustomClassColors(classFilename) .. className .. "|r"
end

---Text colored by name
---@param message string
---@return string colored_name
function LB_CustomColors:GetColoredName(message)
    if not message then return "" end
    return "|c" .. LB_CustomColors:CustomColors("NAME") .. message .. "|r"
end

---Text colored by level
---@param message string
---@return string colored_level
function LB_CustomColors:GetColoredLevel(message)
    if not message then return "" end
    return "|c" .. LB_CustomColors:CustomColors("LEVEL") .. message .. "|r"
end

---Text colored by faction
---@param faction string
---@param factionName string
---@return string colored_faction
function LB_CustomColors:GetColoredFaction(faction, factionName)
    if not faction or not factionName then return "" end
    local horde_color = LB_CustomColors:CustomFactionColors("HORDE")
    local alliance_color = LB_CustomColors:CustomFactionColors("ALLIANCE")
    local other_color = LB_CustomColors:CustomColors("UNDEFINED_COLOR")
    local colored_faction = ""
    if factionName == "Alliance" then
        colored_faction = "|c" .. alliance_color .. faction .. "|r"
    elseif factionName == "Horde" then
        colored_faction = "|c" .. horde_color .. faction .. "|r"
    else
        colored_faction = "|c" .. other_color .. faction .. "|r"
    end
    return colored_faction
end

---Colorize string
---@param color string
---@param message string
---@return string colorized_string
function LB_CustomColors:Colorize(color, message)
    if not color or not message then return "" end
    return string.format("|c%s%s|r", color, message)
end


