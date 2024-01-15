---@class LBZ_ZonesFilter
local LBZ_ZonesFilter = LB_ModuleLoader:CreateModule("LBZ_ZonesFilter")

---@type LBZ_ZonesWindow
local LBZ_ZonesWindow = LB_ModuleLoader:ImportModule("LBZ_ZonesWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local filterContainer

---Redraw body container
---@param parentFrame AceGUIFrame
function LBZ_ZonesFilter:RedrawZonesWindowFilter(parentFrame)
  filterContainer:ReleaseChildren()
  LBZ_ZonesFilter:ContainerFilterFrame(parentFrame)
end

---Create loot fiter frame
---@param parentFrame AceGUIFrame
function LBZ_ZonesFilter:ContainerFilterFrame(parentFrame)
  if not filterContainer then
    -- container
    ---@type AceGUIInlineGroup
    filterContainer = AceGUI:Create("InlineGroup")
    filterContainer:SetFullWidth(true)
    filterContainer:SetWidth(500)
    filterContainer:SetHeight(140)
    filterContainer:SetTitle(LogBookZones:LBZ_i18n("Filter"))
    filterContainer:SetLayout("Flow")
    filterContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -40)
    parentFrame:AddChild(filterContainer)
  end
end

function LBZ_ZonesFilter:RedrawCharactersDropdown()
  realmDropdown:SetValue("all")
end
