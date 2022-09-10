local M = include "Resources/Game/Maps/HighChambersYendor_Floor4/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.HighChambersYendor_Floor4.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "High Chambers of Yendor, Floor 4",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The final floor of the High Chambers of Yendor.",
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
		Ambience = 0.4,
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
		FarDistance = 75,
		Resource = M["Light_Fog2"]
	}
end

M["Light_Fog3"] = ItsyScape.Resource.MapObject.Unique()
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
		ColorRed = 31,
		ColorGreen = 28,
		ColorBlue = 36,
		NearDistance = 50,
		FarDistance = 100,
		Resource = M["Light_Fog2"]
	}
end

M["Light_Chandlier1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 15,
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
		Attenuation = 25,
		Resource = M["Light_Chandlier1"]
	}
end

M["Anchor_FromFloor3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 1,
		PositionZ = 55,
		Name = "Anchor_FromFloor3",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor3"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor4",
		Map = ItsyScape.Resource.Map "HighChambersYendor_Floor3",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToFloor3"] {
		TravelAction
	}
end

M["Anchor_Bridge_TopLeft"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 0,
		PositionZ = 33,
		Name = "Anchor_Bridge_TopLeft",
		Map = M._MAP,
		Resource = M["Anchor_Bridge_TopLeft"]
	}
end

M["Anchor_Bridge_BottomRight"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 37,
		Name = "Anchor_Bridge_BottomRight",
		Map = M._MAP,
		Resource = M["Anchor_Bridge_BottomRight"]
	}
end

M["Isabelle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 15,
		Direction = 1,
		Name = "Isabelle",
		Map = M._MAP,
		Resource = M["Isabelle"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean",
		MapObject = M["Isabelle"]
	}

	M["Isabelle"] {
		ItsyScape.Action.Attack()
	}
end

M["Isabelle_Dummy"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Isabelle_Dummy",
		Map = M._MAP,
		Resource = M["Isabelle_Dummy"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean",
		MapObject = M["Isabelle_Dummy"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Isabelle_Dummy"],
		Name = "Isabelle",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/HighChambersYendor_Floor4/Dialog/Isabelle_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Isabelle_Dummy"] {
		TalkAction
	}
end

M["Isabelle_Dead"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Isabelle_Dead",
		Map = M._MAP,
		Resource = M["Isabelle_Dead"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean",
		MapObject = M["Isabelle_Dead"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Isabelle_Dead"],
		Name = "Isabelle",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/HighChambersYendor_Floor4/Dialog/IsabelleDead_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Isabelle_Dead"] {
		TalkAction
	}
end

M["Wizard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 1,
		PositionZ = 9,
		Direction = 1,
		Name = "Wizard",
		Map = M._MAP,
		Resource = M["Wizard"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Wizard"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Archer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 1,
		PositionZ = 9,
		Direction = 1,
		Name = "Archer",
		Map = M._MAP,
		Resource = M["Archer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["Archer"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Warrior"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 9,
		Direction = 1,
		Name = "Warrior",
		Map = M._MAP,
		Resource = M["Warrior"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior",
		MapObject = M["Warrior"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end
