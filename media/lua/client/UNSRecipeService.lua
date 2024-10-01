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
UNSRecipeService = UNSRecipeService or {}
UNSRecipeService.WINE_FRESH_DAYS = 7
UNSRecipeService.WINE_ROTTEN_DAYS = 14
UNSRecipeService.JERKY_FRESH_DAYS = 7

function UNSRecipeService.updateOpenWIneBottle(drainableComboItem)
  local hours = math.floor(getGameTime():getWorldAgeHours())
  local md = drainableComboItem:getModData()
  if not md then
    if UnJunk.LOG.debug then print("No mod data") end --
    return  
  elseif md.isRotten then
    if UnJunk.LOG.debug then print("Already rotten") end
    return
  end
  
  if not md.offAge then
    local daysFresh = hours + (UNSRecipeService.WINE_FRESH_DAYS * 24)
    md.offAge = daysFresh
    if UnJunk.LOG.debug then print("Setting off age = " .. tostring(daysFresh)) end
  end

  if not md.offAgeMax then
    local daysTotallyRotten = hours + (UNSRecipeService.WINE_ROTTEN_DAYS * 24)
    md.offAgeMax = daysTotallyRotten
    if UnJunk.LOG.debug then print("Setting off age max = " .. tostring(daysTotallyRotten)) end
  end
  
  local daysFresh = md.offAge
  local daysTotallyRotten = md.offAgeMax
  if UnJunk.LOG.debug then print("Days fresh = " .. tostring(daysFresh - hours)) end
  if UnJunk.LOG.debug then print("Days before totally rotten = " .. tostring(daysTotallyRotten - hours)) end
  
  if (daysTotallyRotten - hours) <= 0 and not md.isRotten then
    md.isRotten = true
    drainableComboItem:setTooltip(getText("Tooltip_item_OpenBottleRotten"))
    if UnJunk.LOG.debug then print("Set rotten") end
  elseif (daysFresh - hours) <= 0 and not md.isStale then
    md.isStale = true
    drainableComboItem:setTooltip(getText("Tooltip_item_OpenBottleReady"))
    if UnJunk.LOG.debug then print("Set stale") end
  else
    local deltaDays = (daysFresh - hours) / 24
    drainableComboItem:setTooltip(getText("Tooltip_item_OpenBottleNotReady") .. tostring(deltaDays))
  end  
end

function UNSRecipeService.updateJerky(jerkyItem)
  local hours = math.floor(getGameTime():getWorldAgeHours())
  local md = jerkyItem:getModData()
  if not md then
    if UnJunk.LOG.debug then print("No mod data") end --
    return
  elseif md.isReady then
    if UnJunk.LOG.debug then print("Already ready") end
    return
  end
  
  if not md.offAge then
    local daysFresh = hours + (UNSRecipeService.JERKY_FRESH_DAYS  * 24)
    local delta = (daysFresh - hours) / 24
    md.offAge = daysFresh
    jerkyItem:setbDangerousUncooked(true)
    jerkyItem:setPoisonPower(delta * 10)
    jerkyItem:setUnCookedString("(" .. getText("JerkyWet") .. ")")  
    if UnJunk.LOG.debug then print("Setting off age = " .. tostring(daysFresh)) end
  end
  
  local daysFresh = md.offAge
  if UnJunk.LOG.debug then print("Days fresh = " .. tostring(daysFresh - hours)) end
  
  if (daysFresh - hours) <= 0 and not md.isReady then
    md.isReady = true    
    jerkyItem:setbDangerousUncooked(false)
    jerkyItem:setPoisonPower(0)
    jerkyItem:setCooked(true)
    jerkyItem:setCookedString("(" .. getText("JerkyDry") .. ")")    
    jerkyItem:setTooltip(getText("Tooltip_item_JerkyReady"))  
    if UnJunk.LOG.debug then print("Set ready") end
  else
    local delta = (daysFresh - hours) / 24
    jerkyItem:setPoisonPower(delta * 10) 
    jerkyItem:setTooltip(getText("Tooltip_item_JerkyNotReady") .. tostring(delta)) 
  end  
end
  
function UNSRecipeService.traverseItems(items)  
  if UnJunk.LOG.trace then print("traverseItems #items = " .. tostring(#items)) end
  local possibleItemsToUpdate = {}
  local itemsToUpdate = {}
  for _, item in pairs(items) do
    if UnJunk.LOG.trace then print("traverseItems item = " .. tostring(item)) end
    if type(item) == "table" then
      for key, prop in pairs(item) do
        if UnJunk.LOG.trace then print("traverseItems prop [" .. tostring(key) .. "] " .. tostring(prop)) end
        if key == "items" then
          for _, propItem in pairs(prop) do
            if UnJunk.LOG.trace then print("traverseItems propItem = " .. tostring(propItem)) end
            local md = propItem:getModData()
            if (md and (md.OpenWine or md.OpenWineCovered or md.Jerky)) or instanceof(propItem, "DrainableComboItem") or (instanceof(propItem, "Food") and propItem:getFoodType() == "Game") then
              if UnJunk.LOG.trace then print("traverseItems Adding to possible items = ") end
              table.insert(possibleItemsToUpdate, propItem)
            end
          end
        end
      end      
    else
      if UnJunk.LOG.debug then print("traverseItems item is not a table: " .. type(item)) end
    end
  end
  
  if #possibleItemsToUpdate > 0 then
    if UnJunk.LOG.trace then print("traverseItems Possible items found: " .. tostring(#possibleItemsToUpdate)) end
    for _, item in pairs(possibleItemsToUpdate) do
      local md = item:getModData()
      if md and (md.OpenWine or md.OpenWineCovered or md.Jerky) then
        table.insert(itemsToUpdate, item)
      else
        if UnJunk.LOG.trace then print("\ttraverseItems Tags:") end
        local size = item:getTags():size()
        for i = 0, size - 1 do
          local tag = item:getTags():get(i)
          if UnJunk.LOG.trace then print("\t\t" .. tostring(tag)) end
          if tag == "OpenWineCovered" then
            md.OpenWineCovered = true
          elseif tag == "OpenWine" then
            md.OpenWine = true
          elseif tag == "Jerky" then
            md.Jerky = true
          end
          if md.OpenWine or md.OpenWineCovered then            
            table.insert(itemsToUpdate, item)
          end
        end
      end
    end
  else
    if UnJunk.LOG.trace then print("traverseItems No possible items found") end
  end
  
  if #itemsToUpdate > 0 then
    if UnJunk.LOG.trace then print("traverseItems items found: " .. tostring(#itemsToUpdate)) end
    for _, v in pairs(itemsToUpdate) do
      local md = v:getModData()
      if md.OpenWine or md.OpenWineCovered then
        UNSRecipeService.updateOpenWIneBottle(v)
      elseif md.Jerky then
        UNSRecipeService.updateJerky(v)        
      end
    end
  else
    if UnJunk.LOG.trace then print("traverseItems No items found") end
  end
end

function UNSRecipeService.decant(worldobjects, player, item)
  print("worldobjects: " .. tostring(worldobjects))
  print("player:       " .. tostring(player))
  print("item:         " .. tostring(item))
end

function UNSRecipeService.OnFillInventoryObjectContextMenu(playerIndex, table, items)
  UNSRecipeService.traverseItems(items)
  
  local tempItem = nil
  local openWineCovered = nil
  for _,v in ipairs(items) do
    if not instanceof(v, "InventoryItem") then
      if #v.items == 2 then
        tempItem = v.items[1]
      end
      tempItem = v.items[1]
    else
      tempItem = v
    end

    if tempItem then
      local md = tempItem:getModData()
      if md.OpenWineCovered and not md.isRotten and md.isStale then
        openWineCovered = tempItem
      end
    end
  end

  tempItem = nil
	if openWineCovered then
		context:addOption(getText("ContextMenu_Decant_Vinegar"), items, UNSRecipeService.decant, openWineCovered, player)
	end
end
Events.OnFillInventoryObjectContextMenu.Add(UNSRecipeService.OnFillInventoryObjectContextMenu)
