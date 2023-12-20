---@class LBC_EventHandler
local LBC_EventHandler = LB_ModuleLoader:CreateModule("LBC_EventHandler")
local _LBC_EventHandler = {}

---@type LBC_Init
local LBC_Init = LB_ModuleLoader:ImportModule("LBC_Init")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

function LBC_EventHandler:StartCriticsModuleEvents()
  _LBC_EventHandler:PlayerLogin()
end

function _LBC_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBookCritics.db or not LogBookCriticsDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    LogBookCritics.db.global.data.characters[LogBookCritics.key] = true
    if LogBookCritics.db.global.characters[LogBookCritics.key] == nil then
      LogBookCritics.db.global.characters[LogBookCritics.key] = {
        spells = {
        },
      }
    end
  end
  LBC_Init:Initialize()
end
