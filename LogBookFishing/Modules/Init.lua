---@class LBF_Init
local LBF_Init = LB_ModuleLoader:CreateModule("LBF_Init")

---@type LBF_Track
local LBF_Track = LB_ModuleLoader:ImportModule("LBF_Track")

---@type LBF_FishingWindow
local LBF_FishingWindow = LB_ModuleLoader:ImportModule("LBF_FishingWindow")

-- called by the PLAYER_LOGIN event handler
function LBF_Init:Initialize()
    LBF_Track:Initialize()
    LBF_FishingWindow:Initialize()
end
