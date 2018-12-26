local M = include "Resources/Game/Maps/IsabelleIsland_AbandonedMine/DB/Default.lua"

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
		ColorRed = 255,
		ColorGreen = 173,
		ColorBlue = 119,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
		Resource = M["Light_Ambient"]
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
		ColorRed = 108,
		ColorGreen = 93,
		ColorBlue = 83,
		NearDistance = 40,
		FarDistance = 80,
		Resource = M["Light_Fog"]
	}
end

M["Anchor_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39.5 * 2,
		PositionY = 3,
		PositionZ = 3.5 * 2,
		Name = "Anchor_Entrance",
		Map = M._MAP,
		Resource = M["Anchor_Entrance"]
	}
end

do
	local TravelAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_AbandonedMine",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Climb-up",
		Language = "en-US",
		Action = TravelAction
	}

	M["EntranceLadder"] {
		TravelAction
	}
end

M["SmithingTutor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 51,
		PositionY = 2,
		PositionZ = 35,
		Name = "SmithingTutor",
		Map = M._MAP,
		Resource = M["SmithingTutor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["SmithingTutor"],
		Name = "Smith",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Dialog/Smith_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["SmithingTutor"] {
		TalkAction
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Smith",
		MapObject = M["SmithingTutor"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BrownApron",
		Count = 1,
		Resource = M["SmithingTutor"]
	}
end

M["MiningTutor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 77,
		PositionY = 2,
		PositionZ = 5,
		Name = "MiningTutor",
		Map = M._MAP,
		Resource = M["MiningTutor"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["MiningTutor"],
		Name = "Miner",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Dialog/Miner_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["MiningTutor"] {
		TalkAction
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Miner",
		MapObject = M["MiningTutor"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzePlatebody",
		Count = 1,
		Resource = M["MiningTutor"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeGloves",
		Count = 1,
		Resource = M["MiningTutor"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzeBoots",
		Count = 1,
		Resource = M["MiningTutor"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzePickaxe",
		Count = 1,
		Resource = M["MiningTutor"]
	}
end

M["SkeletonMinerJoe"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.5 * 2,
		PositionY = 3,
		PositionZ = 21.5 * 2,
		Name = "Skeleton",
		Map = M._MAP,
		Resource = M["SkeletonMinerJoe"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["SkeletonMinerJoe"],
		Name = "Joe",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Dialog/SkeletonMinerJoe_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["SkeletonMinerJoe"] {
		TalkAction,
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Skeleton_Base",
		MapObject = M["SkeletonMinerJoe"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "mine",
		Tree = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_MineLogic.lua",
		IsDefault = 1,
		Resource = M["SkeletonMinerJoe"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "smelt",
		Tree = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_SmeltLogic.lua",
		Resource = M["SkeletonMinerJoe"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "deposit",
		Tree = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_DepositLogic.lua",
		Resource = M["SkeletonMinerJoe"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronPickaxe",
		Count = 1,
		Resource = M["SkeletonMinerJoe"]
	}

	ItsyScape.Meta.ResourceName {
		Value = "Skeleton Miner Joe",
		Language = "en-US",
		Resource = M["SkeletonMinerJoe"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Mining",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = M["SkeletonMinerJoe"]
	}
end

M["GhostlyMinerForeman"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 31.5 * 2,
		PositionY = 3,
		PositionZ = 34.5 * 2,
		Name = "GhostlyMinerForeman",
		Map = M._MAP,
		Resource = M["GhostlyMinerForeman"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "GhostlyMinerForeman",
		MapObject = M["GhostlyMinerForeman"]
	}
end

M["Chest"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.5 * 2,
		PositionY = 2,
		PositionZ = 13.5 * 2,
		Name = "Chest",
		Map = M._MAP,
		Resource = M["Chest"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Chest_Default",
		MapObject = M["Chest"]
	}

	local WithdrawAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.ActionVerb {
		Value = "Withdraw",
		Language = "en-US",
		Action = WithdrawAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Chest"],
		Name = "Chest",
		Action = WithdrawAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Dialog/Chest_Withdraw_en-US.lua",
		Language = "en-US",
		Action = WithdrawAction
	}

	M["Chest"] {
		WithdrawAction,
		ItsyScape.Action.Collect(),
		ItsyScape.Action.Bank()
	}
end

M["CopperSkelemental1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 41.5 * 2,
		PositionY = 3,
		PositionZ = 19.5 * 2,
		Name = "CopperSkelemental",
		Map = M._MAP,
		Resource = M["CopperSkelemental1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CopperSkelemental",
		MapObject = M["CopperSkelemental1"]
	}
end

M["CopperSkelemental2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27.5 * 2,
		PositionY = 3,
		PositionZ = 24.5 * 2,
		Name = "CopperSkelemental",
		Map = M._MAP,
		Resource = M["CopperSkelemental2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CopperSkelemental",
		MapObject = M["CopperSkelemental2"]
	}
end

M["CopperSkelemental3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 14.5 * 2,
		PositionY = 3,
		PositionZ = 33.5 * 2,
		Name = "CopperSkelemental",
		Map = M._MAP,
		Resource = M["CopperSkelemental3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CopperSkelemental",
		MapObject = M["CopperSkelemental3"]
	}
end

M["TinSkelemental1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 39.5 * 2,
		PositionY = 3,
		PositionZ = 18.5 * 2,
		Name = "TinSkelemental",
		Map = M._MAP,
		Resource = M["TinSkelemental1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TinSkelemental",
		MapObject = M["TinSkelemental1"]
	}
end

M["TinSkelemental2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33.5 * 2,
		PositionY = 3,
		PositionZ = 24.5 * 2,
		Name = "TinSkelemental",
		Map = M._MAP,
		Resource = M["TinSkelemental2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TinSkelemental",
		MapObject = M["TinSkelemental2"]
	}
end

M["TinSkelemental3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 14.5 * 2,
		PositionY = 3,
		PositionZ = 33.5 * 2,
		Name = "TinSkelemental",
		Map = M._MAP,
		Resource = M["TinSkelemental3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TinSkelemental",
		MapObject = M["TinSkelemental3"]
	}
end

M["EntranceDoor"] {
	ItsyScape.Action.Open() {
		Requirement {
			Resource = ItsyScape.Resource.Item "IsabelleIsland_AbandonedMine_WroughtBronzeKey",
			Count = 1
		}
	},

	ItsyScape.Action.Close() {
		-- Nothing.
	}
}

M["CraftingRoomDoor"] {
	ItsyScape.Action.Open() {
		-- Nothing.
	},

	ItsyScape.Action.Close() {
		-- Nothing.
	}
}

M["BossDoor"] {
	ItsyScape.Action.Open() {
		Requirement {
			Resource = ItsyScape.Resource.Item "IsabelleIsland_AbandonedMine_ReinforcedBronzeKey",
			Count = 1
		}
	}
}

return M
