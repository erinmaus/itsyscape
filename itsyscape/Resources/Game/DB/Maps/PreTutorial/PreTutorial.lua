--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/PreTutorial/PreTutorial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
do
	local Rat = ItsyScape.Resource.Peep "PreTutorial_Rat"

	ItsyScape.Resource.Peep "PreTutorial_Rat" {
		ItsyScape.Action.Attack(),

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "PreTutorial_Rat_Primary",
				Count = 1
			}
		},

		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "PreTutorial_Rat_Secondary",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.BaseRat",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceName {
		Value = "Purple rat",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Disgusting! But at least it smells like lavender.",
		Language = "en-US",
		Resource = Rat
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = Rat
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = -100,
		AccuracySlash = -100,
		AccuracyCrush = -100,
		DefenseStab = -50,
		DefenseSlash = -50,
		DefenseCrush = -50,
		DefenseMagic = -50,
		DefenseRanged = -50,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = Rat
	}
end

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "PreTutorial_Rat_Primary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 300,
		Count = 50,
		Range = 25,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CavePotato",
		Weight = 200,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "TinCan",
		Weight = 200,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "ShadowLogs",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "RustyDagger",
		Weight = 100,
		Count = 1,
		Resource = PrimaryDropTable
	}
end

do
	local SecondaryDropTable = ItsyScape.Resource.DropTable "PreTutorial_Rat_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}
end
