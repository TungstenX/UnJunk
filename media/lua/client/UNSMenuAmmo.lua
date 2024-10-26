--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │ ├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
└────────────────────────────────────────────────────────────────────────────────────────────────────┘

┌───────────────┐
│ UNS Menu Ammo │
└───────────────┘

- This handles the OnFillInventoryObjectContextMenu event for creating molds and casting projectiles
]]

require "UnJunk"
require "UNSUtils"

UNSMenuAmmo = UNSMenuAmmo or {}

function UNSMenuAmmo.onLoad()    
  UNSMenuAmmo.SKILL_METAL_WORK  = 3
  UNSMenuAmmo.CALIBRES          = {}
  UNSMenuAmmo.MUGS              = {}
  UNSMenuAmmo.MUGS_SUBMENU      = {}
  UNSMenuAmmo.TYPE_OF_CRUCIBLES = {}
  UNSMenuAmmo.playerSkills      = {}
  UNSMenuAmmo.textSkillsRed     = {}
  UNSMenuAmmo.textSkillsGreen   = {}
  UNSMenuAmmo.textTooltipHeader = ' <RGB:2,2,2> <LINE> <LINE>' .. getText('Tooltip_craft_Needs') .. ' : <LINE> '
  
  UNSMenuAmmo.CALIBRES["Crucible545"]    = " 5.45mm"
  UNSMenuAmmo.CALIBRES["Crucible556"]    = " 5.56mm"
  UNSMenuAmmo.CALIBRES["Crucible"]       = " 5.7mm"
  UNSMenuAmmo.CALIBRES["Crucible9"]      = " 9mm"
  UNSMenuAmmo.CALIBRES["Crucible30"]     = " 30-cal"
  UNSMenuAmmo.CALIBRES["Crucible38"]     = " 38-cal"
  UNSMenuAmmo.CALIBRES["Crucible44"]     = " 44-cal"
  UNSMenuAmmo.CALIBRES["Crucible45"]     = " 45-cal"
  UNSMenuAmmo.CALIBRES["Crucible50"]     = " 50-cal"
  UNSMenuAmmo.CALIBRES["Crucible00Buck"] = " 00-Buckshot"
  UNSMenuAmmo.MUGS["Mugl"]               = "Empty"
  UNSMenuAmmo.MUGS["MugRed"]             = "Empty"
  UNSMenuAmmo.MUGS["MugWhite"]           = "Empty"
  UNSMenuAmmo.MUGS["MugSpiffo"]          = "Empty"
  UNSMenuAmmo.MUGS["WaterMug"]           = "Water"
  UNSMenuAmmo.MUGS["WaterMugRed"]        = "Water"
  UNSMenuAmmo.MUGS["WaterMugWhite"]      = "Water"
  UNSMenuAmmo.MUGS["WaterMugSpiffo"]     = "Water"
  
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible545") -- 1
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible556") -- 2
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible57")  -- 3
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible9")   -- 4
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible30")  -- 5
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible38")  -- 6
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible44")  -- 7
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible45")  -- 8
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible50")  -- 9
  table.insert(UNSMenuAmmo.MUGS_SUBMENU, "ContextMenu_Make-Crucible00")  -- 10
  
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible545")    -- 1
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible556")    -- 2
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible57")     -- 3
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible9")      -- 4
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible30")     -- 5
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible38")     -- 6
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible44")     -- 7
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible45")     -- 8
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible50")     -- 9
  table.insert(UNSMenuAmmo.TYPE_OF_CRUCIBLES, "Crucible00Buck") -- 10
end
Events.OnLoad.Add(UNSMenuAmmo.onLoad)

function UNSMenuAmmo.preWork(player)
  local itemMap = buildUtil.getMaterialOnGround(player:getCurrentSquare())
  UNSMenuAmmo.groundItemCounts = buildUtil.getMaterialOnGroundCounts(itemMap)
  UNSMenuAmmo.groundItemUses = buildUtil.getMaterialOnGroundUses(itemMap)
  UNSMenuAmmo.buildSkillsList(player)
end

function UNSMenuAmmo.buildSkillsList(player)
  local perks = PerkFactory.PerkList
  local perkID = nil
  local perkType = nil
  for i = 0, perks:size() - 1 do
    perkID = perks:get(i):getId()
    perkType = perks:get(i):getType()
    UNSMenuAmmo.playerSkills[perkID] = player:getPerkLevel(perks:get(i))
    UNSMenuAmmo.textSkillsRed[perkID] = ' <RGB:1,0,0>' .. PerkFactory.getPerkName(perkType) .. ' ' .. UNSMenuAmmo.playerSkills[perkID] .. '/'
    UNSMenuAmmo.textSkillsGreen[perkID] = ' <RGB:1,1,1>' .. PerkFactory.getPerkName(perkType) .. ' '
  end
end

function UNSMenuAmmo.useMaterial(player, material, amount)
  local inv = player:getInventory()
  local typeMaterial = string.split(material, '\\.')[2]
  if tonumber(amount) > 0 then
    local item = inv:getFirstTypeRecurse(typeMaterial)
    if item and instanceof(item, "DrainableComboItem") then
      item:Use()
      return true
    elseif item then
      inv:Remove(item)
      return true
    end
  end
  return false
end

function UNSMenuAmmo.tooltipCheckForMaterial(player, material, amount, tooltip)
  local inv = player:getInventory()
  local typeMaterial = string.split(material, '\\.')[2]
  local invItemCount = 0
  local groundItem = ISBuildMenu.materialOnGround
  if tonumber(amount) > 0 then
    invItemCount = inv:getItemCountFromTypeRecurse(material)

    if groundItem then
      for groundItemType, groundItemCount in pairs(groundItem) do
        if groundItemType == typeMaterial then
          invItemCount = invItemCount + groundItemCount
        end
      end
    end
    
    if invItemCount < amount then
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. ' <LINE>'
      return false
    else
      tooltip.description = tooltip.description .. ' <RGB:0,1,0>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. ' <LINE>'
      return true
    end
  end
end

UNSMenuAmmo.makeCrucible = function(mug, playerIndex, which)
  local player = getSpecificPlayer(playerIndex)
  ISTimedActionQueue.add(UNSTimedCrucible:new(player, mug, which, 50))  
end

function UNSMenuAmmo.tooltipCheckForTool(player, tool, tooltip)
  local tools = UNSTools.getAvailableTool(player:getInventory(), tool)
  if tools then
    tooltip.description = tooltip.description .. ' <RGB:0,1,0>' .. tools:getName() .. ' <LINE>'
    return true
  else
    for _, toolTypes in pairs(UNSTools.TOOLS[tool]) do
      local toolsRequired = ""
      local count = 0
      if toolTypes then
        for _, toolType in pairs(toolTypes) do
          if count > 1 then
            toolsRequired = toolsRequired .. " / "
          end
          count = count + 1
          toolsRequired = toolsRequired .. getItemNameFromFullType(toolType)
        end
      end  
      tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. toolsRequired .. ' <LINE>'
      return false
    end
  end
end

function UNSMenuAmmo.getMaterialUses(player, typeMaterial)    
  local playerInv = player:getInventory()
  local count = playerInv:getUsesTypeRecurse(typeMaterial)
  if UNSMenuAmmo.groundItemUses[typeMaterial] then
    count = count + UNSMenuAmmo.groundItemUses[typeMaterial]
  end
  return count
end

function UNSMenuAmmo.getWater(player, amount)
  local playerInv = player:getInventory()
  local invItem = playerInv:FindAndReturnWaterItem(amount)
  if invItem then
    --that fucntion returns a drainable combo item
    return invItem:getDrainableUsesInt()
  else
    return 0
  end
end

function UNSMenuAmmo.tooltipCheckForWater(player, amount, tooltip)
  local invItemCount = 0
	if amount > 0 then
		invItemCount = UNSMenuAmmo.getWater(player, amount)
		
		local usesText = " (uses)" -- TODO: Translate

		if invItemCount < amount then
			tooltip.description = tooltip.description .. ' <RGB:1,0,0>H2O ' .. invItemCount .. '/' .. amount .. usesText .. ' <LINE>'
			return false
		else
			tooltip.description = tooltip.description .. ' <RGB:0,1,0>H2O ' .. invItemCount .. '/' .. amount .. usesText .. ' <LINE>'
			return true
		end
	end
end

function UNSMenuAmmo.tooltipCheckForUses(player, material, amount, tooltip)
	local invItemCount = 0
	if amount > 0 then
		invItemCount = UNSMenuAmmo.getMaterialUses(player, material)
		
		local usesText = " (uses)"

		if invItemCount < amount then
			tooltip.description = tooltip.description .. ' <RGB:1,0,0>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. usesText .. ' <LINE>'
			return false
		else
			tooltip.description = tooltip.description .. ' <RGB:0,1,0>' .. getItemNameFromFullType(material) .. ' ' .. invItemCount .. '/' .. amount .. usesText .. ' <LINE>'
			return true
		end
	end
end

function UNSMenuAmmo.testOrUse(character, hasWater, tooltip)
  if not character then
    error("[UNS ERROR] Supply character")
    return
  end
  
  local canBuild = true
  local currentResult = true
  
  if UNSRecipe.CRUCIBLE.useConsumable then
    for _, currentMaterial in pairs(UNSRecipe.CRUCIBLE.useConsumable) do
      if not currentMaterial.Consumable then
        for key, consumableData in pairs(currentMaterial) do
          local consumable = consumableData["Consumable"]
          local amount = consumableData["Amount"]
          if tooltip then
            if key > 1 then
              tooltip.description = tooltip.description .. " Or " -- TODO: Translate
            end
            if UNSUtils.hasUseDelta(consumable) then
              currentResult = UNSMenuAmmo.tooltipCheckForUses(character, consumable, amount, tooltip)
            else
              currentResult = UNSMenuAmmo.tooltipCheckForMaterial(character, consumable, amount, tooltip)
           end
          else
            currentResult = UNSMenuAmmo.useMaterial(character, consumable, amount)
          end
          if not currentResult then
            canBuild = false            
            if not tooltip then
              error("[UNS ERROR] " .. string.format("Could not consume item for: %s", consumable or "nil"))
            end
          end       
        end
      elseif currentMaterial.Consumable and currentMaterial.Amount then
        if currentMaterial.Consumable == 'Base.Water' then
          if hasWater then
            if tooltip then
              local usesText = " (uses)" -- TODO: Translate
              tooltip.description = tooltip.description .. ' <RGB:0,1,0>H2O 1/' .. currentMaterial.Amount .. usesText .. ' <LINE>'
            end
            currentResult = true
          else
            if tooltip then
              currentResult = UNSMenuAmmo.tooltipCheckForWater(character, currentMaterial.Amount, tooltip)
            else
              --getWater
              --currentResult = UNSMenuAmmo.useMaterial(character, currentMaterial.Consumable, currentMaterial.Amount)
              --Todo use water
            end
          end
        else
          if UNSUtils.hasUseDelta(currentMaterial.Consumable) then            
            if tooltip then
              currentResult = UNSMenuAmmo.tooltipCheckForUses(character, currentMaterial.Consumable, currentMaterial.Amount, tooltip)              
            else
              currentResult = UNSMenuAmmo.useMaterial(character, currentMaterial.Consumable, currentMaterial.Amount)
            end
          else
            if tooltip then
              currentResult = UNSMenuAmmo.tooltipCheckForMaterial(character, currentMaterial.Consumable, currentMaterial.Amount, tooltip)
            else
              currentResult = UNSMenuAmmo.useMaterial(character, currentMaterial.Consumable, currentMaterial.Amount)
            end
          end
        end        
        if not currentResult then
          canBuild = false
          if not tooltip then
            error("[UNS ERROR] " .. string.format("Could not consume item for: %s", currentMaterial.Consumable or "nil"))
          end
        end 
      else
        canBuild = false
        error("[UNS ERROR] Error in required material definition.")
      end
    end
  end 
  return canBuild
end

function UNSMenuAmmo.canBuildObject(skills, option, player, mugInfo)
  local tooltip = ISToolTip:new()
  tooltip:initialise()
  tooltip:setVisible(false)
  option.toolTip = tooltip

  tooltip.description = UNSMenuAmmo.textTooltipHeader

  local currentResult = true
  
  local canBuild = UNSMenuAmmo.testOrUse(player, mugInfo == "Water", tooltip)
  
  if UNSRecipe.CRUCIBLE.neededTools then
    tooltip.description = tooltip.description .. "<LINE>"
    for _, currentTool in pairs(UNSRecipe.CRUCIBLE.neededTools) do
      currentResult = UNSMenuAmmo.tooltipCheckForTool(player, currentTool, tooltip)    
      if not currentResult then
        canBuild = false
      end
    end
  end

  tooltip.description = tooltip.description .. ' <LINE>'
  if skills then
    for _, skill in pairs (skills) do
      local localSkillName = skill.Skill
      local level = skill.Level
      if (UNSMenuAmmo.playerSkills[localSkillName] < level) then
        tooltip.description = tooltip.description .. UNSMenuAmmo.textSkillsRed[localSkillName]
        canBuild = false
      else
        tooltip.description = tooltip.description .. UNSMenuAmmo.textSkillsGreen[localSkillName]
      end
      tooltip.description = tooltip.description .. level .. ' <LINE>'
    end
  end

  
  if not canBuild then -- and not ISBuildMenu.cheat
    option.onSelect = nil
    option.notAvailable = true
  end
  return tooltip
end

function UNSMenuAmmo.mugMenuBuilder(subMenu, playerNum, player, mug, mugInfo)
  local option
  local tooltip
  local name = '' 
  
	--path
  for k, v in pairs(UNSMenuAmmo.MUGS_SUBMENU) do
    name = getText(v)
    option = subMenu:addOption(name, mug, UNSMenuAmmo.makeCrucible, playerNum, k)
    tooltip = UNSMenuAmmo.canBuildObject(UNSRecipe.CRUCIBLE.skills, option, player, mugInfo)
    tooltip:setName(name)
    tooltip.description = getText('Tooltip_item_crucible') .. tooltip.description
  end
end  

local function isInSameRoom(isoRoom1, isoRoom2)
  if isoRoom1 == nil and isoRoom2 == nil then
    return true
  elseif isoRoom1 ~= nil and isoRoom2 ~= nil and isoRoom1:getName() == isoRoom2:getName() then
    return true
  else
    return false
  end
end

function UNSMenuAmmo.isNearSprite(player, spriteNames)
  local sq0 = player:getCurrentSquare()
  local playerRoom = sq0:getRoom()
  local squares = {
    sq0,
    getSquare(sq0:getX() + 1, sq0:getY() + 1, sq0:getZ()),
    getSquare(sq0:getX() + 1, sq0:getY(), sq0:getZ()),
    getSquare(sq0:getX() + 1, sq0:getY() - 1, sq0:getZ()),
    getSquare(sq0:getX(), sq0:getY() - 1, sq0:getZ()),
    getSquare(sq0:getX() - 1, sq0:getY() - 1, sq0:getZ()),    
    getSquare(sq0:getX() - 1, sq0:getY(), sq0:getZ()),
    getSquare(sq0:getX() - 1, sq0:getY() + 1, sq0:getZ()),
    getSquare(sq0:getX(), sq0:getY() + 1, sq0:getZ()),
  }
  
  for _, square in pairs(squares) do
    local isoRoom = square:getRoom()
    if isInSameRoom(playerRoom, isoRoom) then 
      local objects = square:getObjects()
      local size = objects:size()
      for i = 0, size - 1 do
        local object = objects:get(i)
        local sprite = object:getSprite()
        if sprite then
          for _, sprintName in pairs(spriteNames) do
            if sprintName == sprite:getName() then
              return object
            end
          end
        end
      end
    end
  end  
end

function UNSMenuAmmo.metlToScrap(items, charcoalItems, object, player)
  local numberOfItems = #items
  local numberOfCharoal = charcoalItems:size()
  if numberOfItems > numberOfCharoal then
    numberOfItems = numberOfCharoal
  end
  
  local index = 0
  for _, item in pairs(items) do
    if index == numberOfItems then
      break
    end
    local charcoal = charcoalItems:get(index)
    ISTimedActionQueue.add(UNSTimedMelting:new(player, item, charcoal, object, 200)) 
  end
end

function UNSMenuAmmo.getCharcoal(player)
  local inv = player:getInventory()
  return inv:getAllTypeRecurse("Charcoal")
end

UNSMenuAmmo.OnFillInventoryObjectContextMenu = function(playerIndex, context, items)
  local player = getSpecificPlayer(playerIndex)
  if player:getVehicle() then
    return -- can't work in a vehicle
  end
  
  local crucible = nil
  local calibre = nil
  local mug = nil
  local mugInfo = nil  
  local tempItem = nil
  local metalicItems = {}

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
      calibre = UNSMenuAmmo.CALIBRES[tempItem:getType()]
      mugInfo = UNSMenuAmmo.MUGS[tempItem:getType()]
      if calibre ~= nil then
        crucible = tempItem
      elseif mugInfo ~= nil then
        mug = tempItem
      end
      if tempItem:getMetalValue() > 0.0 then
        table.insert(metalicItems, tempItem)
      end
    end
  end

  tempItem = nil
  if crucible or mug then  
    UNSMenuAmmo.preWork(player)
  end
	if crucible then
  -- Using normal recipes for this?
	-- 	context:addOption(getText("ContextMenu_Cast") .. calibre, items, UNSMenuAmmo.castProjectile, crucible, player)
	end
	if mug then
    local menu = context:addOption(getText("ContextMenu_Mug"))
    local subMenu = ISContextMenu:getNew(context)
    context:addSubMenu(menu, subMenu)
    UNSMenuAmmo.mugMenuBuilder(subMenu, playerIndex, player, mug, mugInfo)		
  end
  
  if #metalicItems > 0 then
    -- scan tiles around player for machine_20
    local object = UNSMenuAmmo.isNearSprite(player, {"machinestile_20", "machinestile_21"})
    if object then
      local which = getText("ContextMenu_MeltItemToScrap")
      if #metalicItems > 1 then
        which = getText("ContextMenu_MeltItemsToScrap") .. " (" .. tostring(#metalicItem) .. ")"
      end
      local charcoalItems = UNSMenuAmmo.getCharcoal(player)
      if charcoalItems and charcoalItems:size() > 0 then
        context:addOption(which, metalicItems, UNSMenuAmmo.metlToScrap, charcoalItems, object, player)
      end
    end
  end

  return context
end
Events.OnFillInventoryObjectContextMenu.Add(UNSMenuAmmo.OnFillInventoryObjectContextMenu)