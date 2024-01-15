---@class LBF_FishingFilter
local LBF_FishingFilter = LB_ModuleLoader:CreateModule("LBF_FishingFilter")

---@type LBF_FishingWindow
local LBF_FishingWindow = LB_ModuleLoader:ImportModule("LBF_FishingWindow")

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
function LBF_FishingFilter:RedrawFishingWindowFilter(parentFrame)
  filterContainer:ReleaseChildren()
  LBF_FishingFilter:ContainerFilterFrame(parentFrame)
end

---Create loot fiter frame
---@param parentFrame AceGUIFrame
function LBF_FishingFilter:ContainerFilterFrame(parentFrame)
  if not filterContainer then
    -- container
    ---@type AceGUIInlineGroup
    filterContainer = AceGUI:Create("InlineGroup")
    filterContainer:SetFullWidth(true)
    filterContainer:SetWidth(500)
    filterContainer:SetHeight(140)
    filterContainer:SetTitle(LogBookFishing:LBF_i18n("Filter"))
    filterContainer:SetLayout("Flow")
    filterContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -40)
    parentFrame:AddChild(filterContainer)
  end
end

function LBF_FishingFilter:RedrawCharactersDropdown()
end
