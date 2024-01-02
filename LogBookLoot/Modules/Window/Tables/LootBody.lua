---@class LBL_LootBody
local LBL_LootBody = LB_ModuleLoader:CreateModule("LBL_LootBody")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local bodyContainer

---Redraw body container
---@param containerTable table
---@param parentFrame AceGUIFrame
function LBL_LootBody:RedrawLootWindowBody(containerTable, parentFrame)
	bodyContainer:ReleaseChildren()
	LBL_LootBody:ContainerBodyFrame(containerTable, parentFrame)
end

---Create Loot container body frame
function LBL_LootBody:ContainerBodyFrame(containerTable, parentFrame)
	if not bodyContainer then
		-- container
		---@type AceGUIInlineGroup
		bodyContainer = AceGUI:Create("InlineGroup")
		bodyContainer:SetFullWidth(true)
		bodyContainer:SetWidth(500)
		bodyContainer:SetHeight(240)
		bodyContainer:SetTitle(LogBookLoot:i18n("Loot list"))
		bodyContainer:SetLayout("Flow")
		bodyContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -180)
		parentFrame:AddChild(bodyContainer)
	end
end
