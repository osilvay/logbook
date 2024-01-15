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
end

---Process combat log event unfiltered
function LBC_TrackCritics:ProcessCombatLogEventUnfiltered()
  --local timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, destName, _, _, spellID, _, _, amount, overkill, _, _, _, _, critical = CombatLogGetCurrentEventInfo()
  local timestamp, subEvent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

  -- common
  local spellID, spellName, spellSchool, amount, critical, absorbed, spellIcon

  -- damage
  local overkill, school, resisted, blocked, absorbed, glancing, crushing, isOffHand

  -- heal
  local overhealing

  if subEvent == nil then return end

  if subEvent == "SWING_DAMAGE" then
    amount = spellID
    spellName = LogBookCritics:LBC_i18n("Attack")
    spellIcon = 136235 -- default icon
    spellID = 6603     -- default spellID
  elseif subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "RANGE_DAMAGE" then
    spellID, spellName, spellSchool, amount, _, _, _, _, _, critical = select(12, CombatLogGetCurrentEventInfo())
  elseif subEvent == "SPELL_HEAL" or subEvent == "SPELL_PERIODIC_HEAL" then
    spellID, spellName, spellSchool, amount, overhealing, absorbed, critical = select(12, CombatLogGetCurrentEventInfo())
  end
  _, _, spellIcon = GetSpellInfo(spellID)

  --         timestamp 	subevent 	hideCaster 	sourceGUID 	sourceName 	sourceFlags 	sourceRaidFlags 	destGUID 	destName 	destFlags 	destRaidFlags
  --         spellId 	spellName 	spellSchool
  -- _DAMAGE amount 	overkill 	school 	resisted 	blocked 	absorbed 	critical 	glancing 	crushing 	isOffHand
  -- _HEAL 	 amount 	overhealing 	absorbed 	critical
  -- Check if the event is a player hit or a player heal and update the highest hits/heals data if needed.
  if amount == nil then amount = 0 end
  if sourceGUID == UnitGUID("player") and LB_CustomFunctions:TableHasValue(eventsToTrack, subEvent) and amount > 0 then
    --LogBook:Debug("Event type : " .. subEvent)
    --LogBook:Debug("Critical : " .. tostring(critical))
    if spellName then
      local spellData = LogBookCritics.db.global.data.spells[spellName] or {}
      local spellLink = ("|Hspell:" .. spellID .. "|h|r|cff71d5ff[" .. spellName .. "]|r|h");
      local class = LogBook.db.global.characters[LogBookCritics.key].info.classFilename

      spellData[spellName] = {
        spellName = spellName,
        spellID = spellID,
        spellLink = spellLink,
        spellIcon = spellIcon,
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
      if subEvent == "SPELL_HEAL" or subEvent == "SPELL_PERIODIC_HEAL" then
        LBC_TrackCritics:StoreNewHeal(spellName, amount, critical)
      elseif subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "SWING_DAMAGE" or subEvent == "RANGE_DAMAGE" then
        LBC_TrackCritics:StoreNewHit(spellName, amount, critical)
      end
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
        for _, v in pairs(spellData.class) do
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
  local critColor, normalColor, highestColor, lowestColor

  local spellLink = LogBookCritics.db.global.data.spells[spellName].spellLink
  local spellID = LogBookCritics.db.global.data.spells[spellName].spellID
  local _, _, icon = GetSpellInfo(spellID)
  local spellText = "|T" .. icon .. ":0|t " .. spellLink

  if spellName == LogBookCritics:LBC_i18n("Attack") then
    critColor = LB_CustomColors:CustomColors("ATTACK_CRITICAL")
    normalColor = LB_CustomColors:CustomColors("ATTACK_NORMAL")
    highestColor = LB_CustomColors:CustomColors("HIGHEST_ATTACK")
    lowestColor = LB_CustomColors:CustomColors("LOWEST_ATTACK")
  else
    critColor = LB_CustomColors:CustomColors("HIT_CRITICAL")
    normalColor = LB_CustomColors:CustomColors("HIT_NORMAL")
    highestColor = LB_CustomColors:CustomColors("HIGHEST_HIT")
    lowestColor = LB_CustomColors:CustomColors("LOWEST_HIT")
  end

  if critical then
    if LogBookCriticsData[spellName].highestHitCrit == 0 and LogBookCriticsData[spellName].lowestHitCrit == 0 then
      LB_CustomSounds:PlayCriticalHit()
      LogBookCriticsData[spellName].highestHitCrit = amount
      LogBookCriticsData[spellName].lowestHitCrit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r and |c%slowest|r critical hit:"), highestColor, lowestColor)
      local messageValue = string.format("|cffffffff%d|r", amount)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end

    if LogBookCriticsData[spellName].highestHitCrit == nil then LogBookCriticsData[spellName].highestHitCrit = 0 end
    if LogBookCriticsData[spellName].highestHitCrit == 0 or amount > LogBookCriticsData[spellName].highestHitCrit then
      LB_CustomSounds:PlayCriticalHit()
      LogBookCriticsData[spellName].highestHitCrit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r critical hit:"), highestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].highestHitCrit)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end

    if LogBookCriticsData[spellName].lowestHitCrit == nil then LogBookCriticsData[spellName].lowestHitCrit = 0 end
    if LogBookCriticsData[spellName].lowestHitCrit == 0 or amount < LogBookCriticsData[spellName].lowestHitCrit then
      LogBookCriticsData[spellName].lowestHitCrit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%slowest|r critical hit:"), lowestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].lowestHitCrit)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end
  else
    if LogBookCriticsData[spellName].highestHit == 0 and LogBookCriticsData[spellName].lowestHit == 0 then
      LB_CustomSounds:PlayCriticalHit()
      LogBookCriticsData[spellName].highestHit = amount
      LogBookCriticsData[spellName].lowestHit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r and |c%slowest|r normal hit:"), highestColor, lowestColor)
      local messageValue = string.format("|cffffffff%d|r", amount)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end

    if LogBookCriticsData[spellName].highestHit == nil then LogBookCriticsData[spellName].highestHit = 0 end
    if LogBookCriticsData[spellName].highestHit == 0 or amount > LogBookCriticsData[spellName].highestHit then
      LB_CustomSounds:PlayNormalHit()
      LogBookCriticsData[spellName].highestHit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r normal hit:"), highestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].highestHit)
      message = string.format("%s |c%s%s|r  %s ", spellText, normalColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end

    if LogBookCriticsData[spellName].lowestHit == nil then LogBookCriticsData[spellName].lowestHit = 0 end
    if LogBookCriticsData[spellName].lowestHit == 0 or amount < LogBookCriticsData[spellName].lowestHit then
      LogBookCriticsData[spellName].lowestHit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%slowest|r normal hit:"), lowestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].lowestHit)
      message = string.format("%s |c%s%s|r  %s ", spellText, normalColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end
  end
end

---Stores new spell hit
---@param amount number
---@param critical boolean
function LBC_TrackCritics:StoreNewHeal(spellName, amount, critical)
  LogBookCriticsData[spellName].isHeal = true
  local message = ""
  local critColor, normalColor, highestColor, lowestColor
  local spellLink = LogBookCritics.db.global.data.spells[spellName].spellLink
  local spellID = LogBookCritics.db.global.data.spells[spellName].spellID
  local _, _, icon = GetSpellInfo(spellID)
  local spellText = "|T" .. icon .. ":0|t " .. spellLink

  critColor = LB_CustomColors:CustomColors("HEAL_CRITICAL")
  normalColor = LB_CustomColors:CustomColors("HEAL_NORMAL")
  highestColor = LB_CustomColors:CustomColors("HIGHEST_HEAL")
  lowestColor = LB_CustomColors:CustomColors("LOWEST_HEAL")

  if critical then
    if LogBookCriticsData[spellName].highestHealCrit == 0 and LogBookCriticsData[spellName].lowestHealCrit == 0 then
      LB_CustomSounds:PlayCriticalHit()
      LogBookCriticsData[spellName].highestHealCrit = amount
      LogBookCriticsData[spellName].lowestHealCrit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r and |c%slowest|r critical heal:"), highestColor, lowestColor)
      local messageValue = string.format("|cffffffff%d|r", amount)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end

    if LogBookCriticsData[spellName].highestHealCrit == nil then LogBookCriticsData[spellName].highestHealCrit = 0 end
    if amount > LogBookCriticsData[spellName].highestHealCrit then
      LB_CustomSounds:PlayCriticalHeal()
      LogBookCriticsData[spellName].highestHealCrit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r critical heal:"), highestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].highestHealCrit)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
    end
    if LogBookCriticsData[spellName].lowestHealCrit == nil then LogBookCriticsData[spellName].lowestHealCrit = 0 end
    if LogBookCriticsData[spellName].lowestHealCrit == 0 or amount < LogBookCriticsData[spellName].lowestHealCrit then
      LogBookCriticsData[spellName].lowestHealCrit = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%slowest|r critical heal:"), lowestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].lowestHealCrit)
      message = string.format("%s |c%s%s|r  %s ", spellText, critColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
    end
  else
    if LogBookCriticsData[spellName].highestHeal == 0 and LogBookCriticsData[spellName].lowestHeal == 0 then
      LB_CustomSounds:PlayNormalHeal()
      LogBookCriticsData[spellName].highestHeal = amount
      LogBookCriticsData[spellName].lowestHeal = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r and |c%slowest|r normal heal:"), highestColor, lowestColor)
      local messageValue = string.format("|cffffffff%d|r", amount)
      message = string.format("%s |c%s%s|r  %s ", spellText, normalColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
      return
    end

    if LogBookCriticsData[spellName].highestHeal == nil then LogBookCriticsData[spellName].highestHeal = 0 end
    if amount > LogBookCriticsData[spellName].highestHeal then
      LB_CustomSounds:PlayNormalHeal()
      LogBookCriticsData[spellName].highestHeal = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%shighest|r normal heal:"), highestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].highestHeal)
      message = string.format("%s |c%s%s|r  %s ", spellText, normalColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
    end
    if LogBookCriticsData[spellName].lowestHeal == nil then LogBookCriticsData[spellName].lowestHeal = 0 end
    if LogBookCriticsData[spellName].lowestHeal == 0 or amount < LogBookCriticsData[spellName].lowestHeal then
      LogBookCriticsData[spellName].lowestHeal = amount
      local messageText = string.format(LogBookCritics:LBC_i18n("New |c%slowest|r normal heal:"), lowestColor)
      local messageValue = string.format("|cffffffff%d|r", LogBookCriticsData[spellName].lowestHeal)
      message = string.format("%s |c%s%s|r  %s ", spellText, normalColor, messageText, messageValue)
      LBC_TrackCritics:ShowMessage(message)
    end
  end
end

function LBC_TrackCritics:ShowMessage(message)
  if message == "" then return end
  LogBookCritics:Print(message)
  LBC_SplashCriticsWindow.AddMessageToQueue(message)
end
