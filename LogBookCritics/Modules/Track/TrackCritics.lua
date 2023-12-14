---@class LBC_TrackCritics
local LBC_TrackCritics = LB_ModuleLoader:CreateModule("LBC_TrackCritics")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:ImportModule("LB_CustomSounds")

---@type LBC_CriticsTooltip
local LBC_CriticsTooltip = LB_ModuleLoader:ImportModule("LBC_CriticsTooltip")

---@type LBC_SplashCriticsWindow
local LBC_SplashCriticsWindow = LB_ModuleLoader:ImportModule("LBC_SplashCriticsWindow")

LogBookCriticsData = {}
local eventsToTrack = {
  "SPELL_DAMAGE",
  "SPELL_PERIODIC_DAMAGE",
  "SWING_DAMAGE",
  "RANGE_DAMAGE",
  "SPELL_HEAL",
  "SPELL_PERIODIC_HEAL"
}

---initialize track crit
function LBC_TrackCritics:Initialize()
  -- tooltip hook
  hooksecurefunc(GameTooltip, "SetAction", LBC_CriticsTooltip.AddHighestHitsToTooltip)
  LogBookCriticsData = LBC_TrackCritics:GetPersonalSpells()
  LogBook:Info(LogBookCritics:i18n("Tracking critics initialized"))
end

---Process combat log event unfiltered
function LBC_TrackCritics:ProcessCombatLogEventUnfiltered()
  local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, amount, overkill, _, _, _, _, critical =
      CombatLogGetCurrentEventInfo()

  if not spellID then return end
  local spellName, spellIcon

  if eventType == nil then
    return
  end

  if eventType == "SWING_DAMAGE" then
    amount = spellID
    spellName = LogBookCritics:i18n("Attack")
    spellIcon = 136235 -- default icon
    spellID = 6603
  else
    spellName, _, spellIcon = GetSpellInfo(spellID)
  end

  -- Check if the event is a player hit or a player heal and update the highest hits/heals data if needed.
  if sourceGUID == UnitGUID("player") and LB_CustomFunctions:TableHasValue(eventsToTrack, eventType) and amount > 0 then
    --LogBook:Debug("Event type : " .. eventType)
    if spellName then
      local spellRank = GetSpellSubtext(spellID)
      if spellRank == nil then spellRank = "" end

      local spellData = LogBookCritics.db.global.data.spells[spellName] or {}
      local spellLink = ("|Hspell:" .. spellID .. "|h|r|cff71d5ff[" .. spellName .. "]|r|h");
      local class = LogBook.db.global.characters[LogBookCritics.key].info.classFilename

      spellData[spellName] = {
        spellName = spellName,
        spellID = spellID,
        spellLink = spellLink,
        spellIcon = spellIcon,
        spellRank = spellRank,
        class = { class }
      }
      LBC_TrackCritics:StoreGlobalSpellData(spellData[spellName])

      LogBookCriticsData[spellName] = LogBookCriticsData[spellName] or {
        spellName = spellName,
        spellID = spellID,
        lowestHitCrit = 0,
        lowestHit = 0,
        lowestHeal = 0,
        lowestHealCrit = 0,
        highestHitCrit = 0,
        highestHit = 0,
        highestHeal = 0,
        highestHealCrit = 0,
        isHeal = false,
        timestamp = timestamp
      }
      if critical == nil then critical = false end
      if amount == nil then amount = 0 end
      if eventType == "SPELL_HEAL" or eventType == "SPELL_PERIODIC_HEAL" then
        LBC_TrackCritics:StoreNewHeal(spellName, amount, critical)
      elseif eventType == "SPELL_DAMAGE" or eventType == "SPELL_PERIODIC_DAMAGE" or eventType == "SWING_DAMAGE" or eventType == "RANGE_DAMAGE" then
        LBC_TrackCritics:StoreNewHit(spellName, amount, critical)
      end
      LogBookCriticsData[spellName].spellRank = spellRank
      LBC_TrackCritics:StorePersonalSpellCritInfo(spellName, LogBookCriticsData[spellName])
    end
  end
end

---Store global spell data
---@param spellData table
function LBC_TrackCritics:StoreGlobalSpellData(spellData)
  if spellData then
    if spellData.spellID == 6603 then
      local savedSpell = LogBookCritics.db.global.data.spells[spellData.spellName]
      if savedSpell ~= nil then
        local savedClass = savedSpell.class
        for _, v in pairs(spellData.class)do
          if not LB_CustomFunctions:TableHasValue(savedClass, v) then
            table.insert(savedClass, v)
          end
        end
        spellData.class = savedClass
      end
    end
    LogBookCritics.db.global.data.spells[spellData.spellName] = spellData
  end
end

---Stores personal spell crit info
---@param spellName string
---@param spellCritInfo table
function LBC_TrackCritics:StorePersonalSpellCritInfo(spellName, spellCritInfo)
  if spellName and spellCritInfo then
    if LogBookCritics.db.global.characters[LogBookCritics.key].spells == nil then
      LogBookCritics.db.global.characters[LogBookCritics.key].spells = {} 
    end
    LogBookCritics.db.global.characters[LogBookCritics.key].spells[spellName] = spellCritInfo
  end
end

---Return spell crit data by spell name
---@param spellName string
---@return table spellCritInfo
function LBC_TrackCritics:GetSpellDataBySpellName(spellName)
  local spells = LogBookCritics.db.global.data.spells[spellName]
  if spells == nil then return {} end
  return spells
end

---Return all spell data by class
function LBC_TrackCritics:GetSpellData()
  local spells = LogBookCritics.db.global.data.spells
  if spells == nil then return {} end
  return spells
end

---Return all spell data by class
---@param class string
function LBC_TrackCritics:GetSpellDataByClass(class)
  local spells = LogBookCritics.db.global.data.spells[class]
  if spells == nil then return {} end
  return spells
end

---Return personal spell crit info by spell name
---@param spellName string
function LBC_TrackCritics:GetPersonalspellCritInfo(spellName)
  if spellName then
    local spells = LogBookCritics.db.global.characters[LogBookCritics.key].spells[spellName]
    if spells == nil then return {} end
    return spells
  end
end

---Return all personal spells
function LBC_TrackCritics:GetPersonalSpells()
  local spells = LogBookCritics.db.global.characters[LogBookCritics.key].spells
  if spells == nil then return {} end
  return spells
end

---Stores new spell hit
---@param amount number
---@param critical boolean
function LBC_TrackCritics:StoreNewHit(spellName, amount, critical)
  LogBookCriticsData[spellName].isHeal = false
  local message = ""
  local critColor = LB_CustomColors:CustomColors("HIT_CRITICAL")
  local color = LB_CustomColors:CustomColors("HIT_NORMAL")

  if spellName == LogBookCritics:i18n("Attack") then
    critColor = LB_CustomColors:CustomColors("ATTACK_CRITICAL")
    color = LB_CustomColors:CustomColors("ATTACK_NORMAL")
  end

  if critical then
    if LogBookCriticsData[spellName].highestHitCrit == nil then LogBookCriticsData[spellName].highestHitCrit = 0 end
    if LogBookCriticsData[spellName].highestHitCrit == 0 or amount > LogBookCriticsData[spellName].highestHitCrit then
      LB_CustomSounds:PlayCriticalHit()
      LogBookCriticsData[spellName].highestHitCrit = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFF40E040highest|r crit hit for %s :|r |cffffffff%d|"), critColor, spellName, LogBookCriticsData[spellName].highestHitCrit)
      LBC_TrackCritics:ShowMessage(message)
    end

    if LogBookCriticsData[spellName].lowestHitCrit == nil then LogBookCriticsData[spellName].lowestHitCrit = 0 end
    if LogBookCriticsData[spellName].lowestHitCrit == 0 or amount < LogBookCriticsData[spellName].lowestHitCrit then
      LogBookCriticsData[spellName].lowestHitCrit = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFFE04040lowest|r crit hit for %s :|r |cffffffff%d|"), critColor, spellName, LogBookCriticsData[spellName].lowestHitCrit)
      LBC_TrackCritics:ShowMessage(message)
    end
  else
    if LogBookCriticsData[spellName].highestHit == nil then LogBookCriticsData[spellName].highestHit = 0 end
    if LogBookCriticsData[spellName].highestHit == 0 or amount > LogBookCriticsData[spellName].highestHit then
      LB_CustomSounds:PlayNormalHit()
      LogBookCriticsData[spellName].highestHit = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFF40E040highest|r hit %s :|r |cffffffff%d|"), color, spellName, LogBookCriticsData[spellName].highestHit)
      LBC_TrackCritics:ShowMessage(message)
    end

    if LogBookCriticsData[spellName].lowestHit == nil then LogBookCriticsData[spellName].lowestHit = 0 end
    if LogBookCriticsData[spellName].lowestHit == 0 or amount < LogBookCriticsData[spellName].lowestHit then
      LogBookCriticsData[spellName].lowestHit = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFFE04040lowest|r hit %s :|r |cffffffff%d|"), color, spellName, LogBookCriticsData[spellName].lowestHit)
      LBC_TrackCritics:ShowMessage(message)
    end
  end
end

---Stores new spell hit
---@param amount number
---@param critical boolean
function LBC_TrackCritics:StoreNewHeal(spellName, amount, critical)
  LogBookCriticsData[spellName].isHeal = true
  local message = ""
  local critColor = LB_CustomColors:CustomColors("HEAL_CRITICAL")
  local color = LB_CustomColors:CustomColors("HEAL_NORMAL")
  if critical then
    if LogBookCriticsData[spellName].highestHealCrit == nil then LogBookCriticsData[spellName].highestHealCrit = 0 end
    if amount > LogBookCriticsData[spellName].highestHealCrit then
      LB_CustomSounds:PlayCriticalHeal()
      LogBookCriticsData[spellName].highestHealCrit = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFF40E040highest|r crit heal for %s :|r |cffffffff%d|"), critColor, spellName, LogBookCriticsData[spellName].highestHealCrit)
      LBC_TrackCritics:ShowMessage(message)
    end
    if LogBookCriticsData[spellName].lowestHealCrit == nil then LogBookCriticsData[spellName].lowestHealCrit = 0 end
    if LogBookCriticsData[spellName].lowestHealCrit == 0 or amount < LogBookCriticsData[spellName].lowestHealCrit then
      LogBookCriticsData[spellName].lowestHealCrit = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFFE04040lowest|r crit heal for %s :|r |cffffffff%d|"), critColor, spellName, LogBookCriticsData[spellName].lowestHealCrit)
      LBC_TrackCritics:ShowMessage(message)
    end
  else
    if LogBookCriticsData[spellName].highestHeal == nil then LogBookCriticsData[spellName].highestHeal = 0 end
    if amount > LogBookCriticsData[spellName].highestHeal then
      LB_CustomSounds:PlayNormalHeal()
      LogBookCriticsData[spellName].highestHeal = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFF40E040highest|r heal for %s :|r |cffffffff%d|"), color, spellName, LogBookCriticsData[spellName].highestHeal)
      LBC_TrackCritics:ShowMessage(message)
    end
    if LogBookCriticsData[spellName].lowestHeal == nil then LogBookCriticsData[spellName].lowestHeal = 0 end
    if LogBookCriticsData[spellName].lowestHeal == 0 or amount < LogBookCriticsData[spellName].lowestHeal then
      LogBookCriticsData[spellName].lowestHeal = amount
      message = string.format(LogBookCritics:i18n("|c%sNew |cFFE04040lowest|r heal for %s :|r |cffffffff%d|"), color, spellName, LogBookCriticsData[spellName].lowestHeal)
      LBC_TrackCritics:ShowMessage(message)
    end
  end
end

function LBC_TrackCritics:ShowMessage(message)
  if message == "" then return end
  LogBookCritics:Print(message)
  LBC_SplashCriticsWindow.ShowNewTextMessage(message)
end