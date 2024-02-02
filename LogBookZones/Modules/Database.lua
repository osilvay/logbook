---@class LBZ_Database
local LBZ_Database = LB_ModuleLoader:CreateModule("LBZ_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---Table lenth
---@return table entries
function LBZ_Database:GetNumEntries()
  local zonesDb = LogBookZones.db.global.data.zones or {}
  local characters = LogBookZones.db.global.characters or {}
  local totalZones = 0
  local totalPaths = 0
  for _, character in pairs(characters) do
    local zones = character.zones or {}
    local paths = character.paths or {}
    totalZones = totalZones + LB_CustomFunctions:TableLength(zones)
    totalPaths = totalPaths + LB_CustomFunctions:TableLength(paths)
  end
  return {
    [LogBookZones:LBZ_i18n("Different zones")] = LB_CustomFunctions:TableLength(zonesDb),
    [LogBookZones:LBZ_i18n("Total zones")] = totalZones,
    [LogBookZones:LBZ_i18n("Overlay paths")] = totalPaths,
  }
end

---Build zones overlay
---@return table overlay
function LBZ_Database:BuildZonesOverlayData()
  local result = {}
  local paths = LogBookZones.db.global.data.zones or {}
  if LB_CustomFunctions:TableIsEmpty(paths) then return {} end
  for mapID, pathData in pairs(paths) do
    for coordinates, values in pairs(pathData) do
      for _, timestamp in pairs(pathData) do
        LogBook:Debug("timestamp = " .. tostring(timestamp))
      end
    end
  end
  return result
end
