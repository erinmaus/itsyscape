local M = include "Resources/Game/Maps/HighChambersYendor_Floor1West/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.HighChambersYendor_Floor1West.Peep",
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
		Ambience = 0.6,
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

M["Anchor_FromAbandonedMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 1,
		PositionZ = 99,
		Name = "Anchor_FromAbandonedMine",
		Map = M._MAP,
		Resource = M["Anchor_FromAbandonedMine"]
	}
end

M["HighChambersYendor_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 1,
		PositionZ = 98,
		Name = "HighChambersYendor_Entrance",
		Map = M._MAP,
		Resource = M["HighChambersYendor_Entrance"]
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Leave before the madness takes you!",
		Resource = M["HighChambersYendor_Entrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Entrance",
		MapObject = M["HighChambersYendor_Entrance"]
	}

	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_HighChambersYendor",
		Map = ItsyScape.Resource.Map "IsabelleIsland_AbandonedMine",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Leave",
		Language = "en-US",
		Action = TravelAction
	}

	M["HighChambersYendor_Entrance"] {
		TravelAction
	}
end

M["Anchor_SoulSiphon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 1,
		PositionZ = 89,
		Name = "Anchor_SoulSiphon",
		Map = M._MAP,
		Resource = M["Anchor_SoulSiphon"]
	}
end

M["Light_SoulSiphon1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 4,
		PositionZ = 89,
		Name = "Light_SoulSiphon1",
		Map = M._MAP,
		Resource = M["Light_SoulSiphon1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_SoulSiphon1"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 255,
		ColorGreen = 44,
		ColorBlue = 90,
		Resource = M["Light_SoulSiphon1"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 10,
		Resource = M["Light_SoulSiphon1"]
	}
end

M["Light_SoulSiphon2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 8,
		PositionZ = 89,
		Name = "Light_SoulSiphon2",
		Map = M._MAP,
		Resource = M["Light_SoulSiphon2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "PointLight_Default",
		MapObject = M["Light_SoulSiphon2"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 76,
		ColorGreen = 255,
		ColorBlue = 76,
		Resource = M["Light_SoulSiphon2"]
	}

	ItsyScape.Meta.PointLight {
		Attenuation = 30,
		Resource = M["Light_SoulSiphon2"]
	}
end

M["SackOfHay_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 1,
		PositionZ = 109,
		Name = "SackOfHay_1",
		Map = M._MAP,
		Resource = M["SackOfHay_1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Bed",
		MapObject = M["SackOfHay_1"]
	}
end

M["SackOfHay_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 13,
		PositionY = 1,
		PositionZ = 109,
		Name = "SackOfHay_2",
		Map = M._MAP,
		Resource = M["SackOfHay_2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Bed",
		MapObject = M["SackOfHay_2"]
	}
end

M["SackOfHay_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 17,
		PositionY = 1,
		PositionZ = 109,
		Name = "SackOfHay_3",
		Map = M._MAP,
		Resource = M["SackOfHay_3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Bed",
		MapObject = M["SackOfHay_3"]
	}
end

M["PuzzleTorch_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 55,
		Name = "PuzzleTorch_1",
		Map = M._MAP,
		Resource = M["PuzzleTorch_1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["PuzzleTorch_1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Puzzle_Torch",
		Map = M._MAP,
		MapObject = M["PuzzleTorch_1"]
	}
end

M["PuzzleTorch_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 55,
		Name = "PuzzleTorch_2",
		Map = M._MAP,
		Resource = M["PuzzleTorch_2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["PuzzleTorch_2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Puzzle_Torch",
		Map = M._MAP,
		MapObject = M["PuzzleTorch_2"]
	}
end

M["PuzzleTorch_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 71,
		Name = "PuzzleTorch_3",
		Map = M._MAP,
		Resource = M["PuzzleTorch_3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["PuzzleTorch_3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Puzzle_Torch",
		Map = M._MAP,
		MapObject = M["PuzzleTorch_3"]
	}
end

M["PuzzleTorch_4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31,
		PositionY = 1,
		PositionZ = 71,
		Name = "PuzzleTorch_4",
		Map = M._MAP,
		Resource = M["PuzzleTorch_4"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["PuzzleTorch_4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Puzzle_Torch",
		Map = M._MAP,
		MapObject = M["PuzzleTorch_4"]
	}
end

M["PuzzleTorch_Ghost"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 29,
		PositionY = 1,
		PositionZ = 63,
		Name = "PuzzleTorch_Ghost",
		Map = M._MAP,
		Resource = M["PuzzleTorch_Ghost"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_TorchPuzzleGhost",
		MapObject = M["PuzzleTorch_Ghost"]
	}
end

M["DoubleLockDoor_PuzzleTorch"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 39,
		Name = "DoubleLockDoor_PuzzleTorch",
		Map = M._MAP,
		Resource = M["DoubleLockDoor_PuzzleTorch"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["DoubleLockDoor_PuzzleTorch"]
	}

	M["DoubleLockDoor_PuzzleTorch"] {
		ItsyScape.Action.None()
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Looks like there's no way to light this torch.",
		Language = "en-US",
		Resource = M["DoubleLockDoor_PuzzleTorch"]
	}
end

M["DoubleLockDoor_CreepRoomTorch"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 37,
		PositionY = 1,
		PositionZ = 33,
		Name = "DoubleLockDoor_CreepRoomTorch",
		Map = M._MAP,
		Resource = M["DoubleLockDoor_CreepRoomTorch"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["DoubleLockDoor_CreepRoomTorch"]
	}

	M["DoubleLockDoor_CreepRoomTorch"] {
		ItsyScape.Action.None()
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Looks like there's no way to light this torch.",
		Language = "en-US",
		Resource = M["DoubleLockDoor_CreepRoomTorch"]
	}
end

M["Door_GuardianPrison"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 10,
		PositionY = 1,
		PositionZ = 72,
		Name = "Door_GuardianPrison",
		Map = M._MAP,
		Resource = M["Door_GuardianPrison"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_GuardianPrison"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianPrison",
		Map = M._MAP,
		MapObject = M["Door_GuardianPrison"]
	}
end

M["PrisonGuard_Archer_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 2,
		PositionZ = 83,
		Name = "PrisonGuard_Archer_1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["PrisonGuard_Archer_1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["PrisonGuard_Archer_1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianPrison",
		Map = M._MAP,
		MapObject = M["PrisonGuard_Archer_1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/PrisonGuard_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["PrisonGuard_Archer_1"]
	}
end

M["PrisonGuard_Archer_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 19,
		PositionY = 1,
		PositionZ = 85,
		Direction = -1,
		Name = "PrisonGuard_Archer_2",
		Map = M._MAP,
		Resource = M["PrisonGuard_Archer_2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["PrisonGuard_Archer_2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianPrison",
		Map = M._MAP,
		MapObject = M["PrisonGuard_Archer_2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/PrisonGuard_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["PrisonGuard_Archer_2"]
	}
end

M["PrisonGuard_Archer_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 1,
		PositionZ = 77,
		Name = "PrisonGuard_Archer_3",
		Map = M._MAP,
		Resource = M["PrisonGuard_Archer_3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["PrisonGuard_Archer_3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianPrison",
		Map = M._MAP,
		MapObject = M["PrisonGuard_Archer_3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/PrisonGuard_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["PrisonGuard_Archer_3"]
	}
end

M["Door_MimicRoomNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 8,
		PositionY = 1,
		PositionZ = 56,
		Name = "Door_MimicRoomNorth",
		Map = M._MAP,
		Resource = M["Door_MimicRoomNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_MimicRoomNorth"]
	}
end

M["Door_MimicRoomEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 1,
		PositionZ = 64,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_MimicRoomEast",
		Map = M._MAP,
		Resource = M["Door_MimicRoomEast"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_MimicRoomEast"]
	}
end

M["Anchor_MimicSpawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 1,
		PositionZ = 61,
		Name = "Anchor_MimicSpawn",
		Map = M._MAP,
		Resource = M["Anchor_MimicSpawn"]
	}
end

M["Mimic_Angry"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Mimic_Angry",
		Map = M._MAP,
		Resource = M["Mimic_Angry"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Prop "ChestMimic_Weak_Base",
		MapObject = M["Mimic_Angry"]
	}

	local AngryMimicShop = ItsyScape.Resource.Shop.Unique()	{
		ItsyScape.Action.Buy() {
			Input {
				Count = 100,
				Resource = ItsyScape.Resource.Item "Coins"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "CavePotato"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 100,
				Resource = ItsyScape.Resource.Item "Coins"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "CookedSardine"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 200,
				Resource = ItsyScape.Resource.Item "Coins"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "CookedSeaBass"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 150,
				Resource = ItsyScape.Resource.Item "Coins"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "CommonLogs"
			}
		},

		ItsyScape.Action.Buy() {
			Input {
				Count = 10000,
				Resource = ItsyScape.Resource.Item "Coins"
			},

			Output {
				Count = 1,
				Resource = ItsyScape.Resource.Item "IronPickaxe"
			}
		}
	}

	ItsyScape.Meta.Shop {
		ExchangeRate = 0.2,
		Currency = ItsyScape.Resource.Item "Coins",
		Resource = AngryMimicShop
	}

	local ShopAction = ItsyScape.Action.Shop()

	ItsyScape.Meta.ShopTarget {
		Resource = AngryMimicShop,
		Action = ShopAction
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Mimic_Angry"],
		Name = "Mimic",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/HighChambersYendor_Floor1West/Dialog/AngryMimic_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Mimic_Angry"] {
		TalkAction,
		ShopAction,
		ItsyScape.Action.Attack()
	}
end

M["Anchor_AliceSpawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 1,
		PositionZ = 65,
		Name = "Anchor_AliceSpawn",
		Map = M._MAP,
		Resource = M["Anchor_AliceSpawn"]
	}
end

M["Door_DoubleLockNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 36,
		PositionY = 1,
		PositionZ = 52,
		Name = "Door_DoubleLockNorth",
		Map = M._MAP,
		Resource = M["Door_DoubleLockNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_DoubleLockNorth"]
	}
end

M["Door_DoubleLockWest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 21,
		PositionY = 1,
		PositionZ = 42,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_DoubleLockWest",
		Map = M._MAP,
		Resource = M["Door_DoubleLockWest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Guardian",
		MapObject = M["Door_DoubleLockWest"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianDoubleLock",
		Map = M._MAP,
		MapObject = M["Door_DoubleLockWest"]
	}
end

M["DoubleLock_Wizard_1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 2,
		PositionZ = 45,
		Name = "DoubleLock_Wizard_1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DoubleLock_Wizard_1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DoubleLock_Wizard_1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianDoubleLock",
		Map = M._MAP,
		MapObject = M["DoubleLock_Wizard_1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DoubleLock_Wizard_1"]
	}
end

M["DoubleLock_Wizard_2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 15,
		PositionY = 1,
		PositionZ = 45,
		Direction = -1,
		Name = "DoubleLock_Wizard_2",
		Map = M._MAP,
		Resource = M["DoubleLock_Wizard_2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DoubleLock_Wizard_2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianDoubleLock",
		Map = M._MAP,
		MapObject = M["DoubleLock_Wizard_2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DoubleLock_Wizard_2"]
	}
end

M["DoubleLock_Wizard_3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 11,
		PositionY = 1,
		PositionZ = 49,
		Name = "DoubleLock_Wizard_3",
		Map = M._MAP,
		Resource = M["DoubleLock_Wizard_3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DoubleLock_Wizard_3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_GuardianDoubleLock",
		Map = M._MAP,
		MapObject = M["DoubleLock_Wizard_3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DoubleLock_Wizard_3"]
	}
end

M["Door_DoubleLockEast"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 40,
		PositionY = 1,
		PositionZ = 36,
		RotationX = ItsyScape.Utility.Quaternion.Y_270.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_270.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_270.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_270.w,
		Name = "Door_DoubleLockEast",
		Map = M._MAP,
		Resource = M["Door_DoubleLockEast"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base",
		MapObject = M["Door_DoubleLockEast"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Door_DoubleLockEast",
		Map = M._MAP,
		MapObject = M["Door_DoubleLockEast"]
	}
end

M["Door_WaterfallNorth"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 46,
		PositionY = -1,
		PositionZ = 50,
		Name = "Door_WaterfallNorth",
		Map = M._MAP,
		Resource = M["Door_WaterfallNorth"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor_Base",
		MapObject = M["Door_WaterfallNorth"]
	}

	M["Door_WaterfallNorth"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "HighChambersYendor_BloodyIronKey",
				Count = 1
			}
		},

		ItsyScape.Action.Close()
	}
end

M["Door_BeforeMinibossEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 102,
		PositionY = 1,
		PositionZ = 70,
		Name = "Door_BeforeMinibossEntrance",
		Map = M._MAP,
		Resource = M["Door_BeforeMinibossEntrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_BeforeMinibossEntrance"]
	}
end

M["Door_MinibossEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 88,
		PositionY = 2,
		PositionZ = 82,
		RotationX = ItsyScape.Utility.Quaternion.Y_90.x,
		RotationY = ItsyScape.Utility.Quaternion.Y_90.y,
		RotationZ = ItsyScape.Utility.Quaternion.Y_90.z,
		RotationW = ItsyScape.Utility.Quaternion.Y_90.w,
		Name = "Door_MinibossEntrance",
		Map = M._MAP,
		Resource = M["Door_MinibossEntrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_MinibossEntrance"]
	}
end

M["Door_To2ndFloor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 110,
		PositionY = 1,
		PositionZ = 70,
		Name = "Door_To2ndFloor",
		Map = M._MAP,
		Resource = M["Door_To2ndFloor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_BigDoor",
		MapObject = M["Door_To2ndFloor"]
	}
end

M["DiningHall_Warrior1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 71,
		PositionY = 1,
		PositionZ = 37,
		Name = "DiningHall_Warrior1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Warrior1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior",
		MapObject = M["DiningHall_Warrior1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Warrior1"]
	}
end

M["DiningHall_Warrior2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 81,
		PositionY = 1,
		PositionZ = 41,
		Name = "DiningHall_Warrior2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Warrior2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior",
		MapObject = M["DiningHall_Warrior2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Warrior2"]
	}
end

M["DiningHall_Warrior3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 71,
		PositionY = 1,
		PositionZ = 55,
		Name = "DiningHall_Warrior3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Warrior3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior",
		MapObject = M["DiningHall_Warrior3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Warrior3"]
	}
end

M["DiningHall_Warrior4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83,
		PositionY = 1,
		PositionZ = 27,
		Name = "DiningHall_Warrior4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Warrior4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWarrior",
		MapObject = M["DiningHall_Warrior4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Warrior4"]
	}
end

M["DiningHall_Wizard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 1,
		PositionZ = 51,
		Name = "DiningHall_Wizard1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Wizard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DiningHall_Wizard1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Wizard1"]
	}
end

M["DiningHall_Wizard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 1,
		PositionZ = 41,
		Name = "DiningHall_Wizard2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Wizard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DiningHall_Wizard2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Wizard2"]
	}
end

M["DiningHall_Wizard3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 1,
		PositionZ = 27,
		Name = "DiningHall_Wizard3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Wizard3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DiningHall_Wizard3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Wizard3"]
	}
end

M["DiningHall_Wizard4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 1,
		PositionZ = 31,
		Name = "DiningHall_Wizard4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Wizard4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["DiningHall_Wizard4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Wizard4"]
	}
end

M["DiningHall_Archer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 3,
		PositionZ = 25,
		Name = "DiningHall_Archer1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Archer1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["DiningHall_Archer1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Archer1"]
	}
end

M["DiningHall_Archer2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 69,
		PositionY = 1,
		PositionZ = 45,
		Name = "DiningHall_Archer2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Archer2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["DiningHall_Archer2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Archer2"]
	}
end

M["DiningHall_Archer3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 87,
		PositionY = 1,
		PositionZ = 45,
		Name = "DiningHall_Archer3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Archer3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["DiningHall_Archer3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Archer3"]
	}
end

M["DiningHall_Archer4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 83,
		PositionY = 1,
		PositionZ = 59,
		Name = "DiningHall_Archer4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["DiningHall_Archer4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["DiningHall_Archer4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["DiningHall_Archer4"]
	}
end

do
	local HealAction = ItsyScape.Action.DiningTable_Heal()
	ItsyScape.Meta.HealingPower {
		HitPoints = 10,
		Action = HealAction
	}

	ItsyScape.Meta.ActionEvent {
		Event = "diningTableFoodEaten",
		Action = HealAction
	}

	ItsyScape.Meta.ActionEventTarget {
		Value = M._MAP,
		Action = HealAction
	}

	M["DiningRoom_Table1"] {
		HealAction
	}

	M["DiningRoom_Table2"] {
		HealAction
	}

	M["DiningRoom_Table3"] {
		HealAction
	}

	M["DiningRoom_Table4"] {
		HealAction
	}
end

M["Kitchen_Chef1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 97,
		PositionY = 1,
		PositionZ = 25,
		Name = "Kitchen_Chef1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Kitchen_Chef1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Kitchen_Staff",
		Map = M._MAP,
		MapObject = M["Kitchen_Chef1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonChef",
		MapObject = M["Kitchen_Chef1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Kitchen_Chef1"]
	}
end

M["Kitchen_Chef2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 107,
		PositionY = 1,
		PositionZ = 25,
		Name = "Kitchen_Chef2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Kitchen_Chef2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Kitchen_Staff",
		Map = M._MAP,
		MapObject = M["Kitchen_Chef2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonChef",
		MapObject = M["Kitchen_Chef2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Kitchen_Chef2"]
	}
end

M["Kitchen_Chef3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 107,
		PositionY = 1,
		PositionZ = 33,
		Name = "Kitchen_Chef3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Kitchen_Chef3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Kitchen_Staff",
		Map = M._MAP,
		MapObject = M["Kitchen_Chef3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonChef",
		MapObject = M["Kitchen_Chef3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Kitchen_Chef3"]
	}
end

M["Kitchen_Chef4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 97,
		PositionY = 1,
		PositionZ = 33,
		Name = "Kitchen_Chef4",
		Direction = -1,
		Map = M._MAP,
		Resource = M["Kitchen_Chef4"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Kitchen_Staff",
		Map = M._MAP,
		MapObject = M["Kitchen_Chef4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonChef",
		MapObject = M["Kitchen_Chef4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/UnaggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Kitchen_Chef4"]
	}
end

M["SouthKitchen_Archer1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 103,
		PositionY = 4.5,
		PositionZ = 59,
		Name = "SouthKitchen_Archer1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["SouthKitchen_Archer1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonArcher",
		MapObject = M["SouthKitchen_Archer1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["SouthKitchen_Archer1"]
	}
end

M["SouthKitchen_Wizard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 109,
		PositionY = 4.5,
		PositionZ = 59,
		Name = "SouthKitchen_Wizard1",
		Map = M._MAP,
		Resource = M["SouthKitchen_Wizard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_SkeletonWizard",
		MapObject = M["SouthKitchen_Wizard1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/AggressiveCreep_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["SouthKitchen_Wizard1"]
	}
end

M["CthulhuianMiniboss1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 71,
		PositionY = 4.5,
		PositionZ = 75,
		Name = "CthulhuianMiniboss1",
		Direction = -1,
		Map = M._MAP,
		Resource = M["CthulhuianMiniboss1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "CthulhuianMiniboss",
		Map = M._MAP,
		MapObject = M["CthulhuianMiniboss1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite",
		MapObject = M["CthulhuianMiniboss1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/CthulhuianParasite_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["CthulhuianMiniboss1"]
	}
end

M["CthulhuianMiniboss2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 4.5,
		PositionZ = 75,
		Name = "CthulhuianMiniboss2",
		Direction = -1,
		Map = M._MAP,
		Resource = M["CthulhuianMiniboss2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "CthulhuianMiniboss",
		Map = M._MAP,
		MapObject = M["CthulhuianMiniboss2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite",
		MapObject = M["CthulhuianMiniboss2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/CthulhuianParasite_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["CthulhuianMiniboss2"]
	}
end

M["CthulhuianMiniboss3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 4.5,
		PositionZ = 75,
		Name = "CthulhuianMiniboss3",
		Direction = -1,
		Map = M._MAP,
		Resource = M["CthulhuianMiniboss3"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "CthulhuianMiniboss",
		Map = M._MAP,
		MapObject = M["CthulhuianMiniboss3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "HighChambersYendor_CthulhuianParasite",
		MapObject = M["CthulhuianMiniboss3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/HighChambersYendor/CthulhuianParasite_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["CthulhuianMiniboss3"]
	}
end

M["SoulSiphon"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 2,
		PositionZ = 89,
		Name = "SoulSiphon",
		Map = M._MAP,
		Resource = M["SoulSiphon"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_SoulSiphon",
		MapObject = M["SoulSiphon"]
	}
end
