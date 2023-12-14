---@class LBC_SplashCriticsWindow
local LBC_SplashCriticsWindow = LB_ModuleLoader:CreateModule("LBC_SplashCriticsWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBC_CriticsHeader
local LBC_CriticsHeader = LB_ModuleLoader:ImportModule("LBC_CriticsHeader")

---@type LBC_CriticsBody
local LBC_CriticsBody = LB_ModuleLoader:ImportModule("LBC_CriticsBody")

---@type LBC_CriticsFilter
local LBC_CriticsFilter = LB_ModuleLoader:ImportModule("LBC_CriticsFilter")

-- Forward declaration
SplashCriticsWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local baseFrame
local currentText = ""
local fadeTicker
local fadeTickerDirection
local fadeTickerValue = 0
local fadeTickerStarted = false

---Initilize
function LBC_SplashCriticsWindow:CreateSplashCriticsWindow()
	baseFrame = CreateFrame("Frame", "LogBook_Critics_Window", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	baseFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
	baseFrame:SetFrameStrata("MEDIUM")
	baseFrame:SetFrameLevel(0)
	baseFrame:SetSize(400, 50)
	baseFrame:SetMovable(true)
	baseFrame:EnableMouse(true)

	baseFrame:SetScript("OnMouseDown", LBC_SplashCriticsWindow.OnDragStart)
	baseFrame:SetScript("OnMouseUp", LBC_SplashCriticsWindow.OnDragStop)
	baseFrame:SetScript("OnEnter", LBC_SplashCriticsWindow.Unfade)
	baseFrame:SetScript("OnLeave", LBC_SplashCriticsWindow.Fade)

	baseFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		edgeSize = 2,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	baseFrame:SetBackdropColor(0, 0, 0, 0)

	local text = baseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	text:SetPoint("CENTER", baseFrame, "CENTER")
	text:SetText(currentText)
	baseFrame.text = text

	return baseFrame
end

function LBC_SplashCriticsWindow.ShowNewTextMessage(message)
	if not baseFrame then
    baseFrame = LBC_SplashCriticsWindow:CreateSplashCriticsWindow()
  end
	baseFrame.text:SetText(message)
	baseFrame:Show()
  C_Timer.After(5, function() baseFrame:Hide() end)
end

function LBC_SplashCriticsWindow.Unfade()
	fadeTickerStarted = true
	fadeTickerDirection = true
	LBC_SplashCriticsWindow.Fader()
end

function LBC_SplashCriticsWindow.Fade()
	fadeTickerStarted = true
	fadeTickerDirection = false
	LBC_SplashCriticsWindow.Fader()
end

function LBC_SplashCriticsWindow.OnDragStart()
	baseFrame:StartMoving()
end

function LBC_SplashCriticsWindow.OnDragStop()
	baseFrame:StopMovingOrSizing()
end

function LBC_SplashCriticsWindow.Fader()
	if (not fadeTicker) and fadeTickerStarted then
		fadeTicker = C_Timer.NewTicker(0.01, function()
			if fadeTickerDirection then
				-- Un-Fade All
				if fadeTickerValue < 0.3 then
					fadeTickerValue = fadeTickerValue + 0.02
					baseFrame:SetBackdropColor(0, 0, 0, math.min(0.5, fadeTickerValue * 3.3))
				else
					fadeTicker:Cancel()
					fadeTicker = nil
				end
			else
				-- Fade All
				if fadeTickerValue >= 0 then
					fadeTickerValue = fadeTickerValue - 0.02

					if fadeTickerValue < 0 then
						fadeTickerValue = 0
						fadeTicker:Cancel()
						fadeTicker = nil
					end
					baseFrame:SetBackdropColor(0, 0, 0, math.min(0.5, fadeTickerValue * 3.3))
				else
					fadeTickerValue = 0
					fadeTicker:Cancel()
					fadeTicker = nil
				end
			end
		end)
	end
end
