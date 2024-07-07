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

function Recipe.OnTest.CanDecantWine(item)
  --print("How rotten: ", tostring(item:HowRotten()))
  return item:IsRotten()
end