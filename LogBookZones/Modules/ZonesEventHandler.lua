---@class LBZ_EventHandler
local LBZ_EventHandler = LB_ModuleLoader:CreateModule("LBZ_EventHandler")
local _LBZ_EventHandler = {}

---@type LBZ_Init
local LBZ_Init = LB_ModuleLoader:ImportModule("LBZ_Init")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

function LBZ_EventHandler:StartZonesModuleEvents()
  _LBZ_EventHandler:PlayerLogin()
end

function _LBZ_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBookZones.db or not LogBookZonesDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    LogBookZones.db.global.data.characters[LogBookZones.key] = true
    if LogBookZones.db.global.characters[LogBookZones.key] == nil then
      LogBookZones.db.global.characters[LogBookZones.key] = {
        zones = {
        },
      }
    end
  end
  LBZ_Init:Initialize()
end
