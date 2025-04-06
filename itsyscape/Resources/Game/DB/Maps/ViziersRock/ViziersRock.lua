--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/ViziersRock/ViziersRock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Bartender_Robert" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ViziersRock.Bartender",
	Resource = ItsyScape.Resource.Peep "Bartender_Robert"
}

ItsyScape.Meta.ResourceName {
	Value = "Robert, Bartender",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Bartender_Robert"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can mix a mean drink.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Bartender_Robert"
}

local ShopAction = ItsyScape.Action.Shop()

ItsyScape.Meta.ShopTarget {
	Resource = ItsyScape.Resource.Shop "Standard_Crafter",
	Action = ShopAction
}

ItsyScape.Resource.Peep "Crafter_Steve" {
	ShopAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ViziersRock.Crafter",
	Resource = ItsyScape.Resource.Peep "Crafter_Steve"
}

ItsyScape.Meta.ResourceName {
	Value = "Steve, Crafter",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Crafter_Steve"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An excellent crafter.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Crafter_Steve"
}

ItsyScape.Resource.Prop "StreetLamp_ViziersRock" {
	-- None.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Street lamp",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Is it powered by gas or magic?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 8,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "StreetLamp_ViziersRock"
}

ItsyScape.Resource.Prop "WallLamp_ViziersRock" {
	-- None.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "WallLamp_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Wall lamp",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "WallLamp_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Surprised no bugs are flying about...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "WallLamp_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0.5,
	SizeY = 0.5,
	SizeZ = 0.5,
	OffsetY = 2,
	MapObject = ItsyScape.Resource.Prop "WallLamp_ViziersRock"
}

ItsyScape.Resource.Prop "Banner_ViziersRock" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Vizier Rock's banner",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A banner representing Bastiel's omniscience. Or so the Arbitrationists believe...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Banner_ViziersRock"
}

ItsyScape.Resource.Prop "Fireplace_ViziersRock" {
	ItsyScape.Action.Light_Prop() {
		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		}
	},

	ItsyScape.Action.Snuff()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTorch",
	Resource = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

ItsyScape.Meta.ResourceName {
	Value = "Fireplace",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This might not keep you as warm as you'd think.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Fireplace_ViziersRock"
}

do
	local Knight = ItsyScape.Resource.Peep "Knight_ViziersRock"

	ItsyScape.Meta.PeepCharacter {
		Peep = Knight,
		Character = ItsyScape.Resource.Character "VizierRockKnight"
	}

	ItsyScape.Resource.Peep "Knight_ViziersRock" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Knight_ViziersRock_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Human_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.Guard",
		Resource = Knight
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier Rock knight",
		Language = "en-US",
		Resource = Knight
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Belongs to the Vizier-King Yohn's personal guard. They're one of the most skilled warriors in the Realm.",
		Language = "en-US",
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Faith",
		Value = ItsyScape.Utility.xpForLevel(45),
		Resource = Knight
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(350),
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantPlatebody",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantBoots",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantGloves",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantHelmet",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AdamantLongsword",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "TrimmedAdamantShield",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "GoldenRing",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "GoldenAmulet",
		Count = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/ViziersRock/Knight_IdleLogic.lua",
		IsDefault = 1,
		Resource = Knight
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Peeps/ViziersRock/Knight_AttackLogic.lua",
		Resource = Knight
	}

	local DropTable = ItsyScape.Resource.DropTable "Knight_ViziersRock_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantTrim",
		Weight = 100,
		Count = 10,
		Range = 5,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 50,
		Count = ItsyScape.Utility.xpForResource(45),
		Range = ItsyScape.Utility.xpForResource(45) / 5,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "ViziersRock_Palace_MineKey",
		Weight = 75,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CosmicRune",
		Weight = 25,
		Count = 100,
		Range = 50,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantArrow",
		Weight = 25,
		Count = 25,
		Range = 10,
		Resource = DropTable
	}
end

do
	local Guard = ItsyScape.Resource.Peep "Guard_ViziersRock" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Guard_ViziersRock_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Human_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.Guard",
		Resource = Guard
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/ViziersRockGuard/Body.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_EQUIPMENT,
		Resource = Guard
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/ViziersRockGuard/Gloves.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_EQUIPMENT,
		Resource = Guard
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/ViziersRockGuard/Boots.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_EQUIPMENT,
		Resource = Guard
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/ViziersRockGuard/Helmet.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_EQUIPMENT,
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(75),
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronArrow",
		Count = 10000,
		Resource = Guard
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier Rock guard",
		Language = "en-US",
		Resource = Guard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "They try to keep order but aren't very good at it.",
		Language = "en-US",
		Resource = Guard
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/ViziersRock/Guard_IdleLogic.lua",
		IsDefault = 1,
		Resource = Guard
	}

	local DropTable = ItsyScape.Resource.DropTable "Guard_ViziersRock_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "AdamantTrim",
		Weight = 5,
		Count = 2,
		Range = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 50,
		Count = ItsyScape.Utility.xpForResource(25),
		Range = ItsyScape.Utility.xpForResource(25) / 5,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "ViziersRock_Palace_MineKey",
		Weight = 50,
		Count = 1,
		Resource = DropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlackenedIronArrow",
		Weight = 50,
		Count = 30,
		Range = 15,
		Resource = DropTable
	}
end

do
	local Prisoner = ItsyScape.Resource.Peep "Prisoner_ViziersRock"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.ViziersRock.Prisoner",
		Resource = Prisoner
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "BlackenedIronPickaxe",
		Count = 1,
		Resource = Prisoner
	}

	ItsyScape.Meta.ResourceName {
		Value = "Vizier Rock prisoner",
		Language = "en-US",
		Resource = Prisoner
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Mining",
		Value = ItsyScape.Utility.xpForLevel(20),
		Resource = Prisoner
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Could be in prison for jay walking or murder... Who knows!",
		Language = "en-US",
		Resource = Prisoner
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "mine",
		Tree = "Resources/Game/Peeps/ViziersRock/Prisoner_MineLogic.lua",
		IsDefault = 1,
		Resource = Prisoner
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "clear",
		Tree = "Resources/Game/Peeps/ViziersRock/Prisoner_ClearLogic.lua",
		Resource = Prisoner
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/ViziersRock/Prisoner_IdleLogic.lua",
		Resource = Prisoner
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "prison-break",
		Tree = "Resources/Game/Peeps/ViziersRock/Prisoner_PrisonBreakLogic.lua",
		Resource = Prisoner
	}
end
