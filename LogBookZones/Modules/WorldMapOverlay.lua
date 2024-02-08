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
  hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
    LBZ_WorldMapOverlay:UpdateWorldMapOverlay(WorldMapFrame:GetMapID())
  end)
end

---Updata map overlay
---@param mapID any
function LBZ_WorldMapOverlay:UpdateWorldMapOverlay(mapID)
  --LogBook:Debug("Building path zone overlay...")
  zoneMapOverlayIntensity = LBZ_WorldMapOverlay:BuildZonesOverlayData()
  if zoneMapOverlayFrame == nil then
    zoneMapOverlayFrame = CreateFrame("Frame", "zoneMapOverlayFrame", WorldMapFrameCanvas)
    LBZ_WorldMapOverlay:InitializeOverlay()
  end

  local grid_x = zoneMapOverlayFrame:GetWidth() / granularity
  local grid_y = zoneMapOverlayFrame:GetHeight() / granularity

  local _, classFilename, _ = UnitClass("player")
  local classColor = LB_CustomColors:CustomClassBrightColors(classFilename)
  local rgbColor = LB_CustomColors:HexToRgb(classColor, true)

  if zoneMapOverlayFrame.zoneMap == nil then
    zoneMapOverlayFrame.zoneMap = {}
  end

  for i = 1, granularity do
    if zoneMapOverlayFrame.zoneMap[i] ~= nil then
      for j = 1, granularity do
        if zoneMapOverlayFrame.zoneMap[i][j] ~= nil then
          zoneMapOverlayFrame.zoneMap[i][j]:SetColorTexture(0, 0, 0, 0.0)
        end
      end
    end
  end
  local playerMpaID = C_Map.GetBestMapForUnit("player")
  if WorldMapFrame:GetMapID() ~= playerMpaID then return end

  local zoneMapIndex = 0
  for i = 1, granularity do
    if zoneMapOverlayFrame.zoneMap[i] == nil then
      zoneMapOverlayFrame.zoneMap[i] = {}
    end
    for j = 1, granularity do
      local intensity = LBZ_WorldMapOverlay:ExistsEntry(mapID, i, j)
      --LogBook:Debug(string.format("%s , %s = %s", tostring(i), tostring(j), tostring(intensity)))
      if intensity > 0 then
        local alpha = intensity
        if alpha > 0.60 then
          alpha = 0.60
        end
        if zoneMapOverlayFrame.zoneMap[i][j] == nil then
          zoneMapOverlayFrame.zoneMap[i][j] = zoneMapOverlayFrame:CreateTexture(nil, "BACKGROUND")
          zoneMapOverlayFrame.zoneMap[i][j]:SetDrawLayer("OVERLAY", -7)
          zoneMapOverlayFrame.zoneMap[i][j]:SetWidth(grid_x)
          zoneMapOverlayFrame.zoneMap[i][j]:SetHeight(grid_y)
          zoneMapOverlayFrame.zoneMap[i][j]:SetPoint(
            "CENTER",
            zoneMapOverlayFrame,
            "TOPLEFT",
            grid_x * i,
            -grid_y * j
          )
        end
        zoneMapOverlayFrame.zoneMap[i][j]:SetColorTexture(rgbColor.r, rgbColor.g, rgbColor.b, alpha)
        zoneMapOverlayFrame.zoneMap[i][j].intensity = intensity
        zoneMapOverlayFrame.zoneMap[i][j]:Show()
        zoneMapIndex = zoneMapIndex + 1
      end
    end
  end
  zoneMapOverlayFrame:Show()
  if not LogBookZones.db.char.general.zones.enablePathOverlay then
    zoneMapOverlayFrame:Hide()
  else
    zoneMapOverlayFrame:Show()
  end
end

---Initialize overlay
function LBZ_WorldMapOverlay:InitializeOverlay()
  --LogBook:Debug("Initializing path zone overlay...")
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

local minNormalizedIntensity = 0.20
local maxNormalizedIntensity = 0.60
local intensitySteps = 5
---Build zones overlay
---@param mapID number?
---@return table overlay
function LBZ_WorldMapOverlay:BuildZonesOverlayData(mapID)
  local result = {}
  local paths = LogBookZones.db.global.characters[LogBookZones.key].paths or {}
  if LB_CustomFunctions:TableIsEmpty(paths) then return {} end
  for currentMapID, pathData in pairs(paths) do
    --LogBook:Debug(mapID)
    if (mapID ~= nil and currentMapID == mapID) or (mapID == nil) then
      for coordinatesKey, values in pairs(pathData) do
        local x, y = coordinatesKey:match("([^,]+),([^,]+)")
        local normalizedX = tonumber(format("%.0f", x * 100))
        local normalizedY = tonumber(format("%.0f", y * 100))
        local timestamps = LB_CustomFunctions:TableLength(values) or 0
        if result[currentMapID] == nil then result[currentMapID] = {} end
        if normalizedX ~= nil and result[currentMapID][normalizedX] == nil then result[currentMapID][normalizedX] = {} end
        if normalizedY ~= nil then
          local currentYValue = result[currentMapID][normalizedX][normalizedY] or 0
          result[currentMapID][normalizedX][normalizedY] = currentYValue + timestamps
        end
      end
    end
  end

  local intensities = {}
  for currentMapID, mapData in pairs(result) do
    if (mapID ~= nil and currentMapID == mapID) or (mapID == nil) then
      local maxIntensity, minIntensity = nil, nil
      if intensities[currentMapID] == nil then intensities[currentMapID] = {} end
      for _, yData in pairs(mapData) do
        for _, intensity in pairs(yData) do
          if minIntensity == nil or intensity < minIntensity then minIntensity = intensity end
          if maxIntensity == nil or intensity > maxIntensity then maxIntensity = intensity end
          intensities[currentMapID] = {
            minIntensity = minIntensity,
            maxIntensity = maxIntensity
          }
        end
      end
    end
  end

  local newResult = {}
  local intensityStep = (maxNormalizedIntensity - minNormalizedIntensity) / intensitySteps
  LogBookZones.db.global.characters[LogBookZones.key].result = result

  for mapID, mapData in pairs(result) do
    local minIntensity = intensities[mapID].minIntensity
    local maxIntensity = intensities[mapID].maxIntensity
    local index = (maxIntensity - minIntensity) / intensitySteps
    --if mapID == 1453 then
    --  LogBook:Debug(string.format("%s = %s , %s", mapID, minIntensity, maxIntensity))
    --end
    if newResult[mapID] == nil then newResult[mapID] = {} end
    for x, yData in pairs(mapData) do
      if newResult[mapID][x] == nil then newResult[mapID][x] = {} end
      for y, intensity in pairs(yData) do
        local newIntensity = ((intensity / index) * intensityStep) + minNormalizedIntensity
        --if mapID == 1453 then
        --  LogBook:Debug(string.format("%s , %s = %s (%s)", x, y, intensity, newIntensity))
        --end
        -- 0.20 > 0.50 (7) 0.05
        newResult[mapID][x][y] = newIntensity
      end
    end
  end
  LogBookZones.db.global.characters[LogBookZones.key].newResult = newResult
  return newResult
end
