local M = include "Resources/Game/Maps/IsabelleIsland_FarOcean/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FarOcean.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Port Isabelle, Far Ocean",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Under the oceans of Rh'lor, Cthulhu sleeps.",
	Language = "en-US",
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
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.3,
		Resource = M["Light_Ambient"]
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
		ColorRed = 66,
		ColorGreen = 66,
		ColorBlue = 66,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 5,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
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
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		NearDistance = 40,
		FarDistance = 60,
		Resource = M["Light_Fog"]
	}
end

M["Cthulhu"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Cthulhu",
		Map = M._MAP,
		Resource = M["Cthulhu"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Cthulhu",
		MapObject = M["Cthulhu"]
	}
end

M["Cthulhu_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = -10,
		PositionZ = -16,
		Name = "Cthulhu_Spawn",
		Map = M._MAP,
		Resource = M["Cthulhu_Spawn"]
	}
end

M["Anchor_Squid_Spawn1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 1,
		PositionZ = 19,
		Name = "Anchor_Squid_Spawn1",
		Map = M._MAP,
		Resource = M["Anchor_Squid_Spawn1"]
	}
end

M["Anchor_Squid_Spawn2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 1,
		PositionY = 1,
		PositionZ = 5,
		Name = "Anchor_Squid_Spawn2",
		Map = M._MAP,
		Resource = M["Anchor_Squid_Spawn2"]
	}
end

M["Anchor_Squid_Spawn3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 7,
		Name = "Anchor_Squid_Spawn3",
		Map = M._MAP,
		Resource = M["Anchor_Squid_Spawn3"]
	}
end

M["UndeadSquid"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "UndeadSquid",
		Map = M._MAP,
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Undead squid",
		Language = "en-US",
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Loyal servants to Cthulhu and its master, Yendor.",
		Language = "en-US",
		Resource = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid",
		MapObject = M["UndeadSquid"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "spawn",
		Tree = "Resources/Game/Maps/IsabelleIsland_FarOcean/Scripts/UndeadSquid.lua",
		IsDefault = 1,
		Resource = M["UndeadSquid"]
	}
end
