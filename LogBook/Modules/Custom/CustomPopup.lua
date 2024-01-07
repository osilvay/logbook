---@class LB_CustomPopup
local LB_CustomPopup = LB_ModuleLoader:CreateModule("LB_CustomPopup")

local _LB_CustomPopup = LB_CustomPopup.private
_LB_CustomPopup.popup = nil

local LibStub = LibStub
local AceGUI = LibStub("AceGUI-3.0")
local isOpened
local _CreateNoteWindow, _CreateContainer, _CreateDescription, _CreateButtonContainer, _CreateSeparator, _CreateAcceptButton, _CreateCancelButton
local title, description, _acceptFn

function LB_CustomPopup:CreatePopup(customTitle, customDescription, customAcceptFn)
    if customTitle == nil or customDescription == nil or customAcceptFn == nil then return end
    title = customTitle
    description = customDescription
    _acceptFn = customAcceptFn
    if not _LB_CustomPopup.popup then
        _LB_CustomPopup.popup = _CreateNoteWindow()
        _LB_CustomPopup.popup:Hide()
    end
    C_Timer.After(0.1, function()
        LB_CustomPopup:ShowPopup()
    end)
end

function LB_CustomPopup:ShowPopup()
    if not _LB_CustomPopup.popup:IsShown() then
        _LB_CustomPopup.popup:Show()
        isOpened = true
    else
        _LB_CustomPopup.popup:Hide()
        isOpened = false
    end
end

function LB_CustomPopup:IsOpened()
    return isOpened
end

_CreateNoteWindow      = function()
    ---@type AceGUIWindow
    local notePopup = AceGUI:Create("Window")
    notePopup:Show()
    notePopup:SetTitle(title)
    notePopup:SetWidth(400)
    notePopup:SetHeight(150)
    notePopup:EnableResize(false)
    notePopup.frame:Raise()
    notePopup:SetCallback("OnClose", function()
        notePopup:Hide()
    end)

    local container = _CreateContainer()
    notePopup:AddChild(container)

    local desc = _CreateDescription()
    container:AddChild(desc)

    local buttonContainer = _CreateButtonContainer()
    container:AddChild(buttonContainer)

    return notePopup
end

---Create container
---@return AceGUIWidget
_CreateContainer       = function()
    ---@type AceGUISimpleGroup
    local container = AceGUI:Create("SimpleGroup")
    container:SetFullHeight(true)
    container:SetFullWidth(true)
    container:SetLayout('Flow')
    return container
end

---Create label
---@return AceGUIWidget
_CreateDescription     = function()
    ---@type AceGUISimpleGroup
    local descContainer = AceGUI:Create("SimpleGroup")
    descContainer:SetFullWidth(true)
    descContainer:SetHeight(60)
    descContainer:SetLayout('Fill')
    descContainer:SetAutoAdjustHeight(false)

    ---@type AceGUILabel
    local desc = AceGUI:Create("Label")
    desc:SetText(description)
    desc:SetFullWidth(true)
    desc:SetFullHeight(true)
    descContainer:AddChild(desc)
    
    return descContainer
end

---Create container
---@return AceGUIWidget
_CreateButtonContainer = function()
    ---@type AceGUISimpleGroup
    local btnContainer = AceGUI:Create("SimpleGroup")
    btnContainer:SetFullWidth(true)
    btnContainer:SetHeight(40)
    btnContainer:SetLayout('Flow')
    btnContainer:SetPoint("BOTTOMLEFT", 0, 0)

    local addAcceptBtn = _CreateAcceptButton()
    btnContainer:AddChild(addAcceptBtn)

    ---@type AceGUILabel
    local separator = AceGUI:Create("Label")
    separator:SetText('')
    separator:SetWidth(130)
    separator:SetHeight(40)
    btnContainer:AddChild(separator)

    local addCancelBtn = _CreateCancelButton()
    btnContainer:AddChild(addCancelBtn)

    return btnContainer
end

---Create accept button
---@return AceGUIWidget
_CreateAcceptButton    = function()
    ---@type AceGUIButton
    local addAcceptBtn = AceGUI:Create("Button")
    addAcceptBtn:SetText(LogBook:i18n('Accept'))
    addAcceptBtn:SetWidth(120)
    addAcceptBtn:SetCallback("OnClick", _HandleAcceptBtn)
    return addAcceptBtn
end

---Create cancel button
---@return AceGUIWidget
_CreateCancelButton    = function()
    ---@type AceGUIButton
    local addCancelBtn = AceGUI:Create("Button")
    addCancelBtn:SetText(LogBook:i18n('Cancel'))
    addCancelBtn:SetWidth(120)
    addCancelBtn:SetCallback("OnClick", _HandleCancelBtn)
    return addCancelBtn
end

---Handle entry note
_HandleAcceptBtn       = function()
    _acceptFn()
    _LB_CustomPopup.popup:Hide()
end

---Handle entry note
_HandleCancelBtn       = function()
    _LB_CustomPopup.popup:Hide()
end
