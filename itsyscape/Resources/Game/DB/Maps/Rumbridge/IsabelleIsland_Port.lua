--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Port.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PortmasterJenkins.PortmasterJenkins",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Portmaster Jenkins",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Ex-ex-ex-pirate now on the good side of the law, again...",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}
end

do
	ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.UndeadSquid.UndeadSquid",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Defense",
		Value = ItsyScape.Utility.xpForLevel(60),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Archery",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(99),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Mn'thrw, Undead Squid",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "A squid sacrified to Yendor, now corrupted by the Empty King to protect the island.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "spawn",
		Tree = "Resources/Game/Peeps/UndeadSquid/UndeadSquid_SpawnLogic.lua",
		IsDefault = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForItem(65),
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(65),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_UndeadSquid"
	}
end

do
	local PlugAction = ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}

	ItsyScape.Meta.ActionEvent {
		Event = "IsabelleIsland_Ocean_PlugLeak",
		Action = PlugAction
	}

	ItsyScape.Meta.ActionEventTarget {
		Value = ItsyScape.Resource.Map "IsabelleIsland_Ocean",
		Action = PlugAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Plug",
		Language = "en-US",
		Action = PlugAction
	}

	ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak" {
		PlugAction
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 3,
		SizeZ = 1.5,
		MapObject = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BlockingProp",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Leak",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "If that's not plugged soon, the ship will sink.",
		Resource = ItsyScape.Resource.Prop "IsabelleIsland_Port_WaterLeak"
	}
end
