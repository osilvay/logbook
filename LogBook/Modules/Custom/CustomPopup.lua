---@class LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:CreateModule("LB_CustomPopup")

local _LB_CustomPopup = LB_CustomPopup.private
_LB_CustomPopup.popup = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local isOpened = false
local _CreateNoteWindow, _CreateContainer, _CreateDescription, _CreateButtonContainer, _CreateSeparator, _CreateAcceptButton, _CreateCancelButton
local title, description, _acceptFn

function LB_CustomPopup:CreatePopup(customTitle, customDescription, customAcceptFn)
  if customTitle == nil or customDescription == nil or customAcceptFn == nil then return end
  title = customTitle
  description = customDescription
  _acceptFn = customAcceptFn
  if not _LB_CustomPopup.popup then
    _LB_CustomPopup.popup = _CreatePopupWindow()
    _LB_CustomPopup.popup:Hide()
  else
    _LB_CustomPopup.popup:ReleaseChildren()
    LB_CustomPopup:CreateWindowContent(_LB_CustomPopup.popup)
  end
  C_Timer.After(0.1, function()
    LB_CustomPopup:ShowPopup()
  end)
end

function LB_CustomPopup:ShowPopup()
  if not _LB_CustomPopup.popup:IsShown() then
    _LB_CustomPopup.popup:Show()
    isOpened = true
    --LogBook:Debug("ShowPopup " .. tostring(isOpened))
  else
    _LB_CustomPopup.popup:Hide()
    isOpened = false
    --LogBook:Debug("ShowPopup " .. tostring(isOpened))
  end
end

function LB_CustomPopup:CancelPopup()
  --LogBook:Debug("Cancel popup")
  if _LB_CustomPopup.popup then
    _LB_CustomPopup.popup:Hide()
    isOpened = false
  end
end

function LB_CustomPopup:IsOpened()
  --LogBook:Debug("IsOpened " .. tostring(isOpened))
  return isOpened
end

_CreatePopupWindow = function()
  ---@type AceGUIWindow
  local popup = AceGUI:Create("Window")
  popup:Show()
  popup:SetTitle(title)
  popup:SetWidth(400)
  popup:SetHeight(140)
  popup:EnableResize(false)
  popup.frame:Raise()
  popup:SetCallback("OnClose", function()
    popup:Hide()
  end)
  LB_CustomPopup:CreateWindowContent(popup)

  return popup
end

function LB_CustomPopup:CreateWindowContent(popup)
  local container = _CreateContainer()
  popup:AddChild(container)

  local desc = _CreateDescription()
  container:AddChild(desc)

  local buttonContainer = _CreateButtonContainer()
  container:AddChild(buttonContainer)
end

---Create container
---@return AceGUIWidget
_CreateContainer       = function()
  ---@type AceGUISimpleGroup
  local container = AceGUI:Create("SimpleGroup")
  container:SetWidth(400)
  container:SetHeight(140)
  container:SetLayout('Flow')
  container:SetAutoAdjustHeight(false)
  return container
end

---Create label
---@return AceGUIWidget
_CreateDescription     = function()
  ---@type AceGUISimpleGroup
  local descContainer = AceGUI:Create("SimpleGroup")
  descContainer:SetWidth(400)
  descContainer:SetHeight(60)
  descContainer:SetLayout('Flow')
  descContainer:SetAutoAdjustHeight(false)

  -- Separator <-
  descContainer:AddChild(_CreateSeparator(10, 60))

  ---@type AceGUILabel
  local desc = AceGUI:Create("Label")
  desc:SetText(description)
  desc:SetWidth(380)
  desc:SetFullHeight(true)
  descContainer:AddChild(desc)

  -- Separator ->
  descContainer:AddChild(_CreateSeparator(10, 60))

  return descContainer
end

---Create container
---@return AceGUIWidget
_CreateButtonContainer = function()
  ---@type AceGUISimpleGroup
  local btnContainer = AceGUI:Create("SimpleGroup")
  btnContainer:SetWidth(400)
  btnContainer:SetHeight(40)
  btnContainer:SetLayout('Flow')

  -- Separator
  btnContainer:AddChild(_CreateSeparator(10, 40))

  local addAcceptBtn = _CreateAcceptButton()
  btnContainer:AddChild(addAcceptBtn)

  -- Separator
  btnContainer:AddChild(_CreateSeparator(120, 40))

  local addCancelBtn = _CreateCancelButton()
  btnContainer:AddChild(addCancelBtn)

  -- Separator
  btnContainer:AddChild(_CreateSeparator(10, 40))

  return btnContainer
end

---Create accept button
---@return AceGUIWidget
_CreateAcceptButton    = function()
  ---@type AceGUIButton
  local addAcceptBtn = AceGUI:Create("Button")
  addAcceptBtn:SetText(LogBook:LB_i18n('Accept'))
  addAcceptBtn:SetWidth(120)
  addAcceptBtn:SetCallback("OnClick", _HandleAcceptBtn)
  return addAcceptBtn
end

---Create cancel button
---@return AceGUIWidget
_CreateCancelButton    = function()
  ---@type AceGUIButton
  local addCancelBtn = AceGUI:Create("Button")
  addCancelBtn:SetText(LogBook:LB_i18n('Cancel'))
  addCancelBtn:SetWidth(120)
  addCancelBtn:SetCallback("OnClick", _HandleCancelBtn)
  return addCancelBtn
end


---Create accept button
---@return AceGUIWidget
_CreateSeparator = function(width, height)
  ---@type AceGUILabel
  local separator = AceGUI:Create("Label")
  separator:SetText('')
  separator:SetWidth(width)
  separator:SetHeight(height)
  return separator
end

---Handle entry note
_HandleAcceptBtn = function()
  _acceptFn()
  _LB_CustomPopup.popup:Hide()
end

---Handle entry note
_HandleCancelBtn = function()
  _LB_CustomPopup.popup:Hide()
end
