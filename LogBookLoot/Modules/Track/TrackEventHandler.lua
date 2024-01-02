---@class LBL_TrackEventHandler
local LBL_TrackEventHandler = LB_ModuleLoader:CreateModule("LBL_TrackEventHandler")
local _LBL_TrackEventHandler = {}

---@type LBL_TrackLoot
local LBL_TrackLoot = LB_ModuleLoader:ImportModule("LBL_TrackLoot")

function LBL_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookLoot:i18n("Initializing track events..."))
end
