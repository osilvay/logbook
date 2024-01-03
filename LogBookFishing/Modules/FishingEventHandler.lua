---@class LBF_EventHandler
local LBF_EventHandler = LB_ModuleLoader:CreateModule("LBF_EventHandler")
local _LBF_EventHandler = {}

---@type LBF_Init
local LBF_Init = LB_ModuleLoader:ImportModule("LBF_Init")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

function LBF_EventHandler:StartFishingModuleEvents()
  _LBF_EventHandler:PlayerLogin()
end

function _LBF_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBookFishing.db or not LogBookFishingDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    LogBookFishing.db.global.data.characters[LogBookFishing.key] = true
    if LogBookFishing.db.global.characters[LogBookFishing.key] == nil then
      LogBookFishing.db.global.characters[LogBookFishing.key] = {
        fishing = {
        },
      }
    end
  end
  LBF_Init:Initialize()
end
