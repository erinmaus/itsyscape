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
		PositionX = 50,
		PositionY = 0,
		PositionZ = 50,
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
