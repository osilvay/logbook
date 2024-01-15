---@class LBE_EnchantingFilter
local LBE_EnchantingFilter = LB_ModuleLoader:CreateModule("LBE_EnchantingFilter")

---@type LBE_EnchantingWindow
local LBE_EnchantingWindow = LB_ModuleLoader:ImportModule("LBE_EnchantingWindow")

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
function LBE_EnchantingFilter:RedrawEnchantingWindowFilter(parentFrame)
  filterContainer:ReleaseChildren()
  LBE_EnchantingFilter:ContainerFilterFrame(parentFrame)
end

---Create loot fiter frame
---@param parentFrame AceGUIFrame
function LBE_EnchantingFilter:ContainerFilterFrame(parentFrame)
  if not filterContainer then
    -- container
    ---@type AceGUIInlineGroup
    filterContainer = AceGUI:Create("InlineGroup")
    filterContainer:SetFullWidth(true)
    filterContainer:SetWidth(500)
    filterContainer:SetHeight(140)
    filterContainer:SetTitle(LogBookEnchanting:i18n("Filter"))
    filterContainer:SetLayout("Flow")
    filterContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -40)
    parentFrame:AddChild(filterContainer)
  end
end

function LBE_EnchantingFilter:RedrawCharactersDropdown()
end
