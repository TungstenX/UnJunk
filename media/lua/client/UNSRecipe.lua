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

┌───────────┐
│ UNSRecipe │
└───────────┘
]]
UNSRecipe = UNSRecipe or {}

UNSMaterials = UNSMaterials or {}
UNSMaterials.SAND_USED  = 0.25 -- the delta
UNSMaterials.WATER_USED = 1
UNSMaterials.BLOW_TORCH = 1
UNSMaterials.METAL_WELDING_XP_PER_LEVEL = 3.5

-- NOT USED - KEEPING IN CASE?
UNSMaterials.GROUPS_ALTERNATIVES = {}
UNSMaterials.GROUPS_ALTERNATIVES = {
  Ropes = {
    {
      Item = "Base.Rope",
      Multiplier = 1,
    },
    {
      Item = "Base.SheetRope",
      Multiplier = 1,
    }
  }
}

UNSRecipe.CRUCIBLE = UNSRecipe.CRUCIBLE or {}
UNSRecipe.CRUCIBLE = {
  neededTools = {
    "WoodenStick",
    "SharpKnife",
  },
  useConsumable = {
    {
      Consumable = "Base.Water",
      Amount = UNSMaterials.WATER_USED
    },
    {
      Consumable = "Base.Sandbag",
      Amount = UNSMaterials.SAND_USED
    },
  },
}

UNSRecipe.LEAD = UNSRecipe.LEAD or {}
UNSRecipe.LEAD = {
  neededTools = {    
    "BlowTorch",
    "WeldingMask",
    "Screwdriver",
  },
  neededMaterials = {
    {
      Materials = "Necklace_DogTag/Necklace_Gold/Necklace_GoldRuby/Necklace_GoldDiamond/Necklace_Silver/Necklace_SilverSapphire/Necklace_SilverCrucifix/Necklace_SilverDiamond/Necklace_Crucifix/Necklace_YingYang/Necklace_Pearl/NecklaceLong_Gold/NecklaceLong_GoldDiamond/NecklaceLong_Silver/NecklaceLong_SilverEmerald/NecklaceLong_SilverSapphire/NecklaceLong_SilverDiamond/NecklaceLong_Amber/NoseRing_Gold/NoseRing_Silver/NoseStud_Gold/NoseStud_Silver/Earring_LoopLrg_Gold/Earring_LoopLrg_Silver/Earring_LoopMed_Silver/Earring_LoopMed_Gold/Earring_LoopSmall_Silver_Both/Earring_LoopSmall_Silver_Top/Earring_LoopSmall_Gold_Both/Earring_LoopSmall_Gold_Top/Earring_Stud_Gold/Earring_Stud_Silver/Earring_Stone_Sapphire/Earring_Stone_Emerald/Earring_Stone_Ruby/Earring_Pearl/Earring_Dangly_Sapphire/Earring_Dangly_Emerald/Earring_Dangly_Ruby/Earring_Dangly_Diamond/Earring_Dangly_Pearl/Ring_Right_MiddleFinger_Gold/Ring_Left_MiddleFinger_Gold/Ring_Right_RingFinger_Gold/Ring_Left_RingFinger_Gold/Ring_Right_MiddleFinger_Silver/Ring_Left_MiddleFinger_Silver/Ring_Right_RingFinger_Silver/Ring_Left_RingFinger_Silver/Ring_Right_MiddleFinger_SilverDiamond/Ring_Left_MiddleFinger_SilverDiamond/Ring_Right_RingFinger_SilverDiamond/Ring_Left_RingFinger_SilverDiamond/Ring_Right_MiddleFinger_GoldRuby/Ring_Left_MiddleFinger_GoldRuby/Ring_Right_RingFinger_GoldRuby/Ring_Left_RingFinger_GoldRuby/Ring_Right_MiddleFinger_GoldDiamond/Ring_Left_MiddleFinger_GoldDiamond/Ring_Right_RingFinger_GoldDiamond/Ring_Left_RingFinger_GoldDiamond/WristWatch_Right_ClassicBlack/WristWatch_Left_ClassicBlack/WristWatch_Right_ClassicBrown/WristWatch_Left_ClassicBrown/WristWatch_Right_ClassicMilitary/WristWatch_Left_ClassicMilitary/WristWatch_Right_ClassicGold/WristWatch_Left_ClassicGold/Bracelet_BangleRightGold/Bracelet_BangleLeftGold/Bracelet_ChainRightGold/Bracelet_ChainLeftGold/Bracelet_BangleRightSilver/Bracelet_BangleLeftSilver/Bracelet_ChainRightSilver/Bracelet_ChainLeftSilver/Bracelet_RightFriendshipTINT/Bracelet_LeftFriendshipTINT/BellyButton_DangleGold/BellyButton_DangleGoldRuby/BellyButton_DangleSilver/BellyButton_DangleSilverDiamond/BellyButton_RingGold/BellyButton_RingGoldDiamond/BellyButton_RingGoldRuby/BellyButton_RingSilver/BellyButton_RingSilverAmethyst/BellyButton_RingSilverDiamond/BellyButton_RingSilverRuby/BellyButton_StudGold/BellyButton_StudGoldDiamond/BellyButton_StudSilver/BellyButton_StudSilverDiamond/Corkscrew/Locket/Necklacepearl/Ring/WeddingRing_Man/WeddingRing_Woman",
      Amount = 2,
    },
  },
  useConsumable = {
    {
      Consumable = "Base.Water",
      Amount = UNSMaterials.WATER_USED
    },
    {
      Consumable = "Base.Sandbag",
      Amount = UNSMaterials.SAND_USED
    },
  },
}