---@class LBF_Database
local LBF_Database = LB_ModuleLoader:CreateModule("LBF_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---Table lenth
---@return table entries
function LBF_Database:GetNumEntries()
  local fishingDb = LogBookLoot.db.global.data.fishing or {}
  local characters = LogBookLoot.db.global.characters or {}
  local totals = 0
  for _, character in pairs(characters) do
    local data = character.fishing or {}
    local parcial = LB_CustomFunctions:TableLength(data)
    totals = totals + parcial
  end
  return {
    [LogBookFishing:LBF_i18n("Total")] = LB_CustomFunctions:TableLength(fishingDb),
    [LogBookFishing:LBF_i18n("Saved values")] = totals,
  }
end
