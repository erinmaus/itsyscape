--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Castle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Guard = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon"

	ItsyScape.Resource.Peep "Guard_RumbridgeDungeon" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Guard_RumbridgeDungeon",
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
		Value = "Resources.Game.Peeps.Rumbridge.DungeonGuard",
		Resource = Guard
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge guard",
		Language = "en-US",
		Resource = Guard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keeps citizens out and prisoners in.",
		Language = "en-US",
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Attack",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Strength",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Guard
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(30),
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronPlatebody",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronBoots",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronGloves",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronLongsword",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronShield",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/Rumbridge/DungeonGuard_IdleLogic.lua",
		IsDefault = 1,
		Resource = Guard
	}
end

do
	local Guard = ItsyScape.Resource.Peep "Guard_RumbridgeDungeon_Cutscene"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rumbridge.DungeonGuard",
		Resource = Guard
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge guard",
		Language = "en-US",
		Resource = Guard
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keeps the peace.",
		Language = "en-US",
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronPlatebody",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronBoots",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronGloves",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronLongsword",
		Count = 1,
		Resource = Guard
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "IronShield",
		Count = 1,
		Resource = Guard
	}
end

do
	local Chef = ItsyScape.Resource.Peep "ChefAllon"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rumbridge.ChefAllon",
		Resource = Chef
	}

	ItsyScape.Meta.ResourceName {
		Value = "Chef Allon",
		Language = "en-US",
		Resource = Chef
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A three-star chef employed by Earl Reddick.",
		Language = "en-US",
		Resource = Chef
	}
end

do
	local Reddick = ItsyScape.Resource.Peep "EarlReddick"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Human.BaseHuman",
		Resource = Reddick
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shirts/ReddicksRobes.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BODY,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Reddick
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Shoes/Boots_Seafarer1.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FEET,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Reddick
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Eyes/Eyes_Brown.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = math.huge,
		Resource = Reddick
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hands/ReddicksGloves.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HANDS,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Reddick
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Head/Light.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_BASE,
		Resource = Reddick
	}

	ItsyScape.Meta.PeepSkin {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/PlayerKit1/Hair/Enby.lua",
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_HEAD,
		Priority = ItsyScape.Utility.Equipment.SKIN_PRIORITY_ACCENT,
		Resource = Reddick
	}

	ItsyScape.Meta.ResourceName {
		Value = "Earl Reddick",
		Language = "en-US",
		Resource = Reddick
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "One of the most popular Earls of Rumbridge in history.",
		Language = "en-US",
		Resource = Reddick
	}
end
