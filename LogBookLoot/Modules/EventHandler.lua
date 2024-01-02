---@class LBL_EventHandler
local LBL_EventHandler = LB_ModuleLoader:CreateModule("LBL_EventHandler")
local _LBL_EventHandler = {}

---@type LBL_Init
local LBL_Init = LB_ModuleLoader:ImportModule("LBL_Init")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

function LBL_EventHandler:StartLootModuleEvents()
  _LBL_EventHandler:PlayerLogin()
end

function _LBL_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBookLoot.db or not LogBookLootDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    LogBookLoot.db.global.data.characters[LogBookLoot.key] = true
    if LogBookLoot.db.global.characters[LogBookLoot.key] == nil then
      LogBookLoot.db.global.characters[LogBookLoot.key] = {
        spells = {
        },
      }
    end
  end
  LBL_Init:Initialize()
end
