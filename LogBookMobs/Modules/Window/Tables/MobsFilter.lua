---@class LBM_MobsFilter
local LBM_MobsFilter = LB_ModuleLoader:CreateModule("LBM_MobsFilter")

---@type LBM_MobsWindow
local LBM_MobsWindow = LB_ModuleLoader:ImportModule("LBM_MobsWindow")

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
function LBM_MobsFilter:RedrawMobsWindowFilter(parentFrame)
  filterContainer:ReleaseChildren()
  LBM_MobsFilter:ContainerFilterFrame(parentFrame)
end

---Create mobs fiter frame
---@param parentFrame AceGUIFrame
function LBM_MobsFilter:ContainerFilterFrame(parentFrame)
  if not filterContainer then
    -- container
    ---@type AceGUIInlineGroup
    filterContainer = AceGUI:Create("InlineGroup")
    filterContainer:SetFullWidth(true)
    filterContainer:SetWidth(500)
    filterContainer:SetHeight(140)
    filterContainer:SetTitle(LogBookMobs:LBM_i18n("Filter"))
    filterContainer:SetLayout("Flow")
    filterContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -40)
    parentFrame:AddChild(filterContainer)
  end
end

function LBM_MobsFilter:RedrawCharactersDropdown()
  realmDropdown:SetValue("all")
end
