---@class LBE_Init
local LBE_Init = LB_ModuleLoader:CreateModule("LBE_Init")

---@type LBE_Track
local LBE_Track = LB_ModuleLoader:ImportModule("LBE_Track")

---@type LBE_EnchantingWindow
local LBE_EnchantingWindow = LB_ModuleLoader:ImportModule("LBE_EnchantingWindow")

-- called by the PLAYER_LOGIN event handler
function LBE_Init:Initialize()
  LBE_Track:Initialize()
  LBE_EnchantingWindow:Initialize()
end
