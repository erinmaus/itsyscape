local M = include "Resources/Game/Maps/Sailing_WhalingTemple_Underground/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_WhalingTemple_Underground.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Underground, The Whaling Temple",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A cave running under the abandoned Yendorian whaling temple.",
	Language = "en-US",
	Resource = M._MAP
}

M["Ladder_FromFish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 0,
		PositionZ = 49,
		Name = "Ladder_FromFish",
		Map = M._MAP,
		Resource = M["Ladder_FromFish"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_FromFish"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromMine",
		Map = ItsyScape.Resource.Map "Sailing_WhalingTemple",
		IsInstance = 1,
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_FromFish"] {
		TravelAction
	}
end

M["Anchor_FromFish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 5,
		PositionZ = 51,
		Name = "Anchor_FromFish",
		Map = M._MAP,
		Resource = M["Anchor_FromFish"]
	}
end

M["Anchor_FromBoss"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 0,
		PositionZ = 39,
		Name = "Anchor_FromBoss",
		Map = M._MAP,
		Resource = M["Anchor_FromBoss"]
	}
end

M["Ladder_ToBoss"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 0,
		PositionZ = 41,
		Name = "Ladder_ToBoss",
		Map = M._MAP,
		Resource = M["Ladder_ToBoss"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_ToBoss"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromMineToBoss",
		Map = ItsyScape.Resource.Map "Sailing_WhalingTemple",
		IsInstance = 1,
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToBoss"] {
		TravelAction
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
		ColorRed = 128,
		ColorGreen = 128,
		ColorBlue = 255,
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
		ColorRed = 66,
		ColorGreen = 66,
		ColorBlue = 132,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 5,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
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
		ColorRed = 33,
		ColorGreen = 33,
		ColorBlue = 33,
		NearDistance = 5,
		FarDistance = 10,
		FollowTarget = 1,
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
		ColorRed = 83,
		ColorGreen = 103,
		ColorBlue = 108,
		NearDistance = 30,
		FarDistance = 60,
		Resource = M["Light_Fog2"]
	}
end

M["Door_FromYenderling"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 0,
		PositionZ = 39,
		Name = "Door_FromYenderling",
		Map = M._MAP,
		Resource = M["Door_FromYenderling"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_FromYenderling"]
	}

	M["Door_FromYenderling"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.KeyItem "PreTutorial_SlayedYenderling",
				Count = 1
			}
		},

		ItsyScape.Action.Close()
	}
end

M["Anchor_BeforeYenderling"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 0,
		PositionZ = 51,
		Name = "Anchor_BeforeYenderling",
		Map = M._MAP,
		Resource = M["Anchor_BeforeYenderling"]
	}
end

M["Yenderling"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 14,
		PositionY = 1,
		PositionZ = 50,
		Name = "Yenderling",
		Map = M._MAP,
		Resource = M["Yenderling"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Yenderling",
		MapObject = M["Yenderling"],
		DoesRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle-attack",
		IsDefault = 1,
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple_Underground/Scripts/Yenderling_AttackLogic.lua",
		Resource = M["Yenderling"]
	}
end

M["Zombi1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 15,
		Name = "Zombi1",
		Map = M._MAP,
		Resource = M["Zombi1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi1"],
		DoesRespawn = 1
	}
end

M["Zombi2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 0,
		PositionZ = 21,
		Name = "Zombi2",
		Map = M._MAP,
		Resource = M["Zombi2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi2"],
		DoesRespawn = 1
	}
end

M["Zombi3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 0,
		PositionZ = 21,
		Name = "Zombi3",
		Map = M._MAP,
		Resource = M["Zombi3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi3"],
		DoesRespawn = 1
	}
end

M["Zombi4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 0,
		PositionZ = 31,
		Name = "Zombi4",
		Map = M._MAP,
		Resource = M["Zombi4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi4"],
		DoesRespawn = 1
	}
end

M["Zombi5"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 0,
		PositionZ = 39,
		Name = "Zombi5",
		Map = M._MAP,
		Resource = M["Zombi5"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Zombi_Base_Attackable",
		MapObject = M["Zombi5"],
		DoesRespawn = 1
	}
end

M["Door_ToBoss"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0,
		PositionZ = 17.25,
		RotationX = 0,
		RotationY = 0.707107,
		RotationZ = 0,
		RotationW = 0.707107,
		Name = "Door_ToBoss",
		Map = M._MAP,
		Resource = M["Door_ToBoss"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_ToBoss"]
	}

	M["Door_ToBoss"] {
		ItsyScape.Action.Open(),
		ItsyScape.Action.Close()
	}
end

M["Passage_ToBossDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_ToBossDoor",
		Map = M._MAP,
		Resource = M["Passage_ToBossDoor"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 26,
		Z1 = 16,
		X2 = 28,
		Z2 = 20,
		Map = M._MAP,
		Resource = M["Passage_ToBossDoor"]
	}
end

M["Passage_ToMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_ToMine",
		Map = M._MAP,
		Resource = M["Passage_ToMine"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 8,
		Z1 = 34,
		X2 = 18,
		Z2 = 42,
		Map = M._MAP,
		Resource = M["Passage_ToMine"]
	}
end

M["Passage_Mine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Mine",
		Map = M._MAP,
		Resource = M["Passage_Mine"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 15,
		Z1 = 23,
		X2 = 19,
		Z2 = 27,
		Map = M._MAP,
		Resource = M["Passage_Mine"]
	}
end

M["Anchor_ToMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 0,
		PositionZ = 25,
		Name = "Anchor_ToMine",
		Map = M._MAP,
		Resource = M["Anchor_ToMine"]
	}
end

M["Anchor_ToSmithy"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 0,
		PositionZ = 17,
		Name = "Anchor_ToSmithy",
		Map = M._MAP,
		Resource = M["Anchor_ToSmithy"]
	}
end

do
	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Anvil_Default1"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_SmithedUpAndComingHeroItem"
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Furnace_Default1"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_SmeltedWeirdBars"
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_WhalingTemple_Underground_Yenderling"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Yenderling",
		Cutscene = Cutscene,
		Resource = M["Yenderling"]
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Rosalind",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind"
	}
end
