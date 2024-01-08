---@class LBM_Init
local LBM_Init = LB_ModuleLoader:CreateModule("LBM_Init")

---@type LBM_Track
local LBM_Track = LB_ModuleLoader:ImportModule("LBM_Track")

---@type LBM_MobsWindow
local LBM_MobsWindow = LB_ModuleLoader:ImportModule("LBM_MobsWindow")

-- called by the PLAYER_LOGIN event handler
function LBM_Init:Initialize()
    LBM_Track:Initialize()
    LBM_MobsWindow:Initialize()
end
