---@class LBM_Database
local LBM_Database = LB_ModuleLoader:CreateModule("LBM_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---Table lenth
---@return table entries
function LBM_Database:GetNumEntries()
  local mobsDb = LogBookMobs.db.global.data.mobs or {}
  local characters = LogBookMobs.db.global.characters or {}
  local totals = 0
  for _, character in pairs(characters) do
    local data = character.mobs or {}
    local parcial = LB_CustomFunctions:TableLength(data)
    totals = totals + parcial
  end
  return {
    [LogBookMobs:LBM_i18n("Total")] = LB_CustomFunctions:TableLength(mobsDb),
    [LogBookMobs:LBM_i18n("Saved values")] = totals,
  }
end
