---@class LBE_Init
local LBE_Init = LB_ModuleLoader:CreateModule("LBE_Init")

---@type LBE_Track
local LBE_Track = LB_ModuleLoader:ImportModule("LBE_Track")

---@type LBE_EnchantingWindow
local LBE_EnchantingWindow = LB_ModuleLoader:ImportModule("LBE_EnchantingWindow")

---@type LBE_Database
local LBE_Database = LB_ModuleLoader:ImportModule("LBE_Database")

local updateDbTimeout

-- called by the PLAYER_LOGIN event handler
function LBE_Init:Initialize()
  LBE_Track:Initialize()
  LBE_EnchantingWindow:Initialize()
  LBE_Database:Initialize()
  if LogBookEnchanting.db.char.general.enchanting.autoUpdateDb then
    C_Timer.After(0.1, function()
      LBE_Database:StartAutoUpdateDatabase()
    end)
  end
end
