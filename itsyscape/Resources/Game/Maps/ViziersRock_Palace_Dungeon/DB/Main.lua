local M = include "Resources/Game/Maps/ViziersRock_Palace_Dungeon/DB/Default.lua"

-- ItsyScape.Meta.PeepID {
-- 	Value = "Resources.Game.Maps.ViziersRock_Palace_Dungeon.Peep",
-- 	Resource = M._MAP
-- }

ItsyScape.Meta.ResourceName {
	Value = "Vizier's Rock Palace, Dungeon",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "Prisoners of Vizier's Rock hard at work mining.",
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

M["Anchor_FromPalace"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 59,
		PositionY = 0,
		PositionZ = 59,
		Name = "Anchor_FromPalace",
		Map = M._MAP,
		Resource = M["Anchor_FromPalace"]
	}
end

M["Door_IronGate_Sewers"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 0,
		PositionZ = 39,
		Name = "Door_IronGate_Sewers",
		Map = M._MAP,
		Resource = M["Door_IronGate_Sewers"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate_Sewers"]
	}

	M["Door_IronGate_Sewers"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "ViziersRock_Sewers_AdamantKey",
				Count = 1
			}
		}
	}
end

M["Door_IronGate_Mine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 0,
		PositionZ = 39,
		RotationX = 0,
		RotationY = 1,
		RotationZ = 0,
		RotationW = 0,
		Name = "Door_IronGate_Mine",
		Map = M._MAP,
		Resource = M["Door_IronGate_Mine"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate_Mine"]
	}

	M["Door_IronGate_Mine"] {
		ItsyScape.Action.Open()
	}
end

M["Door_IronGate_Entrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 0,
		PositionZ = 55,
		RotationX = 0,
		RotationY = 1,
		RotationZ = 0,
		RotationW = 0,
		Name = "Door_IronGate_Entrance",
		Map = M._MAP,
		Resource = M["Door_IronGate_Entrance"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate_Entrance"]
	}

	M["Door_IronGate_Entrance"] {
		ItsyScape.Action.Open()
	}
end

M["Door_IronGate_DeeperMine"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 33,
		PositionY = 1,
		PositionZ = 5,
		RotationX = 0,
		RotationY = -0.707107,
		RotationZ = 0,
		RotationW = -0.707107,
		Name = "Door_IronGate_DeeperMine",
		Map = M._MAP,
		Resource = M["Door_IronGate_DeeperMine"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Door_IronGate",
		MapObject = M["Door_IronGate_DeeperMine"]
	}

	M["Door_IronGate_DeeperMine"] {
		ItsyScape.Action.Open() {
			Requirement {
				Resource = ItsyScape.Resource.Item "ViziersRock_Palace_MineKey",
				Count = 1
			}
		}
	}
end

M["TrashHeap1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 0,
		PositionZ = 11,
		Name = "TrashHeap1",
		Map = M._MAP,
		Resource = M["TrashHeap1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap1"]
	}
end


M["TrashHeap2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 9,
		PositionY = 0,
		PositionZ = 27,
		Name = "TrashHeap2",
		Map = M._MAP,
		Resource = M["TrashHeap2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap2"]
	}
end


M["TrashHeap3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = 0,
		PositionZ = 19,
		Name = "TrashHeap3",
		Map = M._MAP,
		Resource = M["TrashHeap3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap3"]
	}
end

M["TrashHeap4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 7,
		PositionY = -1,
		PositionZ = 35,
		Name = "TrashHeap4",
		Map = M._MAP,
		Resource = M["TrashHeap4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "TrashHeap",
		MapObject = M["TrashHeap4"]
	}
end

M["Guard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 55,
		PositionY = 0,
		PositionZ = 15,
		Name = "Guard1",
		Map = M._MAP,
		Resource = M["Guard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronLongsword",
		Count = 1,
		Resource = M["Guard1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronShield",
		Count = 1,
		Resource = M["Guard1"]
	}
end

M["Guard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 45,
		PositionY = 0,
		PositionZ = 9,
		Name = "Guard2",
		Map = M._MAP,
		Resource = M["Guard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronLongsword",
		Count = 1,
		Resource = M["Guard2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronShield",
		Count = 1,
		Resource = M["Guard2"]
	}
end

M["Guard3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 0,
		PositionZ = 27,
		Name = "Guard3",
		Map = M._MAP,
		Resource = M["Guard3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Guard_ViziersRock",
		MapObject = M["Guard3"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronLongsword",
		Count = 1,
		Resource = M["Guard3"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronShield",
		Count = 1,
		Resource = M["Guard3"]
	}
end

M["Knight1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 35,
		PositionY = 0,
		PositionZ = 29,
		Name = "Knight1",
		Map = M._MAP,
		Resource = M["Knight1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Knight_ViziersRock",
		MapObject = M["Knight1"]
	}
end

M["Knight2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 57,
		PositionY = 0,
		PositionZ = 15,
		Name = "Knight2",
		Map = M._MAP,
		Resource = M["Knight2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Knight_ViziersRock",
		MapObject = M["Knight2"]
	}
end

M["BankingCrate"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 27,
		PositionY = 1,
		PositionZ = 5,
		ScaleX = 1.5,
		ScaleY = 1.5,
		ScaleZ = 1.5,
		Name = "BankingCrate",
		Map = M._MAP,
		Resource = M["BankingCrate"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Crate_Default1",
		MapObject = M["BankingCrate"]
	}

	M["BankingCrate"] {
		ItsyScape.Action.Bank()
	}
end