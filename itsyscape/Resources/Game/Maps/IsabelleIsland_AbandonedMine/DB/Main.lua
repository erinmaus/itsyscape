local M = include "Resources/Game/Maps/IsabelleIsland_AbandonedMine/DB/Default.lua"

M["Goblin"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 16.5 * 2,
		PositionY = 3,
		PositionZ = 21.5 * 2,
		Name = "Goblin",
		Map = M._MAP,
		Resource = M["Goblin"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Goblin_Base",
		MapObject = M["Goblin"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "mine",
		Tree = "Resources/Game/Maps/IsabelleIsland_AbandonedMine/Scripts/Miner_MineLogic.lua",
		Default = 1,
		Resource = M["Goblin"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BronzePickaxe",
		Count = 1,
		Resource = M["Goblin"]
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
	},

	ItsyScape.Action.Close() {
		-- Nothing.
	}
}
