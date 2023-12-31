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
        HIT_CRITICAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.hitCriticalColor, "FFF0E91F"),
        HIT_NORMAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.hitNormalColor, "FFFFF599"),
        HEAL_CRITICAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.healCriticalColor, "FF8EF01F"),
        HEAL_NORMAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.healNormalColor, "ffb1eb74"),
        HIGHEST_HIT = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.highestHitColor, "FF40E068"),
        LOWEST_HIT = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.lowestHitColor, "FFE04040"),
        HIGHEST_HEAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.highestHealColor, "FF40E068"),
        LOWEST_HEAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.lowestHealColor, "FFE04040"),
        HIGHEST_ATTACK = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.highestAttackColor, "FF40E068"),
        LOWEST_ATTACK = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.lowestAttackColor, "FFE04040"),
        UNDEFINED = "FF999999",
        ZERO = "FF991E15",
        ATTACK_NORMAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.attackNormalColor, "FFAAC0CF"),
        ATTACK_CRITICAL = LB_CustomColors:RgbToHex(LogBookCritics.db.char.general.critics.attackCriticalColor, "FFEDF4F9"),
        SPELLID = "FFF1F1F1",
        TEXT_VALUE = "FFc0c0c0",
        HIGHLIGHTED = "ffffcc00",
        DEFAULT_VALUE = "ffffcc00"
    };
    return customColors[color_index]
end

---Converts hex to rgb
---@param hex string
---@param normalized boolean
---@return table rgb
function LB_CustomColors:HexToRgb(hex, normalized)
    local result = {}
    hex = hex:gsub("#", "")
    local a = tonumber("0x" .. hex:sub(1, 2)) or 0
    local r = tonumber("0x" .. hex:sub(3, 4)) or 0
    local g = tonumber("0x" .. hex:sub(5, 6)) or 0
    local b = tonumber("0x" .. hex:sub(7, 8)) or 0
    if normalized then
        result = { r = tonumber(string.format("%.3f", r/255)), g = tonumber(string.format("%.3f", g/255)), b = tonumber(string.format("%.3f", b/255)), a = tonumber(string.format("%.3f", a/255)) }
    else
        result = { r = r, g = g, b = b, a = a }
    end
    return result
end

function LB_CustomColors:RgbToHex(rgbTable, default)
    if rgbTable == nil or rgbTable.red == nil or rgbTable.green == nil or rgbTable.blue == nil then
        local defaultColor = LB_CustomColors:HexToRgb(default, true)
        rgbTable = {
            red = defaultColor.r,
            green = defaultColor.g,
            blue = defaultColor.b,
            alpha = defaultColor.a,
        }
    end
    local r = rgbTable.red
    local g = rgbTable.green
    local b = rgbTable.blue
    local a = rgbTable.alpha
    local hex = string.format("ff%s%s%s", string.format("%x", (r * 255 * 0x1)), string.format("%x", (g * 255 * 0x1)), string.format("%x", (b * 255 * 0x1)))
    return hex
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
    local other_color = LB_CustomColors:CustomColors("UNDEFINED")
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
