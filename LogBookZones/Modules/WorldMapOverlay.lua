---@class LBZ_WorldMapOverlay
local LBZ_WorldMapOverlay = LB_ModuleLoader:CreateModule("LBZ_WorldMapOverlay")

---@type LB_CustomColors
local LB_CustomColors = LB_ModuleLoader:ImportModule("LB_CustomColors")

---@type LB_CustomFunctions
local LB_CustomFunctions = LB_ModuleLoader:ImportModule("LB_CustomFunctions")

---@type LBZ_Database
local LBZ_Database = LB_ModuleLoader:ImportModule("LBZ_Database")

local WorldMapFrameCanvas = WorldMapFrame:GetCanvas()
local mWidth, mHeight = WorldMapFrameCanvas:GetSize()

local lastCalculatedMapID = nil
local granularity = 100

local zoneMapOverlayFrame
local zoneMapOverlayIntensity = {}

---Initialize
function LBZ_WorldMapOverlay:Initialize()
  zoneMapOverlayIntensity = LBZ_Database:BuildZonesOverlayData()
  local mapID = C_Map.GetBestMapForUnit("player")
  hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
    LBZ_WorldMapOverlay:UpdateWorldMapOverlay(mapID)
  end)
end

---Updata map overlay
---@param mapID any
function LBZ_WorldMapOverlay:UpdateWorldMapOverlay(mapID)
  if zoneMapOverlayFrame == nil then
    zoneMapOverlayFrame = CreateFrame("Frame", "zoneMapOverlayFrame", WorldMapFrameCanvas)
    LBZ_WorldMapOverlay:InitializeOverlay()
  end

  local grid_x = zoneMapOverlayFrame:GetWidth() / granularity
  local grid_y = zoneMapOverlayFrame:GetHeight() / granularity
  local rgbColor = LB_CustomColors:HexToRgb("FFC6FFF6", true)

  if zoneMapOverlayFrame.zoneMap == nil then
    zoneMapOverlayFrame.zoneMap = {}
  end

  local zoneMapIndex = 0
  for i = 1, granularity do
    zoneMapOverlayFrame.zoneMap[i] = {}
    for j = 1, granularity do
      local intensity = LBZ_WorldMapOverlay:ExistsEntry(mapID, i, j)
      --LogBook:Debug(string.format("%s , %s = %s", tostring(i), tostring(j), tostring(intensity)))
      if intensity > 0 then
        local alpha = intensity * 4
        if alpha > 0.5 then
          alpha = 0.5
        end
        zoneMapOverlayFrame.zoneMap[i][j] = zoneMapOverlayFrame:CreateTexture(nil, "BACKGROUND")
        zoneMapOverlayFrame.zoneMap[i][j]:SetDrawLayer("OVERLAY", -7)
        zoneMapOverlayFrame.zoneMap[i][j]:SetWidth(grid_x)
        zoneMapOverlayFrame.zoneMap[i][j]:SetHeight(grid_y)
        zoneMapOverlayFrame.zoneMap[i][j]:SetColorTexture(rgbColor.r, rgbColor.g, rgbColor.b, alpha)
        zoneMapOverlayFrame.zoneMap[i][j]:SetPoint(
          "CENTER",
          zoneMapOverlayFrame,
          "TOPLEFT",
          grid_x * i,
          -grid_y * j
        )
        zoneMapOverlayFrame.zoneMap[i][j].intensity = intensity
        zoneMapOverlayFrame.zoneMap[i][j]:Show()
        zoneMapIndex = zoneMapIndex + 1
      end
    end
    zoneMapOverlayFrame:Show()
    LogBook:Debug("Map overlay chunks : " .. tostring(zoneMapIndex))
  end

  --LBZ_WorldMapOverlay:UpdateWorldMapOverlay(WorldMapFrame:GetMapID())
  if not LogBookZones.db.char.general.zones.enablePathOverlay then
    zoneMapOverlayFrame:Hide()
  else
    zoneMapOverlayFrame:Show()
  end
end

---Initialize overlay
function LBZ_WorldMapOverlay:InitializeOverlay()
  zoneMapOverlayFrame:SetParent(WorldMapFrameCanvas)
  zoneMapOverlayFrame:SetHeight(mHeight)
  zoneMapOverlayFrame:SetWidth(mWidth)
  zoneMapOverlayFrame:ClearAllPoints()
  zoneMapOverlayFrame:SetAllPoints()
  zoneMapOverlayFrame:SetFrameLevel(3010)
  zoneMapOverlayFrame:SetFrameStrata("MEDIUM")
  zoneMapOverlayFrame:Show()
end

---Test if entry exists
---@param mapID number?
---@param x number
---@param y number
---@return number intensity
function LBZ_WorldMapOverlay:ExistsEntry(mapID, x, y)
  if zoneMapOverlayIntensity[mapID] == nil then return 0 end
  local byMapID = zoneMapOverlayIntensity[mapID]
  if byMapID[x] == nil then return 0 end
  local xValues = byMapID[x]
  if xValues[y] == nil or type(xValues[y]) ~= "number" then return 0 end
  return xValues[y] or 0
end
