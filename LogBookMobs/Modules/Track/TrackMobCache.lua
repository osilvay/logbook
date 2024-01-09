---@class LBM_TrackMobCache
local LBM_TrackMobCache = LB_ModuleLoader:CreateModule("LBM_TrackMobCache")

MobCacheIndex = 1
MaxMobCache = 25
MobCache = {}

---Initialize cache
function LBM_TrackMobCache:Initialize()
  Bitacora:Info("Initializing track cache")
end

---Add mob to cache
---@param mobIndex string
---@param mobData table
function LBM_TrackMobCache:AddMobToCache(mobIndex, mobData)
  if mobIndex and mobData then
    --Bitacora:Debug("Adding to cache " .. mobIndex)
    MobCache[mobIndex] = mobData
    MobCacheIndex = MobCacheIndex + 1
    if MobCacheIndex > MaxMobCache then
      MobCacheIndex = 1
    end
    LogBookMobs.db.global.cache.mobs = MobCache
  end
end

---Add mob to cache
---@param mobIndex string
---@return table mobInfo
function LBM_TrackMobCache:GetMobFromCache(mobIndex)
  if mobIndex and MobCache[mobIndex] ~= nil then
    local mobInfo = MobCache[mobIndex]
    if mobInfo then
      return mobInfo
    end
  end
  return {}
end

---Clear mob cache
function LBM_TrackMobCache:ClearMobCache()
  MobCache = {}
  MobCacheIndex = 1
end
