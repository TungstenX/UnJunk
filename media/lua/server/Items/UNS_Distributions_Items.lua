require 'Items/ProceduralDistributions'

local places = {  
  "BinBar",                    "BinGeneric",               "BookstoreMisc",           "BreakRoomShelves",      "CarSupplyTools", 
  "CarWindows1",               "CarWindows2",              "CarWindows3",             "CrateBooks",            "CrateMagazines",      
  "CrateMechanics",            "CrateTools",               "FactoryLockers",          "FilingCabinetGeneric",  "GarageMechanics",
  "LibraryBooks",              "MagazineRackMixed",        "MechanicShelfBooks",      "MechanicShelfTools",    "OfficeDesk",       
  "OtherGeneric",              "PostOfficeBooks",          "PostOfficeMagazines",     "PrisonCellRandom",      "ShelfGeneric",      
  "StoreShelfMechanics",       "ToolStoreBooks",           "Bakery",                  "DrugLabGuns",           "DrugLabOutfit",        
  "DrugLabSupplies",           "DrugShackDrugs",           "DrugShackMisc",           "DrugShackTools",        "DrugShackWeapons",
  "ElectronicStoreAppliances", "ElectronicStoreComputers", "ElectronicStoreHAMRadio", "ElectronicStoreLights", "ElectronicStoreMagazines",
  "ElectronicStoreMisc",       "ElectronicStoreMusic",     "EngineerTools"
}
local mags = {}
mags["TaticalGrannyMag1"] = {
  0.10, 0.10, 0.45, 0.45, 0.10, --BinBar, BinGeneric, BookstoreMisc, BreakRoomShelves, CarSupplyTools
  0.10, 0.10, 0.10, 0.45, 0.45, --CarWindows1, CarWindows2, CarWindows3, CrateBooks, CrateMagazines
  0.10, 0.10, 0.25, 0.25, 0.10, --CrateMechanics, CrateTools, FactoryLockers, FilingCabinetGeneric, GarageMechanics
  0.25, 0.45, 0.10, 0.10, 0.10, --LibraryBooks, MagazineRackMixed, MechanicShelfBooks, MechanicShelfTools, OfficeDesk
  0.25, 0.35, 0.45, 0.50, 0.25, --OtherGeneric, PostOfficeBooks, PostOfficeMagazines, PrisonCellRandom, ShelfGeneric
  0.10, 0.10, 0.10, 0.00, 0.00, --StoreShelfMechanics, ToolStoreBooks, Bakery, DrugLabGuns, DrugLabOutfit
  0.00, 0.00, 0.00, 0.00, 0.00, --DrugLabSupplies, DrugShackDrugs, DrugShackMisc, DrugShackTools, DrugShackWeapons
  0.00, 0.00, 0.00, 0.00, 0.00, --ElectronicStoreAppliances, ElectronicStoreComputers, ElectronicStoreHAMRadio, ElectronicStoreLights, ElectronicStoreMagazines
  0.00, 0.00, 0.00              --ElectronicStoreMisc, ElectronicStoreMusic, EngineerTools
}
mags["KentuckyAppalachianCookingMag1"] = {
  0.10, 0.10, 0.45, 0.45, 0.10, --BinBar, BinGeneric, BookstoreMisc, BreakRoomShelves, CarSupplyTools
  0.10, 0.10, 0.10, 0.45, 0.45, --CarWindows1, CarWindows2, CarWindows3, CrateBooks, CrateMagazines
  0.10, 0.10, 0.25, 0.25, 0.10, --CrateMechanics, CrateTools, FactoryLockers, FilingCabinetGeneric, GarageMechanics
  0.25, 0.45, 0.10, 0.10, 0.10, --LibraryBooks, MagazineRackMixed, MechanicShelfBooks, MechanicShelfTools, OfficeDesk
  0.25, 0.35, 0.45, 0.50, 0.25, --OtherGeneric, PostOfficeBooks, PostOfficeMagazines, PrisonCellRandom, ShelfGeneric
  0.10, 0.10, 0.50, 0.00, 0.00, --StoreShelfMechanics, ToolStoreBooks, Bakery, DrugLabGuns, DrugLabOutfit
  0.00, 0.00, 0.00, 0.00, 0.00, --DrugLabSupplies, DrugShackDrugs, DrugShackMisc, DrugShackTools, DrugShackWeapons
  0.00, 0.00, 0.00, 0.00, 0.00, --ElectronicStoreAppliances, ElectronicStoreComputers, ElectronicStoreHAMRadio, ElectronicStoreLights, ElectronicStoreMagazines
  0.00, 0.00, 0.00              --ElectronicStoreMisc, ElectronicStoreMusic, EngineerTools
}
mags["KentuckyAppalachianCookingMag2"] = {
  0.10, 0.10, 0.45, 0.45, 0.10, --BinBar, BinGeneric, BookstoreMisc, BreakRoomShelves, CarSupplyTools
  0.10, 0.10, 0.10, 0.45, 0.45, --CarWindows1, CarWindows2, CarWindows3, CrateBooks, CrateMagazines
  0.10, 0.10, 0.25, 0.25, 0.10, --CrateMechanics, CrateTools, FactoryLockers, FilingCabinetGeneric, GarageMechanics
  0.25, 0.45, 0.10, 0.10, 0.10, --LibraryBooks, MagazineRackMixed, MechanicShelfBooks, MechanicShelfTools, OfficeDesk
  0.25, 0.35, 0.45, 0.50, 0.25, --OtherGeneric, PostOfficeBooks, PostOfficeMagazines, PrisonCellRandom, ShelfGeneric
  0.10, 0.10, 0.50, 0.00, 0.00, --StoreShelfMechanics, ToolStoreBooks, Bakery, DrugLabGuns, DrugLabOutfit
  0.00, 0.00, 0.00, 0.00, 0.00, --DrugLabSupplies, DrugShackDrugs, DrugShackMisc, DrugShackTools, DrugShackWeapons
  0.00, 0.00, 0.00, 0.00, 0.00, --ElectronicStoreAppliances, ElectronicStoreComputers, ElectronicStoreHAMRadio, ElectronicStoreLights, ElectronicStoreMagazines
  0.00, 0.00, 0.00              --ElectronicStoreMisc, ElectronicStoreMusic, EngineerTools
}
mags["TweakingTimmyMag1"] = {
  0.10, 0.10, 0.10, 0.25, 0.25, --BinBar, BinGeneric, BookstoreMisc, BreakRoomShelves, CarSupplyTools
  0.35, 0.35, 0.35, 0.10, 0.25, --CarWindows1, CarWindows2, CarWindows3, CrateBooks, CrateMagazines
  0.30, 0.30, 0.50, 0.10, 0.50, --CrateMechanics, CrateTools, FactoryLockers, FilingCabinetGeneric, GarageMechanics
  0.05, 0.45, 0.50, 0.50, 0.10, --LibraryBooks, MagazineRackMixed, MechanicShelfBooks, MechanicShelfTools, OfficeDesk
  0.25, 0.25, 0.45, 0.50, 0.25, --OtherGeneric, PostOfficeBooks, PostOfficeMagazines, PrisonCellRandom, ShelfGeneric
  0.45, 0.45, 0.00, 0.50, 0.50, --StoreShelfMechanics, ToolStoreBooks, Bakery, DrugLabGuns, DrugLabOutfit
  0.50, 0.50, 0.50, 0.50, 0.50, --DrugLabSupplies, DrugShackDrugs, DrugShackMisc, DrugShackTools, DrugShackWeapons
  0.50, 0.50, 0.50, 0.50, 0.50, --ElectronicStoreAppliances, ElectronicStoreComputers, ElectronicStoreHAMRadio, ElectronicStoreLights, ElectronicStoreMagazines
  0.50, 0.50, 0.50              --ElectronicStoreMisc, ElectronicStoreMusic, EngineerTools
}  

for index, place in ipairs(places) do
  for magName, values in pairs(mags) do
    if values[index] > 0.00 then
      table.insert(ProceduralDistributions.list[place].items, magName)
      table.insert(ProceduralDistributions.list[place].items, values[index])  
      if getDebug() then
        print("UnJunk adding to ProceduralDistributions.list: " .. magName .. " to " .. place .. " (" .. tostring(values[index]) .. ")") 
      end
    end
  end  
end

--[[
   Antiques
   ArmyHangarOutfit
   ArmyHangarTools
   ArmyStorageAmmunition
   ArmyStorageElectronics
   ArmyStorageGuns
   ArmyStorageMedical
   ArmyStorageOutfit
   ArmySurplusBackpacks
   ArmySurplusFootwear
   ArmySurplusHeadwear
   ArmySurplusMisc
   ArmySurplusOutfit
   ArmySurplusTools
   ArtStoreOther
   ArtStorePaper
   ArtStorePen
   ArtSupplies
   Bakery
   BakeryBread
   BakeryCake
   BakeryDoughnuts
   BakeryKitchenBaking
   BakeryKitchenFreezer
   BakeryKitchenFridge
   BakeryMisc
   BakeryPie
   BandMerchClothes
   BandMerchShelves
   BandPracticeClothing
   BandPracticeFridge
   BandPracticeInstruments
   BarCounterGlasses
   BarCounterLiquor
   BarCounterMisc
   BarCounterWeapon
   BarCrateDarts
   BarCratePool
   BarShelfLiquor
   BaseballStoreShelves
   BatFactoryBats
   BathroomCabinet
   BathroomCounter
   BathroomCounterEmpty
   BathroomCounterNoMeds
   BathroomShelf
   BedroomDresser
   BedroomSideTable
   BinBar
   BinDumpster
   BinGeneric
   BookstoreBags
   BookstoreBooks
   BookstoreMisc
   BookstoreStationery
   BowlingAlleyLockers
   BowlingAlleyShoes
   BreakRoomCounter
   BreakRoomShelves
   BreweryBottles
   BreweryCans
   BreweryEmptyBottles
   BurgerKitchenButcher
   BurgerKitchenFreezer
   BurgerKitchenFridge
   BurgerKitchenSauce
   BurglarTools
   ButcherChicken
   ButcherChops
   ButcherFish
   ButcherFreezer
   ButcherGround
   ButcherSmoked
   ButcherSnacks
   ButcherTools
   CabinetFactoryTools
   CafeKitchenFridge
   CafeShelfBooks
   CafeteriaDrinks
   CafeteriaFruit
   CafeteriaSandwiches
   CafeteriaSnacks
   CameraStoreDisplayCase
   CameraStoreShelves
   CampingLockers
   CampingStoreBackpacks
   CampingStoreBooks
   CampingStoreClothes
   CampingStoreGear
   CampingStoreLegwear
   CandyStoreSnacks
   CarSupplyTools
   CarBrakesModern1
   CarBrakesModern2
   CarBrakesModern3
   CarBrakesNormal1
   CarBrakesNormal2
   CarBrakesNormal3
   CarSuspensionModern1
   CarSuspensionModern2
   CarSuspensionModern3
   CarSuspensionNormal1
   CarSuspensionNormal2
   CarSuspensionNormal3
   CarTiresModern1
   CarTiresModern2
   CarTiresModern3
   CarTiresNormal1
   CarTiresNormal2
   CarTiresNormal3
   CarWindows1
   CarWindows2
   CarWindows3
   ChangeroomCounters
   Chemistry
   ChineseKitchenBaking
   ChineseKitchenButcher
   ChineseKitchenCutlery
   ChineseKitchenFreezer
   ChineseKitchenFridge
   ChineseKitchenSauce
   ClassroomDesk
   ClassroomMisc
   ClassroomShelves
   ClosetInstruments
   ClosetShelfGeneric
   ClothingPoor
   ClothingStorageAllJackets
   ClothingStorageAllShirts
   ClothingStorageFootwear
   ClothingStorageHeadwear
   ClothingStorageLegwear
   ClothingStorageWinter
   ClothingStoresBoots
   ClothingStoresDress
   ClothingStoresEyewear
   ClothingStoresGloves
   ClothingStoresGlovesLeather
   ClothingStoresHeadwear
   ClothingStoresJackets
   ClothingStoresJacketsFormal
   ClothingStoresJacketsLeather
   ClothingStoresJeans
   ClothingStoresJumpers
   ClothingStoresOvershirts
   ClothingStoresPants
   ClothingStoresPantsFormal
   ClothingStoresPantsLeather
   ClothingStoresShirts
   ClothingStoresShirtsFormal
   ClothingStoresShoes
   ClothingStoresShoesLeather
   ClothingStoresSocks
   ClothingStoresSport
   ClothingStoresSummer
   ClothingStoresUnderwearWoman
   ClothingStoresUnderwearMan
   ClothingStoresWoman
   ControlRoomCounter
   CrateAntiqueStove
   CrateBakingSoda
   CrateBatteries
   CrateBlueComfyChair
   CrateBluePlasticChairs
   CrateBlueRattanChair
   CrateBooks
   CrateBrownComfyChair
   CrateBrownLowTables
   CrateButter
   CrateCameraFilm
   CrateCamping
   CrateCandyPackage
   CrateCannedFood
   CrateCannedFoodSpoiled
   CrateCanning
   CrateCarpentry
   CrateCereal
   CrateCharcoal
   CrateChips
   CrateChocolate
   CrateChocolateChips
   CrateChromeSinks
   CrateCigarettes
   CrateCocoaPowder
   CrateConesIceCream
   CrateCompactDiscs
   CrateCornflour
   CrateClothesRandom
   CrateCoffee
   CrateComics
   CrateComputer
   CrateConcrete
   CrateCostume
   CrateCrackers
   CrateDarkBlueChairs
   CrateDarkWoodenChairs
   CrateDishes
   CrateElectronics
   CrateEmptyBottles1
   CrateEmptyBottles2
   CrateEmptyMixed
   CrateEmptyTinCans
   CrateFancyBlackChairs
   CrateFancyDarkTables
   CrateFancyLowTables
   CrateFancyToilets
   CrateFancyWhiteChairs
   CrateFarming
   CrateFishing
   CrateFlour
   CrateFertilizer
   CrateFitnessWeights
   CrateFoldingChairs
   CrateFootwearRandom
   CrateFountainCups
   CrateGrahamCrackers
   CrateGravelBags
   CrateGravyMix
   CrateGreenChairs
   CrateGreenComfyChair
   CrateGreenOven
   CrateGreyChairs
   CrateGreyComfyChair
   CrateGreyOven
   CrateGum
   CrateHotsauce
   CrateIndustrialSinks
   CrateInstruments
   CrateLeather
   CrateLightRoundTable
   CrateLinens
   CrateLongTables
   CrateLumber
   CrateMagazines
   CrateMannequins
   CrateMapleSyrup
   CrateMaps
   CrateMapsLarge
   CrateMarinara
   CrateMarshmallows
   CrateMechanics
   CrateMetalwork
   CrateMetalLockers
   CrateModernOven
   CrateNewspapers
   CrateOakRoundTable
   CrateOfficeChairs
   CrateOfficeSupplies
   CrateOilOlive
   CrateOilVegetable
   CrateOrangeModernChair
   CratePaint
   CratePancakeMix
   CratePaperBagJays
   CratePaperBagSpiffos
   CratePaperNapkins
   CratePasta
   CratePeanuts
   CratePetSupplies
   CratePlaster
   CratePlasticChairs
   CratePlasticLowTables
   CratePlasticTrays
   CratePopcorn
   CratePropane
   CratePurpleRattanChair
   CratePurpleWoodenChairs
   CrateRandomJunk
   CrateRedBBQ
   CrateRedChairs
   CrateRedOven
   CrateRice
   CrateRiceVinegar
   CrateRedWoodenChairs
   CrateRoundTable
   CrateSalonSupplies
   CrateSandBags
   CrateSeaweed
   CrateSheetMetal
   CrateSmallTables
   CrateSodaBottles
   CrateSodaCans
   CrateSoysauce
   CrateSpiffoMerch
   CrateSports
   CrateSugar
   CrateSugarBrown
   CrateSunflowerSeeds
   CrateTacoShells
   CrateTailoring
   CrateTea
   CrateTools
   CrateTortillaChips
   CrateToys
   CrateTV
   CrateTVWide
   CrateVHSTapes
   CrateWhiteComfyChair
   CrateWhiteSimpleChairs
   CrateWhiteSinks
   CrateWhiteWoodenChairs
   CrateWoodenChairs
   CrateWoodenStools
   CrateYeast
   CrateYellowModernChair
   CrateWallets
   CrepeKitchenBaking
   CrepeKitchenFridge
   CrepeKitchenSauce
   DaycareCounter
   DaycareDesk
   DaycareShelves
   DeepFryKitchenFreezer
   DeepFryKitchenFridge
   DepartmentStoreJewelry
   DepartmentStoreWatches
   DeskGeneric
   DinerBackRoomCounter
   DinerKitchenFreezer
   DinerKitchenFridge
   DishCabinetGeneric
   DishCabinetLiquor
   DogFoodFactoryCans
   DresserGeneric
   DrugLabGuns
   DrugLabOutfit
   DrugLabSupplies
   DrugShackDrugs
   DrugShackMisc
   DrugShackTools
   DrugShackWeapons
   ElectronicStoreAppliances
   ElectronicStoreComputers
   ElectronicStoreHAMRadio
   ElectronicStoreLights
   ElectronicStoreMagazines
   ElectronicStoreMisc
   ElectronicStoreMusic
   Empty
   EngineerTools
   FactoryLockers
   FilingCabinetGeneric
   FirearmWeapons
   FireDeptLockers
   FireStorageOutfit
   FireStorageTools
   FishChipsKitchenButcher
   FishChipsKitchenFreezer
   FishChipsKitchenFridge
   FishChipsKitchenSauce
   FishingStoreBait
   FishingStoreGear
   FitnessTrainer
   FoodGourmet
   ForestFireTools
   FreezerGeneric
   FreezerRich
   FreezerTrailerPark
   FreezerIceCream
   FridgeBeer
   FridgeBottles
   FridgeBreakRoom
   FridgeGeneric
   FridgeOffice
   FridgeOther
   FridgeRich
   FridgeSnacks
   FridgeSoda
   FridgeTrailerPark
   FridgeWater
   FryFactoryPotatoes
   GarageCarpentry
   GarageFirearms
   GarageMechanics
   GarageMetalwork
   GarageTools
   GardenStoreMisc
   GardenStoreTools
   GasStorageMechanics
   GasStorageCombo
   GeneratorRoom
   Gifts
   GigamartBakingMisc
   GigamartBedding
   GigamartBottles
   GigamartCandy
   GigamartCannedFood
   GigamartCrisps
   GigamartDryGoods
   GigamartFarming
   GigamartHouseElectronics
   GigamartHousewares
   GigamartPots
   GigamartSauce
   GigamartSchool
   GigamartLightbulb
   GigamartTools
   GigamartToys
   GolfLockers
   GrillAcessories
   GroceryStandFruits1
   GroceryStandFruits2
   GroceryStandFruits3
   GroceryStandLettuce
   GroceryStandVegetables1
   GroceryStandVegetables2
   GroceryStandVegetables3
   GroceryStandVegetables4
   GroceryStorageCrate1
   GroceryStorageCrate2
   GroceryStorageCrate3
   GunStoreAmmunition
   GunStoreCounter
   GunStoreDisplayCase
   GunStoreMagazineRack
   GunStoreShelf
   GymLaundry
   GymLockers
   GymSweatbands
   GymTowels
   GymWeights
   Hiker
   Hobbies
   HolidayStuff
   Homesteading
   HospitalLockers
   Hunter
   HuntingLockers
   ImprovisedCrafts
   ItalianKitchenBaking
   ItalianKitchenButcher
   ItalianKitchenFreezer
   ItalianKitchenFridge
   JanitorChemicals
   JanitorCleaning
   JanitorMisc
   JanitorTools
   JaysDiningCounter
   JaysKitchenBags
   JaysKitchenBaking
   JaysKitchenButcher
   JaysKitchenFreezer
   JaysKitchenFridge
   JaysKitchenSauce
   JewelryGems
   JewelryGold
   JewelryNavelRings
   JewelryOthers
   JewelrySilver
   JewelryWeddingRings
   JewelryWrist
   JewelryStorageAll
   JunkBin
   JunkHoard
   KitchenBaking
   KitchenBook
   KitchenBottles
   KitchenBreakfast
   KitchenCannedFood
   KitchenDishes
   KitchenDryFood
   KitchenPots
   KitchenRandom
   KnifeFactoryCutlery
   KnifeFactoryKitchenKnife
   KnifeFactoryMeatCleaver
   LaundryCleaning
   LaundryHospital
   LaundryLoad1
   LaundryLoad2
   LaundryLoad3
   LaundryLoad4
   LaundryLoad5
   LaundryLoad6
   LaundryLoad7
   LaundryLoad8
   LibraryBooks
   LibraryCounter
   LingerieStoreAccessories
   LingerieStoreBras
   LingerieStoreOutfits
   LingerieStoreUnderwear
   LivingRoomShelf
   LivingRoomShelfNoTapes
   LivingRoomSideTable
   LivingRoomSideTableNoRemote
   Locker
   LockerArmyBedroom
   LockerClassy
   LoggingFactoryTools
   MagazineRackMaps
   MagazineRackMixed
   MagazineRackNewspaper
   Meat
   MechanicShelfBooks
   MechanicShelfBrakes
   MechanicShelfElectric
   MechanicShelfMisc
   MechanicShelfMufflers
   MechanicShelfOutfit
   MechanicShelfSuspension
   MechanicShelfTools
   MechanicShelfWheels
   MechanicSpecial
   MedicalClinicDrugs
   MedicalClinicOutfit
   MedicalClinicTools
   MedicalOfficeBooks
   MedicalStorageDrugs
   MedicalStorageOutfit
   MedicalStorageTools
   MeleeWeapons
   MetalShopTools
   MexicanKitchenBaking
   MexicanKitchenButcher
   MexicanKitchenFreezer
   MexicanKitchenFridge
   MexicanKitchenSauce
   MorgueChemicals
   MorgueOutfit
   MorgueTools
   MotelFridge
   MotelLinens
   MotelTowels
   MovieRentalShelves
   MusicStoreBass
   MusicStoreCases
   MusicStoreCDs
   MusicStoreGuitar
   MusicStoreOthers
   MusicStoreSpeaker
   OfficeCounter
   OfficeDesk
   OfficeDeskHome
   OfficeDrawers
   OfficeShelfSupplies
   OptometristGlasses
   OtherGeneric
   PawnShopCases
   PawnShopGuns
   PawnShopGunsSpecial
   PawnShopKnives
   PetShopShelf
   PharmacyCosmetics
   Photographer
   PizzaKitchenBaking
   PizzaKitchenButcher
   PizzaKitchenCheese
   PizzaKitchenFridge
   PizzaKitchenSauce
   PlankStashGun
   PlankStashMagazine
   PlankStashMisc
   PlankStashMoney
   PlumbingSupplies
   PoliceDesk
   PoliceEvidence
   PoliceLockers
   PoliceStorageAmmunition
   PoliceStorageGuns
   PoliceStorageOutfit
   PoolLockers
   PostOfficeBooks
   PostOfficeBoxes
   PostOfficeMagazines
   PostOfficeNewspapers
   PostOfficeSupplies
   PrisonCellRandom
   PrisonGuardLockers
   ProduceStorageApples
   ProduceStorageBellPeppers
   ProduceStorageBroccoli
   ProduceStorageCabbages
   ProduceStorageCarrots
   ProduceStorageCherries
   ProduceStorageCorn
   ProduceStorageEggplant
   ProduceStorageLeeks
   ProduceStorageLettuce
   ProduceStorageOnions
   ProduceStoragePeaches
   ProduceStoragePear
   ProduceStoragePotatoes
   ProduceStorageRadishes
   ProduceStorageStrawberries
   ProduceStorageTomatoes
   ProduceStorageWatermelons
   RadioFactoryComponents
   RandomFiller
   RestaurantKitchenFreezer
   RestaurantKitchenFridge
   SafehouseArmor
   SafehouseMedical
   SafehouseTraps
   SalonCounter
   SalonShelfHaircare
   SalonShelfTowels
   SchoolLockers
   ScienceMisc
   SeafoodKitchenButcher
   SeafoodKitchenFreezer
   SeafoodKitchenFridge
   SeafoodKitchenSauce
   SecurityLockers
   ServingTrayBiscuits
   ServingTrayBurgers
   ServingTrayBurritos
   ServingTrayChicken
   ServingTrayChickenNuggets
   ServingTrayCornbread
   ServingTrayFish
   ServingTrayFries
   ServingTrayGravy
   ServingTrayHotdogs
   ServingTrayMaki
   ServingTrayMeatDumplings
   ServingTrayMeatSteamBuns
   ServingTrayNoodleSoup
   ServingTrayOmelettes
   ServingTrayOnigiri
   ServingTrayOnionRings
   ServingTrayOysters
   ServingTrayPancakes
   ServingTrayPerogies
   ServingTrayPotatoPancakes
   ServingTrayPie
   ServingTrayPizza
   ServingTrayRefriedBeans
   ServingTrayScrambledEggs
   ServingTrayShrimp
   ServingTrayShrimpDumplings
   ServingTraySpringRolls
   ServingTraySushiEgg
   ServingTraySushiFish
   ServingTrayTaco
   ServingTrayTofuFried
   ServingTrayWaffles
   SewingStoreTools
   SewingStoreFabric
   ShelfGeneric
   SpiffosDiningCounter
   SpiffosKitchenBags
   SpiffosKitchenCounter
   SpiffosKitchenFreezer
   SpiffosKitchenFridge
   SportStoreSneakers
   SportStorageBats
   SportStorageBalls
   SportStorageHelmets
   SportStoragePaddles
   SportStorageRacquets
   SportStorageSticks
   StoreCounterBags
   StoreCounterBagsFancy
   StoreCounterCleaning
   StoreCounterTobacco
   StoreDisplayWatches
   StoreKitchenBaking
   StoreKitchenButcher
   StoreKitchenCafe
   StoreKitchenCutlery
   StoreKitchenBags
   StoreKitchenCups
   StoreKitchenDishes
   StoreKitchenGlasses
   StoreKitchenPotatoes
   StoreKitchenPots
   StoreKitchenSauce
   StoreKitchenTrays
   StoreShelfBeer
   StoreShelfCombo
   StoreShelfDrinks
   StoreShelfElectronics
   StoreShelfMechanics
   StoreShelfMedical
   StoreShelfSnacks
   StoreShelfSpices
   StoreShelfWhiskey
   StoreShelfWine
   StripClubDressers
   SurvivalGear
   SushiKitchenBaking
   SushiKitchenCutlery
   SushiKitchenFreezer
   SushiKitchenFridge
   SushiKitchenSauce
   TestingLab
   TheatreDrinks
   TheatreKitchenFreezer
   TheatreSnacks
   TheatrePopcorn
   ToolStoreAccessories
   ToolStoreBooks
   ToolStoreCarpentry
   ToolStoreFarming
   ToolStoreFootwear
   ToolStoreMetalwork
   ToolStoreMisc
   ToolStoreOutfit
   ToolStoreTools
   Trapper
   VacationStuff
   WallDecor
   WardrobeChild
   WardrobeMan
   WardrobeManClassy
   WardrobeRedneck
   WardrobeWoman
   WardrobeWomanClassy
   WesternKitchenBaking
   WesternKitchenButcher
   WesternKitchenFreezer
   WesternKitchenFridge
   WesternKitchenSauce
   WhiskeyBottlingEmpty
   WhiskeyBottlingFull
   WireFactoryBarbed
   WireFactoryBasic
   WireFactoryElectric
   ZippeeClothing
   ]]
   
   
   
  --[[
-- Magazines: Tactical Granny Mag vol 1
table.insert(ProceduralDistributions.list["BinBar"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["BinBar"].items, 0.25)
table.insert(ProceduralDistributions.list["BinGeneric"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["BinGeneric"].items, 0.25)
table.insert(ProceduralDistributions.list["BookstoreMisc"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["BookstoreMisc"].items, 0.5)
table.insert(ProceduralDistributions.list["BreakRoomShelves"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["BreakRoomShelves"].items, 0.25)
table.insert(ProceduralDistributions.list["CarSupplyTools"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CarSupplyTools"].items, 0.5)
table.insert(ProceduralDistributions.list["CarWindows1"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CarWindows1"].items,0.25)
table.insert(ProceduralDistributions.list["CarWindows2"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CarWindows2"].items,0.25)
table.insert(ProceduralDistributions.list["CarWindows3"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CarWindows3"].items,0.25)
table.insert(ProceduralDistributions.list["CrateBooks"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CrateBooks"].items, 0.25)
table.insert(ProceduralDistributions.list["CrateMagazines"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CrateMagazines"].items, 0.25)
table.insert(ProceduralDistributions.list["CrateMechanics"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CrateMechanics"].items, 0.25)
table.insert(ProceduralDistributions.list["CrateTools"].junk.items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["CrateTools"].junk.items, 0.25)
table.insert(ProceduralDistributions.list["FactoryLockers"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["FactoryLockers"].items, 0.5)
table.insert(ProceduralDistributions.list["FilingCabinetGeneric"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["FilingCabinetGeneric"].items, 0.5)
table.insert(ProceduralDistributions.list["GarageMechanics"].junk.items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["GarageMechanics"].junk.items, 0.25)
table.insert(ProceduralDistributions.list["LibraryBooks"].junk.items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["LibraryBooks"].junk.items, 0.25)
table.insert(ProceduralDistributions.list["MagazineRackMixed"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["MagazineRackMixed"].items, 0.25)
table.insert(ProceduralDistributions.list["MechanicShelfBooks"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["MechanicShelfBooks"].items, 0.5)
table.insert(ProceduralDistributions.list["MechanicShelfTools"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["MechanicShelfTools"].items, 0.5)
table.insert(ProceduralDistributions.list["OfficeDesk"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["OfficeDesk"].items, 0.25)
table.insert(ProceduralDistributions.list["OtherGeneric"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["OtherGeneric"].items, 0.25)
table.insert(ProceduralDistributions.list["PostOfficeBooks"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["PostOfficeBooks"].items, 0.25)
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items,0.25)
table.insert(ProceduralDistributions.list["PrisonCellRandom"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["PrisonCellRandom"].items, 0.25)
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, 0.25)
table.insert(ProceduralDistributions.list["StoreShelfMechanics"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["StoreShelfMechanics"].items, 0.25)
table.insert(ProceduralDistributions.list["ToolStoreBooks"].items, "TaticalGrannyMag1")
table.insert(ProceduralDistributions.list["ToolStoreBooks"].items, 0.25)


-- Magazines: Kentucky Appalachian Cooking Magazine Vol. 1
table.insert(ProceduralDistributions.list["BinBar"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["BinBar"].items, 0.25)
table.insert(ProceduralDistributions.list["BinGeneric"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["BinGeneric"].items, 0.25)
table.insert(ProceduralDistributions.list["BookstoreMisc"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["BookstoreMisc"].items, 0.5)
table.insert(ProceduralDistributions.list["BreakRoomShelves"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["BreakRoomShelves"].items, 0.25)
table.insert(ProceduralDistributions.list["CarSupplyTools"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CarSupplyTools"].items, 0.5)
table.insert(ProceduralDistributions.list["CarWindows1"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CarWindows1"].items,0.25)
table.insert(ProceduralDistributions.list["CarWindows2"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CarWindows2"].items,0.25)
table.insert(ProceduralDistributions.list["CarWindows3"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CarWindows3"].items,0.25)
table.insert(ProceduralDistributions.list["CrateBooks"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CrateBooks"].items, 0.25)
table.insert(ProceduralDistributions.list["CrateMagazines"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CrateMagazines"].items, 0.25)
table.insert(ProceduralDistributions.list["CrateMechanics"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CrateMechanics"].items, 0.25)
table.insert(ProceduralDistributions.list["CrateTools"].junk.items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["CrateTools"].junk.items, 0.25)
table.insert(ProceduralDistributions.list["FactoryLockers"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["FactoryLockers"].items, 0.5)
table.insert(ProceduralDistributions.list["FilingCabinetGeneric"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["FilingCabinetGeneric"].items, 0.5)
table.insert(ProceduralDistributions.list["GarageMechanics"].junk.items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["GarageMechanics"].junk.items, 0.25)
table.insert(ProceduralDistributions.list["LibraryBooks"].junk.items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["LibraryBooks"].junk.items, 0.25)
table.insert(ProceduralDistributions.list["MagazineRackMixed"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["MagazineRackMixed"].items, 0.25)
table.insert(ProceduralDistributions.list["MechanicShelfBooks"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["MechanicShelfBooks"].items, 0.5)
table.insert(ProceduralDistributions.list["MechanicShelfTools"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["MechanicShelfTools"].items, 0.5)
table.insert(ProceduralDistributions.list["OfficeDesk"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["OfficeDesk"].items, 0.25)
table.insert(ProceduralDistributions.list["OtherGeneric"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["OtherGeneric"].items, 0.25)
table.insert(ProceduralDistributions.list["PostOfficeBooks"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["PostOfficeBooks"].items, 0.25)
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["PostOfficeMagazines"].items,0.25)
table.insert(ProceduralDistributions.list["PrisonCellRandom"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["PrisonCellRandom"].items, 0.25)
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["ShelfGeneric"].items, 0.25)
table.insert(ProceduralDistributions.list["StoreShelfMechanics"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["StoreShelfMechanics"].items, 0.25)
table.insert(ProceduralDistributions.list["ToolStoreBooks"].items, "KentuckyAppalachianCookingMag1")
table.insert(ProceduralDistributions.list["ToolStoreBooks"].items, 0.25)
]]