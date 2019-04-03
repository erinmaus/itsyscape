local M = include "Resources/Game/Maps/HighChambersYendor_Floor2/DB/Default.lua"

--ItsyScape.Meta.PeepID {
	--Value = "Resources.Game.Maps.HighChambersYendor_Floor2.Peep",
	--Resource = M._MAP
--}

ItsyScape.Meta.ResourceName {
	Value = "High Chambers of Yendor, Floor 2",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Stalked by an abomination through a violent maze; don't let the frenzy take you.",
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
		ColorRed = 124,
		ColorGreen = 111,
		ColorBlue = 145,
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

M["Anchor_FromFloor1West"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 103,
		PositionY = 2,
		PositionZ = 99,
		Name = "Anchor_FromFloor1West",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor1West"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor2",
		Map = ItsyScape.Resource.Map "HighChambersYendor_Floor1West",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToFloor1West"] {
		TravelAction
	}
end

M["Room1_SkeletonArcher"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 107,
		PositionY = 1,
		PositionZ = 73,
		Name = "Room1_SkeletonArcher",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room1_SkeletonArcher"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["Room1_SkeletonArcher"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room1",
		Map = M._MAP,
		MapObject = M["Room1_SkeletonArcher"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room1_SkeletonArcher"]
	}
end

M["Room1_SkeletonWizard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 113,
		PositionY = 1,
		PositionZ = 73,
		Name = "Room1_SkeletonWizard",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room1_SkeletonWizard"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["Room1_SkeletonWizard"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room1",
		Map = M._MAP,
		MapObject = M["Room1_SkeletonWizard"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room1_SkeletonWizard"]
	}
end

M["Room1_SkeletonWarrior"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 113,
		PositionY = 1,
		PositionZ = 73,
		Name = "Room1_SkeletonWarrior",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room1_SkeletonWarrior"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior",
		MapObject = M["Room1_SkeletonWarrior"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room1",
		Map = M._MAP,
		MapObject = M["Room1_SkeletonWarrior"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room1_SkeletonWarrior"]
	}
end

M["Room2_ZombiWarrior1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 1,
		PositionZ = 51,
		Name = "Room2_ZombiWarrior1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room2_ZombiWarrior1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiWarrior",
		MapObject = M["Room2_ZombiWarrior1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room2",
		Map = M._MAP,
		MapObject = M["Room2_ZombiWarrior1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room2_ZombiWarrior1"]
	}
end

M["Room2_ZombiWarrior2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 1,
		PositionZ = 55,
		Name = "Room2_ZombiWarrior2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room2_ZombiWarrior2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiWarrior",
		MapObject = M["Room2_ZombiWarrior2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room2",
		Map = M._MAP,
		MapObject = M["Room2_ZombiWarrior2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room2_ZombiWarrior2"]
	}
end

M["Room3_ZombiArcher1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 103,
		PositionY = 1,
		PositionZ = 29,
		Name = "Room3_ZombiArcher1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room3_ZombiArcher1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiArcher",
		MapObject = M["Room3_ZombiArcher1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room3",
		Map = M._MAP,
		MapObject = M["Room3_ZombiArcher1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room3_ZombiArcher1"]
	}
end

M["Room3_ZombiArcher2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 1,
		PositionZ = 29,
		Name = "Room3_ZombiArcher2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room3_ZombiArcher2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiArcher",
		MapObject = M["Room3_ZombiArcher2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room3",
		Map = M._MAP,
		MapObject = M["Room3_ZombiArcher2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room3_ZombiArcher2"]
	}
end

M["Room3_ZombiArcher3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 103,
		PositionY = 1,
		PositionZ = 25,
		Name = "Room3_ZombiArcher3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room3_ZombiArcher3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiArcher",
		MapObject = M["Room3_ZombiArcher3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room3",
		Map = M._MAP,
		MapObject = M["Room3_ZombiArcher3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room3_ZombiArcher3"]
	}
end

M["Room3_ZombiArcher4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 1,
		PositionZ = 25,
		Name = "Room3_ZombiArcher4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room3_ZombiArcher4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiArcher",
		MapObject = M["Room3_ZombiArcher4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room3",
		Map = M._MAP,
		MapObject = M["Room3_ZombiArcher4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room3_ZombiArcher4"]
	}
end

M["Room4_Zombi1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 1,
		PositionZ = 33,
		Name = "Room4_Zombi1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room4_Zombi1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Room4_Zombi1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room4",
		Map = M._MAP,
		MapObject = M["Room4_Zombi1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room4_Zombi1"]
	}
end

M["Room4_Zombi2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 1,
		PositionZ = 37,
		Name = "Room4_Zombi2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room4_Zombi2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Room4_Zombi2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room4",
		Map = M._MAP,
		MapObject = M["Room4_Zombi2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room4_Zombi2"]
	}
end

M["Room4_Zombi3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 1,
		PositionZ = 41,
		Name = "Room4_Zombi3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room4_Zombi3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Room4_Zombi3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room4",
		Map = M._MAP,
		MapObject = M["Room4_Zombi3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room4_Zombi3"]
	}
end

M["Room6_Sailor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 21,
		Name = "Room6_Sailor1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room6_Sailor1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiSailor",
		MapObject = M["Room6_Sailor1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room6",
		Map = M._MAP,
		MapObject = M["Room6_Sailor1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room6_Sailor1"]
	}
end

M["Room6_Sailor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 15,
		Name = "Room6_Sailor2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room6_Sailor2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiSailor",
		MapObject = M["Room6_Sailor2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room6",
		Map = M._MAP,
		MapObject = M["Room6_Sailor2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room6_Sailor2"]
	}
end

M["Room6_Sailor3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 1,
		PositionZ = 21,
		Name = "Room6_Sailor3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room6_Sailor3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiSailor",
		MapObject = M["Room6_Sailor3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room6",
		Map = M._MAP,
		MapObject = M["Room6_Sailor3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room6_Sailor3"]
	}
end

M["Room6_Sailor4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 27,
		Name = "Room6_Sailor4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room6_Sailor4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiSailor",
		MapObject = M["Room6_Sailor4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room6",
		Map = M._MAP,
		MapObject = M["Room6_Sailor4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room6_Sailor4"]
	}
end
