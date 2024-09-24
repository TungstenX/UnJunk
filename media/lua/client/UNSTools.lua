--[[
┌────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ _/_/_/_/_/  _/    _/  _/      _/    _/_/_/    _/_/_/  _/_/_/_/_/  _/_/_/_/  _/      _/  _/      _/ │    
│    _/      _/    _/  _/_/    _/  _/        _/            _/      _/        _/_/    _/    _/  _/    │   
│   _/      _/    _/  _/  _/  _/  _/  _/_/    _/_/        _/      _/_/_/    _/  _/  _/      _/       │   
│  _/      _/    _/  _/    _/_/  _/    _/        _/      _/      _/        _/    _/_/    _/  _/      │   
│ _/        _/_/    _/      _/    _/_/_/  _/_/_/        _/      _/_/_/_/  _/      _/  _/      _/     │   
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ © Copyright 2024                                                                                   │ 
├────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ Credits:                                                                                           │
│   El1oN's Building Menu mod                                                                        │
│   Workshop ID: 3067798182                                                                          │
│   Mod ID: BuildingMenu                                                                             │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
]]

UNSTools = UNSTools or {}

UNSTools.TOOLS = UNSTools.TOOLS or {}
UNSTools.TOOLS = {
  Hammer = {
    types = {
      'Base.Hammer',
      'Base.HammerStone',
      'Base.BallPeenHammer',
      'Base.ClubHammer',
      'ToolsOfTheTrade.BrickHammer',     --Tools of the Trade
      'ToolsOfTheTrade.StubbyHammer',    --Tools of the Trade
      'MWPWeapons.oxnailhammer',         -- [Reworked] MWPWeapons
      'MWPWeapons.fatmaxbrickhammer',    -- [Reworked] MWPWeapons
      'MWPWeapons.m48tacticalwarhammer', -- [Reworked] MWPWeapons
    },
    tags = { 'Hammer' }
  },
  Sledgehammer = {
    types = {
      'Base.Sledgehammer',
      'Base.Sledgehammer2',
      'ToolsOfTheTrade.PoliceBreachingHammer',           --Tools of the Trade
      'ToolsOfTheTrade.RailwaySpikeHammer',              --Tools of the Trade
      'ToolsOfTheTrade.WarHammer',                       --Tools of the Trade
      'ToolsOfTheTrade.IndustrialBreachingHammer',       --Tools of the Trade
      'ToolsOfTheTrade.CoreHammer',                      --Tools of the Trade
      'ToolsOfTheTrade.RailroadHammer',                  --Tools of the Trade
      'ToolsOfTheTrade.RebarHammer',                     --Tools of the Trade
      'ToolsOfTheTrade.DefilerSledgehammer',             --Tools of the Trade
      'ToolsOfTheTrade.DespoilerSledgehammer',           --Tools of the Trade
      'SWeapons.SalvagedSledgehammer',                   -- Scrap Weapons
      'SWeapons.GearMace',                               -- Scrap Weapons
      'SWeapons.HugeScrapPickaxe',                       -- Scrap Weapons
      'MWPWeapons.roughneckgorillasledgehammer',         -- [Reworked] MWPWeapons
      'AuthenticZClothing.AuthenticTagillaSledgehammer', -- Authentic Z
      'KWP.StoneSledgehammer',                           -- Kwin's Melee Weapon Pack
    },
    tags = { 'Sledgehammer' }
  },  
  Paintbrush = {
    types = { 'Base.Paintbrush' },
      tags = {}
  },  
  Screwdriver = {
    types = {
      'Base.Screwdriver',
      'ToolsOfTheTrade.Multitool',      --Tools of the Trade
      'ToolsOfTheTrade.SpiffArmyKnife', --Tools of the Trade
    },
    tags = { 'Screwdriver' }
  },
  Saw = {
    types = {
      'Base.Saw',
      'Base.GardenSaw',
      'ToolsOfTheTrade.Backsaw',  -- Tools of the Trade
      'ToolsOfTheTrade.RyobaSaw', -- Tools of the Trade
    },
    tags = { 'Saw' }
  },
  HandShovel = {
    types = {
      'farming.HandShovel',
      'SOMW.SharpTrowel',
      'ToolsOfTheTrade.Adze', --Tools of the Trade
    },
    tags = {}                   --'DigPlow' > this includes shovels
  },
  Shovel = {
    types = {
      'Base.Shovel',
      'SOMW.EntrenchingShovel',            --SOMW
      'MWPWeapons.sptesnaztacticalshovel', -- [Reworked] MWPWeapons
      'ToolsOfTheTrade.TrenchShovel'       -- Tools of the Trade
    },
    tags = {}
  },
  BlowTorch = { -- 
    types = { 'Base.BlowTorch' },
    tags = {}
  },
  WeldingMask = {
    types = {
      'Base.WeldingMask',
      'AuthenticZClothing.Hat_TagillaMask2', -- Authentic Z
      'AuthenticZClothing.Hat_TagillaMask',  -- Authentic Z
      'Base.Hat_WelderMask2'                 -- Scrap Armor
    },
    tags = { 'WeldingMask' }
  },
  Needle = {
    types = { 'Base.Needle' },
    tags = { 'SewingNeedle' }
  },
  Wrench = {
    types = {
      'Base.PipeWrench',
      'Base.Wrench'
    },
    tags = {}
  },
  Scissors = {
    types = {
      'Base.Scissors',
      'ToolsOfTheTrade.BandageScissors',
      'ToolsOfTheTrade.SpiffArmyKnife',
      'ToolsOfTheTrade.Multitool'
    },
    tags = { 'Scissors' }
  },
  WoodenStick = {
    types = {
      'Base.WoodenStick',
    },
    tags = {}
  },
  SharpKnife = {
    types = {
      "Base.FlintKnife",
      "Base.HuntingKnife",
      "Base.KitchenKnife", 
      "Base.Machete",
    },
    tags = {
      "SharpKnife",
    }
  }
}

-- Gets the available tool from the inventory
-- @param inv ItemContainer
-- @param tool string
-- @return InventoryItem|nil
function UNSTools.getAvailableTool(inv, tool)
  local toolInfo = UNSTools.TOOLS[tool];
  if toolInfo.types then
    for _, type in ipairs(toolInfo.types) do
      --@diagnostic disable-next-line: param-type-mismatch
      local item = inv:getBestTypeEvalRecurse(type, UNSUtils.predicateNotBroken)
      if item then return item end
    end
  end
  if toolInfo.tags then
    for _, tag in ipairs(toolInfo.tags) do
      --@diagnostic disable-next-line: param-type-mismatch
      local item = inv:getBestEvalRecurse(function(item) return UNSUtils.predicateHasTag(item, tag) end,
        --@diagnostic disable-next-line: param-type-mismatch
        function(item) return true end)
      if item then return item end
    end
  end
  return nil
end