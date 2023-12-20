---@class LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:CreateModule("LB_CustomFunctions")

function LB_CustomFunctions:Initialize()
end

---Dump table to string
---@param o table
---@return string o
function LB_CustomFunctions:Dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. LB_CustomFunctions:Dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

---Remove duplications in table
---@param currentTable table
---@return table res
function LB_CustomFunctions:RemoveDuplicationsInTable(currentTable)
    local hash = {}
    local res = {}
    for _, v in ipairs(currentTable) do
        if (not hash[v]) then
            res[#res + 1] = v
            hash[v] = true
        end
    end
    return res
end

---Check if table contains value
---@param table table
---@param value string
---@return boolean
function LB_CustomFunctions:TableHasValue(table, value)
    local f = false
    for k, v in pairs(table) do
        if table[k] == value then
            f = true
            break
        end
    end
    return f
end

---Check if table contains key
---@param table table
---@param key string
---@return boolean
function LB_CustomFunctions:TableHasKey(table, key)
    local f = false
    for k, _ in pairs(table) do
        if k == key then
            f = true
            break
        end
    end
    return f
end

---Count table entries
---@param table table
---@return number
function LB_CustomFunctions:CountTableEntries(table)
    local f = 0
    for _, v in pairs(table) do
        f = f + 1
    end
    return f
end

---Synchronize two tables
---@param table1 table
---@param table2 table
---@return table
function LB_CustomFunctions:SyncTableEntries(table1, table2)
    local r = {}
    for k, v in pairs(table1) do
		if not LB_CustomFunctions:TableHasKey(table2, k) then
			r[k] = v
		end
	end
    return r
end

local _optionsTimer = nil;
---Create a delay
---@param time number
---@param func function
---@param message string
function LB_CustomFunctions:Delay(time, func, message)
    if (_optionsTimer) then
        LogBook:CancelTimer(_optionsTimer)
        _optionsTimer = nil;
    end
    _optionsTimer = LogBook:ScheduleTimer(function()
        func()
        if not message == nil and message ~= "" then
            LogBook:Print(message)
        end
    end, time)
end

---Get class icon
---@param classFilename string
---@return number icon_texture
function LB_CustomFunctions:GetClassIcon(classFilename)
    local iconTexture = {
        ["DEATHKNIGHT"] = 135771,
        ["DEMONHUNTER"] = 236415,
        ["DRUID"] = 625999,
        ["HUNTER"] = 626000,
        ["MAGE"] = 626001,
        ["MONK"] = 626002,
        ["PALADIN"] = 626003,
        ["PRIEST"] = 626004,
        ["ROGUE"] = 626005,
        ["SHAMAN"] = 626006,
        ["WARLOCK"] = 626007,
        ["WARRIOR"] = 626008,
        ["ALL"] = 136235
    }
    if iconTexture[classFilename] == nil then return 134400 end -- question mark
    return iconTexture[classFilename]
end

---Get class id from class filename
---@param classFilename string
---@return number classID
function LB_CustomFunctions:GetClassInfoByClassFilename(classFilename)
    if not classFilename then return 0 end
    local classIDs = {
        ["WARRIOR"] = 1,
        ["PALADIN"] = 2,
        ["HUNTER"] = 3,
        ["ROGUE"] = 4,
        ["PRIEST"] = 5,
        ["DEATHKNIGHT"] = 6,
        ["SHAMAN"] = 7,
        ["MAGE"] = 8,
        ["WARLOCK"] = 9,
        ["MONK"] = 10,
        ["DRUID"] = 11,
        ["DEMONHUNTER"] = 12,
        ["EVOKER"] = 13,
    }
    return classIDs[classFilename]
end

---Get class icon
---@param customIcon string
---@return number icon_texture
function LB_CustomFunctions:GetCustomIcon(customIcon)
    if not customIcon then return 0 end
    local iconTexture = {
        ["BOOK_1"] = 133742,
        ["BOOK_2"] = 133737,
        ["BOOK_3"] = 133738,
        ["BOOK_4"] = 133733,
        ["BOOK_5"] = 133740,
        ["PAGE_1"] = 134332,
    }
    return iconTexture[customIcon]
end

---Check if empty or nil
function LB_CustomFunctions:EmptyOrNil(value)
    if value == nil or value == "" then return true end
    return false
end