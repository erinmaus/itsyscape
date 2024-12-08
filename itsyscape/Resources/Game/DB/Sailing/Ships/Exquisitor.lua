--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Ships/Exquisitor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Ship = ItsyScape.Resource.SailingShip "NPC_Isabelle_Exquisitor"

local PRIMARY_COLOR = ItsyScape.Utility.Color.fromHexString("b3002a")
local METAL_COLOR   = ItsyScape.Utility.Color.fromHexString("ffa100")
local WOOD_COLOR    = ItsyScape.Utility.Color.fromHexString("66362c")
local GLASS_COLOR   = ItsyScape.Utility.Color.fromHexString("d5f6ff")
local SAIL_COLOR    = ItsyScape.Utility.Color.fromHexString("b3002a")

ItsyScape.Meta.ShipSailingItem {
	Red1 = WOOD_COLOR.r,
	Green1 = WOOD_COLOR.g,
	Blue1 = WOOD_COLOR.b,
	Red2 = METAL_COLOR.r,
	Green2 = METAL_COLOR.g,
	Blue2 = METAL_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Capstan",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Capstan_ExquisiteDragonBone"
}

ItsyScape.Meta.ShipSailingItem {
	ItemGroup = "Figurehead",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Figurehead_ExquisiteDragonSkull"
}

ItsyScape.Meta.ShipSailingItem {
	Red1 = WOOD_COLOR.r,
	Green1 = WOOD_COLOR.g,
	Blue1 = WOOD_COLOR.b,
	Red2 = METAL_COLOR.r,
	Green2 = METAL_COLOR.g,
	Blue2 = METAL_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Helm",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Helm_ExquisiteMahogany"
}

ItsyScape.Meta.ShipSailingItem {
	Red1 = WOOD_COLOR.r,
	Green1 = WOOD_COLOR.g,
	Blue1 = WOOD_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Hull",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Hull_Galleon_Wood"
}

ItsyScape.Meta.ShipSailingItem {
	Red1 = WOOD_COLOR.r,
	Green1 = WOOD_COLOR.g,
	Blue1 = WOOD_COLOR.b,
	Red2 = METAL_COLOR.r,
	Green2 = METAL_COLOR.g,
	Blue2 = METAL_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Mast",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Mast_ExquisiteMahogany"
}

ItsyScape.Meta.ShipSailingItem {
	Red1 = WOOD_COLOR.r,
	Green1 = WOOD_COLOR.g,
	Blue1 = WOOD_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Rail",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Rail_Galleon_ExquisiteFiligree"
}

ItsyScape.Meta.ShipSailingItem {
	Red1 = SAIL_COLOR.r,
	Green1 = SAIL_COLOR.g,
	Blue1 = SAIL_COLOR.b,
	Red2 = METAL_COLOR.r,
	Green2 = METAL_COLOR.g,
	Blue2 = METAL_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Sail",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Sail_VelvetDragon"
}

ItsyScape.Meta.ShipSailingItem {
	Red1 = WOOD_COLOR.r,
	Green1 = WOOD_COLOR.g,
	Blue1 = WOOD_COLOR.b,
	Red2 = GLASS_COLOR.r,
	Green2 = GLASS_COLOR.g,
	Blue2 = GLASS_COLOR.b,
	IsColorCustomized = 1,
	ItemGroup = "Window",
	Ship = Ship,
	SailingItem = ItsyScape.Resource.SailingItem "Window_Galleon_ExquisiteFiligree"
}
