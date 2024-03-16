---@class LB_MinimapIcon
local LB_MinimapIcon = LB_ModuleLoader:CreateModule("LB_MinimapIcon");
local _LB_MinimapIcon = {}

---@type LB_Settings
local LB_Settings = LB_ModuleLoader:ImportModule("LB_Settings")

---@type LB_SlashCommands
local LB_SlashCommands = LB_ModuleLoader:ImportModule("LB_SlashCommands")

---@type LB_WelcomeWindow
local LB_WelcomeWindow = LB_ModuleLoader:ImportModule("LB_WelcomeWindow")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomMedias
local LB_CustomMedias = LB_ModuleLoader:ImportModule("LB_CustomMedias")

local _LibDBIcon = LibStub("LibDBIcon-1.0");

function LB_MinimapIcon:Initialize()
  _LibDBIcon:Register("LogBook", _LB_MinimapIcon:CreateDataBrokerObject(), LogBook.db.profile.minimap);
  LogBook.minimapConfigIcon = _LibDBIcon
end

function _LB_MinimapIcon:CreateDataBrokerObject()
  local LDBDataObject = LibStub("LibDataBroker-1.1"):NewDataObject("LogBook", {
    type = "data source",
    text = "ldbDisplayText",
    icon = LB_CustomMedias:GetMediaFile("logbook"),

    OnClick = function(_, button)
      --if (not LogBook.started) then return end

      if button == "LeftButton" then
        LB_SlashCommands:CloseAllFrames()
        LB_WelcomeWindow:OpenWelcomeWindowFrame()
      elseif button == "RightButton" then
        LB_SlashCommands:CloseAllFrames()
        LB_Settings:OpenSettingsFrame()
      end
      --[[
            if button == "LeftButton" then
                if IsShiftKeyDown() and IsControlKeyDown() then
                    Questie.db.profile.enabled = (not Questie.db.profile.enabled)
                    QuestieQuest:ToggleNotes(Questie.db.profile.enabled)

                    -- Close config window if it's open to avoid desyncing the Checkbox
                    QuestieOptions:HideFrame();
                    return;
                elseif IsControlKeyDown() then
                    QuestieQuest:SmoothReset()
                    return
                end

                QuestieMenu:Show()

                if QuestieJourney:IsShown() then
                    QuestieJourney.ToggleJourneyWindow();
                end

                return;
            elseif button == "RightButton" then
                if (not IsModifierKeyDown()) then
                    -- CLose config window if it's open to avoid desyncing the Checkbox
                    QuestieOptions:HideFrame();
                    if InCombatLockdown() then
                        Questie:Print(l10n("Questie will open after combat ends."))
                    end
                    QuestieCombatQueue:Queue(function()
                        QuestieOptions:OpenConfigWindow()
                    end)
                    return;
                elseif IsControlKeyDown() then
                    Questie.db.profile.minimap.hide = true;
                    Questie.minimapConfigIcon:Hide("Questie");
                    return;
                end
            end
            ]]
    end,

    OnTooltipShow = function(tooltip)
      tooltip:AddLine("|cffffffffLog|r|cff57b6ffBook|r")
      tooltip:AddLine(LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHLIGHTED"), LogBook:LB_i18n("Left Click")) .. ": " .. LB_CustomColors:Colorize(LB_CustomColors:CustomColors("TEXT_VALUE"), LogBook:LB_i18n("Open main window")));
      tooltip:AddLine(LB_CustomColors:Colorize(LB_CustomColors:CustomColors("HIGHLIGHTED"), LogBook:LB_i18n("Right Click")) .. ": " .. LB_CustomColors:Colorize(LB_CustomColors:CustomColors("TEXT_VALUE"), LogBook:LB_i18n("Open settings window")));
    end,
  });

  self.LDBDataObject = LDBDataObject

  return LDBDataObject
end

--- Update the LibDataBroker text
function LB_MinimapIcon:UpdateText(text)
  --Questie.db.profile.ldbDisplayText = text
  _LB_MinimapIcon.LDBDataObject.text = text
end
