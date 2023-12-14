---@class LBC_CriticsTooltip
local LBC_CriticsTooltip = LB_ModuleLoader:CreateModule("LBC_CriticsTooltip")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

local GameTooltip = GameTooltip

---@type string
local hitLineLeft, hitCritLineLeft, healLineLeft, healCritLineLeft

function LBC_CriticsTooltip.AddHighestHitsToTooltip(self, slot)
  if (not slot) then return end

  hitLineLeft = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIT_NORMAL"),
    LogBookCritics:i18n("Hit: "))
  hitCritLineLeft = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIT_CRITICAL"),
    LogBookCritics:i18n("Hit crit.: "))

  healLineLeft = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HEAL_NORMAL"),
    LogBookCritics:i18n("Heal: "))
  healCritLineLeft = LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HEAL_CRITICAL"),
    LogBookCritics:i18n("Heal crit.: "))

  local actionType, id = GetActionInfo(slot)
  if actionType == "spell" then
    if id == nil then return end
    local spellName, _, _, castTime = GetSpellInfo(id)
    if LogBookCriticsData[spellName] then
      if LogBookCriticsData[spellName].isHeal then
        LBC_CriticsTooltip:PrintHealLines(spellName)
      else
        LBC_CriticsTooltip:PrintHitLines(spellName)
      end
      GameTooltip:Show()
    end
  end
end

---Format color values
---@param spellName string
function LBC_CriticsTooltip:PrintHitLines(spellName)
  local lowestHit = LogBookCriticsData[spellName].lowestHit
  local highestHit = LogBookCriticsData[spellName].highestHit
  local lowestHitCrit = LogBookCriticsData[spellName].lowestHitCrit
  local highestHitCrit = LogBookCriticsData[spellName].highestHitCrit

  local hitRight = string.format("%s / %s",
    LBC_CriticsTooltip:ValueColor(lowestHit, LB_CustomColors:CustomColors("LOWEST_COLOR")),
    LBC_CriticsTooltip:ValueColor(highestHit, LB_CustomColors:CustomColors("HIGHEST_COLOR")))
  local hitCritRight = string.format("%s / %s",
    LBC_CriticsTooltip:ValueColor(lowestHitCrit, LB_CustomColors:CustomColors("LOWEST_COLOR")),
    LBC_CriticsTooltip:ValueColor(highestHitCrit, LB_CustomColors:CustomColors("HIGHEST_COLOR")))

  GameTooltip:AddLine(" ")
  GameTooltip:AddDoubleLine(hitLineLeft, hitRight)
  GameTooltip:AddDoubleLine(hitCritLineLeft, hitCritRight)
end

---Format color values
---@param spellName string
function LBC_CriticsTooltip:PrintHealLines(spellName)
  local lowestHeal = LogBookCriticsData[spellName].lowestHeal
  local highestHeal = LogBookCriticsData[spellName].highestHeal
  local lowestHealCrit = LogBookCriticsData[spellName].lowestHealCrit
  local highestHealCrit = LogBookCriticsData[spellName].highestHealCrit

  local healRight = string.format("%s / %s",
    LBC_CriticsTooltip:ValueColor(lowestHeal, LB_CustomColors:CustomColors("LOWEST_COLOR")),
    LBC_CriticsTooltip:ValueColor(highestHeal, LB_CustomColors:CustomColors("HIGHEST_COLOR")))
  local healCritRight = string.format("%s / %s",
    LBC_CriticsTooltip:ValueColor(lowestHealCrit, LB_CustomColors:CustomColors("LOWEST_COLOR")),
    LBC_CriticsTooltip:ValueColor(highestHealCrit, LB_CustomColors:CustomColors("HIGHEST_COLOR")))

  GameTooltip:AddLine(" ")
  GameTooltip:AddDoubleLine(healLineLeft, healRight)
  GameTooltip:AddDoubleLine(healCritLineLeft, healCritRight)
end

---Format color values
---@param value number
---@param valueColor string
---@return string text
function LBC_CriticsTooltip:ValueColor(value, valueColor)
  local undefinedValue = string.format("|c%s???|r", LB_CustomColors:CustomColors("UNDEFINED_COLOR"))
  local zeroValue = string.format("|c%s0|r", LB_CustomColors:CustomColors("ZERO_COLOR"))
  if value == nil then
    return undefinedValue
  elseif value == 0 then
    return zeroValue
  else
    return string.format("|c%s%s|r", valueColor, value)
  end
end
