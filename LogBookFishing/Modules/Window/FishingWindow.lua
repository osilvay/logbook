---@class LBF_FishingWindow
local LBF_FishingWindow = LB_ModuleLoader:CreateModule("LBF_FishingWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBF_FishingHeader
local LBF_FishingHeader = LB_ModuleLoader:ImportModule("LBF_FishingHeader")

---@type LBF_FishingBody
local LBF_FishingBody = LB_ModuleLoader:ImportModule("LBF_FishingBody")

---@type LBF_FishingFilter
local LBF_FishingFilter = LB_ModuleLoader:ImportModule("LBF_FishingFilter")

-- Forward declaration
FishingWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LBF_FishingWindow:Initialize()
	if not FishingWindowFrame then
		LBF_FishingWindow:CreateFishingWindowTable()

		---@type AceGUIFrame, AceGUIFrame
		local fishingWindowFrame = AceGUI:Create("Frame");
		fishingWindowFrame:SetWidth(540)
		fishingWindowFrame:SetHeight(520)
		fishingWindowFrame:SetPoint("CENTER", 0, 0)
		fishingWindowFrame:SetLayout("Fill")
		fishingWindowFrame:SetTitle("|cffffffffLog|r|cff57b6ffBook|r |cffa27be0Fishing|r |cffc1c1c1v|r|cff9191a10.0.1|r")
		fishingWindowFrame:SetStatusText(LogBookFishing:i18n("LogBook fishing management window"))
		fishingWindowFrame:EnableResize(false)
		fishingWindowFrame:Hide()

		fishingWindowFrame:SetCallback("OnClose", function(widget)
			PlaySound(840)
		end)

		-- header
		LBF_FishingHeader:ContainerHeaderFrame(tableData, fishingWindowFrame)
		-- filter
		LBF_FishingFilter:ContainerFilterFrame(fishingWindowFrame)
		-- table
		LBF_FishingBody:ContainerBodyFrame(tableData, fishingWindowFrame)

		fishingWindowFrame:Hide()
		FishingWindowFrame = fishingWindowFrame;

		-- Add the frame as a global variable under the name `MyGlobalFrameName`
		_G["LogBookFishingWindowFrame"] = FishingWindowFrame.frame
		-- Register the global variable `MyGlobalFrameName` as a "special frame"
		-- so that it is closed when the escape key is pressed.
		table.insert(UISpecialFrames, "LogBookFishingWindowFrame")
	end
end

---Create fishing window table data
function LBF_FishingWindow:CreateFishingWindowTable()
	tableData = {
		table = {
			header = {
			},
			data = {
			}
		},
	}
end

---Hide fishing window frame
function LBF_FishingWindow:HideFishingWindowFrame()
	if FishingWindowFrame and FishingWindowFrame:IsShown() then
		FishingWindowFrame:Hide();
	end
end

---Open fishing window
function LBF_FishingWindow:OpenFishingWindowFrame()
	if not FishingWindowFrame then return end
	if not FishingWindowFrame:IsShown() then
		PlaySound(882)
		--LogBook:Debug("Show FishingWindow frame")
		FishingWindowFrame:Show()
		LBF_FishingWindow:RedrawFishingWindowFrame()
	else
		--LogBook:Debug("Hide FishingWindow frame")
		FishingWindowFrame:Hide()
	end
end

---Redraw fishing window frame
function LBF_FishingWindow:RedrawFishingWindowFrame()
	if not FishingWindowFrame then return end
	--LogBook:Debug("Redraw FishingWindowFrame frame")
	if FishingWindowFrame:IsShown() then
		LBF_FishingBody:RedrawFishingWindowBody(tableData, FishingWindowFrame)
	end
end
