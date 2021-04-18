local M = include "Resources/Game/Maps/HighChambersYendor_Floor2/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.HighChambersYendor_Floor2.Peep",
	Resource = M._MAP
}

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
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToFloor1West"] {
		TravelAction
	}
end

M["Anchor_FromFloor3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 111,
		PositionY = 2,
		PositionZ = 99,
		Name = "Anchor_FromFloor3",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor3"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor2",
		Map = ItsyScape.Resource.Map "HighChambersYendor_Floor3",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToFloor3"] {
		TravelAction
	}
end

M["YendorianPriest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 1,
		PositionZ = 17,
		Name = "YendorianPriest",
		Map = M._MAP,
		Resource = M["YendorianPriest"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Base",
		MapObject = M["YendorianPriest"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian priest Rhy'lth",
		Language = "en-US",
		Resource = M["YendorianPriest"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["YendorianPriest"],
		Name = "Priest",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/HighChambersYendor_Floor2/Dialog/YendorianPriest_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["YendorianPriest"] {
		TalkAction
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["YendorianPriest"]
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
		PositionX = 79,
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
		PositionX = 83,
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

M["Room7_Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 45,
		Name = "Room7_Pirate1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room7_Pirate1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiPirate",
		MapObject = M["Room7_Pirate1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room7",
		Map = M._MAP,
		MapObject = M["Room7_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room7_Pirate1"]
	}
end

M["Room7_Pirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 1,
		PositionZ = 53,
		Name = "Room7_Pirate2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room7_Pirate2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiPirate",
		MapObject = M["Room7_Pirate2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room7",
		Map = M._MAP,
		MapObject = M["Room7_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room7_Pirate2"]
	}
end

M["Room7_Pirate3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 49,
		Name = "Room7_Pirate3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room7_Pirate3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_ZombiPirate",
		MapObject = M["Room7_Pirate3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room7",
		Map = M._MAP,
		MapObject = M["Room7_Pirate3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room7_Pirate3"]
	}
end

M["Room8_Ghost1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 1,
		PositionZ = 85,
		Name = "Room8_Ghost1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room8_Ghost1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Ghost",
		MapObject = M["Room8_Ghost1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room8",
		Map = M._MAP,
		MapObject = M["Room8_Ghost1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room8_Ghost1"]
	}
end

M["Room8_Ghost2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 1,
		PositionZ = 85,
		Name = "Room8_Ghost2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room8_Ghost2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Ghost",
		MapObject = M["Room8_Ghost2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room8",
		Map = M._MAP,
		MapObject = M["Room8_Ghost2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room8_Ghost2"]
	}
end

M["Room8_Ghost3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 1,
		PositionZ = 91,
		Name = "Room8_Ghost3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room8_Ghost3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Ghost",
		MapObject = M["Room8_Ghost3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room8",
		Map = M._MAP,
		MapObject = M["Room8_Ghost3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room8_Ghost3"]
	}
end

M["Room8_Ghost4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 1,
		PositionZ = 91,
		Name = "Room8_Ghost4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room8_Ghost4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Ghost",
		MapObject = M["Room8_Ghost4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room8",
		Map = M._MAP,
		MapObject = M["Room8_Ghost4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room8_Ghost4"]
	}
end

M["Room9_CthulhianParasite1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 2,
		PositionZ = 111,
		Name = "Room9_CthulhianParasite1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room9_CthulhianParasite1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite_Regular",
		MapObject = M["Room9_CthulhianParasite1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room9",
		Map = M._MAP,
		MapObject = M["Room9_CthulhianParasite1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room9_CthulhianParasite1"]
	}
end

M["Room9_CthulhianParasite2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 2,
		PositionZ = 111,
		Name = "Room9_CthulhianParasite2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room9_CthulhianParasite2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite_Regular",
		MapObject = M["Room9_CthulhianParasite2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room9",
		Map = M._MAP,
		MapObject = M["Room9_CthulhianParasite2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room9_CthulhianParasite2"]
	}
end

M["Room9_CthulhianParasite3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 1,
		PositionZ = 101,
		Name = "Room9_CthulhianParasite3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room9_CthulhianParasite3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite_Regular",
		MapObject = M["Room9_CthulhianParasite3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room9",
		Map = M._MAP,
		MapObject = M["Room9_CthulhianParasite3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveWanderCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room9_CthulhianParasite3"]
	}
end

M["Room10_RatKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 1,
		PositionZ = 99,
		Name = "Room10_RatKing",
		Direction = 1,
		Map = M._MAP,
		Resource = M["Room10_RatKing"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_RatKing",
		MapObject = M["Room10_RatKing"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room10",
		Map = M._MAP,
		MapObject = M["Room10_RatKing"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/HighChambersYendor_Floor2/Scripts/RatKing_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room10_RatKing"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/HighChambersYendor_Floor2/Scripts/RatKing_AttackLogic.lua",
		Resource = M["Room10_RatKing"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "hungry",
		Tree = "Resources/Game/Maps/HighChambersYendor_Floor2/Scripts/RatKing_HungryLogic.lua",
		Resource = M["Room10_RatKing"]
	}
end

M["Room10_Rat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 3,
		PositionZ = 99,
		Name = "Room10_Rat1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room10_Rat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Rat",
		MapObject = M["Room10_Rat1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room10_Rat1"]
	}
end

M["Room10_Rat2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 3,
		PositionZ = 105,
		Name = "Room10_Rat2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room10_Rat2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Rat",
		MapObject = M["Room10_Rat2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room10_Rat2"]
	}
end

M["Room10_Rat3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 1,
		PositionZ = 97,
		Name = "Room10_Rat3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Room10_Rat3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_Rat",
		MapObject = M["Room10_Rat3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Room10_Rat3"]
	}
end

M["Door_BeforeRoom1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 110,
		PositionY = 1,
		PositionZ = 85,
		Name = "Door_BeforeRoom1",
		Map = M._MAP,
		Resource = M["Door_BeforeRoom1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_BeforeRoom1"]
	}
end

M["Door_Room1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 101,
		PositionY = 1,
		PositionZ = 70,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_Room1",
		Map = M._MAP,
		Resource = M["Door_Room1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room1",
		Map = M._MAP,
		MapObject = M["Door_Room1"]
	}
end

M["Door_BeforeRoom2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 82,
		PositionY = 1,
		PositionZ = 59,
		Name = "Door_BeforeRoom2",
		Map = M._MAP,
		Resource = M["Door_BeforeRoom2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_BeforeRoom2"]
	}
end

M["Door_Room2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 98,
		PositionY = 1,
		PositionZ = 43,
		Name = "Door_Room2",
		Map = M._MAP,
		Resource = M["Door_Room2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room2",
		Map = M._MAP,
		MapObject = M["Door_Room2"]
	}
end

M["Door_Room3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 98,
		PositionY = 1,
		PositionZ = 23,
		Name = "Door_Room3",
		Map = M._MAP,
		Resource = M["Door_Room3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room3",
		Map = M._MAP,
		MapObject = M["Door_Room3"]
	}
end

M["Door_Room4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 73,
		PositionY = 1,
		PositionZ = 42,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_Room4",
		Map = M._MAP,
		Resource = M["Door_Room4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room4",
		Map = M._MAP,
		MapObject = M["Door_Room4"]
	}
end

M["Door_Room6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 1,
		PositionZ = 39,
		Name = "Door_Room6",
		Map = M._MAP,
		Resource = M["Door_Room6"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room6"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room6",
		Map = M._MAP,
		MapObject = M["Door_Room6"]
	}
end

M["Door_Room7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 34,
		PositionY = 1,
		PositionZ = 71,
		Name = "Door_Room7",
		Map = M._MAP,
		Resource = M["Door_Room7"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room7"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room7",
		Map = M._MAP,
		MapObject = M["Door_Room7"]
	}
end

M["Door_Room8"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 66,
		PositionY = 1,
		PositionZ = 97,
		Name = "Door_Room8",
		Map = M._MAP,
		Resource = M["Door_Room8"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room8"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room8",
		Map = M._MAP,
		MapObject = M["Door_Room8"]
	}
end

M["Door_Room9"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 98,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_Room9",
		Map = M._MAP,
		Resource = M["Door_Room9"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_Room9"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Room9",
		Map = M._MAP,
		MapObject = M["Door_Room9"]
	}
end

M["Light_Chandlier1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 97,
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

M["Light_Chandlier2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 3,
		PositionZ = 77,
		Name = "Light_Chandlier2",
		Map = M._MAP,
		Resource = M["Light_Chandlier2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Chandlier2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_Chandlier2"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 20,
		Resource = M["Light_Chandlier2"]
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

M["RatKingRewardChest"] {
	ItsyScape.Action.Collect()
}
