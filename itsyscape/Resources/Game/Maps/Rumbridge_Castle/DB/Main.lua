local M = include "Resources/Game/Maps/Rumbridge_Castle/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Rumbridge_Castle.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Rumbridge, Castle",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Castle of Earl Reddick and home of the Rumbridge.",
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
		Ambience = 0.6,
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
		ColorRed = 175,
		ColorGreen = 223,
		ColorBlue = 233,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		Resource = M["Light_Sun"]
	}
end

M["Anchor_FromFloor1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_FromFloor1",
		Map = M._MAP,
		Resource = M["Anchor_FromFloor1"]
	}
end

M["Anchor_FromBasement"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 29,
		Name = "Anchor_FromBasement",
		Map = M._MAP,
		Resource = M["Anchor_FromBasement"]
	}
end

M["Anchor_FromDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 4,
		PositionZ = 39,
		Name = "Anchor_FromDungeon",
		Map = M._MAP,
		Resource = M["Anchor_FromDungeon"]
	}
end

M["Anchor_FromTown1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 59,
		Name = "Anchor_FromTown1",
		Map = M._MAP,
		Resource = M["Anchor_FromTown1"]
	}
end

M["Anchor_FromTown2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 4,
		PositionZ = 59,
		Name = "Anchor_FromTown2",
		Map = M._MAP,
		Resource = M["Anchor_FromTown2"]
	}
end

M["Anchor_FromMonastery"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 4,
		PositionZ = 5,
		Name = "Anchor_FromMonastery",
		Map = M._MAP,
		Resource = M["Anchor_FromMonastery"]
	}
end

M["SpiralStaircase"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 4,
		PositionZ = 13,
		Name = "SpiralStaircase",
		Map = M._MAP,
		Resource = M["SpiralStaircase"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromStairs",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Floor1",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		XProgressive = "Climbing-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["SpiralStaircase"] {
		TravelAction
	}
end

M["Ladder_ToBasement"] = ItsyScape.Resource.MapObject.Unique()
do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromKitchen",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Basement",
		Action = TravelAction
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 2,
		PositionZ = 29,
		RotationX = 0.000000,
		RotationY = 0.707107,
		RotationZ = 0.000000,
		RotationW = 0.707107,
		Name = "Ladder_ToBasement",
		Map = M._MAP,
		Resource = M["Ladder_ToBasement"]
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = -1,
		Resource = M["Ladder_ToBasement"]
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "WoodenLadder_Default",
		MapObject = M["Ladder_ToBasement"]
	}

	M["Ladder_ToBasement"] {
		TravelAction
	}
end

M["SpiralStaircase_ToDungeon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 47,
		PositionY = 0,
		PositionZ = 39,
		Name = "SpiralStaircase_ToDungeon",
		Map = M._MAP,
		Resource = M["SpiralStaircase_ToDungeon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "SpiralStaircase_Default",
		MapObject = M["SpiralStaircase_ToDungeon"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromGroundFloor",
		Map = ItsyScape.Resource.Map "Rumbridge_Castle_Dungeon",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["SpiralStaircase_ToDungeon"] {
		TravelAction
	}
end

M["Portal_ToTown1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 4,
		PositionZ = 61,
		Name = "Portal_ToTown1",
		Map = M._MAP,
		Resource = M["Portal_ToTown1"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToTown1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToTown1"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Town Center, Home District",
		Language = "en-US",
		Resource = M["Portal_ToTown1"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromCastle1",
		Map = ItsyScape.Resource.Map "Rumbridge_Town_Homes",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToTown1"] {
		TravelAction
	}
end

M["Portal_ToTown2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 4,
		PositionZ = 61,
		Name = "Portal_ToTown2",
		Map = M._MAP,
		Resource = M["Portal_ToTown2"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToTown2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToTown2"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Town Center, Home District",
		Language = "en-US",
		Resource = M["Portal_ToTown2"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromCastle2",
		Map = ItsyScape.Resource.Map "Rumbridge_Town_Homes",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToTown2"] {
		TravelAction
	}
end

M["Portal_ToMonastery"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 32,
		PositionY = 4,
		PositionZ = 2,
		Name = "Portal_ToMonastery",
		Map = M._MAP,
		Resource = M["Portal_ToMonastery"]
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6,
		SizeY = 2,
		SizeZ = 6,
		MapObject = M["Portal_ToMonastery"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "InvisiblePortal",
		MapObject = M["Portal_ToMonastery"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Monastery",
		Language = "en-US",
		Resource = M["Portal_ToMonastery"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromCastle",
		Map = ItsyScape.Resource.Map "Rumbridge_Monastery",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["Portal_ToMonastery"] {
		TravelAction
	}
end

M["Anchor_Oliver"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_Oliver",
		Map = M._MAP,
		Resource = M["Anchor_Oliver"]
	}
end

M["Anchor_Oliver_RunAway"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 31,
		Name = "Anchor_Oliver_RunAway",
		Map = M._MAP,
		Resource = M["Anchor_Oliver_RunAway"]
	}
end

M["Oliver"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Oliver",
		Map = M._MAP,
		Resource = M["Oliver"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Oliver",
		MapObject = M["Oliver"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mysterious dog",
		Language = "en-US",
		Resource = M["Oliver"]
	}
end

M["Anchor_ButlerLear"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_ButlerLear",
		Map = M._MAP,
		Resource = M["Anchor_ButlerLear"]
	}
end

M["Anchor_ButlerLear_PlayerWalkTo"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_ButlerLear_PlayerWalkTo",
		Map = M._MAP,
		Resource = M["Anchor_ButlerLear_PlayerWalkTo"]
	}
end

M["Anchor_ButlerLear_ChefAllonWalkTo"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_ButlerLear_ChefAllonWalkTo",
		Map = M._MAP,
		Resource = M["Anchor_ButlerLear_ChefAllonWalkTo"]
	}
end

M["ButlerLear"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		PositionX = 33,
		PositionY = 4,
		PositionZ = 15,
		Name = "ButlerLear",
		Map = M._MAP,
		Resource = M["ButlerLear"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "FancyBanker",
		MapObject = M["ButlerLear"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Butler Lear",
		Language = "en-US",
		Resource = M["ButlerLear"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A friend of Chef Allon's and a darn good butler.",
		Language = "en-US",
		Resource = M["ButlerLear"]
	}
end

M["Anchor_GuardCaptain"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 17,
		Name = "Anchor_GuardCaptain",
		Map = M._MAP,
		Resource = M["Anchor_GuardCaptain"]
	}
end

M["GuardCaptain"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "GuardCaptain",
		Map = M._MAP,
		Resource = M["GuardCaptain"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon_Cutscene",
		MapObject = M["GuardCaptain"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge guard captain",
		Language = "en-US",
		Resource = M["GuardCaptain"]
	}
end

M["Anchor_ChefAllon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 4,
		PositionZ = 15,
		Name = "Anchor_ChefAllon",
		Map = M._MAP,
		Resource = M["Anchor_ChefAllon"]
	}
end

M["ChefAllon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "ChefAllon",
		Map = M._MAP,
		Resource = M["ChefAllon"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "ChefAllon",
		MapObject = M["ChefAllon"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["ChefAllon"],
		Name = "ChefAllon",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["GuardCaptain"],
		Name = "GuardCaptain",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle/Dialog/ChefAllon_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["ChefAllon"] {
		TalkAction
	}
end

M["Anchor_EarlReddick"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 4,
		PositionZ = 27,
		Direction = -1,
		Name = "Anchor_EarlReddick",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick"]
	}
end

M["Anchor_EarlReddick_Guard"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 27,
		Direction = -1,
		Name = "Anchor_EarlReddick_Guard",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick_Guard"]
	}
end

M["Anchor_EarlReddick_Chef"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 27,
		Direction = 1,
		Name = "Anchor_EarlReddick_Chef",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick_Chef"]
	}
end

M["Anchor_EarlReddick_Player"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 31,
		Direction = 1,
		Name = "Anchor_EarlReddick_Player",
		Map = M._MAP,
		Resource = M["Anchor_EarlReddick_Player"]
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
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["ChefAllon"],
		Name = "ChefAllon",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["GuardCaptain"],
		Name = "GuardCaptain",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["EarlReddick"],
		Name = "EarlReddick",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle/Dialog/SuperSupperSaboteurInProgress_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "StartSuperSupperSaboteur",
		Action = TalkAction,
		Map = M._MAP
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["ChefAllon"],
		Name = "ChefAllon",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["ButlerLear"],
		Name = "ButlerLear",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Oliver"],
		Name = "Oliver",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["EarlReddick"],
		Name = "EarlReddick",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle/Dialog/SuperSupperSaboteurInProgress_en-US.lua",
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
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["ChefAllon"],
		Name = "ChefAllon",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["EarlReddick"],
		Name = "EarlReddick",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["GuardCaptain"],
		Name = "GuardCaptain",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Rumbridge_Castle/Dialog/SuperSupperSaboteurComplete_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedMapAction {
		Name = "EndSuperSupperSaboteurCutscene",
		Action = TalkAction,
		Map = M._MAP
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_ButlerDies"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ChefAllon",
		Cutscene = Cutscene,
		Resource = M["ChefAllon"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ButlerLear",
		Cutscene = Cutscene,
		Resource = M["ButlerLear"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Oliver",
		Cutscene = Cutscene,
		Resource = M["Oliver"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_EarlReddickDies_DoubleCross"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ChefAllon",
		Cutscene = Cutscene,
		Resource = M["ChefAllon"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "EarlReddick",
		Cutscene = Cutscene,
		Resource = M["EarlReddick"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "GuardCaptain",
		Cutscene = Cutscene,
		Resource = M["GuardCaptain"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_EarlReddickDies"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ChefAllon",
		Cutscene = Cutscene,
		Resource = M["ChefAllon"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "EarlReddick",
		Cutscene = Cutscene,
		Resource = M["EarlReddick"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "GuardCaptain",
		Cutscene = Cutscene,
		Resource = M["GuardCaptain"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Rumbridge_Castle_EarlReddickLives"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "ChefAllon",
		Cutscene = Cutscene,
		Resource = M["ChefAllon"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "EarlReddick",
		Cutscene = Cutscene,
		Resource = M["EarlReddick"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "GuardCaptain",
		Cutscene = Cutscene,
		Resource = M["GuardCaptain"]
	}
end
