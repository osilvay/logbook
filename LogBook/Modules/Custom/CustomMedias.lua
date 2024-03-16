---@class LB_CustomMedias
local LB_CustomMedias = LB_ModuleLoader:CreateModule("LB_CustomMedias")

local logBookIcons
local logBookMedias

logBookIcons = {
  ["accept"]        = "Interface/AddOns/LogBook/Images/Icons/accept",
  ["back"]          = "Interface/AddOns/LogBook/Images/Icons/back",
  ["cleanup"]       = "Interface/AddOns/LogBook/Images/Icons/cleanup",
  ["cleanup_a"]     = "Interface/AddOns/LogBook/Images/Icons/cleanup_a",
  ["color"]         = "Interface/AddOns/LogBook/Images/Icons/close",
  ["consolidate"]   = "Interface/AddOns/LogBook/Images/Icons/consolidate",
  ["consolidate_a"] = "Interface/AddOns/LogBook/Images/Icons/consolidate_a",
  ["copy"]          = "Interface/AddOns/LogBook/Images/Icons/copy",
  ["cut"]           = "Interface/AddOns/LogBook/Images/Icons/cut",
  ["delete"]        = "Interface/AddOns/LogBook/Images/Icons/delete",
  ["delete_a"]      = "Interface/AddOns/LogBook/Images/Icons/delete_a",
  ["edit"]          = "Interface/AddOns/LogBook/Images/Icons/edit",
  ["lock"]          = "Interface/AddOns/LogBook/Images/Icons/lock",
  ["minus"]         = "Interface/AddOns/LogBook/Images/Icons/minus",
  ["paste"]         = "Interface/AddOns/LogBook/Images/Icons/paste",
  ["play"]          = "Interface/AddOns/LogBook/Images/Icons/play",
  ["plus"]          = "Interface/AddOns/LogBook/Images/Icons/plus",
  ["purge"]         = "Interface/AddOns/LogBook/Images/Icons/purge",
  ["purge_a"]       = "Interface/AddOns/LogBook/Images/Icons/purge_a",
  ["settings"]      = "Interface/AddOns/LogBook/Images/Icons/settings",
  ["settings_a"]    = "Interface/AddOns/LogBook/Images/Icons/settings_a",
  ["update"]        = "Interface/AddOns/LogBook/Images/Icons/update",
  ["update_a"]      = "Interface/AddOns/LogBook/Images/Icons/update_a",
}

logBookMedias = {
  ["criticals"] = "Interface/AddOns/LogBook/Images/Menus/criticals",
  ["enchanting"] = "Interface/AddOns/LogBook/Images/Menus/enchanting",
  ["fishing"] = "Interface/AddOns/LogBook/Images/Menus/fishing",
  ["logbook"] = "Interface/AddOns/LogBook/Images/Menus/logbook",
  ["loot"] = "Interface/AddOns/LogBook/Images/Menus/loot",
  ["mobs"] = "Interface/AddOns/LogBook/Images/Menus/mobs",
  ["zones"] = "Interface/AddOns/LogBook/Images/Menus/zones",
  ["criticals_a"] = "Interface/AddOns/LogBook/Images/Menus/criticals_a",
  ["enchanting_a"] = "Interface/AddOns/LogBook/Images/Menus/enchanting_a",
  ["fishing_a"] = "Interface/AddOns/LogBook/Images/Menus/fishing_a",
  ["logbook_a"] = "Interface/AddOns/LogBook/Images/Menus/logbook_a",
  ["loot_a"] = "Interface/AddOns/LogBook/Images/Menus/loot_a",
  ["mobs_a"] = "Interface/AddOns/LogBook/Images/Menus/mobs_a",
  ["zones_a"] = "Interface/AddOns/LogBook/Images/Menus/zones_a",
  ["Alliance_icon"] = "Interface/AddOns/LogBook/Images/Factions/icon_alliance",
  ["Horde_icon"] = "Interface/AddOns/LogBook/Images/Factions/icon_horde",
  ["alliance_flag"] = "Interface/AddOns/LogBook/Images/Factions/flag_alliance",
  ["horde_flag"] = "Interface/AddOns/LogBook/Images/Factions/flag_horde",
}

---Return icon
---@param typeSelected string
---@return string file
function LB_CustomMedias:GetIconFile(typeSelected)
  if typeSelected == nil or logBookIcons[typeSelected] == nil then return "" end
  return logBookIcons[typeSelected]
end

---Get media
---@param typeSelected any
---@return string
function LB_CustomMedias:GetMediaFile(typeSelected)
  if typeSelected == nil or logBookMedias[typeSelected] == nil then return "" end
  return logBookMedias[typeSelected]
end

---Return icon as link
---@param typeSelected any
---@param sizeX any
---@param sizeY any
---@return string
function LB_CustomMedias:GetIconFileAsLink(typeSelected, sizeX, sizeY)
  if typeSelected == nil or logBookIcons[typeSelected] == nil then return "" end
  return string.format("|T%s:%s:%s|t", logBookIcons[typeSelected], tostring(sizeX), tostring(sizeY))
end

---Return media as link
---@param typeSelected any
---@param sizeX any
---@param sizeY any
---@return string
function LB_CustomMedias:GetMediaFileAsLink(typeSelected, sizeX, sizeY)
  if typeSelected == nil or logBookMedias[typeSelected] == nil then return "" end
  return string.format("|T%s:%s:%s|t", logBookMedias[typeSelected], tostring(sizeX), tostring(sizeY))
end
