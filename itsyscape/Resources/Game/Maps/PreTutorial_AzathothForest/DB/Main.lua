local M = include "Resources/Game/Maps/PreTutorial_AzathothForest/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.PreTutorial_AzathothForest.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Azathoth, Forest South of Woodston",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "An eerie forest full of rats.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 5,
		PositionZ = 47,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

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
		ColorRed = 91,
		ColorGreen = 119,
		ColorBlue = 111,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.8,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Fog1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog1",
		Map = M._MAP,
		Resource = M["Light_Fog1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog1"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 91,
		ColorGreen = 119,
		ColorBlue = 111,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog1"]
	}
end

M["Light_Fog2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog2",
		Map = M._MAP,
		Resource = M["Light_Fog2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog2"]
	}

	ItsyScape.Meta.Fog {
		ColorRed = 178,
		ColorGreen = 70,
		ColorBlue = 49,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Rat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 4,
		PositionZ = 41,
		Name = "Rat1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Rat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat1"]
	}
end


M["Rat2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 5,
		PositionZ = 39,
		Name = "Rat2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Rat2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat2"]
	}
end


M["Rat3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 15,
		Name = "Rat3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Rat3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat3"]
	}
end


M["Rat4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 5,
		PositionZ = 11,
		Name = "Rat4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Rat4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat4"]
	}
end


M["Rat5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 5,
		PositionY = 4,
		PositionZ = 27,
		Name = "Rat5",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Rat5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Rat",
		MapObject = M["Rat5"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/PreTutorial/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Rat5"]
	}
end