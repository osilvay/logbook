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
  local totals = 0
  for _, character in pairs(characters) do
    local data = character.zones or {}
    local parcial = LB_CustomFunctions:TableLength(data)
    totals = totals + parcial
  end
  return {
    [LogBookZones:LBZ_i18n("Total")] = LB_CustomFunctions:TableLength(zonesDb),
    [LogBookZones:LBZ_i18n("Saved values")] = totals,
  }
end
