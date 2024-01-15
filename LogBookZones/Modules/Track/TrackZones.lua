---@class LBZ_TrackZones
local LBZ_TrackZones = LB_ModuleLoader:CreateModule("LBZ_TrackZones")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:ImportModule("LB_CustomSounds")

local C_Map_GetBestMapForUnit = C_Map.GetBestMapForUnit
local C_Map_GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local UNKNOWN = UNKNOWN
local SANCTUARY_TERRITORY, ARENA, FRIENDLY, HOSTILE, CONTESTED_TERRITORY, COMBAT, AGGRO_WARNING_IN_INSTANCE = SANCTUARY_TERRITORY, ARENA, FRIENDLY, HOSTILE, CONTESTED_TERRITORY, COMBAT, AGGRO_WARNING_IN_INSTANCE

-- Process zone change
---@param printMessages boolean
function LBZ_TrackZones:ZoneChanged(printMessages)
  local currentZone = GetZoneText()
  local currentSubZone = GetSubZoneText()
  if currentSubZone == nil or currentSubZone == "" then currentSubZone = UNKNOWN end
  local mapID = C_Map_GetBestMapForUnit("player")
  local mapPos = mapID and C_Map_GetPlayerMapPosition(mapID, "player")

  local unitOnTaxi = UnitOnTaxi("player")
  local trackInFlight = LogBookZones.db.char.general.zones.trackInFlight
  if unitOnTaxi and not trackInFlight then return end
  if printMessages and LogBookZones.db.char.general.zones.showZoneMessagesInChat then
    LogBookZones:Print(string.format(LogBookZones:LBZ_i18n("Entering") .. " %s - %s", LBZ_TrackZones:GetZoneRecolored(false, currentZone), LBZ_TrackZones:GetZoneRecolored(false, currentSubZone or "")))
  end
  LBZ_TrackZones:SetNewZone(currentZone, currentSubZone)
end

ZoneTable = {}
CurrentZone = 0
---Sets new zone
---@param zoneName  string
function LBZ_TrackZones:SetNewZone(zoneName, currentSubZone)
  if not zoneName or zoneName == "" or zoneName == nil then return end
  -- find zone ID if zone is already known
  local name, id, zone

  for savedId, savedZone in pairs(ZoneTable) do
    if savedZone.name == zoneName then
      zone = savedZone
      break
    end
  end
  local mapID = C_Map.GetBestMapForUnit("player")
  if not mapID then mapID = 0 end
  local mapInfo = C_Map.GetMapInfo(mapID)
  if mapInfo == nil then return end
  local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
  if parentMapInfo == nil then return end

  local worldMapInfo = C_Map.GetMapInfo(parentMapInfo.parentMapID)
  if worldMapInfo == nil then return end

  zone = {
    mapID = mapID,
    world = worldMapInfo.name,
    continent = parentMapInfo.name,
    name = zoneName,
    reaction = LBZ_TrackZones:GetReactionZone(),
    subzone = currentSubZone
  }

  if zone ~= nil then
    LBZ_TrackZones:StoreZone(zone)
    LBZ_TrackZones:StorePersonalZone(zone)
  end
  CurrentZone = zone
end

---Get and Stores current location in DB
---@param zone  table
function LBZ_TrackZones:StoreZone(zone)
  if not LogBookZones.db.global.data.zones then
    LogBookZones.db.global.data.zones = {}
  end

  local zoneString = string.format("%s - %s", zone.continent, zone.name)
  local savedZones = LogBookZones.db.global.data.zones[zoneString]
  if savedZones == nil then
    savedZones = {
      subzones = {}
    }
  end
  local savedSubzones = savedZones.subzones
  if savedSubzones == nil then
    savedSubzones = {}
  end


  local currentSubzone = zone.subzone
  table.insert(savedSubzones, currentSubzone)
  zone.subzones = LB_CustomFunctions:RemoveDuplicationsInTable(savedSubzones)
  LogBookZones.db.global.data.zones[zoneString] = zone
end

local MapRects = {}
local TempVec2D = CreateVector2D(0, 0)
---Get current player position
---@param mapID number
---@return number x,number y
function LBZ_TrackZones:GetPlayerMapPosition(mapID)
  if mapID then
    TempVec2D.x, TempVec2D.y = UnitPosition('player')
    if not TempVec2D.x then return 0, 0 end
    local mapRect = MapRects[mapID]
    if not mapRect then
      local _, pos1 = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0))
      local _, pos2 = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1))
      if not pos1 or not pos2 then return 0, 0 end
      mapRect = { pos1, pos2 }
      mapRect[2]:Subtract(mapRect[1])
      MapRects[mapID] = mapRect
    end
    TempVec2D:Subtract(mapRect[1])
    return (tonumber(string.format("%.5f", TempVec2D.y / mapRect[2].y)) * 100),
        (tonumber(string.format("%.5f", TempVec2D.x / mapRect[2].x)) * 100)
  end
  return 0, 0
end

---Get zone color or recolored string
---@param color boolean
---@param text string
---@return table|string
function LBZ_TrackZones:GetZoneRecolored(color, text)
  local status = ""
  local statusText
  local r, g, b = 1, 1, 0
  local pvpType = GetZonePVPInfo()
  local inInstance, _ = IsInInstance()

  if (pvpType == "sanctuary") then
    status = SANCTUARY_TERRITORY
    r, g, b = 0.41, 0.8, 0.94
  elseif (pvpType == "arena") then
    status = ARENA
    r, g, b = 1, 0.1, 0.1
  elseif (pvpType == "friendly") then
    status = FRIENDLY
    r, g, b = 0.1, 1, 0.1
  elseif (pvpType == "hostile") then
    status = HOSTILE
    r, g, b = 1, 0.1, 0.1
  elseif (pvpType == "contested") then
    status = CONTESTED_TERRITORY
    r, g, b = 1, 0.7, 0.10
  elseif (pvpType == "combat") then
    status = COMBAT
    r, g, b = 1, 0.1, 0.1
  elseif inInstance then
    status = AGGRO_WARNING_IN_INSTANCE
    r, g, b = 1, 0.1, 0.1
  else
    status = CONTESTED_TERRITORY
  end

  statusText = format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, text)

  if color then
    return r, g, b
  else
    return statusText
  end
end

---Get reaction zone
function LBZ_TrackZones:GetReactionZone()
  local status = ""
  local pvpType = GetZonePVPInfo()
  local inInstance, _ = IsInInstance()

  if (pvpType == "sanctuary") then
    status = SANCTUARY_TERRITORY
  elseif (pvpType == "arena") then
    status = ARENA
  elseif (pvpType == "friendly") then
    status = FRIENDLY
  elseif (pvpType == "hostile") then
    status = HOSTILE
  elseif (pvpType == "contested") then
    status = CONTESTED_TERRITORY
  elseif (pvpType == "combat") then
    status = COMBAT
  elseif inInstance then
    status = AGGRO_WARNING_IN_INSTANCE
  else
    status = CONTESTED_TERRITORY
  end
  return status
end

---Get and Stores current location in DB
---@param zone  table
---@return table|nil zone
function LBZ_TrackZones:StorePersonalZone(zone)
  if zone == nil then return end
  local currentZones = LogBookZones.db.global.characters[LogBookZones.key]
  if currentZones.zones == nil then
    currentZones.zones = {}
  end

  local zoneString = string.format("%s - %s - %s", zone.continent, zone.name, zone.subzone)
  local zoneValue = 0
  if currentZones.zones[zoneString] ~= nil then
    zoneValue = currentZones.zones[zoneString]
  end
  zoneValue = zoneValue + 1
  LogBookZones.db.global.characters[LogBookZones.key].zones[zoneString] = zoneValue
end

---Get current personal zone
function LBZ_TrackZones:GetCurrentZone()
  local currentZone = GetZoneText()
  local currentSubZone = GetSubZoneText()
  if currentSubZone == nil or currentSubZone == "" then currentSubZone = UNKNOWN end
  local mapID = C_Map_GetBestMapForUnit("player")
  if not mapID then mapID = 0 end
  local mapInfo = C_Map.GetMapInfo(mapID)
  if mapInfo == nil then return end
  local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
  if parentMapInfo == nil then return end
  local worldMapInfo = C_Map.GetMapInfo(parentMapInfo.parentMapID)
  if worldMapInfo == nil then return end

  local zoneResult = {
    continent = parentMapInfo.name,
    name = currentZone,
  }
  return string.format("%s - %s", zoneResult.continent, zoneResult.name)
end

---Get current personal zone
function LBZ_TrackZones:GetCurrentPersonalZone()
  local currentZone = GetZoneText()
  local currentSubZone = GetSubZoneText()
  if currentSubZone == nil or currentSubZone == "" then currentSubZone = UNKNOWN end
  local mapID = C_Map_GetBestMapForUnit("player")
  local mapPos = mapID and C_Map_GetPlayerMapPosition(mapID, "player")
  if not mapID then mapID = 0 end
  local mapInfo = C_Map.GetMapInfo(mapID)
  if mapInfo == nil then return end
  local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
  if parentMapInfo == nil then return end

  local worldMapInfo = C_Map.GetMapInfo(parentMapInfo.parentMapID)
  if worldMapInfo == nil then return end

  local zoneResult = {
    continent = parentMapInfo.name,
    name = currentZone,
    subzone = currentSubZone,
  }
  return string.format("%s - %s - %s", zoneResult.continent, zoneResult.name, zoneResult.subzone)
end
