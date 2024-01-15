---@class LBZ_ZonesBody
local LBZ_ZonesBody = LB_ModuleLoader:CreateModule("LBZ_ZonesBody")

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
function LBZ_ZonesBody:RedrawZonesWindowBody(containerTable, parentFrame)
  bodyContainer:ReleaseChildren()
  LBZ_ZonesBody:ContainerBodyFrame(containerTable, parentFrame)
end

---Create Zones container body frame
function LBZ_ZonesBody:ContainerBodyFrame(containerTable, parentFrame)
  if not bodyContainer then
    -- container
    ---@type AceGUIInlineGroup
    bodyContainer = AceGUI:Create("InlineGroup")
    bodyContainer:SetFullWidth(true)
    bodyContainer:SetWidth(500)
    bodyContainer:SetHeight(240)
    bodyContainer:SetTitle(LogBookZones:LBZ_i18n("Zones list"))
    bodyContainer:SetLayout("Flow")
    bodyContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -180)
    parentFrame:AddChild(bodyContainer)
  end
end
