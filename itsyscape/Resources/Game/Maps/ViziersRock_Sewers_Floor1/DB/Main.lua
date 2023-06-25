local M = include "Resources/Game/Maps/ViziersRock_Sewers_Floor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.ViziersRock_Sewers_Floor1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock Sewers, Floor 1",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Damp and dark.",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.RaidGroup {
	Raid = ItsyScape.Resource.Raid "ViziersRockSewers",
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
		ColorRed = 120,
		ColorGreen = 91,
		ColorBlue = 70,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
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
		ColorRed = 120,
		ColorGreen = 91,
		ColorBlue = 70,
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
		ColorRed = 89,
		ColorGreen = 120,
		ColorBlue = 89,
		NearDistance = 15,
		FarDistance = 25,
		FollowTarget = 1,
		Resource = M["Light_Fog"]
	}
end

M["MetalLadder_ToCityCenter"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 0,
		PositionZ = 85,
		Name = "MetalLadder_ToCityCenter",
		Map = M._MAP,
		Resource = M["MetalLadder_ToCityCenter"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["MetalLadder_ToCityCenter"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromSewers",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["MetalLadder_ToCityCenter"] {
		TravelAction
	}
end

M["Anchor_FromCityCenter"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 0,
		PositionZ = 83,
		Name = "Anchor_FromCityCenter",
		Map = M._MAP,
		Resource = M["Anchor_FromCityCenter"]
	}
end

M["Valve_SquareTriangle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 0.125,
		PositionZ = 15,
		ScaleX = 0.5,
		ScaleY = 0.5,
		ScaleZ = 0.5,
		Name = "Valve_SquareTriangle",
		Map = M._MAP,
		Resource = M["Valve_SquareTriangle"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_Valve",
		MapObject = M["Valve_SquareTriangle"]
	}
end

M["Door_TrialValveWest_Triangle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 0,
		PositionZ = 15,
		Name = "Door_TrialValveWest_Triangle",
		Map = M._MAP,
		Resource = M["Door_TrialValveWest_Triangle"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_TrialValveWest_Triangle"]
	}
end

M["Door_TrialValveSouth_Square"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 0,
		PositionZ = 29,
		Name = "Door_TrialValveSouth_Square",
		Map = M._MAP,
		Resource = M["Door_TrialValveSouth_Square"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_TrialValveSouth_Square"]
	}
end

M["Door_Bridge_Circle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 61,
		Name = "Door_Bridge_Circle",
		Map = M._MAP,
		Resource = M["Door_Bridge_Circle"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_WaterDoor",
		MapObject = M["Door_Bridge_Circle"]
	}
end

M["RatKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 5,
		PositionZ = 55,
		Name = "RatKing",
		Map = M._MAP,
		Resource = M["RatKing"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RatKing",
		MapObject = M["RatKing"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "RatKing",
		Map = M._MAP,
		MapObject = M["RatKing"]
	}
end

M["RatKingUnleashed"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "RatKingUnleashed",
		Map = M._MAP,
		Resource = M["RatKingUnleashed"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "RatKingUnleashed",
		MapObject = M["RatKingUnleashed"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "RatKing",
		Map = M._MAP,
		MapObject = M["RatKingUnleashed"]
	}
end

M["RatKing_CourtRat_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 5,
		PositionZ = 55,
		Name = "RatKing_CourtRat_1",
		Map = M._MAP,
		Resource = M["RatKing_CourtRat_1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["RatKing_CourtRat_1"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "RatKing_Court",
		Map = M._MAP,
		MapObject = M["RatKing_CourtRat_1"]
	}
end

M["RatKing_CourtRat_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 5,
		PositionZ = 55,
		Name = "RatKing_CourtRat_2",
		Map = M._MAP,
		Resource = M["RatKing_CourtRat_2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["RatKing_CourtRat_2"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "RatKing_Court",
		Map = M._MAP,
		MapObject = M["RatKing_CourtRat_2"]
	}
end

M["RatKing_CourtRat_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 5,
		PositionZ = 55,
		Name = "RatKing_CourtRat_3",
		Map = M._MAP,
		Resource = M["RatKing_CourtRat_3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["RatKing_CourtRat_3"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "RatKing_Court",
		Map = M._MAP,
		MapObject = M["RatKing_CourtRat_3"]
	}
end

M["Light_RatKing"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 1.5,
		PositionZ = 57,
		Name = "Light_RatKing",
		Map = M._MAP,
		Resource = M["Light_RatKing"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_RatKing"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 255,
		ColorBlue = 255,
		Resource = M["Light_RatKing"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 12,
		Resource = M["Light_RatKing"]
	}
end

M["Light_ShrimpFishingSpot"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 2,
		PositionZ = 51,
		Name = "Light_ShrimpFishingSpot",
		Map = M._MAP,
		Resource = M["Light_ShrimpFishingSpot"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_ShrimpFishingSpot"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 255,
		ColorBlue = 200,
		Resource = M["Light_ShrimpFishingSpot"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 12,
		Resource = M["Light_ShrimpFishingSpot"]
	}
end

M["Anchor_FromCrawfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_FromCrawfish",
		Map = M._MAP,
		Resource = M["Anchor_FromCrawfish"]
	}
end

M["Anchor_FromCrawfish_Cutscene_LeftToRight"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 2,
		PositionZ = 15,
		Name = "Anchor_FromCrawfish_Cutscene_LeftToRight",
		Map = M._MAP,
		Resource = M["Anchor_FromCrawfish_Cutscene_LeftToRight"]
	}
end

M["Anchor_FromCrawfish_Cutscene_RightToLeft"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 2,
		PositionZ = 15,
		Name = "Anchor_FromCrawfish_Cutscene_RightToLeft",
		Map = M._MAP,
		Resource = M["Anchor_FromCrawfish_Cutscene_RightToLeft"]
	}
end

M["Anchor_FromCrawfish_Cutscene_RightToLeft_Jump"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4.5,
		PositionZ = 15,
		Name = "Anchor_FromCrawfish_Cutscene_RightToLeft_Jump",
		Map = M._MAP,
		Resource = M["Anchor_FromCrawfish_Cutscene_RightToLeft_Jump"]
	}
end

M["Pipe_ToCrawfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17.875,
		PositionY = 0,
		PositionZ = 15,
		RotationX = 0,
		RotationY = 0.707107,
		RotationZ = 0,
		RotationW = -0.707107,
		Name = "Pipe_ToCrawfish",
		Map = M._MAP,
		Resource = M["Pipe_ToCrawfish"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_Pipe_NoGrate",
		MapObject = M["Pipe_ToCrawfish"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/ViziersRock_Sewers_Floor1/Dialog/Crawl_LeftToRight.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Crawl-through",
		XProgressive = "Crawling-through",
		Language = "en-US",
		Action = TalkAction
	}

	M["Pipe_ToCrawfish"] {
		TalkAction
	}
end

M["Anchor_ToCrawfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_ToCrawfish",
		Map = M._MAP,
		Resource = M["Anchor_ToCrawfish"]
	}
end

M["Anchor_ToCrawfish_Cutscene_LeftToRight"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_ToCrawfish_Cutscene_LeftToRight",
		Map = M._MAP,
		Resource = M["Anchor_ToCrawfish_Cutscene_LeftToRight"]
	}
end

M["Anchor_ToCrawfish_Cutscene_RightToLeft"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 22,
		PositionY = 2,
		PositionZ = 15,
		Name = "Anchor_ToCrawfish_Cutscene_RightToLeft",
		Map = M._MAP,
		Resource = M["Anchor_ToCrawfish_Cutscene_RightToLeft"]
	}
end

M["Anchor_ToCrawfish_Cutscene_LeftToRight_Jump"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 4.5,
		PositionZ = 15,
		Name = "Anchor_ToCrawfish_Cutscene_LeftToRight_Jump",
		Map = M._MAP,
		Resource = M["Anchor_ToCrawfish_Cutscene_LeftToRight_Jump"]
	}
end

M["Pipe_FromCrawfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 22.125,
		PositionY = 0,
		PositionZ = 15,
		RotationX = 0,
		RotationY = 0.707107,
		RotationZ = 0,
		RotationW = 0.707107,
		Name = "Pipe_FromCrawfish",
		Map = M._MAP,
		Resource = M["Pipe_FromCrawfish"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "ViziersRock_Sewers_Pipe_NoGrate",
		MapObject = M["Pipe_FromCrawfish"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/ViziersRock_Sewers_Floor1/Dialog/Crawl_RightToLeft.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Crawl-through",
		XProgressive = "Crawling-through",
		Language = "en-US",
		Action = TalkAction
	}

	M["Pipe_FromCrawfish"] {
		TalkAction
	}
end

M["Light_CrawfishFishingSpot"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 1.5,
		PositionZ = 13,
		Name = "Light_CrawfishFishingSpot",
		Map = M._MAP,
		Resource = M["Light_CrawfishFishingSpot"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_CrawfishFishingSpot"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 200,
		ColorBlue = 255,
		Resource = M["Light_CrawfishFishingSpot"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 12,
		Resource = M["Light_CrawfishFishingSpot"]
	}
end

M["Light_SewerValve"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 2,
		PositionZ = 15,
		Name = "Light_SewerValve",
		Map = M._MAP,
		Resource = M["Light_SewerValve"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_SewerValve"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 200,
		ColorGreen = 200,
		ColorBlue = 200,
		Resource = M["Light_SewerValve"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 15,
		Resource = M["Light_SewerValve"]
	}
end

M["Light_Pond"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 1.5,
		PositionZ = 39,
		Name = "Light_Pond",
		Map = M._MAP,
		Resource = M["Light_Pond"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_Pond"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 200,
		ColorBlue = 200,
		Resource = M["Light_Pond"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 12,
		Resource = M["Light_Pond"]
	}
end

M["Anchor_ToPuzzleTrapDoor_Floor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_ToPuzzleTrapDoor_Floor1",
		Map = M._MAP,
		Resource = M["Anchor_ToPuzzleTrapDoor_Floor1"]
	}
end

M["TrapDoor_ToPuzzle_Floor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 0,
		PositionZ = 15,
		Name = "TrapDoor_ToPuzzle_Floor2",
		Map = M._MAP,
		Resource = M["TrapDoor_ToPuzzle_Floor2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_ToPuzzle_Floor2"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor1Puzzle",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Descend",
		XProgressive = "Descending",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor_ToPuzzle_Floor2"] {
		TravelAction
	}
end

M["Anchor_ToOtherPuzzleTrapDoor_Floor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_ToOtherPuzzleTrapDoor_Floor1",
		Map = M._MAP,
		Resource = M["Anchor_ToOtherPuzzleTrapDoor_Floor1"]
	}
end

M["TrapDoor_ToKaradon_Floor2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 0,
		PositionZ = 15,
		Name = "TrapDoor_ToKaradon_Floor2",
		Map = M._MAP,
		Resource = M["TrapDoor_ToKaradon_Floor2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_ToKaradon_Floor2"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_OtherFromFloor1Puzzle",
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Descend",
		XProgressive = "Descending",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor_ToKaradon_Floor2"] {
		TravelAction
	}
end

M["Shrimp1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 0,
		PositionZ = 61,
		Name = "Shrimp1",
		Map = M._MAP,
		Resource = M["Shrimp1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Shrimp_Default",
		MapObject = M["Shrimp1"]
	}
end

M["Shrimp2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 0,
		PositionZ = 51,
		Name = "Shrimp2",
		Map = M._MAP,
		Resource = M["Shrimp2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Shrimp_Default",
		MapObject = M["Shrimp2"]
	}
end

M["Shrimp3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 0,
		PositionZ = 61,
		Name = "Shrimp3",
		Map = M._MAP,
		Resource = M["Shrimp3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Shrimp_Default",
		MapObject = M["Shrimp3"]
	}
end

M["Crawfish1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 0,
		PositionZ = 13,
		Name = "Crawfish1",
		Map = M._MAP,
		Resource = M["Crawfish1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crawfish_Default",
		MapObject = M["Crawfish1"]
	}
end

M["Crawfish2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 17,
		Name = "Crawfish2",
		Map = M._MAP,
		Resource = M["Crawfish2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crawfish_Default",
		MapObject = M["Crawfish2"]
	}
end

M["Crawfish2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 0,
		PositionZ = 11,
		Name = "Crawfish2",
		Map = M._MAP,
		Resource = M["Crawfish2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crawfish_Default",
		MapObject = M["Crawfish2"]
	}
end

M["Rat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 0,
		PositionZ = 83,
		Name = "Rat1",
		Map = M._MAP,
		Resource = M["Rat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat1"]
	}
end

M["Rat2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 0,
		PositionZ = 85,
		Name = "Rat2",
		Map = M._MAP,
		Resource = M["Rat2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat2"]
	}
end

M["Rat3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 0,
		PositionZ = 83,
		Name = "Rat3",
		Map = M._MAP,
		Resource = M["Rat3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat3"]
	}
end

M["Rat4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 0,
		PositionZ = 87,
		Name = "Rat4",
		Map = M._MAP,
		Resource = M["Rat4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat4"]
	}
end

M["SkeletalRat1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 81,
		Name = "SkeletalRat1",
		Map = M._MAP,
		Resource = M["SkeletalRat1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "SkeletalRat",
		MapObject = M["SkeletalRat1"]
	}
end

M["Rat5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 0,
		PositionZ = 77,
		Name = "Rat5",
		Map = M._MAP,
		Resource = M["Rat5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat5"]
	}
end

M["Rat6"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 79,
		Name = "Rat6",
		Map = M._MAP,
		Resource = M["Rat6"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat6"]
	}
end

M["Rat7"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 89,
		Name = "Rat7",
		Map = M._MAP,
		Resource = M["Rat7"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rat",
		MapObject = M["Rat7"]
	}
end

M["TrashHeap1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 0,
		PositionZ = 13,
		Name = "TrashHeap1",
		Map = M._MAP,
		Resource = M["TrashHeap1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap1"]
	}
end

do
	ItsyScape.Resource.Cutscene "ViziersRock_Sewers_Floor1_Crawl_LeftToRight"
	ItsyScape.Resource.Cutscene "ViziersRock_Sewers_Floor1_Crawl_RightToLeft"
end
