local M = include "Resources/Game/Maps/HighChambersYendor_Floor3/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.HighChambersYendor_Floor3.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "High Chambers of Yendor, Floor 3",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Prisium's first Terrible Machine...",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.RaidGroup {
	Raid = ItsyScape.Resource.Raid "HighChambersYendor",
	Map = M._MAP
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
		ColorRed = 124,
		ColorGreen = 111,
		ColorBlue = 145,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 1.1,
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
		ColorRed = 90,
		ColorGreen = 44,
		ColorBlue = 160,
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
		ColorRed = 170,
		ColorGreen = 76,
		ColorBlue = 76,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Light_Chandlier1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 91,
		PositionY = 4,
		PositionZ = 51,
		Name = "Light_Chandlier1",
		Map = M._MAP,
		Resource = M["Light_Chandlier1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Chandlier1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Chandlier1"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 20,
		Resource = M["Light_Chandlier1"]
	}
end

M["Anchor_FromFloor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 2,
		PositionZ = 99,
		Name = "Anchor_FromFloor2",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor2"]
	}
end

M["Anchor_FromFloor4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 103,
		PositionY = 2,
		PositionZ = 99,
		Name = "Anchor_FromFloor4",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor4"]
	}
end

M["Anchor_FromFloor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 2,
		PositionZ = 99,
		Name = "Anchor_FromFloor2",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor2"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor3",
		Map = ItsyScape.Resource.Map "HighChambersYendor_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToFloor2"] {
		TravelAction
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor3",
		Map = ItsyScape.Resource.Map "HighChambersYendor_Floor4",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToFloor4"] {
		TravelAction
	}
end

M["Door_Waterfall"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 44,
		PositionY = 1,
		PositionZ = 45,
		Name = "Door_Waterfall",
		Map = M._MAP,
		Resource = M["Door_Waterfall"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_LightDoor",
		MapObject = M["Door_Waterfall"]
	}
end

M["Lever"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 1,
		PositionZ = 57,
		Name = "Lever",
		Map = M._MAP,
		Resource = M["Lever"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Lever",
		MapObject = M["Lever"]
	}
end

M["Wizard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 89,
		Name = "Wizard1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard1"]
	}
end

M["Wizard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 107,
		Name = "Wizard2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard2"]
	}
end

M["Wizard3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 1,
		PositionZ = 103,
		Name = "Wizard3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard3"]
	}
end

M["Wizard4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 1,
		PositionZ = 101,
		Name = "Wizard4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard4"]
	}
end

M["Wizard4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 1,
		PositionZ = 61,
		Name = "Wizard4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard4"]
	}
end

M["Wizard5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83,
		PositionY = 1,
		PositionZ = 35,
		Name = "Wizard5",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard5"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard5"]
	}
end

M["Wizard6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 1,
		PositionZ = 39,
		Name = "Wizard6",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard6"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard6"]
	}
end

M["Wizard7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 1,
		PositionZ = 39,
		Name = "Wizard7",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard7"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard7"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard7"]
	}
end

M["Wizard8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 1,
		PositionZ = 45,
		Name = "Wizard8",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Wizard8"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard8"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Wizard8"]
	}
end
