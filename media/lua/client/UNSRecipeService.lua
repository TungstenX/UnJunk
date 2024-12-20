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

┌────────────────────────────────┐
│ UNS Recipe Serivce for Complex │
└────────────────────────────────┘
]]
require "UnJunk/UNSSharedData"
UNSRecipeService = UNSRecipeService or {}

function UNSRecipeService.everyDays()
  UNSSharedData.updateJerkyItems()
  UNSSharedData.updateOpenWineItems()
end    
Events.EveryDays.Add(UNSRecipeService.everyDays)

function UNSRecipeService.OnGameStart()
  local allItems = getAllItems()

  for i = 0, allItems:size()-1 do
    local item = allItems:get(i)
    local md = item:getModData()
    if md.Jerky and not md.isReady then
      UNSSharedData.addJerkyItems(item)
    elseif md.OpenWine or md.OpenWineCovered then
      UNSSharedData.addOpenWineItems(item)
    end
  end
  
  UNSSharedData.updateJerkyItems()
  UNSSharedData.updateOpenWineItems()
end
Events.OnGameStart.Add(OnGameStart)