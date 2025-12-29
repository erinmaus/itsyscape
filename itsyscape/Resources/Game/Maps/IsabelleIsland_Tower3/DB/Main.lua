local M = include "Resources/Game/Maps/IsabelleIsland_Tower3/DB/Default.lua"

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Tower",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Once known as the crooked tower.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_Tower3.Peep",
	Resource = M._MAP
}

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 0,
		ColorGreen = 0,
		ColorBlue = 0,
		NearDistance = 150,
		FarDistance = 200,
		Resource = M["Light_Fog"]
	}
end

M["Light_Sun"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Sun",
		Map = M._MAP,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Sun"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 130,
		ColorGreen = 130,
		ColorBlue = 130,
		CastsShadows = 1,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 8,
		DirectionZ = -4,
		Resource = M["Light_Sun"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 79,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Floor2Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Layer = 4,
		Name = "Anchor_Floor2Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Floor2Spawn"]
	}
end

M["IsabelleIslandTowerLargeDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 81,
		Name = "IsabelleIslandTowerLargeDoor",
		Map = M._MAP,
		Resource = M["IsabelleIslandTowerLargeDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerLargeDoor",
		MapObject = M["IsabelleIslandTowerLargeDoor"]
	}

	M["IsabelleIslandTowerLargeDoor"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 89,
		Name = "Cthulhu",
		Map = M._MAP,
		Resource = M["Cthulhu"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Cthulhu",
		MapObject = M["Cthulhu"]
	}
end

M["GildedDragon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12,
		PositionZ = 59,
		Name = "GildedDragon",
		Map = M._MAP,
		Resource = M["GildedDragon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GildedDragon",
		MapObject = M["GildedDragon"]
	}
end

M["Plinth_GildedDragon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 12.5,
		PositionZ = 69,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Plinth_GildedDragon",
		Map = M._MAP,
		Resource = M["Plinth_GildedDragon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Plinth_Isabelle",
		MapObject = M["Plinth_GildedDragon"]
	}

	local Read = ItsyScape.Action.Read_Plinth()

	ItsyScape.Meta.PlinthExhibit {
		ExhibitResource = M["GildedDragon"],
		ExhibitName = "Gilded royal dragon",
		ExhibitDescription = "One of the last known royal dragons, slain by Lady Isabelle. She personally smelted gold with the bones to gild them. Supposedly, burying these bones would give over 13,000,000 Faith experience.",
		Zoom = 3,
		OffsetY = 0.5,
		Language = "en-US",
		Action = Read
	}

	M["Plinth_GildedDragon"] {
		Read
	}
end

M["GiantSquid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 72.5,
		PositionY = 12.5,
		PositionZ = 54,
		ScaleX = 0.750000,
		ScaleY = 0.750000,
		ScaleZ = 0.750000,
		Name = "GiantSquid",
		Map = M._MAP,
		Resource = M["GiantSquid"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "GiantSquidTentacleExhibit",
		MapObject = M["GiantSquid"]
	}
end

M["Plinth_GiantSquid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 72.5,
		PositionY = 12.5,
		PositionZ = 59,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Plinth_GiantSquid",
		Map = M._MAP,
		Resource = M["Plinth_GiantSquid"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Plinth_Isabelle",
		MapObject = M["Plinth_GiantSquid"]
	}

	local Read = ItsyScape.Action.Read_Plinth()

	ItsyScape.Meta.PlinthExhibit {
		ExhibitResource = M["GiantSquid"],
		ExhibitName = "Giant squid tentacle",
		ExhibitDescription = "The remaining piece of a giant squid slain near Humanity's Edge by Lady Isabelle and her crew. First of its kind ever recovered. Remainder of squid sold to anonymous noble-folks and cooked by Chef Allons.",
		Zoom = 2,
		OffsetY = 0.25,
		Language = "en-US",
		Action = Read
	}

	M["Plinth_GiantSquid"] {
		Read
	}
end

M["IsabelliumBars"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 72.5,
		PositionY = 12.5,
		PositionZ = 65.5,
		RotationX = 0.000000,
		RotationY = -0.382683,
		RotationZ = 0.000000,
		RotationW = 0.923880,
		ScaleX = 1.5,
		ScaleY = 1.5,
		ScaleZ = 1.5,
		Name = "IsabelliumBars",
		Map = M._MAP,
		Resource = M["IsabelliumBars"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelliumBars",
		MapObject = M["IsabelliumBars"]
	}
end

M["Plinth_IsabelliumBars"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 72.5,
		PositionY = 12.5,
		PositionZ = 71,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Plinth_IsabelliumBars",
		Map = M._MAP,
		Resource = M["Plinth_IsabelliumBars"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Plinth_Isabelle",
		MapObject = M["Plinth_IsabelliumBars"]
	}

	local Read = ItsyScape.Action.Read_Plinth()

	ItsyScape.Meta.PlinthExhibit {
		ExhibitResource = M["IsabelliumBars"],
		ExhibitName = "Isabellium alloy",
		ExhibitDescription = "Isabellium is a secret, special alloy derived from the failures of impure azatite alloys. The alloy inherently scales with the user's strength with no known upper limit. Isabellium is priceless, as the process to smelt it is only known to the Fierbloom family, and only them and their closest allies possess weapons and armor made from it.",
		Zoom = 2,
		OffsetY = 0,
		Language = "en-US",
		Action = Read
	}

	M["Plinth_IsabelliumBars"] {
		Read
	}
end

M["AmuletOfYendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 46,
		PositionY = 12.5,
		PositionZ = 65.5,
		ScaleX = 0.750000,
		ScaleY = 0.750000,
		ScaleZ = 0.750000,
		Name = "AmuletOfYendor",
		Map = M._MAP,
		Resource = M["AmuletOfYendor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmuletOfYendor",
		MapObject = M["AmuletOfYendor"]
	}
end

M["Plinth_AmuletOfYendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49.250000,
		PositionY = 12.5,
		PositionZ = 71.000000,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Plinth_AmuletOfYendor",
		Map = M._MAP,
		Resource = M["Plinth_AmuletOfYendor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Plinth_Isabelle",
		MapObject = M["Plinth_AmuletOfYendor"]
	}

	local Read = ItsyScape.Action.Read_Plinth()

	ItsyScape.Meta.PlinthExhibit {
		ExhibitResource = M["AmuletOfYendor"],
		ExhibitName = "Amulet of yendor",
		ExhibitDescription = "Lady Isabelle obtained this artefact from the inner chambers of the Sistine of the Simulacrum on an adventure that almost lead to her death. The amulet was rumored to grant godhood to those who possess it, but it was just a mere rumor. Instead, its true powers are only known to Lady Isabelle, a secret she keeps close to her chest.",
		Zoom = 2,
		OffsetY = 0,
		Language = "en-US",
		Action = Read
	}

	M["Plinth_AmuletOfYendor"] {
		Read
	}
end

M["DrakkensonComputer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13.25,
		PositionY = 0,
		PositionZ = 13.5,
		RotationX = 0.000000,
		RotationY = 0.381784,
		RotationZ = 0.000000,
		RotationW = -0.924251,
		Name = "DrakkensonComputer",
		Map = M._MAP,
		Layer = 4,
		Resource = M["DrakkensonComputer"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DrakkensonComputer",
		MapObject = M["DrakkensonComputer"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mysterious static",
		Language = "en-US",
		Resource = M["DrakkensonComputer"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Is this some kind of scrying technology? What does that... static... mean?",
		Language = "en-US",
		Resource = M["DrakkensonComputer"]
	}
end

M["LifeSupportProcessor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15.25,
		PositionY = 0,
		PositionZ = 12,
		Name = "LifeSupportProcessor",
		Map = M._MAP,
		Layer = 4,
		Resource = M["LifeSupportProcessor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "LifeSupportProcessor",
		MapObject = M["LifeSupportProcessor"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mysterious pump",
		Language = "en-US",
		Resource = M["LifeSupportProcessor"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An automatic pump... The sound is familiar.",
		Language = "en-US",
		Resource = M["LifeSupportProcessor"]
	}
end

M["LifeSupportTank"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 0,
		PositionZ = 11,
		Name = "LifeSupportTank",
		Map = M._MAP,
		Layer = 4,
		Resource = M["LifeSupportTank"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "LifeSupportTank",
		MapObject = M["LifeSupportTank"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mysterious tank",
		Language = "en-US",
		Resource = M["LifeSupportTank"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A tank of some weird, translucent goo. The sight of it makes you feel comfortable, almost like you're at home.",
		Language = "en-US",
		Resource = M["LifeSupportTank"]
	}
end

M["Door_ToLibrary"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.5,
		PositionZ = 12,
		RotationX = 0,
		RotationY = 0.728632,
		RotationZ = 0,
		RotationW = 0.684905,
		Name = "Door_ToLibrary",
		Map = M._MAP,
		Layer = 7,
		Resource = M["Door_ToLibrary"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerSmallDoor",
		MapObject = M["Door_ToLibrary"]
	}

	local ClimbAction = ItsyScape.Action.Climb()

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_SmallDoor",
		FromLayer = 8,
		ToLayer = 7,
		Action = ClimbAction
	}

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_SmallDoor",
		FromLayer = 7,
		ToLayer = 8,
		Action = ClimbAction
	}

	M["Door_ToLibrary"] {
		ClimbAction
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 7,
		PositionX = 25,
		PositionZ = 12,
		MapObject = M["Door_ToLibrary"]
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 8,
		PositionX = 2,
		PositionZ = 3,
		MapObject = M["Door_ToLibrary"]
	}
end

M["Door_ToIsabellesBedroom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13.9,
		PositionY = 0,
		PositionZ = 27.5,
		Name = "Door_ToIsabellesBedroom",
		Map = M._MAP,
		Layer = 4,
		Resource = M["Door_ToIsabellesBedroom"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerSmallDoor",
		MapObject = M["Door_ToIsabellesBedroom"]
	}

	local ClimbAction = ItsyScape.Action.Climb()

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_SmallDoor",
		FromLayer = 6,
		ToLayer = 4,
		Action = ClimbAction
	}

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_SmallDoor",
		FromLayer = 4,
		ToLayer = 6,
		Action = ClimbAction
	}

	M["Door_ToIsabellesBedroom"] {
		ClimbAction
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 4,
		PositionX = 14,
		PositionZ = 26,
		MapObject = M["Door_ToIsabellesBedroom"]
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 6,
		PositionX = 3,
		PositionZ = 3,
		MapObject = M["Door_ToIsabellesBedroom"]
	}
end

M["Staircase_ToIsabellesBedroom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 38,
		PositionY = 12,
		PositionZ = 59,
		RotationX = -0.000000,
		RotationY = -0.707107,
		RotationZ = -0.000000,
		RotationW = 0.707107,
		Name = "Staircase_ToIsabellesBedroom",
		Map = M._MAP,
		Resource = M["Staircase_ToIsabellesBedroom"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerSpiralStaircase",
		MapObject = M["Staircase_ToIsabellesBedroom"]
	}

	local ClimbAction = ItsyScape.Action.Climb()

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_ClimbUpStairs",
		FromLayer = 1,
		ToLayer = 6,
		Action = ClimbAction
	}

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_ClimbDownStairs",
		FromLayer = 6,
		ToLayer = 1,
		Action = ClimbAction
	}

	M["Staircase_ToIsabellesBedroom"] {
		ClimbAction
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 1,
		PositionX = 39,
		PositionZ = 61,
		MapObject = M["Staircase_ToIsabellesBedroom"]
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 6,
		PositionX = 1,
		PositionZ = 4,
		MapObject = M["Staircase_ToIsabellesBedroom"]
	}
end

M["Staircase_ToLibrary"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 3.5,
		PositionY = 0,
		PositionZ = 4.5,
		Name = "Staircase_ToLibrary",
		Map = M._MAP,
		Layer = 6,
		Resource = M["Staircase_ToLibrary"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerSpiralStaircase",
		MapObject = M["Staircase_ToLibrary"]
	}

	local ClimbAction = ItsyScape.Action.Climb()

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_ClimbUpStairs",
		FromLayer = 6,
		ToLayer = 8,
		Action = ClimbAction
	}

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_ClimbDownStairs",
		FromLayer = 8,
		ToLayer = 6,
		Action = ClimbAction
	}

	M["Staircase_ToLibrary"] {
		ClimbAction
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 8,
		PositionX = 5,
		PositionZ = 5,
		MapObject = M["Staircase_ToLibrary"]
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 6,
		PositionX = 5,
		PositionZ = 5,
		MapObject = M["Staircase_ToLibrary"]
	}
end

M["Staircase_ToRoof"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 0,
		PositionZ = 2.5,
		RotationX = 0,
		RotationY = 0.707107,
		RotationZ = 0,
		RotationW = 0.707107,
		Name = "Staircase_ToRoof",
		Map = M._MAP,
		Layer = 8,
		Resource = M["Staircase_ToRoof"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "IsabelleIslandTowerSpiralStaircase",
		MapObject = M["Staircase_ToRoof"]
	}

	local ClimbAction = ItsyScape.Action.Climb()

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_ClimbUpStairs",
		FromLayer = 8,
		ToLayer = 9,
		Action = ClimbAction
	}

	ItsyScape.Meta.ClimbDestination {
		Cutscene = ItsyScape.Resource.Cutscene "IsabelleIsland_Tower_ClimbDownStairs",
		FromLayer = 9,
		ToLayer = 8,
		Action = ClimbAction
	}

	M["Staircase_ToRoof"] {
		ClimbAction
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 8,
		PositionX = 5,
		PositionZ = 2.5,
		MapObject = M["Staircase_ToRoof"]
	}

	ItsyScape.Meta.MapObjectAnchor {
		Layer = 9,
		PositionX = 21,
		PositionZ = 3,
		MapObject = M["Staircase_ToRoof"]
	}
end
