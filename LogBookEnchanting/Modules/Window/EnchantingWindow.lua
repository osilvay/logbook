---@class LBE_EnchantingWindow
local LBE_EnchantingWindow = LB_ModuleLoader:CreateModule("LBE_EnchantingWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LB_CustomFrames
local LB_CustomFrames = LB_ModuleLoader:ImportModule("LB_CustomFrames")

---@type LBE_EnchantingHeader
local LBE_EnchantingHeader = LB_ModuleLoader:ImportModule("LBE_EnchantingHeader")

---@type LBE_EnchantingBody
local LBE_EnchantingBody = LB_ModuleLoader:ImportModule("LBE_EnchantingBody")

---@type LBE_EnchantingFilter
local LBE_EnchantingFilter = LB_ModuleLoader:ImportModule("LBE_EnchantingFilter")

-- Forward declaration
EnchantingWindowFrame = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")

local tableData = {}

---Initilize
function LBE_EnchantingWindow:Initialize()
  if not EnchantingWindowFrame then
    LBE_EnchantingWindow:CreateEnchantingWindowTable()

    ---@type AceGUIFrame, AceGUIFrame
    local enchantingWindowFrame = AceGUI:Create("Frame");
    enchantingWindowFrame:SetWidth(540)
    enchantingWindowFrame:SetHeight(520)
    enchantingWindowFrame:SetPoint("CENTER", 0, 0)
    enchantingWindowFrame:SetLayout("Fill")
    enchantingWindowFrame:SetTitle("LogBook Enchanting")
    enchantingWindowFrame:SetStatusText("|cffffffffLog|r|cff57b6ffBook|r |cff4fe368Enchanting|r |cff9191a1v0.0.1|r")
    enchantingWindowFrame:EnableResize(false)
    enchantingWindowFrame:Hide()

    enchantingWindowFrame:SetCallback("OnClose", function(widget)
      PlaySound(840)
    end)

    -- header
    LBE_EnchantingHeader:ContainerHeaderFrame(tableData, enchantingWindowFrame)
    -- filter
    LBE_EnchantingFilter:ContainerFilterFrame(enchantingWindowFrame)
    -- table
    LBE_EnchantingBody:ContainerBodyFrame(tableData, enchantingWindowFrame)

    enchantingWindowFrame:Hide()
    EnchantingWindowFrame = enchantingWindowFrame;

    -- Add the frame as a global variable under the name `MyGlobalFrameName`
    _G["LogBookEnchantingWindowFrame"] = EnchantingWindowFrame.frame
    -- Register the global variable `MyGlobalFrameName` as a "special frame"
    -- so that it is closed when the escape key is pressed.
    table.insert(UISpecialFrames, "LogBookEnchantingWindowFrame")
  end
end

---Create enchanting window table data
function LBE_EnchantingWindow:CreateEnchantingWindowTable()
  tableData = {
    table = {
      header = {
      },
      data = {
      }
    },
  }
end

---Hide enchanting window frame
function LBE_EnchantingWindow:HideEnchantingWindowFrame()
  if EnchantingWindowFrame and EnchantingWindowFrame:IsShown() then
    EnchantingWindowFrame:Hide();
  end
end

---Open enchanting window
function LBE_EnchantingWindow:OpenEnchantingWindowFrame()
  if not EnchantingWindowFrame then return end
  if not EnchantingWindowFrame:IsShown() then
    PlaySound(882)
    --LogBook:Debug("Show EnchantingWindow frame")
    EnchantingWindowFrame:Show()
    LBE_EnchantingWindow:RedrawEnchantingWindowFrame()
  else
    --LogBook:Debug("Hide EnchantingWindow frame")
    EnchantingWindowFrame:Hide()
  end
end

---Redraw enchanting window frame
function LBE_EnchantingWindow:RedrawEnchantingWindowFrame()
  if not EnchantingWindowFrame then return end
  --LogBook:Debug("Redraw EnchantingWindowFrame frame")
  if EnchantingWindowFrame:IsShown() then
    LBE_EnchantingBody:RedrawEnchantingWindowBody(tableData, EnchantingWindowFrame)
  end
end
