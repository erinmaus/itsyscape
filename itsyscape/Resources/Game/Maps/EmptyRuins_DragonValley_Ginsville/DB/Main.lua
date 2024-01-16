local M = include "Resources/Game/Maps/EmptyRuins_DragonValley_Ginsville/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.EmptyRuins_DragonValley_Ginsville.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Old Ginsville Ruins",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Recently ravaged by the enraged, undead dragon Svalbard.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.RaidGroup {
	Raid = ItsyScape.Resource.Raid "EmptyRuinsDragonValley",
	Map = M._MAP
}

M["Anchor_Trees"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 4,
		PositionZ = 67,
		Name = "Anchor_Trees",
		Map = M._MAP,
		Resource = M["Anchor_Trees"]
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
		ColorRed = 113,
		ColorGreen = 55,
		ColorBlue = 200,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.5,
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
		ColorRed = 100,
		ColorGreen = 100,
		ColorBlue = 100,
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
		ColorRed = 55,
		ColorGreen = 55,
		ColorBlue = 55,
		NearDistance = 10,
		FarDistance = 25,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["Entrance_ToMines"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 4,
		PositionZ = 19.875000,
		Name = "Entrance_ToMines",
		Map = M._MAP,
		Resource = M["Entrance_ToMines"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Entrance",
		MapObject = M["Entrance_ToMines"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mt. Vazikerl mines entrance",
		Language = "en-US",
		Resource = M["Entrance_ToMines"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's tremors coming from in those mines...",
		Language = "en-US",
		Resource = M["Entrance_ToMines"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromGinsville",
		Map = ItsyScape.Resource.Map "EmptyRuins_DragonValley_Mine",
		Action = TravelAction
	}

	M["Entrance_ToMines"] {
		TravelAction
	}
end

M["Anchor_FromMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 4,
		PositionZ = 21,
		Name = "Anchor_FromMine",
		Map = M._MAP,
		Resource = M["Anchor_FromMine"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 91,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Tinkerer"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 4,
		PositionZ = 47,
		Name = "Tinkerer",
		Map = M._MAP,
		Resource = M["Tinkerer"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Tinkerer_DragonValley_Unattackable",
		MapObject = M["Tinkerer"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Tinkerer"]
	}
end

M["Fire1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 4,
		PositionZ = 69,
		ScaleX = 2.5,
		ScaleY = 4,
		ScaleZ = 2.5,
		Name = "Fire1",
		Map = M._MAP,
		Resource = M["Fire1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire1"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire1"]
	}
end

M["Fire2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 4,
		PositionZ = 45,
		ScaleX = 3,
		ScaleY = 4,
		ScaleZ = 3,
		Name = "Fire2",
		Map = M._MAP,
		Resource = M["Fire2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire2"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire2"]
	}
end

M["Fire3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 29,
		ScaleX = 1.5,
		ScaleY = 4,
		ScaleZ = 1.5,
		Name = "Fire3",
		Map = M._MAP,
		Resource = M["Fire3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire3"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire3"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire3"]
	}
end

M["Fire4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 4,
		PositionZ = 87,
		ScaleX = 3,5,
		ScaleY = 5,
		ScaleZ = 3.5,
		Name = "Fire4",
		Map = M._MAP,
		Resource = M["Fire4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "RagingFire",
		MapObject = M["Fire4"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Fire4"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 2,
		DirectionY = 4,
		DirectionZ = 2,
		Resource = M["Fire4"]
	}
end

M["ExperimentX"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 55,
		Name = "ExperimentX",
		Map = M._MAP,
		Resource = M["ExperimentX"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ExperimentX",
		MapObject = M["ExperimentX"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}
end

M["Door_Tinkerer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 28,
		PositionY = 4,
		PositionZ = 43.5,
		Name = "Door_Tinkerer1",
		Map = M._MAP,
		Resource = M["Door_Tinkerer1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked",
		MapObject = M["Door_Tinkerer1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Door_Tinkerer1"]
	}

	M["Door_Tinkerer1"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Door_Tinkerer2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19.5,
		PositionY = 4,
		PositionZ = 58,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		Name = "Door_Tinkerer2",
		Map = M._MAP,
		Resource = M["Door_Tinkerer2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_EmptyRuins_Locked",
		MapObject = M["Door_Tinkerer2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Door_Tinkerer2"]
	}

	M["Door_Tinkerer2"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Door_Tinkerer3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 44.5,
		PositionY = 4,
		PositionZ = 57,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Door_Tinkerer3",
		Map = M._MAP,
		Resource = M["Door_Tinkerer3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_EmptyRuins_Single_Locked",
		MapObject = M["Door_Tinkerer3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_Tinkerer",
		Map = M._MAP,
		MapObject = M["Door_Tinkerer3"]
	}

	M["Door_Tinkerer3"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Adventurer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 83,
		Name = "Adventurer1",
		Map = M._MAP,
		Resource = M["Adventurer1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer1"]
	}
end

M["Adventurer2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 77,
		Name = "Adventurer2",
		Map = M._MAP,
		Resource = M["Adventurer2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer2"]
	}
end

M["Adventurer3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 87,
		Name = "Adventurer3",
		Map = M._MAP,
		Resource = M["Adventurer3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer3"]
	}
end

M["Adventurer4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 69,
		Name = "Adventurer4",
		Map = M._MAP,
		Resource = M["Adventurer4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer4"]
	}
end

M["Adventurer5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 4,
		PositionZ = 71,
		Name = "Adventurer5",
		Map = M._MAP,
		Resource = M["Adventurer5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "DisemboweledAdventurer",
		MapObject = M["Adventurer5"]
	}
end

M["Trailer_SurgeonZombi"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Trailer_SurgeonZombi",
		Map = M._MAP,
		Resource = M["Trailer_SurgeonZombi"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SurgeonZombi",
		MapObject = M["Trailer_SurgeonZombi"]
	}
end

M["Trailer_FleshyPillar"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Trailer_FleshyPillar",
		Map = M._MAP,
		Resource = M["Trailer_FleshyPillar"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EmptyRuins_DragonValley_FleshyPillar",
		MapObject = M["Trailer_FleshyPillar"]
	}
end

M["Trailer_GoryMass"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Trailer_GoryMass",
		Map = M._MAP,
		Resource = M["Trailer_GoryMass"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GoryMass",
		MapObject = M["Trailer_GoryMass"]
	}
end

M["Trailer_CameraDolly"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Trailer_CameraDolly",
		Map = M._MAP,
		Resource = M["Trailer_CameraDolly"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CameraDolly",
		MapObject = M["Trailer_CameraDolly"]
	}
end

M["Trailer_Sweep_Tinkerer_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 55,
		Name = "Trailer_Sweep_Tinkerer_1",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_Tinkerer_1"]
	}
end

M["Trailer_Sweep_Tinkerer_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 47,
		Name = "Trailer_Sweep_Tinkerer_2",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_Tinkerer_2"]
	}
end

M["Trailer_Sweep_SurgeonZombi_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 63,
		Name = "Trailer_Sweep_SurgeonZombi_1",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_SurgeonZombi_1"]
	}
end

M["Trailer_Sweep_SurgeonZombi_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 4,
		PositionZ = 57,
		Name = "Trailer_Sweep_SurgeonZombi_2",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_SurgeonZombi_2"]
	}
end

M["Trailer_Sweep_GoryMass_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 61,
		Name = "Trailer_Sweep_GoryMass_1",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_GoryMass_1"]
	}
end

M["Trailer_Sweep_GoryMass_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 4,
		PositionZ = 53,
		Name = "Trailer_Sweep_GoryMass_2",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_GoryMass_2"]
	}
end

M["Trailer_Sweep_Dolly_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 10,
		PositionZ = 81,
		Name = "Trailer_Sweep_Dolly_1",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_Dolly_1"]
	}
end

M["Trailer_Sweep_Dolly_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 10,
		PositionZ = 29,
		Name = "Trailer_Sweep_Dolly_2",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_Dolly_2"]
	}
end

M["Trailer_Sweep_ExperimentX_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 47,
		Name = "Trailer_Sweep_ExperimentX_1",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_ExperimentX_1"]
	}
end

M["Trailer_Sweep_ExperimentX_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 57,
		Name = "Trailer_Sweep_ExperimentX_2",
		Map = M._MAP,
		Resource = M["Trailer_Sweep_ExperimentX_2"]
	}
end

M["Trailer_ZoomInView"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 10,
		PositionZ = 57,
		Name = "Trailer_ZoomInView",
		Map = M._MAP,
		Resource = M["Trailer_ZoomInView"]
	}
end

M["Trailer_ExperimentX_Fight_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 47,
		Name = "Trailer_ExperimentX_Fight_1",
		Map = M._MAP,
		Resource = M["Trailer_ExperimentX_Fight_1"]
	}
end

M["Trailer_ExperimentX_Fight_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 4,
		PositionZ = 53,
		Name = "Trailer_ExperimentX_Fight_2",
		Map = M._MAP,
		Resource = M["Trailer_ExperimentX_Fight_2"]
	}
end

M["Trailer_Tinkerer_BoneBlast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 63,
		Name = "Trailer_Tinkerer_BoneBlast",
		Map = M._MAP,
		Resource = M["Trailer_Tinkerer_BoneBlast"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "EmptyRuins_DragonValley_Ginsville_Trailer"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ExperimentX",
		Cutscene = Cutscene,
		Resource = M["ExperimentX"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Tinkerer",
		Cutscene = Cutscene,
		Resource = M["Tinkerer"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "GoryMass",
		Cutscene = Cutscene,
		Resource = M["Trailer_GoryMass"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "SurgeonZombi",
		Cutscene = Cutscene,
		Resource = M["Trailer_SurgeonZombi"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "FleshyPillar",
		Cutscene = Cutscene,
		Resource = M["Trailer_FleshyPillar"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["Trailer_CameraDolly"]
	}
end

M["Portal_Temp_ToViziersRock"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 30,
		PositionY = 4,
		PositionZ = 93,
		Name = "Portal_Temp_ToViziersRock",
		Map = M._MAP,
		Resource = M["Portal_Temp_ToViziersRock"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3.5,
		SizeY = 2,
		SizeZ = 3.5,
		MapObject = M["Portal_Temp_ToViziersRock"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_Temp_ToViziersRock"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier's Rock (temporary)",
		Language = "en-US",
		Resource = M["Portal_Temp_ToViziersRock"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "SneakyGuy",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center_Floor2",
		Action = TravelAction
	}

	M["Portal_Temp_ToViziersRock"] {
		TravelAction
	}
end
