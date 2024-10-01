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

TODO: Recipe.OnTest.CanDecantWine - must be past stale
]]

require "recipecode"
UNSRecipeCode = UNSRecipeCode or {}
UNSRecipeCode.LOG = UNSRecipeCode.LOG or {}
UNSRecipeCode.LOG.debug = getDebug() or false
UNSRecipeCode.LOG.trace = false

function Recipe.OnCreate.OpenWine(items, result, player)
  player:getInventory():AddItem("Base.Cork")
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

function Recipe.OnTest.CanDecantWine(item)
  -- to be removed
  --if item:HowRotten() > 0 then
  if UNSRecipeCode.LOG.debug then print("How rotten: " .. tostring(item:IsRotten()) .. ": " .. tostring(item:HowRotten())) end
  --end
  return item:IsRotten()
end

function UNSRecipeCode.isCorrectBodyLocation(item)
  if item and item:getBodyLocation() then
    local bodyLocs = {'Necklace', 'Necklace_Long', 'Nose', 'Ears', 'EarTop', 'Right_MiddleFinger', 'Left_MiddleFinger', 'Right_RingFinger', 'Left_RingFinger', 'RightWrist', 'LeftWrist', 'BellyButton'}
    for _, v in pairs(bodyLocs) do
      print("Item body loc " .. tostring(item:getBodyLocation()))
      if item:getBodyLocation() == v then
        print("true")
        return true
      end
    end
  end
  print("false")
  return false
end

function Recipe.GetItemTypes.UNSoftMetals(scriptItems)
  local all = getScriptManager():getItemsByType("Clothing")
  local size = all:size()
  print("Got " .. tostring(size) .. " items")
  for i = 0, size - 1 do
    local item = all:get(i)
    if UNSRecipeCode.isCorrectBodyLocation(item) and not scriptItems:contains(item) then
      scriptItems:add(item)
    end
  end
end
