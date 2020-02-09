--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Legendaries/TimeTurner.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ActionType "TurnForwardTime"
ItsyScape.Meta.ActionTypeVerb {
	Value = "Turn-Forward",
	Language = "en-US",
	Value = "TurnForwardTime"
}

ActionType "TurnBackwardTime"
ItsyScape.Meta.ActionTypeVerb {
	Value = "Turn-Backward",
	Language = "en-US",
	Value = "TurnBackwardTime"	
}

ItsyScape.Resource.Item "TimeTurner" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(90)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(90)
		}
	},

	ItsyScape.Action.Dequip(),

	ItsyScape.Action.TurnForwardTime(),
	ItsyScape.Action.TurnBackwardTime()
}

ItsyScape.Meta.Equipment {
	DefenseStab    = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseCrush   = ItsyScape.Utility.styleBonusForItem(50, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseMagic   = ItsyScape.Utility.styleBonusForItem(45, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	DefenseRanged  = -ItsyScape.Utility.styleBonusForItem(10, ItsyScape.Utility.ARMOR_HELMET_WEIGHT),
	Prayer         = 30,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_POCKET,
	Resource = ItsyScape.Resource.Item "TimeTurner"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(100),
	Weight = -100,
	Resource = ItsyScape.Resource.Item "TimeTurner"
}

ItsyScape.Meta.ResourceName {
	Value = "Prisium's Time Turner Mashina",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "TimeTurner"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A machina that can move time for the wearer without splitting timelines by invoking the unholy genius of Prisium. And try as you might, it resists being turned backwards, on forward... Tick, tick tick.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "TimeTurner"
}
