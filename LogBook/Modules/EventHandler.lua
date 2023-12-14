---@class LB_EventHandler
local LB_EventHandler = LB_ModuleLoader:CreateModule("LB_EventHandler")
local _LB_EventHandler = {}

---@type LB_Init
local LB_Init = LB_ModuleLoader:ImportModule("LB_Init")

function LB_EventHandler:RegisterEarlyEvents()
  LogBook:RegisterEvent("PLAYER_LOGIN", _LB_EventHandler.PlayerLogin)
end

function _LB_EventHandler:PlayerLogin()
  -- Check config exists
  if not LogBook.db or not LogBookDB then
    LogBook:Error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    error("Config DB from saved variables is not loaded and initialized. Please report this issue.")
    return
  end

  do
    -- All this information was researched here: https://www.townlong-yak.com/framexml/live/GlobalStrings.lua
    local realmID, realmName, realmNormalizedRealmName = GetRealmID(), GetRealmName(), GetNormalizedRealmName()
    local name = UnitName("player")
    local className, classFilename, classId = UnitClass("player")
    local raceName, raceFile, raceID = UnitRace("player")
    local level = UnitLevel("player")
    local englishFaction, localizedFaction = UnitFactionGroup("player")
    local version, build, date, tocversion, localizedVersion, buildType = GetBuildInfo()
    local locale = GetLocale()
    local key = name .. " - " .. realmName
    local info = {
      realm = realmName,
      realmID = realmID,
      name = name,
      level = level,
      classFilename = classFilename,
      className = className,
      classId = classId,
      raceName = raceName,
      raceFile = raceFile,
      raceID = raceID,
      faction = localizedFaction,
      factionName = englishFaction,
      locale = locale
    }
    LogBook.db.global.data.characters[key] = true

    if LogBook.db.global.characters[LogBook.key] == nil then
      LogBook.db.global.characters[LogBook.key] = {
        info = info,
        spells = {
        },
      }
    else
      LogBook.db.global.characters[LogBook.key].info = info
    end
  end
  LB_Init:Initialize()
end
