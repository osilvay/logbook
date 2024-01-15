---@class LBL_LootFilter
local LBL_LootFilter = LB_ModuleLoader:CreateModule("LBL_LootFilter")

---@type LBL_LootWindow
local LBL_LootWindow = LB_ModuleLoader:ImportModule("LBL_LootWindow")

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
function LBL_LootFilter:RedrawLootWindowFilter(parentFrame)
  filterContainer:ReleaseChildren()
  LBL_LootFilter:ContainerFilterFrame(parentFrame)
end

---Create loot fiter frame
---@param parentFrame AceGUIFrame
function LBL_LootFilter:ContainerFilterFrame(parentFrame)
  if not filterContainer then
    -- container
    ---@type AceGUIInlineGroup
    filterContainer = AceGUI:Create("InlineGroup")
    filterContainer:SetFullWidth(true)
    filterContainer:SetWidth(500)
    filterContainer:SetHeight(140)
    filterContainer:SetTitle(LogBookLoot:LBL_i18n("Filter"))
    filterContainer:SetLayout("Flow")
    filterContainer:SetPoint("TOPLEFT", parentFrame.frame, "TOPLEFT", 20, -40)
    parentFrame:AddChild(filterContainer)
  end
end

function LBL_LootFilter:RedrawCharactersDropdown()
  realmDropdown:SetValue("all")
end
