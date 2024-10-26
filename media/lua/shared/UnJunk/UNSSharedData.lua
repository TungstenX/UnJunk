--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
]]
UNSSharedData = UNSSharedData or {}
UNSSharedData.LOG = UNSSharedData.LOG or {}
UNSSharedData.LOG.debug = UNSSharedData.LOG.debug or getDebug()
UNSSharedData.jerkyList = UNSSharedData.jerkyList or {}
UNSSharedData.openWineList = UNSSharedData.openWineList or {}
UNSSharedData.WINE_FRESH_DAYS = 7
UNSSharedData.WINE_ROTTEN_DAYS = 14
UNSSharedData.JERKY_FRESH_DAYS = 7

function UNSSharedData.addOpenWineItems(item)
  for i = 1, #UNSSharedData.openWineList do
    if UNSSharedData.openWineList[i] == item then return end -- don't add duplicates
  end
  table.insert(UNSSharedData.openWineList, item)
  if UNSSharedData.LOG.debug then print("UNSSharedData: adding open wine to list") end
end

function UNSSharedData.addJerkyItems(item)
  for i = 1, #UNSSharedData.jerkyList do
    if UNSSharedData.jerkyList[i] == item then return end -- don't add duplicates
  end
  table.insert(UNSSharedData.jerkyList, item)
  if UNSSharedData.LOG.debug then print("UNSSharedData: adding jerky to list") end
end

function UNSSharedData.updateJerkyItems()
  for i = 1, #UNSSharedData.jerkyList do
    UNSSharedData.updateJerky(UNSSharedData.jerkyList[i])
  end
end

function UNSSharedData.updateOpenWineItems()
  for i = 1, #UNSSharedData.openWineList do
    UNSSharedData.updateOpenWine(UNSSharedData.openWineList[i])
  end
end

-- Rounds a number to a specified number of decimal places
-- If `numDecimalPlaces` is not provided or less than 1, the number is rounded to the nearest integer
-- @param num number The number to round
-- @param numDecimalPlaces number|nil The number of decimal places to round to. Optional; if nil or less than 1, rounds to the nearest integer
-- @return number num The rounded number
function UNSSharedData.roundDays(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces > 0 then
    local multiplier = 10 ^ numDecimalPlaces;
    return math.floor(num * multiplier + 0.5) / multiplier;
  end

  local roundedNum = math.floor(num + 0.5);
  return math.max(roundedNum, 1);
end

function UNSSharedData.addMoreJerky(name, daysFresh, delta, player)  
  local newItem = InventoryItemFactory.CreateItem(name)
  local md = newItem:getModData()
  md.offAge = daysFresh
  md.Jerky = true
  newItem:setPoisonPower(delta * 10)
  newItem:setTooltip(getText("Tooltip_item_JerkyNotReady") .. tostring(UNSSharedData.roundDays(delta, 1)))   
  UNSSharedData.updateJerkyName(newItem, delta)
  player:getInventory():AddItem(newItem)
  UNSSharedData.addJerkyItems(newItem)
end

function UNSSharedData.updateJerkyName(item, delta)
  if item == nil then
    return
  end
  local md = item:getModData()
  local wetDry = getText("JerkyWet")
  local days = tostring(UNSSharedData.roundDays(delta, 1)) .. "d"
  local name = item:getDisplayName()
  if md.isReady then
    wetDry = getText("JerkyDry")
    days = ""
  end
  if item:getType() == "FrogJerky" then
    name = getText("DisplayNameFrogJerky") .. " (" .. wetDry .. ") " .. days
  elseif item:getType() == "RodentJerky" then
    name = getText("DisplayNameRodentJerky") .. " (" .. wetDry .. ") " .. days  
  elseif item:getType() == "BirdJerky" then
    name = getText("DisplayNameBirdJerky") .. " (" .. wetDry .. ") " .. days  
  elseif item:getType() == "RabbitJerky" then
    name = getText("DisplayNameRabbitJerky") .. " (" .. wetDry .. ") " .. days  
  end
  item:setName(name)
end

function UNSSharedData.updateJerky(jerkyItem)
  if jerkyItem == nil then
    return
  end
  local md = jerkyItem:getModData()
  if md.isReady then
    if UNSSharedData.LOG.debug then print("Jerky already ready") end
    return
  end
  
  local hours = math.floor(getGameTime():getWorldAgeHours())
  local daysFresh = md.offAge
  local delta = (daysFresh - hours) / 24
  if UNSSharedData.LOG.debug then print("Days fresh = " .. tostring(delta)) end
  
  if (daysFresh - hours) <= 0 and not md.isReady then
    md.isReady = true    
    jerkyItem:setbDangerousUncooked(false)
    jerkyItem:setPoisonPower(0)
    jerkyItem:setTooltip(getText("Tooltip_item_JerkyReady"))  
    UNSSharedData.updateJerkyName(jerkyItem, delta)
    if UNSSharedData.LOG.debug then print("Set ready") end
  else
    local delta = (daysFresh - hours) / 24
    jerkyItem:setPoisonPower(delta * 10) 
    jerkyItem:setTooltip(getText("Tooltip_item_JerkyNotReady") .. tostring(UNSSharedData.roundDays(delta, 1))) 
    UNSSharedData.updateJerkyName(jerkyItem, delta)
  end  
end

function UNSSharedData.updateOpenWineName(item, delta)
  if item == nil then
    return
  end
  local md = item:getModData()
  local days = tostring(UNSSharedData.roundDays(delta, 1)) .. "d"
  local name = item:getDisplayName()
  if md.isStale or md.isRotten then
    days = ""
  end
  if item:getType() == "OpenChardonnay" then
    name = getText("DisplayNameOpenChardonnay") .. " " .. days
  elseif item:getType() == "OpenRedWine" then
    name = getText("DisplayNameOpenRedWine") .. " " .. days
  elseif item:getType() == "OpenWineCovered" then
    name = getText("DisplayNameOpenWineCovered") .. " " .. days
  end
  item:setName(name)
end

-- TODO Change to rotten item
function UNSSharedData.updateOpenWine(item)
  if item ~= nil then
    return
  end
  local md = item:getModData()
  if not md then
    if UNSSharedData.LOG.debug then print("No mod data") end --
    return  
  elseif md.isRotten then
    if UNSSharedData.LOG.debug then print("OPen wine already rotten") end
    return
  end
  local hours = math.floor(getGameTime():getWorldAgeHours())
  
  if not md.offAge then
    local daysFresh = hours + (UNSSharedData.WINE_FRESH_DAYS * 24)
    md.offAge = daysFresh
    if UNSSharedData.LOG.debug then print("Setting off age = " .. tostring(daysFresh)) end
  end

  if not md.offAgeMax then
    local daysTotallyRotten = hours + (UNSSharedData.WINE_ROTTEN_DAYS * 24)
    md.offAgeMax = daysTotallyRotten
    if UNSSharedData.LOG.debug then print("Setting off age max = " .. tostring(daysTotallyRotten)) end
  end
  
  local daysFresh = md.offAge
  local daysTotallyRotten = md.offAgeMax
  local deltaDays = (daysFresh - hours) / 24
  if UNSSharedData.LOG.debug then print("Days fresh = " .. tostring(daysFresh - hours)) end
  if UNSSharedData.LOG.debug then print("Days before totally rotten = " .. tostring(daysTotallyRotten - hours)) end
  
  if (daysTotallyRotten - hours) <= 0 and not md.isRotten then
    md.isRotten = true
    item:setTooltip(getText("Tooltip_item_OpenBottleRotten"))
    if UNSSharedData.LOG.debug then print("Set rotten") end
  elseif (daysFresh - hours) <= 0 and not md.isStale then
    md.isStale = true
    item:setTooltip(getText("Tooltip_item_OpenBottleReady"))
    if UNSSharedData.LOG.debug then print("Set stale") end
  else
    item:setTooltip(getText("Tooltip_item_OpenBottleNotReady") .. tostring(UNSSharedData.roundDays(deltaDays, 1)))
  end 
  UNSSharedData.updateOpenWineName(item, deltaDays)  
end