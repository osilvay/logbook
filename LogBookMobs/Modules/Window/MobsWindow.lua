---@class LBM_MobsWindow
local LBM_MobsWindow = LB_ModuleLoader:CreateModule("LBM_MobsWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBM_MobsHeader
local LBM_MobsHeader = LB_ModuleLoader:ImportModule("LBM_MobsHeader")

---@type LBM_MobsBody
local LBM_MobsBody = LB_ModuleLoader:ImportModule("LBM_MobsBody")

---@type LBM_MobsFilter
local LBM_MobsFilter = LB_ModuleLoader:ImportModule("LBM_MobsFilter")

-- Forward declaration
MobsWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LBM_MobsWindow:Initialize()
	if not MobsWindowFrame then
		LBM_MobsWindow:CreateMobsWindowTable()

		---@type AceGUIFrame, AceGUIFrame
		local mobsWindowFrame = AceGUI:Create("Frame");
		mobsWindowFrame:SetWidth(540)
		mobsWindowFrame:SetHeight(520)
		mobsWindowFrame:SetPoint("CENTER", 0, 0)
		mobsWindowFrame:SetLayout("Fill")
		mobsWindowFrame:SetTitle("|cffffffffLog|r|cff57b6ffBook|r |cffe38d4fMobs|r |cffc1c1c1v|r|cff9191a10.0.1|r")
		mobsWindowFrame:SetStatusText(LogBookMobs:i18n("LogBook mobs management window"))
		mobsWindowFrame:EnableResize(false)
		mobsWindowFrame:Hide()

		mobsWindowFrame:SetCallback("OnClose", function(widget)
			PlaySound(840)
		end)

		-- header
		LBM_MobsHeader:ContainerHeaderFrame(tableData, mobsWindowFrame)
		-- filter
		LBM_MobsFilter:ContainerFilterFrame(mobsWindowFrame)
		-- table
		LBM_MobsBody:ContainerBodyFrame(tableData, mobsWindowFrame)

		mobsWindowFrame:Hide()
		MobsWindowFrame = mobsWindowFrame;

		-- Add the frame as a global variable under the name `MyGlobalFrameName`
		_G["LogBookMobsWindowFrame"] = MobsWindowFrame.frame
		-- Register the global variable `MyGlobalFrameName` as a "special frame"
		-- so that it is closed when the escape key is pressed.
		table.insert(UISpecialFrames, "LogBookMobsWindowFrame")
	end
end

---Create mobs window table data
function LBM_MobsWindow:CreateMobsWindowTable()
	tableData = {
		table = {
			header = {
			},
			data = {
			}
		},
	}
end

---Hide mobs window frame
function LBM_MobsWindow:HideMobsWindowFrame()
	if MobsWindowFrame and MobsWindowFrame:IsShown() then
		MobsWindowFrame:Hide();
	end
end

---Open mobs window
function LBM_MobsWindow:OpenMobsWindowFrame()
	if not MobsWindowFrame then return end
	if not MobsWindowFrame:IsShown() then
		PlaySound(882)
		--LogBook:Debug("Show MobsWindow frame")
		MobsWindowFrame:Show()
		LBM_MobsWindow:RedrawMobsWindowFrame()
	else
		--LogBook:Debug("Hide MobsWindow frame")
		MobsWindowFrame:Hide()
	end
end

---Redraw mobs window frame
function LBM_MobsWindow:RedrawMobsWindowFrame()
	if not MobsWindowFrame then return end
	--LogBook:Debug("Redraw MobsWindowFrame frame")
	if MobsWindowFrame:IsShown() then
		LBM_MobsBody:RedrawMobsWindowBody(tableData, MobsWindowFrame)
	end
end
