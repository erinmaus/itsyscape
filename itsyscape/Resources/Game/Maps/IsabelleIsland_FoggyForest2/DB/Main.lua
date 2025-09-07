local M = include "Resources/Game/Maps/IsabelleIsland_FoggyForest2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_FoggyForest.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Foggy Forest",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The resting place of Yendor's faithful human servants.",
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
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
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
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
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
		ColorRed = 81,
		ColorGreen = 16,
		ColorBlue = 117,
		NearDistance = 60,
		FarDistance = 120,
		Resource = M["Light_Fog"]
	}
end

M["YendorianPriest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 105,
		Name = "YendorianPriest",
		Map = M._MAP,
		Resource = M["YendorianPriest"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Base",
		MapObject = M["YendorianPriest"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian priest Uuly'lth",
		Language = "en-US",
		Resource = M["YendorianPriest"]
	}

	local ShopAction = ItsyScape.Action.Shop()

	ItsyScape.Meta.ShopTarget {
		Resource = ItsyScape.Resource.Shop "IsabelleIsland_FoggyForest_YendorianIncenseShop",
		Action = ShopAction
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["YendorianPriest"],
		Name = "Priest",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_FoggyForest/Dialog/YendorianPriest_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["YendorianPriest"] {
		TalkAction,
		ShopAction,
		ItsyScape.Action.Attack()
	}
end

M["Zombi1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 93,
		PositionY = 4,
		PositionZ = 47,
		Name = "Zombi1",
		Map = M._MAP,
		Resource = M["Zombi1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi1"]
	}
end

M["Zombi2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87,
		PositionY = 5,
		PositionZ = 63,
		Name = "Zombi2",
		Map = M._MAP,
		Resource = M["Zombi2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi2"]
	}
end

M["Zombi3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 95,
		PositionY = 5,
		PositionZ = 65,
		Name = "Zombi3",
		Map = M._MAP,
		Resource = M["Zombi3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi3"]
	}
end

M["Zombi4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 5,
		PositionZ = 65,
		Name = "Zombi4",
		Map = M._MAP,
		Resource = M["Zombi4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi4"]
	}
end

M["Zombi5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 107,
		PositionY = 4,
		PositionZ = 69,
		Name = "Zombi5",
		Map = M._MAP,
		Resource = M["Zombi5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi5"]
	}
end

M["Zombi6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 107,
		PositionY = 4,
		PositionZ = 47,
		Name = "Zombi6",
		Map = M._MAP,
		Resource = M["Zombi6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi6"]
	}
end

M["WoodNymph1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 5,
		PositionZ = 47,
		Name = "WoodNymph1",
		Map = M._MAP,
		Resource = M["WoodNymph1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["WoodNymph1"]
	}
end

M["WoodNymph2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 95,
		PositionY = 4.5,
		PositionZ = 31,
		Name = "WoodNymph2",
		Map = M._MAP,
		Resource = M["WoodNymph2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["WoodNymph2"]
	}
end

M["WoodNymph3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 107,
		PositionY = 4,
		PositionZ = 49,
		Name = "WoodNymph3",
		Map = M._MAP,
		Resource = M["WoodNymph3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["WoodNymph3"]
	}
end

M["WoodNymph4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 73,
		PositionY = 4,
		PositionZ = 49,
		Name = "WoodNymph4",
		Map = M._MAP,
		Resource = M["WoodNymph4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["WoodNymph4"]
	}
end

M["WoodNymph5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 73,
		PositionY = 6,
		PositionZ = 33,
		Name = "WoodNymph5",
		Map = M._MAP,
		Resource = M["WoodNymph5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Nymph_Base_Attackable_Wand",
		MapObject = M["WoodNymph5"]
	}
end

M["Anchor_AncientDriftwood"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 4,
		PositionZ = 77,
		Name = "Anchor_AncientDriftwood",
		Map = M._MAP,
		Resource = M["Anchor_AncientDriftwood"]
	}
end
