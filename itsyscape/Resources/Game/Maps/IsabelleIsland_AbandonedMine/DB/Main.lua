local M = include "Resources/Game/Maps/IsabelleIsland_AbandonedMine/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.IsabelleIsland_AbandonedMine.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Isabelle Island, Abandoned Mine",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "An ancient cavern full of tin and copper... and the restless undead.",
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

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 3,
		PositionZ = 9,
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		MapObject = M["Orlando"]
	}

	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkSpeaker {
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Orlando",
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkDialog {
		Script = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Dialog/Orlando_en-US.lua",
		Language = "en-US",
		Action = TalkAction
	}

	M["Orlando"] {
		TalkAction
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "follow",
		Tree = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Orlando_FollowLogic.lua",
		IsDefault = 1,
		Resource = M["Orlando"]
	}
end

M["Anchor_HighChambersYendor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 2,
		PositionZ = 32,
		Name = "Anchor_HighChambersYendor",
		Map = M._MAP,
		Resource = M["Anchor_HighChambersYendor"]
	}
end

M["HighChambersYendor_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "HighChambersYendor_Entrance",
		Map = M._MAP,
		Resource = M["HighChambersYendor_Entrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "HighChambersYendor_Entrance",
		MapObject = M["HighChambersYendor_Entrance"]
	}

	local TravelAction = ItsyScape.Action.PartyTravel() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToJenkins",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_OpenedHighChambersYendor",
			Count = 1
		}
	}

	ItsyScape.Meta.PartyTravelDestination {
		Raid = ItsyScape.Resource.Raid "HighChambersYendor",
		Action = TravelAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Enter",
		XProgressive = "Entering",
		Language = "en-US",
		Action = TravelAction
	}

	M["HighChambersYendor_Entrance"] {
		TravelAction
	}
end

M["HighChambersYendor_Torch1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 23,
		PositionY = 2,
		PositionZ = 33,
		Name = "HighChambersYendor_Torch1",
		Map = M._MAP,
		Resource = M["HighChambersYendor_Torch1"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "HighChambersYendor_Torch",
		Map = M._MAP,
		MapObject = M["HighChambersYendor_Torch1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["HighChambersYendor_Torch1"]
	}
end

M["HighChambersYendor_Torch2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 2,
		PositionZ = 33,
		Name = "HighChambersYendor_Torch2",
		Map = M._MAP,
		Resource = M["HighChambersYendor_Torch2"]
	}

	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "HighChambersYendor_Torch",
		Map = M._MAP,
		MapObject = M["HighChambersYendor_Torch2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Torch_Default",
		MapObject = M["HighChambersYendor_Torch2"]
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
		XProgressive = "Climbing-up",
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
		Name = "SkeletonMinerJoe",
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
		TalkAction
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

	M["Chest"] {
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
		Name = "CopperSkelemental1",
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
		Name = "CopperSkelemental2",
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
		Name = "CopperSkelemental3",
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
		Name = "TinSkelemental1",
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
		Name = "TinSkelemental2",
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
		Name = "TinSkelemental3",
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

M["Passage_JoeArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_JoeArea",
		Map = M._MAP,
		Resource = M["Passage_JoeArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 19,
		Z1 = 33,
		X2 = 33,
		Z2 = 49,
		Map = M._MAP,
		Resource = M["Passage_JoeArea"]
	}
end

M["Passage_CraftingRoom"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_CraftingRoom",
		Map = M._MAP,
		Resource = M["Passage_CraftingRoom"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 49,
		Z1 = 27,
		X2 = 69,
		Z2 = 43,
		Map = M._MAP,
		Resource = M["Passage_CraftingRoom"]
	}
end

M["Passage_FirstChamber"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_FirstChamber",
		Map = M._MAP,
		Resource = M["Passage_FirstChamber"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 75,
		Z1 = 33,
		X2 = 83,
		Z2 = 43,
		Map = M._MAP,
		Resource = M["Passage_FirstChamber"]
	}
end

M["Passage_BossChamber"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_BossChamber",
		Map = M._MAP,
		Resource = M["Passage_BossChamber"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 49,
		Z1 = 53,
		X2 = 73,
		Z2 = 83,
		Map = M._MAP,
		Resource = M["Passage_BossChamber"]
	}
end

return M
