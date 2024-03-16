---@class LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:CreateModule("LB_CustomFunctions")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomMedias
local LB_CustomMedias = LB_ModuleLoader:ImportModule("LB_CustomMedias")

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
---@param currentTable table
---@return number
function LB_CustomFunctions:CountTableEntries(currentTable)
  local f = 0
  for _, v in pairs(currentTable) do
    f = f + 1
  end
  return f
end

function LB_CustomFunctions:RemoveIndexFromTable(currentTable, currentIndex)
  local resultTable = {}
  --LogBook:Debug("Removing from table : " .. tostring(currentIndex))
  --LogBook:Dump(currentTable)
  for k, v in pairs(currentTable) do
    if k ~= currentIndex then
      table.insert(resultTable, k, v)
    end
  end
  --LogBook:Debug("Removed from table : " .. tostring(currentIndex))
  --LogBook:Dump(resultTable)
  return resultTable
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

---Convert number to short version
---@param num number
---@param numNax number
---@return string num
function LB_CustomFunctions:GetNumText(num, numNax)
  local factor = 1
  if numNax and numNax > 10000 then
    factor = 10
  end
  if num > 10000000 * factor then
    return string.format("%.fM", num / 1000000)
  end
  if num > 10000 * factor then
    return string.format("%.fK", num / 1000)
  end
  return tostring(num)
end

---Sort complex table by key
---@param tableToSort table
---@return table tableSorted
function LB_CustomFunctions:SortComplexTableByKey(tableToSort)
  local sortedRows = {}
  for k, _ in pairs(tableToSort) do
    table.insert(sortedRows, k)
  end
  table.sort(sortedRows, function(v1, v2) return v1 < v2 end)
  local newList = {}
  for _, v in pairs(sortedRows) do
    newList[v] = tableToSort[v]
  end
  return newList
end

---Sort multiple values
---@param tableToSort any
---@param ... table
function LB_CustomFunctions:SortMultipleValues(tableToSort, ...)
  local a = { ... }

  table.sort(tableToSort, function(u, v)
    local result = false
    for i = 1, #a do
      local j = a[i]
      local name = j.name
      local direction = j.direction
      if u[name] ~= v[name] then
        if direction == 'desc' then
          result = u[name] > v[name]
        else
          result = u[name] < v[name]
        end
        break
      end
    end
    return result
  end)
end

---Create table for a dropdown
---@param characters table
---@param withRealm boolean
---@param withFaction boolean
---@return table result
function LB_CustomFunctions:CreateCharacterDropdownList(characters, withRealm, withFaction)
  local r = {}
  for k, v in pairs(characters) do
    if LogBook.db.global.characters[k] ~= nil and v then
      local info = LogBook.db.global.characters[k].info
      if info then
        local realm = LB_CustomColors:GetColoredFaction(info.faction, info.factionName)
        local name = LB_CustomColors:GetColoredClass(info.name, info.classFilename)
        local faction_icon = LB_CustomMedias:GetMediaFileAsLink(info.factionName .. "_icon", 16, 16)

        local newKey = info.realm .. " - " .. info.name
        if not withRealm and not withFaction then
          r[newKey] = string.format("%s", name)
        elseif not withRealm and withFaction then
          r[newKey] = string.format("%s %s", faction_icon, name)
        elseif withRealm and not withFaction then
          r[newKey] = string.format("|cffa1a1c1%s|r - %s", info.realm, name)
        else
          r[newKey] = string.format("|cffa1a1c1%s|r - %s %s", info.realm, faction_icon, name)
        end
      end
    end
  end

  table.sort(r, function(v1, v2) return v1 < v2 end)
  return r
end

---Create table for a dropdown
---@param characters table
---@return table result
function LB_CustomFunctions:CreateRealmDropdownList(characters)
  local r = {}
  for k, _ in pairs(characters) do
    local info = LogBook.db.global.characters[k].info
    if info then
      r[info.realm] = string.format("|cffa1a1c1%s|r", info.realm)
    end
  end
  table.sort(r, function(v1, v2) return v1 < v2 end)
  return r
end

---@param newKey string
---@return string key
function LB_CustomFunctions:ConvertNewKeyToKey(newKey)
  local realm, character = newKey:match("(.*)-(.*)")
  return string.format('%s - %s', string.trim(character), string.trim(realm))
end

---@param key string
---@return string key
function LB_CustomFunctions:ConvertKeyToNewKey(key)
  local realm, character = key:match("(.*)-(.*)")
  return string.format('%s - %s', string.trim(realm), string.trim(character))
end

---Check boolean nil value
---@param value boolean
---@return boolean value
function LB_CustomFunctions:CheckNilBoolean(value)
  if value == nil then
    return false
  end
  return value
end

local addonStats = {}
local lastDate = GetServerTime()

---Update my memory usage
---@param addon string
---@return table result
function LB_CustomFunctions:UpdateMemoryUsageForAddon(addon)
  local addonList = {}
  table.insert(addonList, addon)
  local currentDate = GetServerTime()
  local diff = difftime(currentDate, lastDate)
  if diff > 60 * 15 or addonStats[addon] == nil then
    local result = LB_CustomFunctions:UpdateMemoryUsageFromList(addonList)
    addonStats[addon] = result[addon]
    return result[addon]
  else
    return addonStats[addon]
  end
end

--Update my memory usage
---@param addonList table
---@return table result
function LB_CustomFunctions:UpdateMemoryUsageForAddonList(addonList)
  local currentDate = GetServerTime()
  local diff = difftime(currentDate, lastDate)
  if diff > 60 * 15 or addonStats == {} then
    local result = LB_CustomFunctions:UpdateMemoryUsageFromList(addonList)
    addonStats = result
    return result
  else
    return addonStats
  end
end

local lastGarbageCollectorTime = 0
---Update memory usage
---@param addonList table
---@return table list
function LB_CustomFunctions:UpdateMemoryUsageFromList(addonList)
  local garbageCollectorTime = GetServerTime()
  local diff = difftime(garbageCollectorTime, lastGarbageCollectorTime)
  if diff > 60 * 15 then
    collectgarbage()
    UpdateAddOnMemoryUsage()
    lastGarbageCollectorTime = GetServerTime()
  end

  local memInKb = 0
  local totalMem = 0
  local result = {}

  for _, module in ipairs(addonList) do
    if C_AddOns.IsAddOnLoaded(module) then -- module is enabled
      memInKb = GetAddOnMemoryUsage(module)
      totalMem = totalMem + memInKb
      result[module] = {
        disabled = false,
        memInKb = tonumber(format("%.0f", memInKb)),
        memInMb = tonumber(format("%.2f", memInKb / 1024)),
        totalMemInKb = tonumber(format("%.0f", totalMem)),
        totalMemInMb = tonumber(format("%.2f", totalMem / 1024)),
      }
    else
      result[module] = {
        disabled = true,
        memInKb = 0,
        memInMb = 0,
        totalMemInKb = tonumber(format("%.0f", totalMem)),
        totalMemInMb = tonumber(format("%.2f", totalMem / 1024)),
      }
    end
  end
  return result
end

---Count table entries
---@param T table
---@return number count
function LB_CustomFunctions:TableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

---Count table entries
---@param T table
---@return boolean isEmpty
function LB_CustomFunctions:TableIsEmpty(T)
  local count = LB_CustomFunctions:TableLength(T) or 0
  if count == 0 then
    return true
  else
    return false
  end
end

---Count table entries
---@param keyNeeded string
---@return boolean pressed
function LB_CustomFunctions:IsKeyPressed(keyNeeded)
  if keyNeeded == "2_alt" then
    return IsAltKeyDown()
  elseif keyNeeded == "3_shift" then
    return IsShiftKeyDown()
  elseif keyNeeded == "4_control" then
    return IsControlKeyDown()
  elseif keyNeeded == "5_altShift" then
    return IsAltKeyDown() and IsShiftKeyDown()
  elseif keyNeeded == "6_altControl" then
    return IsAltKeyDown() and IsControlKeyDown()
  elseif keyNeeded == "7_altShiftControl" then
    return IsAltKeyDown() and IsShiftKeyDown() and IsControlKeyDown()
  elseif keyNeeded == "8_shiftControl" then
    return IsShiftKeyDown() and IsControlKeyDown()
  else
    return true
  end
end

---Split string
---@param text string
---@param pattern string
---@return table
function LB_CustomFunctions:SplitString(text, pattern)
  local outResults = {}
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find(text, pattern, theStart)

  while theSplitStart do
    table.insert(outResults, string.sub(text, theStart, theSplitStart - 1))
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find(text, pattern, theStart)
  end

  table.insert(outResults, string.sub(text, theStart))
  return outResults
end
