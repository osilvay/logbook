---@class LBZ_ZonesWindow
local LBZ_ZonesWindow = LB_ModuleLoader:CreateModule("LBZ_ZonesWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBZ_ZonesHeader
local LBZ_ZonesHeader = LB_ModuleLoader:ImportModule("LBZ_ZonesHeader")

---@type LBZ_ZonesBody
local LBZ_ZonesBody = LB_ModuleLoader:ImportModule("LBZ_ZonesBody")

---@type LBZ_ZonesFilter
local LBZ_ZonesFilter = LB_ModuleLoader:ImportModule("LBZ_ZonesFilter")

-- Forward declaration
ZonesWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LBZ_ZonesWindow:Initialize()
  if not ZonesWindowFrame then
    LBZ_ZonesWindow:CreateZonesWindowTable()

    ---@type AceGUIFrame, AceGUIFrame
    local zonesWindowFrame = AceGUI:Create("Frame");
    zonesWindowFrame:SetWidth(540)
    zonesWindowFrame:SetHeight(520)
    zonesWindowFrame:SetPoint("CENTER", 0, 0)
    zonesWindowFrame:SetLayout("Fill")
    zonesWindowFrame:SetTitle("LogBook Zones")
    zonesWindowFrame:SetStatusText("|cffffffffLog|r|cff57b6ffBook|r |cff4fe368Zones|r |cff9191a1v0.0.1|r")
    zonesWindowFrame:EnableResize(false)
    zonesWindowFrame:Hide()

    zonesWindowFrame:SetCallback("OnClose", function(widget)
      PlaySound(840)
    end)

    -- header
    LBZ_ZonesHeader:ContainerHeaderFrame(tableData, zonesWindowFrame)
    -- filter
    LBZ_ZonesFilter:ContainerFilterFrame(zonesWindowFrame)
    -- table
    LBZ_ZonesBody:ContainerBodyFrame(tableData, zonesWindowFrame)

    zonesWindowFrame:Hide()
    ZonesWindowFrame = zonesWindowFrame;

    -- Add the frame as a global variable under the name `MyGlobalFrameName`
    _G["LogBookZonesWindowFrame"] = ZonesWindowFrame.frame
    -- Register the global variable `MyGlobalFrameName` as a "special frame"
    -- so that it is closed when the escape key is pressed.
    table.insert(UISpecialFrames, "LogBookZonesWindowFrame")
  end
end

---Create zones window table data
function LBZ_ZonesWindow:CreateZonesWindowTable()
  tableData = {
    table = {
      header = {
      },
      data = {
      }
    },
  }
end

---Hide zones window frame
function LBZ_ZonesWindow:HideZonesWindowFrame()
  if ZonesWindowFrame and ZonesWindowFrame:IsShown() then
    ZonesWindowFrame:Hide();
  end
end

---Open zones window
function LBZ_ZonesWindow:OpenZonesWindowFrame()
  if not ZonesWindowFrame then return end
  if not ZonesWindowFrame:IsShown() then
    PlaySound(882)
    --LogBook:Debug("Show ZonesWindow frame")
    ZonesWindowFrame:Show()
    LBZ_ZonesWindow:RedrawZonesWindowFrame()
  else
    --LogBook:Debug("Hide ZonesWindow frame")
    ZonesWindowFrame:Hide()
  end
end

---Redraw zones window frame
function LBZ_ZonesWindow:RedrawZonesWindowFrame()
  if not ZonesWindowFrame then return end
  --LogBook:Debug("Redraw ZonesWindowFrame frame")
  if ZonesWindowFrame:IsShown() then
    LBZ_ZonesBody:RedrawZonesWindowBody(tableData, ZonesWindowFrame)
  end
end
