---@class LBE_EventHandler
local LBE_EventHandler = LB_ModuleLoader:CreateModule("LBE_EventHandler")
local _LBE_EventHandler = {}

---@type LBE_Init
local LBE_Init = LB_ModuleLoader:ImportModule("LBE_Init")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

function LBE_EventHandler:StartEnchantingModuleEvents()
  _LBE_EventHandler:PlayerLogin()
end

function _LBE_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBookEnchanting.db or not LogBookEnchantingDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    LogBookEnchanting.db.global.data.characters[LogBookEnchanting.key] = true
    if LogBookEnchanting.db.global.characters[LogBookEnchanting.key] == nil then
      LogBookEnchanting.db.global.characters[LogBookEnchanting.key] = {
        enchanting = {
        },
      }
    end
  end
  LBE_Init:Initialize()
end
