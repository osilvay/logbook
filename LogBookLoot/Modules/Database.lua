---@class LBL_Database
local LBL_Database = LB_ModuleLoader:CreateModule("LBL_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---Table lenth
---@return table entries
function LBL_Database:GetNumEntries()
  local lootDb = LogBookLoot.db.global.data.loot or {}
  local characters = LogBookLoot.db.global.characters or {}
  local totals = 0
  for _, character in pairs(characters) do
    local data = character.loot or {}
    local parcial = LB_CustomFunctions:TableLength(data)
    totals = totals + parcial
  end
  return {
    [LogBookLoot:LBL_i18n("Total")] = LB_CustomFunctions:TableLength(lootDb),
    [LogBookLoot:LBL_i18n("Saved values")] = totals,
  }
end
