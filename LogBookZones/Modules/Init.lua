---@class LBZ_Init
local LBZ_Init = LB_ModuleLoader:CreateModule("LBZ_Init")

---@type LBZ_Track
local LBZ_Track = LB_ModuleLoader:ImportModule("LBZ_Track")

---@type LBZ_ZonesWindow
local LBZ_ZonesWindow = LB_ModuleLoader:ImportModule("LBZ_ZonesWindow")

-- called by the PLAYER_LOGIN event handler
function LBZ_Init:Initialize()
  LBZ_Track:Initialize()
  LBZ_ZonesWindow:Initialize()
end
