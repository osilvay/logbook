---@class LB_CustomSounds
local LB_CustomSounds = LB_ModuleLoader:CreateModule("LB_CustomSounds")

local logBookSoundTable

---Play critical hit sound
function LB_CustomSounds:PlayCriticalHit()
    C_Timer.After(0.5, function()
        PlaySoundFile(LB_CustomSounds:GetSoundFile("HitCritDefault"), "Master")
    end)
end

---Play normal hit sound
function LB_CustomSounds:PlayNormalHit()
    C_Timer.After(0.5, function()
        PlaySoundFile(LB_CustomSounds:GetSoundFile("HitDefault"), "Master")
    end)
end

---Play critical heal sound
function LB_CustomSounds:PlayCriticalHeal()
    C_Timer.After(0.5, function()
        PlaySoundFile(LB_CustomSounds:GetSoundFile("HitCritDefault"), "Master")
    end)
end

---Play normal heal sound
function LB_CustomSounds:PlayNormalHeal()
    C_Timer.After(0.5, function()
        PlaySoundFile(LB_CustomSounds:GetSoundFile("HitDefault"), "Master")
    end)
end

---Return sound
---@param typeSelected string
---@return string file
function LB_CustomSounds:GetSoundFile(typeSelected)
    return logBookSoundTable[typeSelected]
end

--https://wowpedia.fandom.com/wiki/PlaySoundFile_macros
logBookSoundTable = {
    ["HitCritDefault"] = "Sound/Interface/LevelUp.ogg",
    ["HitDefault"]     = "Sound/Interface/AuctionWindowOpen.ogg",
    ["Window Close"]   = "Sound/Interface/AuctionWindowClose.ogg",
    ["Window Open"]    = "Sound/Interface/AuctionWindowOpen.ogg",
}