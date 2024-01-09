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

---initialize track crit
function LBM_TrackMobs:Initialize()
  -- tooltip hook
end

Target = {}
LastTargetIdx = nil

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
    --Bitacora:Debug("Storing mobDetails : " .. target.mobIndex)
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
  --Bitacora:Debug("Searching mob = " .. mobIndex)
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
    --Bitacora:Debug("Storing mobDetails : ")
    --Bitacora:Dump(mobDetails)
    LogBookMobs.db.global.data.mobs[mobDetails.mobIndex] = mobDetails
  end
end
