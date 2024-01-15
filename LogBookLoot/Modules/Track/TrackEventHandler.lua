---@class LBL_TrackEventHandler
local LBL_TrackEventHandler = LB_ModuleLoader:CreateModule("LBL_TrackEventHandler")
local _LBL_TrackEventHandler = {}

---@type LBL_TrackLoot
local LBL_TrackLoot = LB_ModuleLoader:ImportModule("LBL_TrackLoot")

function LBL_TrackEventHandler:Initialize()
  --LogBook:Debug(LogBookLoot:LBL_i18n("Initializing track events..."))

  LogBookLoot:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", _LBL_TrackEventHandler.UnitSpellCastSucceeded)
  LogBookLoot:RegisterEvent("LOOT_READY", _LBL_TrackEventHandler.LootReady)
  LogBookLoot:RegisterEvent("LOOT_CLOSED", _LBL_TrackEventHandler.LootClosed)
  LogBookLoot:RegisterEvent("CHAT_MSG_LOOT", _LBL_TrackEventHandler.ChatMsgLoot)
  LogBookLoot:RegisterEvent("ITEM_LOCKED", _LBL_TrackEventHandler.ItemLocked)
end

function _LBL_TrackEventHandler.LootReady()
  LBL_TrackLoot:ProcessLootReady()
end

function _LBL_TrackEventHandler.LootClosed()
  LBL_TrackLoot:ProcessLootClosed()
end

function _LBL_TrackEventHandler.UnitSpellCastSucceeded(_, unitTarget, _, spellID)
  LBL_TrackLoot:ProcessUnitSpellCastSucceeded(unitTarget, spellID)
end

function _LBL_TrackEventHandler.ChatMsgLoot(_, text, notPlayerName, _, _, playerName)
  --LogBook:Debug(text)
  --LogBook:Debug(playerName)
  --LBL_TrackLoot:ProcessChatMsgLoot(text, notPlayerName, playerName)
end

function _LBL_TrackEventHandler.ItemLocked(_, bagOrSlotIndex, slotIndex)
  LBL_TrackLoot:ProcessItemLocked(bagOrSlotIndex, slotIndex)
end
