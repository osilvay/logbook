---@class LBL_LootWindow
local LBL_LootWindow = LB_ModuleLoader:CreateModule("LBL_LootWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBL_LootHeader
local LBL_LootHeader = LB_ModuleLoader:ImportModule("LBL_LootHeader")

---@type LBL_LootBody
local LBL_LootBody = LB_ModuleLoader:ImportModule("LBL_LootBody")

---@type LBL_LootFilter
local LBL_LootFilter = LB_ModuleLoader:ImportModule("LBL_LootFilter")

-- Forward declaration
LootWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LBL_LootWindow:Initialize()
  if not LootWindowFrame then
    LBL_LootWindow:CreateLootWindowTable()

    ---@type AceGUIFrame, AceGUIFrame
    local lootWindowFrame = AceGUI:Create("Frame");
    lootWindowFrame:SetWidth(540)
    lootWindowFrame:SetHeight(520)
    lootWindowFrame:SetPoint("CENTER", 0, 0)
    lootWindowFrame:SetLayout("Fill")
    lootWindowFrame:SetTitle("LogBook Loot")
    lootWindowFrame:SetStatusText("|cffffffffLog|r|cff57b6ffBook|r |cff4fe368Loot|r |cff9191a1v0.0.1|r")
    lootWindowFrame:EnableResize(false)
    lootWindowFrame:Hide()

    lootWindowFrame:SetCallback("OnClose", function(widget)
      PlaySound(840)
    end)

    -- header
    LBL_LootHeader:ContainerHeaderFrame(tableData, lootWindowFrame)
    -- filter
    LBL_LootFilter:ContainerFilterFrame(lootWindowFrame)
    -- table
    LBL_LootBody:ContainerBodyFrame(tableData, lootWindowFrame)

    lootWindowFrame:Hide()
    LootWindowFrame = lootWindowFrame;

    -- Add the frame as a global variable under the name `MyGlobalFrameName`
    _G["LogBookLootWindowFrame"] = LootWindowFrame.frame
    -- Register the global variable `MyGlobalFrameName` as a "special frame"
    -- so that it is closed when the escape key is pressed.
    table.insert(UISpecialFrames, "LogBookLootWindowFrame")
  end
end

---Create loot window table data
function LBL_LootWindow:CreateLootWindowTable()
  tableData = {
    table = {
      header = {
      },
      data = {
      }
    },
  }
end

---Hide loot window frame
function LBL_LootWindow:HideLootWindowFrame()
  if LootWindowFrame and LootWindowFrame:IsShown() then
    LootWindowFrame:Hide();
  end
end

---Open loot window
function LBL_LootWindow:OpenLootWindowFrame()
  if not LootWindowFrame then return end
  if not LootWindowFrame:IsShown() then
    PlaySound(882)
    --LogBook:Debug("Show LootWindow frame")
    LootWindowFrame:Show()
    LBL_LootWindow:RedrawLootWindowFrame()
  else
    --LogBook:Debug("Hide LootWindow frame")
    LootWindowFrame:Hide()
  end
end

---Redraw loot window frame
function LBL_LootWindow:RedrawLootWindowFrame()
  if not LootWindowFrame then return end
  --LogBook:Debug("Redraw LootWindowFrame frame")
  if LootWindowFrame:IsShown() then
    LBL_LootBody:RedrawLootWindowBody(tableData, LootWindowFrame)
  end
end
