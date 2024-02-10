local M = include "Resources/Game/Maps/Rumbridge_Castle_Floor1/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle_Floor1.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle, Floor 1",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sleeping quarters of the Earl and his guests.",
	Language = "en-US",
	Resource = M._MAP
}

M["Anchor_FromStairs"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 15,
		Name = "Anchor_FromStairs",
		Map = M._MAP,
		Resource = M["Anchor_FromStairs"]
	}
end

M["Anchor_FromLadder"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 13,
		Name = "Anchor_FromLadder",
		Map = M._MAP,
		Resource = M["Anchor_FromLadder"]
	}
end

M["Ladder_ToThroneRoom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 0,
		PositionZ = 13,
		Name = "Ladder_ToThroneRoom",
		Map = M._MAP,
		Resource = M["Ladder_ToThroneRoom"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToThroneRoom"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromLadder",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor2",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_ToThroneRoom"] {
		TravelAction
	}
end

M["SpiralStaircase"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 0,
		PositionZ = 13,
		Name = "SpiralStaircase",
		Map = M._MAP,
		Resource = M["SpiralStaircase"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase"]
	}

	local TravelActionUp = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromStairs",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor2",
		Action = TravelActionUp
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelActionUp
	}

	M["SpiralStaircase"] {
		TravelActionUp
	}

	local TravelActionDown = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFloor1",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle",
		Action = TravelActionDown
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelActionDown
	}

	M["SpiralStaircase"] {
		TravelActionDown
	}
end

M["Door_ToAttic1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 19,
		Name = "Door_ToAttic1",
		Map = M._MAP,
		Resource = M["Door_ToAttic1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_ToAttic1"]
	}

	M["Door_ToAttic1"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "Rumbridge_Castle_SecretAtticKey",
				Count = 1
			}
		},
	}
end

M["Door_ToAttic2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 0,
		PositionZ = 15,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = -0.707107,
		Name = "Door_ToAttic2",
		Map = M._MAP,
		Resource = M["Door_ToAttic2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_ToAttic2"]
	}

	M["Door_ToAttic2"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "Rumbridge_Castle_SecretAtticKey",
				Count = 1
			}
		},
	}
end

M["Chandelier"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 5.25,
		PositionZ = 35,
		Name = "Chandelier",
		Map = M._MAP,
		Resource = M["Chandelier"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chandelier_Default",
		MapObject = M["Chandelier"]
	}
end

M["Anchor_EarlReddick"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 0,
		PositionZ = 35,
		Name = "Anchor_EarlReddick",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick"]
	}
end

M["Anchor_EarlReddick_Left"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 18,
		PositionY = 0,
		PositionZ = 35,
		Name = "Anchor_EarlReddick_Left",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick_Left"]
	}
end

M["Anchor_EarlReddick_Right"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 0,
		PositionZ = 35,
		Name = "Anchor_EarlReddick_Right",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick_Right"]
	}
end

M["Guard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 0,
		PositionZ = 27,
		Name = "Guard1",
		Map = M._MAP,
		Resource = M["Guard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon_Cutscene",
		MapObject = M["Guard1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Rumbridge_Castle_Floor1/Scripts/Guard_IdleLogic.lua",
		Resource = M["Guard1"]
	}
end

M["Guard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 0,
		PositionZ = 37,
		Name = "Guard2",
		Map = M._MAP,
		Resource = M["Guard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon_Cutscene",
		MapObject = M["Guard2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Rumbridge_Castle_Floor1/Scripts/Guard_IdleLogic.lua",
		Resource = M["Guard2"]
	}
end

M["EarlReddick"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "EarlReddick",
		Map = M._MAP,
		Resource = M["EarlReddick"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "EarlReddick",
		MapObject = M["EarlReddick"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Name = "EarlReddick",
		Resource = M["EarlReddick"],
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Name = "Guard1",
		Resource = M["Guard1"],
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Name = "Guard2",
		Resource = M["Guard2"],
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle_Floor1/Dialog/EarlReddick_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["EarlReddick"] {
		TalkAction
	}
end

M["Kvre"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Kvre",
		Map = M._MAP,
		Resource = M["Kvre"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Drakkenson_Kvre",
		MapObject = M["Kvre"]
	}
end

M["Isabelle"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Isabelle",
		Map = M._MAP,
		Resource = M["Isabelle"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_IsabelleMean",
		MapObject = M["Isabelle"]
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Name = "EarlReddick",
		Resource = M["EarlReddick"],
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Name = "Guard1",
		Resource = M["Guard1"],
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Name = "Guard2",
		Resource = M["Guard2"],
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Name = "Demon",
		Resource = ItsyScape.Resource.Peep "SuperSupperSaboteur_DemonicAssassin",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Name = "Hellhound",
		Resource = ItsyScape.Resource.Peep "SuperSupperSaboteur_Hellhound",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle_Floor1/Dialog/SuperSupperSaboteurInProgress_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "StartSuperSupperSaboteurCutscene",
		Action = TalkAction,
		Map = M._MAP
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_Floor1_AssassinationAttempt"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "EarlReddick",
		Cutscene = Cutscene,
		Resource = M["EarlReddick"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Guard1",
		Cutscene = Cutscene,
		Resource = M["Guard1"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Guard2",
		Cutscene = Cutscene,
		Resource = M["Guard2"]
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Demon",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "SuperSupperSaboteur_DemonicAssassin"
	}

	ItsyScape.Meta.CutscenePeep {
		Name = "Hellhound",
		Cutscene = Cutscene,
		Resource = ItsyScape.Resource.Peep "SuperSupperSaboteur_Hellhound"
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_Floor1_Intro"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "EarlReddick",
		Cutscene = Cutscene,
		Resource = M["EarlReddick"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Isabelle",
		Cutscene = Cutscene,
		Resource = M["Isabelle"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Kvre",
		Cutscene = Cutscene,
		Resource = M["Kvre"]
	}
end
