local M = include "Resources/Game/Maps/Sailing_WhalingTemple/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_WhalingTemple.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "The Whaling Temple",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "A whaling temple thought to be abandoned by Yendorians.",
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

M["YendorianBallista"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "YendorianBallista",
		Map = M._MAP,
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
		MapObject = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 25,
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_AttackLogic.lua",
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianBallista"]
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(1),
		DefenseStab = ItsyScape.Utility.styleBonusForBody(1),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(1),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(1),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(5),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(5),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(1),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["YendorianBallista"]
	}
end

M["YendorianMast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "YendorianMast",
		Map = M._MAP,
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Mast",
		MapObject = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 25,
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_AttackLogic.lua",
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Magic",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianMast"]
	}

	ItsyScape.Meta.Equipment {
		AccuracyMagic = ItsyScape.Utility.styleBonusForWeapon(1),
		DefenseStab = ItsyScape.Utility.styleBonusForBody(5),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(5),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(5),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(5),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(1),
		StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(1),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["YendorianMast"]
	}
end

M["YendorianSwordfish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "YendorianSwordfish",
		Map = M._MAP,
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Swordfish",
		MapObject = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 25,
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_AttackLogic.lua",
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Yendorian_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(1),
		Resource = M["YendorianSwordfish"]
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(1),
		DefenseStab = ItsyScape.Utility.styleBonusForBody(5),
		DefenseSlash = ItsyScape.Utility.styleBonusForBody(5),
		DefenseCrush = ItsyScape.Utility.styleBonusForBody(5),
		DefenseMagic = ItsyScape.Utility.styleBonusForBody(1),
		DefenseRanged = ItsyScape.Utility.styleBonusForBody(5),
		StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(1),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["YendorianSwordfish"]
	}
end

M["Anchor_InjuredYendorian"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 5,
		PositionZ = 37,
		Name = "Anchor_InjuredYendorian",
		Map = M._MAP,
		Resource = M["Anchor_InjuredYendorian"]
	}
end

M["Anchor_MantokPortal"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 10,
		PositionZ = 29,
		Name = "Anchor_MantokPortal",
		Map = M._MAP,
		Resource = M["Anchor_MantokPortal"]
	}
end

M["MantokPortal"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "MantokPortal",
		Map = M._MAP,
		Resource = M["MantokPortal"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Portal_Chasm",
		MapObject = M["MantokPortal"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unstable portal",
		Language = "en-US",
		Resource = M["MantokPortal"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An unstable portal to some horrible place with some horrible creature...",
		Language = "en-US",
		Resource = M["MantokPortal"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 3,
		PositionZ = 67,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_Ship"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 85,
		PositionY = 1.5,
		PositionZ = 83,
		Name = "Anchor_Ship",
		Map = M._MAP,
		Resource = M["Anchor_Ship"]
	}
end

M["Rowboat"] = ItsyScape.Resource.MapObject.Unique()
do
	local rotation = ItsyScape.Utility.Quaternion.fromAxisAngle(ItsyScape.Utility.Vector.UNIT_Y, math.pi / 4)

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 2,
		PositionZ = 73,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Rowboat",
		Map = M._MAP,
		Resource = M["Rowboat"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Rowboat_Default",
		MapObject = M["Rowboat"]
	}
end

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 3,
		PositionZ = 65,
		Direction = -1,
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		MapObject = M["Orlando"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Orlando_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["Orlando"] {
		TalkAction
	}
end

M["Anchor_Rosalind"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 3,
		PositionZ = 71,
		Direction = 1,
		Name = "Anchor_Rosalind",
		Map = M._MAP,
		Resource = M["Anchor_Rosalind"]
	}
end

M["Rosalind"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Rosalind",
		Map = M._MAP,
		Resource = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Rosalind",
		MapObject = M["Rosalind"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = TalkAction
	}

	M["Rosalind"] {
		TalkAction
	}

	local NamedTalkActionTrees = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Trees_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionTrees
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionTrees
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutTrees",
		Action = NamedTalkActionTrees,
		Peep = M["Rosalind"]
	}

	local NamedTalkActionFish = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Fish_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionFish
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionFish
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutFish",
		Action = NamedTalkActionFish,
		Peep = M["Rosalind"]
	}

	local NamedTalkActionDungeon = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Dungeon_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionDungeon
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionDungeon
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "PreTutorial_Yenderling",
		Name = "Yenderling",
		Action = NamedTalkActionDungeon
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutDungeon",
		Action = NamedTalkActionDungeon,
		Peep = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "follow",
		Tree = "Resources/Game/Maps/Sailing_WhalingTemple/Scripts/Rosalind_FollowLogic.lua",
		Resource = M["Rosalind"]
	}

	local NamedTalkActionBoss = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Boss_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionBoss
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionBoss
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["YendorianBallista"],
		Name = "Yendorian",
		Action = NamedTalkActionBoss
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["YendorianMast"],
		Name = "Yendorian",
		Action = NamedTalkActionBoss
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["YendorianSwordfish"],
		Name = "Yendorian",
		Action = NamedTalkActionBoss
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutBoss",
		Action = NamedTalkActionBoss,
		Peep = M["Rosalind"]
	}

	local NamedTalkActionPortal = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Portal_en-US.lua",
		Language = "en-US",
		Action = NamedTalkActionPortal
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = NamedTalkActionPortal
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "TalkAboutPortal",
		Action = NamedTalkActionPortal,
		Peep = M["Rosalind"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IsabelliumStaff",
		Count = 1,
		Resource = M["Rosalind"]
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = -1000,
		AccuracySlash = -1000,
		AccuracyCrush = -1000,
		AccuracyMagic = -1000,
		DefenseStab = 5000,
		DefenseSlash = 5000,
		DefenseCrush = 5000,
		DefenseMagic = 5000,
		DefenseRanged = 5000,
		StrengthMagic = -1000,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["Rosalind"]
	}
end

M["Jenkins"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 3,
		PositionZ = 67,
		Direction = -1,
		Name = "Jenkins",
		Map = M._MAP,
		Resource = M["Jenkins"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins",
		MapObject = M["Jenkins"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Jenkins_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Jenkins"],
		Name = "Jenkins",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = TalkAction
	}

	M["Jenkins"] {
		TalkAction
	}
end

M["MantokPortalStable"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "MantokPortalStable",
		Map = M._MAP,
		Resource = M["MantokPortalStable"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Portal_Chasm",
		MapObject = M["MantokPortalStable"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Stable portal",
		Language = "en-US",
		Resource = M["MantokPortalStable"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Rosalind used her witch magic to stabilize the portal. It leads to Isabelle Island now.",
		Language = "en-US",
		Resource = M["MantokPortalStable"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/Sailing_WhalingTemple/Dialog/Rosalind_Portal_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = TalkAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Traverse",
		XProgressive = "Traversing",
		Language = "en-US",
		Action = TalkAction
	}

	M["MantokPortalStable"] {
		TalkAction
	}
end

M["Ladder_FromMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 3,
		PositionZ = 21,
		Name = "Ladder_FromMine",
		Map = M._MAP,
		Resource = M["Ladder_FromMine"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "MetalLadder_Default",
		MapObject = M["Ladder_FromMine"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromBoss",
		Map = ItsyScape.Resource.Map "Sailing_WhalingTemple_Underground",
		IsInstance = 1,
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-down",
		XProgressive = "Climbing-down",
		Language = "en-US",
		Action = TravelAction
	}

	M["Ladder_FromMine"] {
		TravelAction
	}
end

M["TrapDoor_ToMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 5,
		PositionZ = 31,
		Name = "TrapDoor_ToMine",
		Map = M._MAP,
		Resource = M["TrapDoor_ToMine"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "TrapDoor_Default",
		MapObject = M["TrapDoor_ToMine"]
	}

	local TravelAction = ItsyScape.Action.Travel() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_CookedFish",
			Count = 1
		},

		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_SleptAtBed",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_ExploreDungeon",
			Count = 1
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_FromFish",
		Map = ItsyScape.Resource.Map "Sailing_WhalingTemple_Underground",
		IsInstance = 1,
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Descend",
		XProgressive = "Descending",
		Language = "en-US",
		Action = TravelAction
	}

	M["TrapDoor_ToMine"] {
		TravelAction
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["TrapDoor_ToMine"],
		KeyItem = ItsyScape.Resource.KeyItem "PreTutorial_ExploreDungeon"
	}
end

M["Anchor_FromMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 5,
		PositionZ = 33,
		Name = "Anchor_FromMine",
		Map = M._MAP,
		Resource = M["Anchor_FromMine"]
	}
end

M["Anchor_FromMineToBoss"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 5,
		PositionZ = 23,
		Name = "Anchor_FromMineToBoss",
		Map = M._MAP,
		Resource = M["Anchor_FromMineToBoss"]
	}
end

M["BossDoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 76,
		PositionY = 5,
		PositionZ = 53,
		Name = "BossDoor",
		Map = M._MAP,
		Resource = M["BossDoor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base",
		MapObject = M["BossDoor"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian door",
		Language = "en-US",
		Resource = M["BossDoor"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Doesn't look like there's a simple way to open this door.",
		Language = "en-US",
		Resource = M["BossDoor"]
	}
end

M["BossDoorOpen"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "BossDoorOpen",
		Map = M._MAP,
		Resource = M["BossDoorOpen"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base",
		MapObject = M["BossDoorOpen"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian door",
		Language = "en-US",
		Resource = M["BossDoorOpen"]
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Looks like the door has opened...",
		Language = "en-US",
		Resource = M["BossDoorOpen"]
	}
end

M["Sardine1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 2,
		PositionZ = 39,
		Name = "Sardine1",
		Map = M._MAP,
		Resource = M["Sardine1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sardine_Default",
		MapObject = M["Sardine1"]
	}
end

M["Sardine2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 2,
		PositionZ = 41,
		Name = "Sardine2",
		Map = M._MAP,
		Resource = M["Sardine2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sardine_Default",
		MapObject = M["Sardine2"]
	}
end

M["Sardine3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 2,
		PositionZ = 37,
		Name = "Sardine3",
		Map = M._MAP,
		Resource = M["Sardine3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Sardine_Default",
		MapObject = M["Sardine3"]
	}
end

M["Maggot1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 4,
		PositionZ = 51,
		Direction = -1,
		Name = "Maggot1",
		Map = M._MAP,
		Resource = M["Maggot1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot1"],
		DoesRespawn = 1
	}
end

M["Maggot2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39,
		PositionY = 4,
		PositionZ = 45,
		Direction = 1,
		Name = "Maggot2",
		Map = M._MAP,
		Resource = M["Maggot2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot2"],
		DoesRespawn = 1
	}
end

M["Maggot3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 49,
		PositionY = 4,
		PositionZ = 49,
		Direction = -1,
		Name = "Maggot3",
		Map = M._MAP,
		Resource = M["Maggot3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "PreTutorial_Maggot",
		MapObject = M["Maggot3"],
		DoesRespawn = 1
	}
end

M["Bed"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 26,
		PositionY = 4,
		PositionZ = 49,
		Name = "Bed",
		Map = M._MAP,
		Resource = M["Bed"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Bed",
		MapObject = M["Bed"]
	}

	M["Bed"] {
		ItsyScape.Action.Sleep() {
			Output {
				Resource = ItsyScape.Resource.KeyItem "PreTutorial_SleptAtBed",
				Count = 1
			}
		}
	}
end

M["Passage_ToFishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_ToFishingArea",
		Map = M._MAP,
		Resource = M["Passage_ToFishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 38,
		Z1 = 50,
		X2 = 44,
		Z2 = 58,
		Map = M._MAP,
		Resource = M["Passage_ToFishingArea"]
	}
end

M["Passage_FishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_FishingArea",
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 36,
		Z1 = 46,
		X2 = 46,
		Z2 = 50,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}
end

M["Passage_Trees"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Trees",
		Map = M._MAP,
		Resource = M["Passage_Trees"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 32,
		Z1 = 60,
		X2 = 50,
		Z2 = 76,
		Map = M._MAP,
		Resource = M["Passage_Trees"]
	}
end

M["Passage_BeforeTrapdoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_BeforeTrapdoor",
		Map = M._MAP,
		Resource = M["Passage_BeforeTrapdoor"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 28,
		Z1 = 32,
		X2 = 36,
		Z2 = 36,
		Map = M._MAP,
		Resource = M["Passage_BeforeTrapdoor"]
	}
end

M["Anchor_ToTrees"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 43,
		PositionY = 4,
		PositionZ = 71,
		Name = "Anchor_ToTrees",
		Map = M._MAP,
		Resource = M["Anchor_ToTrees"]
	}
end

M["Anchor_FromFishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41,
		PositionY = 4,
		PositionZ = 63,
		Name = "Anchor_FromFishingArea",
		Map = M._MAP,
		Resource = M["Anchor_FromFishingArea"]
	}
end

M["Anchor_ToBed"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 4,
		PositionZ = 51,
		Name = "Anchor_ToBed",
		Map = M._MAP,
		Resource = M["Anchor_ToBed"]
	}
end

M["Anchor_FromTrapdoor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 5,
		PositionZ = 39,
		Name = "Anchor_FromTrapdoor",
		Map = M._MAP,
		Resource = M["Anchor_FromTrapdoor"]
	}
end

M["Passage_BossArena"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_BossArena",
		Map = M._MAP,
		Resource = M["Passage_BossArena"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 49,
		Z1 = 9,
		X2 = 89,
		Z2 = 43,
		Map = M._MAP,
		Resource = M["Passage_BossArena"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_WhalingTemple_DefeatedYendorian"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Rosalind",
		Cutscene = Cutscene,
		Resource = M["Rosalind"]
	}
end
