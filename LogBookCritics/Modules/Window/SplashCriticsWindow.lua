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

local showTextFrame
local messageQueue = {}
local processingQueue = false
local showingMessage = false

---Initilize
function LBC_SplashCriticsWindow:CreateSplashCriticsWindow()
	local xOffset = LogBookCritics.db.char.general.critics.splashFrameOffset.xOffset
	local yOffset = LogBookCritics.db.char.general.critics.splashFrameOffset.yOffset
	local bgColor = LogBookCritics.db.char.general.critics.textFrameBgColorAlpha

	baseFrame = CreateFrame("Frame", "LogBook_Critics_Window", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	baseFrame:SetPoint("CENTER", UIParent, "CENTER", xOffset, yOffset)
	baseFrame:SetFrameStrata("MEDIUM")
	baseFrame:SetFrameLevel(0)
	baseFrame:SetSize(400, 50)
	baseFrame:SetMovable(true)
	baseFrame:EnableMouse(true)

	baseFrame:SetScript("OnMouseDown", LBC_SplashCriticsWindow.OnDragStart)
	baseFrame:SetScript("OnMouseUp", LBC_SplashCriticsWindow.OnDragStop)
	baseFrame:SetScript("OnEnter", function()
		if not LogBookCritics.db.char.general.critics.unlockTextFrame then return end
		LBC_SplashCriticsWindow.Unfade()
	end)
	baseFrame:SetScript("OnLeave", function()
		if not LogBookCritics.db.char.general.critics.unlockTextFrame then return end
		LBC_SplashCriticsWindow.Fade()
	end)

	baseFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		edgeSize = 2,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	baseFrame:SetBackdropColor(0, 0, 0, bgColor)

	local text = baseFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	text:SetPoint("CENTER", baseFrame, "CENTER")
	text:SetText(currentText)
	baseFrame.text = text

	return baseFrame
end

function LBC_SplashCriticsWindow.AddMessageToQueue(message)
	
	table.insert(messageQueue, message)
	local numMessagesInQueue = LB_CustomFunctions:CountTableEntries(messageQueue)

	if numMessagesInQueue >= 1 and not processingQueue then
		--LogBook:Debug("Messages to process : " .. tostring(numMessagesInQueue))
		LBC_SplashCriticsWindow.ProcessMessageQueue()
	end
end

function LBC_SplashCriticsWindow.ProcessMessageQueue()
	processingQueue = true
	local numMessagesInQueue = LB_CustomFunctions:CountTableEntries(messageQueue)
	if numMessagesInQueue == 0 then return end

	showTextFrame = C_Timer.NewTicker(0.5, function()

		for currentIndex, currentMessage in pairs(messageQueue) do
			--LogBook:Debug("Current index = " .. tostring(currentIndex) .. " - " .. currentMessage)
			--LogBook:Debug("Messages in queue before: " .. tostring(numMessagesInQueue))
			--LogBook:Dump(messageQueue)
			if not showingMessage then
				--LogBookCritics:Print(currentMessage)
				LBC_SplashCriticsWindow.ShowNewTextMessage(currentMessage)
				messageQueue = LB_CustomFunctions:RemoveIndexFromTable(messageQueue, currentIndex)
				--LogBook:Debug("Messages in queue after: " .. tostring(numMessagesInQueue))
				--LogBook:Dump(messageQueue)
			end
			break
		end
		
		numMessagesInQueue = LB_CustomFunctions:CountTableEntries(messageQueue)
		--LogBook:Print(numMessagesInQueue)
		if numMessagesInQueue == 0 then
			if showTextFrame ~= nil then
				showTextFrame:Cancel()
			end
			showTextFrame = nil
		end
	end)



	processingQueue = false
end

function LBC_SplashCriticsWindow.ShowNewTextMessage(message)
	if not baseFrame then
		baseFrame = LBC_SplashCriticsWindow:CreateSplashCriticsWindow()
	end
	showingMessage = true
	baseFrame.text:SetText(message)
	baseFrame:Show()
	C_Timer.After(5, function()
		if LogBookCritics.db.char.general.critics.unlockTextFrame then
			baseFrame.text:SetText(LogBookCritics:i18n("Test message"))
			return
		end
		baseFrame:Hide()
		C_Timer.After(0.5, function()
			showingMessage = false
		end)
	end)
end

function LBC_SplashCriticsWindow.UnlockTextMessage(message)
	if not baseFrame then
		baseFrame = LBC_SplashCriticsWindow:CreateSplashCriticsWindow()
	end
	baseFrame.text:SetText(message)
	baseFrame:Show()
	LBC_SplashCriticsWindow.Fade()
end

function LBC_SplashCriticsWindow.LockTextMessage(message)
	if baseFrame then
		C_Timer.After(0.1, function() baseFrame:Hide() end)
	end
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
	local frameX = baseFrame:GetCenter()
	local xLeft, yTop, xRight, yBottom = baseFrame:GetLeft(), baseFrame:GetTop(), baseFrame:GetRight(), baseFrame:GetBottom()
	local xSize, ySize = baseFrame:GetSize()
	local screenWidth = GetScreenWidth()
	local xcreenHeight = GetScreenHeight()
	local xPositionFromCenter = -((screenWidth / 2) - xLeft) + (xSize / 2)
	local yPositionFromCenter = -((xcreenHeight / 2) - yTop) - (ySize / 2)
	LogBookCritics.db.char.general.critics.splashFrameOffset.xOffset = tonumber(string.format("%.1f", xPositionFromCenter))
	LogBookCritics.db.char.general.critics.splashFrameOffset.yOffset = tonumber(string.format("%.1f", yPositionFromCenter))
	baseFrame:StopMovingOrSizing()
end

function LBC_SplashCriticsWindow.Fader()
	if (not fadeTicker) and fadeTickerStarted then
		if LogBookCritics.db.char.general.critics.unlockTextFrame then
			fadeTickerValue = LogBookCritics.db.char.general.critics.textFrameBgColorAlpha
		end
		fadeTicker = C_Timer.NewTicker(0.01, function()
			if fadeTickerDirection then
				-- Un-Fade All
				local fadeTo = 0.3
				if fadeTickerValue < fadeTo then
					fadeTickerValue = fadeTickerValue + 0.02
					baseFrame:SetBackdropColor(0, 0, 0, math.min(0.5, fadeTickerValue * 3.3))
				else
					fadeTicker:Cancel()
					fadeTicker = nil
				end
			else
				-- Fade All
				local fadeTo = 0
				if LogBookCritics.db.char.general.critics.unlockTextFrame then
					fadeTo = LogBookCritics.db.char.general.critics.textFrameBgColorAlpha
				end
				if fadeTickerValue >= fadeTo then
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
