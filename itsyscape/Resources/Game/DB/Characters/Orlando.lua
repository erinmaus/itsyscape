--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/Orlando.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
do
	local Character = ItsyScape.Resource.Character "Orlando"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Ser Orlando",
		Resource = Character
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Knighted on the behest of his sister and Vizier-King Yohn's friend, Lady Isabelle. Ser Orlando is a hopeless romantic that never waivers from the morals of knighthood.",
		Resource = Character
	}
end

local Orlando = ItsyScape.Resource.Peep "Orlando" {
	ItsyScape.Action.InvisibleAttack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Orlando.Orlando",
	Resource = Orlando
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Ser Orlando",
	Resource = Orlando
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hopeless romantic.",
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumGloves",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumBoots",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "IsabelliumPlatebody",
	Count = 1,
	Resource = Orlando
}

ItsyScape.Meta.PeepHealth {
	Hitpoints = 200,
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Attack",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Strength",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Defense",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.PeepStat {
	Skill = ItsyScape.Resource.Skill "Faith",
	Value = ItsyScape.Utility.xpForLevel(60),
	Resource = Orlando
}

ItsyScape.Meta.Equipment {
	AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(60, 1),
	DefenseCrush = ItsyScape.Utility.styleBonusForItem(50, 1),
	DefenseSlash = ItsyScape.Utility.styleBonusForItem(50, 1),
	DefenseDefense = ItsyScape.Utility.styleBonusForItem(50, 1),
	DefenseRanged = ItsyScape.Utility.styleBonusForItem(55, 1),
	DefenseMagic = ItsyScape.Utility.styleBonusForItem(30, 1),
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(60, 1),
	Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
	Resource = Orlando
}
