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

UNSMenuAmmo.castProjectile = function(worldobjects, player, item)
  print(tostring(worldobjects))
  print(tostring(player))
  print(tostring(item))
end

UNSMenuAmmo.makeCrucible = function(mug, player, which)
  ISTimedActionQueue.add(UNSTimedCrucible.new(player, mug, which, 50))
  
end

function UNSMenuAmmo.tooltipCheckForTool(player, tool, tooltip)
  local tools = UNSTools.getAvailableTool(player:getInventory(), tool)
  if tools then
    tooltip.description = tooltip.description .. ' <RGB:1,1,1>' .. tools:getName() .. ' <LINE>'
    return true
  else
    for _, toolT in pairs (UNSTools.TOOLS[tool]) do
      local toolsRequired = ""
      local count = 0
      if toolT and toolT.types then
        for _, toolType in pairs (toolT.types) do
          if count > 1 then
            toolsRequired = toolsRequired + " / "
          end
          count = count + 1
          toolsRequired = toolsRequired + getItemNameFromFullType(toolType)
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

function UNSMenuAmmo.canBuildObject(skills, option, player, mugInfo)
  local tooltip = ISToolTip:new()
  tooltip:initialise()
  tooltip:setVisible(false)
  option.toolTip = tooltip

  tooltip.description = UNSMenuAmmo.textTooltipHeader

  local canBuild = true
  local currentResult = true
  
  for _, currentMaterial in pairs(UNSRecipe.CRUCIBLE.useConsumable) do
    if not currentMaterial.Consumable then
      for k, v in pairs(currentMaterial) do
        local consumable = v["Consumable"]
        local amount = v["Amount"]
        if k > 1 then
          tooltip.description = tooltip.description .. "Or " -- TODO: Translate
        end
        if UNSUtils.hasUseDelta(consumable) then
          currentResult = UNSMenuAmmo.tooltipCheckForUses(player, consumable, amount, tooltip)
        else
          currentResult = UNSMenuAmmo.tooltipCheckForMaterial(player, consumable, amount, tooltip)
       end
        if not currentResult then
          canBuild = false
        end       
      end
    elseif currentMaterial.Consumable and currentMaterial.Amount then
      if currentMaterial.Consumable == 'Base.Water' then
        if mugInfo == "Water" then
          local usesText = " (uses)" -- TODO: Translate
          tooltip.description = tooltip.description .. ' <RGB:0,1,0>H2O 1/' .. currentMaterial.Amount .. usesText .. ' <LINE>'
          currentResult = true
        else
          currentResult = UNSMenuAmmo.tooltipCheckForWater(player, currentMaterial.Amount, tooltip)
        end
      else
        if UNSUtils.hasUseDelta(currentMaterial.Consumable) then
          currentResult = UNSMenuAmmo.tooltipCheckForUses(player, currentMaterial.Consumable, currentMaterial.Amount, tooltip)
        else
          currentResult = UNSMenuAmmo.tooltipCheckForMaterial(player, currentMaterial.Consumable, currentMaterial.Amount, tooltip)
        end
        if not currentResult then
          canBuild = false
        end
      end
    else
      tooltip.description = tooltip.description .. ' <RGB:1,0,0> Error in required material definition. <LINE>'
      canBuild = false
    end
  end
  
  for _, currentTool in pairs(UNSRecipe.CRUCIBLE.neededTools) do
    currentResult = UNSMenuAmmo.tooltipCheckForTool(player, currentTool, tooltip)    
    if not currentResult then
      canBuild = false
    end
  end

  tooltip.description = tooltip.description .. ' <LINE>'
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

  if not canBuild and not ISBuildMenu.cheat then
    option.onSelect = nil
    option.notAvailable = true
  end
  return tooltip
end


function UNSMenuAmmo.mugMenuBuilder(subMenu, playerNum, player, mug, mugInfo)
  local option
  local tooltip
  local name = '' 
  print("PlayerNum = ", tostring(playerNum))
	--path
  for k, v in pairs(UNSMenuAmmo.MUGS_SUBMENU) do
    name = getText(v)
    option = subMenu:addOption(name, mug, UNSMenuAmmo.makeCrucible, playerNum, k)
    tooltip = UNSMenuAmmo.canBuildObject(UNSRecipe.CRUCIBLE.skills, option, player, mugInfo)
    tooltip:setName(name)
    tooltip.description = getText('Tooltip_item_crucible') .. tooltip.description
  end
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
    end
  end

  tempItem = nil
  if crucible or mug then  
    UNSMenuAmmo.preWork(player)
  end
	if crucible then
		context:addOption(getText("ContextMenu_Cast") .. calibre, items, UNSMenuAmmo.castProjectile, crucible, player)
	end
	if mug then
    local menu = context:addOption(getText("ContextMenu_Mug"))
    local subMenu = ISContextMenu:getNew(context)
    context:addSubMenu(menu, subMenu)
    UNSMenuAmmo.mugMenuBuilder(subMenu, playerIndex, player, mug, mugInfo)		
  end

  return context
end
Events.OnFillInventoryObjectContextMenu.Add(UNSMenuAmmo.OnFillInventoryObjectContextMenu)