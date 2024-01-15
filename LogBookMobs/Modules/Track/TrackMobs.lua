---@class LBM_TrackMobs
local LBM_TrackMobs = LB_ModuleLoader:CreateModule("LBM_TrackMobs")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:ImportModule("LB_CustomSounds")

---@type LBM_TrackMobCache
local LBM_TrackMobCache = LB_ModuleLoader:ImportModule("LBM_TrackMobCache")

Target = {}
LastTargetIdx = nil

local lastExp, currentExp, maxExp
local lastRestedExp, currentRestedExp
local lastLevel, currentLevel

function LBM_TrackMobs:Initialize()
  maxExp = UnitXPMax("player")
  currentExp = UnitXP("player")
  lastExp = UnitXP("player")
  currentRestedExp = GetXPExhaustion()
  lastRestedExp = GetXPExhaustion()
  lastLevel = UnitLevel("player")
  currentLevel = UnitLevel("player")
  LBM_TrackMobs.StoreExperience()
end

---Process target changed event
function LBM_TrackMobs:ProcessPlayerTargetChanged()
  local name = UnitName("target")
  local level = UnitLevel("target")
  if name and level then
    Target = { name = name, level = level }
    if UnitIsPlayer("target") or UnitIsDeadOrGhost("target") then
      return
    else
      Target.mobIndex = name .. ":" .. level
      Target.mobGUID = UnitGUID("target")
      local mobData = LBM_TrackMobCache:GetMobFromCache(Target.mobGUID)
      if next(mobData) == nil then
        mobData = LBM_TrackMobs:GetUnitMobData("target")
      end
      Target.mobData = mobData

      if Target.mobGUID then
        LBM_TrackMobCache:AddMobToCache(Target.mobGUID, mobData)
      end
      LBM_TrackMobs:StoreMobDetailsFromTarget(Target)
    end
    LastTargetIdx = Target.mobIndex
  else
    Target = {}
  end
end

---Get unit data
---@param unitId string
---@return table zoneEntry
function LBM_TrackMobs:GetUnitMobData(unitId)
  local mobData = {}
  if unitId == nil or not unitId then
    mobData.healthText = "0/" .. (mobData.healthMax or "???")
  else
    mobData.healthMax = UnitHealthMax(unitId)
    mobData.healthCur = UnitHealth(unitId)
    mobData.manaCur = UnitPower(unitId)
    mobData.manaMax = UnitPowerMax(unitId)
    --LogBook:Dump(mobData)
    mobData.healthText = LB_CustomFunctions:GetNumText(mobData.healthCur, mobData.healthMax) .. "/" .. LB_CustomFunctions:GetNumText(mobData.healthMax, 0)
    if mobData.manaMax > 0 then
      mobData.manaText = mobData.manaCur .. "/" .. mobData.manaMax
    else
      mobData.manaText = "-/-"
    end
    --LogBook:Debug(mobData.healthText)
    --LogBook:Debug(mobData.manaText)

    local mobType = UnitClassification(unitId)
    mobData.mobQuality = mobType
    if mobType == "rare" then
      mobData.mobType = 2
    elseif mobType == "worldboss" then
      mobData.mobType = 3
    elseif mobType == "elite" then
      mobData.mobType = 4
    elseif mobType == "rareelite" then
      mobData.mobType = 6
    else
      mobData.mobType = 1
    end
  end
  return mobData
end

---Stores mob data from target
---@param target table
function LBM_TrackMobs:StoreMobDetailsFromTarget(target)
  if target then
    --LogBook:Debug("Storing mobDetails : " .. target.mobIndex)
    -- corrections to mobData
    local savedMob = LogBookMobs.db.global.data.mobs[target.mobIndex]
    if savedMob then
      local savedMobData = savedMob.mobData or {
        healthMax = 0,
        manaMax = 0,
      }
      local mobData = target.mobData or {
        mobType = 0,
        healthMax = 0,
        manaMax = 0,
      }
      local maxHealth = math.max(savedMobData.healthMax or 0, mobData.healthMax or 0)
      local minHealth = math.min(savedMobData.healthMax or 0, mobData.healthMax or 0)
      local maxMana = math.max(savedMobData.manaMax or 0, mobData.manaMax or 0)
      local minMana = math.min(savedMobData.manaMax or 0, mobData.manaMax or 0)
      local newMobData = {
        mobType = mobData.mobType,
        mobQuality = mobData.mobQuality,
        minHealth = minHealth,
        maxHealth = maxHealth,
        minMana = minMana,
        maxMana = maxMana,
      }
      target.minExp = savedMob.minExp or 0
      target.maxExp = savedMob.maxExp or 0
      target.mobData = newMobData
    end
    LogBookMobs.db.global.data.mobs[target.mobIndex] = target
  end
end

---Stores mob data
---@param mobGUID string
---@return table r
function LBM_TrackMobs:GetMobDetailsByGUID(mobGUID)
  local r = {}
  for mobIndex, mobDetails in pairs(LogBookMobs.db.global.data.mobs) do
    if mobDetails.mobGUID == mobGUID then
      r = mobDetails
      break
    end
  end
  return r
end

---Get mob data from mobIndex
---@param mobIndex string
---@return table r
function LBM_TrackMobs:GetMobDetailsByMobIndex(mobIndex)
  local r = {}
  --LogBook:Debug("Searching mob = " .. mobIndex)
  for k, mobDetails in pairs(LogBookMobs.db.global.data.mobs) do
    if mobDetails.mobIndex == mobIndex then
      r = mobDetails
      break
    end
  end
  return r
end

---Stores mob data
---@param mobDetails table
function LBM_TrackMobs:StoreMobDetails(mobDetails)
  if mobDetails then
    --LogBook:Debug("Storing mobDetails : ")
    --LogBook:Dump(mobDetails)
    LogBookMobs.db.global.data.mobs[mobDetails.mobIndex] = mobDetails
  end
end

---Process combat log for xp
function LBM_TrackMobs:ProcessCombatLogEventUnfiltered()
  local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, amount, overkill, _, _, _, _, critical =
      CombatLogGetCurrentEventInfo()

  if not spellID then return end
  if eventType == nil then
    return
  end
  if eventType == "PARTY_KILL" then
    C_Timer.After(0.2, LBM_TrackMobs.StoreExperience)
    return
  end
end

---Stores experience mob
function LBM_TrackMobs.StoreExperience()
  currentExp = UnitXP("player")
  currentRestedExp = GetXPExhaustion()
  currentLevel = UnitLevel("player")

  if lastLevel < currentLevel then
    return
  end
  local diffExp = (currentExp - lastExp)
  if lastRestedExp == nil then lastRestedExp = 0 end
  if currentRestedExp == nil then currentRestedExp = 0 end
  local diffRestedExp = (lastRestedExp - currentRestedExp)
  if diffExp ~= 0 then
    --LogBook:Debug("mobIndex = " .. LastTargetIdx)
    --LogBook:Debug(string.format(" lastExp = %d, currentExp = %d, maxExp = %d", lastExp, currentExp, maxExp))
    --LogBook:Debug(string.format(" lastRestedExp = %d, currentRestedExp = %d", lastRestedExp, currentRestedExp))
    --LogBook:Debug(string.format(" XP gained = %d", diffExp))

    -- Update mob experience
    if LastTargetIdx ~= nil then
      local mobDetails = LBM_TrackMobs:GetMobDetailsByMobIndex(LastTargetIdx)
      if mobDetails then
        local currentMinExp = mobDetails.minExp or 0
        local currentMaxExp = mobDetails.maxExp or 0
        if diffExp < currentMinExp or currentMinExp == 0 then currentMinExp = diffExp end
        if diffExp > currentMaxExp or currentMaxExp == 0 then currentMaxExp = diffExp end
        mobDetails.minExp = currentMinExp
        mobDetails.maxExp = currentMaxExp
        --LogBook:Dump(mobDetails)
      end
      LBM_TrackMobs:StoreMobDetails(mobDetails)
    end
  end
  lastExp = currentExp
end
