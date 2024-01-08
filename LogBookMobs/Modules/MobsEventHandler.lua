---@class LBM_EventHandler
local LBM_EventHandler = LB_ModuleLoader:CreateModule("LBM_EventHandler")
local _LBM_EventHandler = {}

---@type LBM_Init
local LBM_Init = LB_ModuleLoader:ImportModule("LBM_Init")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

function LBM_EventHandler:StartMobsModuleEvents()
  _LBM_EventHandler:PlayerLogin()
end

function _LBM_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBookMobs.db or not LogBookMobsDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    LogBookMobs.db.global.data.characters[LogBookMobs.key] = true
    if LogBookMobs.db.global.characters[LogBookMobs.key] == nil then
      LogBookMobs.db.global.characters[LogBookMobs.key] = {
        mobs = {
        },
      }
    end
  end
  LBM_Init:Initialize()
end
