---@class LBC_Init
local LBC_Init = LB_ModuleLoader:CreateModule("LBC_Init")

---@type LBC_Track
local LBC_Track = LB_ModuleLoader:ImportModule("LBC_Track")

---@type LBC_CriticsWindow
local LBC_CriticsWindow = LB_ModuleLoader:ImportModule("LBC_CriticsWindow")

---@type LBC_SplashCriticsWindow
local LBC_SplashCriticsWindow = LB_ModuleLoader:ImportModule("LBC_SplashCriticsWindow")

-- called by the PLAYER_LOGIN event handler
function LBC_Init:Initialize()
    LBC_Track:Initialize()
    LBC_CriticsWindow:Initialize()

    if LogBookCritics.db.char.general.critics.unlockTextFrame then
        LBC_SplashCriticsWindow.UnlockTextMessage(LogBookCritics:i18n("Test message"))
    end
end
