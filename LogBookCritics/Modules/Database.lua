---@class LBC_Database
local LBC_Database = LB_ModuleLoader:CreateModule("LBC_Database")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---Table lenth
---@return table entries
function LBC_Database:GetNumEntries()
  local spellsDb = LogBookCritics.db.global.data.spells or {}
  local characters = LogBookCritics.db.global.characters or {}
  local totalSpells = 0
  for _, character in pairs(characters) do
    local characterSpells = character.spells or {}
    local numSpells = LB_CustomFunctions:TableLength(characterSpells)
    totalSpells = totalSpells + numSpells
  end

  return {
    [LogBookCritics:LBC_i18n("Total spells")] = LB_CustomFunctions:TableLength(spellsDb),
    [LogBookCritics:LBC_i18n("Saved values")] = totalSpells,
  }
end
