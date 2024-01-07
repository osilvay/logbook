---@class LB_WelcomeWindow
local LB_WelcomeWindow = LB_ModuleLoader:CreateModule("LB_WelcomeWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LB_WelcomeBody
local LB_WelcomeBody = LB_ModuleLoader:ImportModule("LB_WelcomeBody")

---@type LB_WelcomeHeader
local LB_WelcomeHeader = LB_ModuleLoader:ImportModule("LB_WelcomeHeader")

-- Forward declaration
WelcomeWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LB_WelcomeWindow:Initialize()
	if not WelcomeWindowFrame then
		LB_WelcomeWindow:CreateWelcomeWindowTable()

		---@type AceGUIFrame, AceGUIFrame
		local welcomeWindowFrame = AceGUI:Create("Frame");
		welcomeWindowFrame:SetWidth(515)
		welcomeWindowFrame:SetHeight(535)
		welcomeWindowFrame:SetPoint("CENTER", 0, 0)
		welcomeWindowFrame:SetLayout("Fill")
		welcomeWindowFrame:SetTitle("|cffffffffLog|r|cff57b6ffBook|r |cffc1c1c1v|r|cff9191a10.0.1|r")
		welcomeWindowFrame:SetStatusText(LogBook:i18n("LogBook welcome window"))
		welcomeWindowFrame:EnableResize(false)
		welcomeWindowFrame:Hide()

		welcomeWindowFrame:SetCallback("OnClose", function(widget)
			PlaySound(840) 
		end)

		-- header
		LB_WelcomeHeader:ContainerHeaderFrame(tableData, welcomeWindowFrame)

		-- table
		LB_WelcomeBody:ContainerBodyFrame(tableData, welcomeWindowFrame)

		welcomeWindowFrame:Hide()
		WelcomeWindowFrame = welcomeWindowFrame;

		-- Add the frame as a global variable under the name `MyGlobalFrameName`
		_G["LogBookWelcomeWindowFrame"] = WelcomeWindowFrame.frame
		-- Register the global variable `MyGlobalFrameName` as a "special frame"
		-- so that it is closed when the escape key is pressed.
		table.insert(UISpecialFrames, "LogBookWelcomeWindowFrame")
	end
end

---Create welcome window table data
function LB_WelcomeWindow:CreateWelcomeWindowTable()
	tableData = {
		table = {
			header = {
			},
			data = {
			}
		},
	}
end

---Hide crit window frame
function LB_WelcomeWindow:HideWelcomeWindowFrame()
	if WelcomeWindowFrame and WelcomeWindowFrame:IsShown() then
		WelcomeWindowFrame:Hide();
	end
end

---Open crit window
function LB_WelcomeWindow:OpenWelcomeWindowFrame()
	if not WelcomeWindowFrame then return end
	if not WelcomeWindowFrame:IsShown() then
		PlaySound(882)
		--LogBook:Debug("Show WelcomeWindow frame")
		WelcomeWindowFrame:Show()
		LB_WelcomeWindow:RedrawWelcomeWindowFrame()
	else
		--LogBook:Debug("Hide WelcomeWindow frame")
		WelcomeWindowFrame:Hide()
	end
end

---Redraw welcome window frame
function LB_WelcomeWindow:RedrawWelcomeWindowFrame()
	if not WelcomeWindowFrame then return end
	--LogBook:Debug("Redraw WelcomeWindowFrame frame")
	if WelcomeWindowFrame:IsShown() then
		LB_WelcomeBody:RedrawWelcomeWindowBody(tableData, WelcomeWindowFrame)
	end
end
