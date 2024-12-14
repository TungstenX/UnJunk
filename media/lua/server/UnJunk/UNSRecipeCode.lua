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
require "recipecode"
require "UnJunk/UNSSharedData"

UNSRecipeCode = UNSRecipeCode or {}
UNSRecipeCode.LOG = UNSRecipeCode.LOG or {}
UNSRecipeCode.LOG.debug = getDebug() or false
UNSRecipeCode.LOG.trace = false

function Recipe.OnCreate.OpenWine(items, result, player)
  player:getInventory():AddItem("Base.Cork")
  local md = result:getModData()
  md.OpenWine = true
  UNSSharedData.addOpenWineItems(result)
end

function Recipe.OnCreate.CoverOpenWine(items, result, player)
  local md = result:getModData()
  md.OpenWineCovered = true
  UNSSharedData.addOpenWineItems(result)
end

function Recipe.OnCreate.DecantCoveredWine(items, result, player)
  player:getInventory():AddItem("Base.RubberBand")
  player:getInventory():AddItem("Base.DishClothWet")
  if ZombRand(10) >= 5 then
    player:getInventory():AddItem("Base.WineEmpty")
  else
    player:getInventory():AddItem("Base.WineEmpty2")
  end
end

function Recipe.OnTest.IsCookedMeat(sourceItem, result)    
  if sourceItem:getFullType() == "Base.Rabbitmeat" or sourceItem:getFullType() == "Base.Smallanimalmeat" or sourceItem:getFullType() == "Base.Smallbirdmeat"  or sourceItem:getFullType() == "Base.FrogMeat" then
    return sourceItem:isCooked() or sourceItem:isBurnt()
  end
  return true
end

function Recipe.OnTest.IsUncookedMeat(sourceItem, result)
  if sourceItem:getFullType() == "Base.Rabbitmeat" or sourceItem:getFullType() == "Base.Smallanimalmeat" or sourceItem:getFullType() == "Base.Smallbirdmeat"  or sourceItem:getFullType() == "Base.FrogMeat" then
    return not (sourceItem:isCooked() or sourceItem:isBurnt())
  end
  return true
end

-- FrogMeat = 1 can
-- Smallanimalmeat = 2 cans
-- Smallbirdmeat = 2 cans
-- Rabbitmeat = 3 cans
function Recipe.OnCreate.CompleteLardedMeat(items, result, player)
  local size = items:size()
  for i = 0, size - 1 do
    local meat = items:get(i):getType()
    if meat == "Smallanimalmeat" or meat == "Smallbirdmeat" then
      player:getInventory():AddItem(result:getFullType())
      break -- out of loop
    elseif meat == "Rabbitmeat" then
      player:getInventory():AddItem(result:getFullType())      
      player:getInventory():AddItem(result:getFullType())
      break -- out of loop
    end
  end
end

-- FrogMeat = 1 jerky
-- Smallanimalmeat = 2 jerky
-- Smallbirdmeat = 2 jerky
-- Rabbitmeat = 3 jerky
function Recipe.OnCreate.CompleteJerkyMeat(items, result, player)
  local mdResult = result:getModData()
  local daysFresh = hours + (UNSSharedData.JERKY_FRESH_DAYS * 24)
  local delta = (daysFresh - hours) / 24
  mdResult.offAge = daysFresh
  mdResult.Jerky = true
  result:setPoisonPower(delta * 10)
  UNSSharedData.updateJerkyName(result, delta)  
  result:setTooltip(getText("Tooltip_item_JerkyNotReady") .. tostring(UNSSharedData.roundDays(delta, 1))) 
  UNSSharedData.addJerkyItems(result)
  
  local size = items:size()
  for i = 0, size - 1 do
    local meat = items:get(i):getType()
    if meat == "Smallanimalmeat" or meat == "Smallbirdmeat" then
      UNSSharedData.addMoreJerky(result:getFullType(), daysFresh, delta, player)
      break -- out of loop
    elseif meat == "Rabbitmeat" then
      UNSSharedData.addMoreJerky(result:getFullType(), daysFresh, delta, player)
      UNSSharedData.addMoreJerky(result:getFullType(), daysFresh, delta, player)
      break -- out of loop
    end
  end
end

function Recipe.OnTest.CanDecantWine(sourceItem, result)
  --if sourceItem:getFullType() == "Base.OpenWineCovered" then
  local md = sourceItem:getModData()
  if md.OpenWineCovered then
    return not md.isRotten and md.isStale
  end
  return true
end

function UNSRecipeCode.isCorrectBodyLocation(item)
  if item and item:getBodyLocation() then
    local bodyLocs = {'Necklace', 'Necklace_Long', 'Nose', 'Ears', 'EarTop', 'Right_MiddleFinger', 'Left_MiddleFinger', 'Right_RingFinger', 'Left_RingFinger', 'RightWrist', 'LeftWrist', 'BellyButton'}
    for _, v in pairs(bodyLocs) do
      if item:getBodyLocation() == v then
        return true
      end
    end
  end
  return false
end

function Recipe.GetItemTypes.UNSoftMetals(scriptItems)
  local all = getScriptManager():getItemsByType("Clothing")
  local size = all:size()
  for i = 0, size - 1 do
    local item = all:get(i)
    if UNSRecipeCode.isCorrectBodyLocation(item) and not scriptItems:contains(item) then
      scriptItems:add(item)
    end
  end
end

function Recipe.OnCreate.DismantleSeat(items, result, player)
  if ZombRand(10) >= 5 then
    player:getInventory():AddItems("Base.LeatherStrips", 5)
  else
    player:getInventory():AddItems("Base.RippedSheets", 5)
  end
  player:getInventory():AddItem("Base.Wire")
  player:getInventory():AddItems("Base.SmallSheetMetal", 2)
  player:getInventory():AddItems("Base.Screws", 7)
end

function Recipe.OnCreate.CompleteDrumCut(items, result, player)
  -- remove from inventory
  local constainer = result:getContainer()
  if UNSRecipeCode.LOG.debug then
    print("CompleteDrumCut called")
  end
    
  local sq = player:getCurrentSquare()
  local spriteName = "crafted_01_24"
  local modData = {}
	modData["haveCharcoal"] = false
	modData["haveLogs"] = false
	modData["isLit"] = false
	modData["waterAmount"] = 0.0
	modData["waterMax"] = 800
	modData["taintedWater"] = false

	local cell = getWorld():getCell()
	local north = false
	local metalDrum = IsoThumpable.new(cell, sq, spriteName, north, modData)

	metalDrum:setCanPassThrough(false)
	metalDrum:setCanBarricade(false)
	metalDrum:setThumpDmg(8)
	metalDrum:setIsContainer(false)
	metalDrum:setIsDoor(false)
	metalDrum:setIsDoorFrame(false)
	metalDrum:setCrossSpeed(1.0)
	metalDrum:setBlockAllTheSquare(true)
	metalDrum:setName("MetalDrum")
	metalDrum:setIsDismantable(true)
	metalDrum:setCanBePlastered(false)
	metalDrum:setIsHoppable(false)
	metalDrum:setIsThumpable(true)
	metalDrum:setModData(copyTable(modData))
	metalDrum:setMaxHealth(200)
	metalDrum:setHealth(200)
	metalDrum:setBreakSound("BreakObject")
	metalDrum:setSpecialTooltip(true)

	metalDrum:setWaterAmount(0.0)

	sq:AddSpecialObject(metalDrum, 1)
	metalDrum:transmitCompleteItemToClients()

  if isClient() then metalDrum:transmitCompleteItemToServer() end
  -- for RainCollectorBarrel in singleplayer
  triggerEvent("OnObjectAdded", metalDrum) 
  getTileOverlays():fixTableTopOverlays(sq)
  sq:RecalcProperties()
  sq:RecalcAllWithNeighbours(true)
  triggerEvent("OnContainerUpdate")
  IsoGenerator.updateGenerator(sq)
end
