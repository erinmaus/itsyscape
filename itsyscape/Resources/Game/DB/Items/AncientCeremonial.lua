--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/AncientCeremonial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "AncientZweihander" {
	ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Attack",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Strength",
			Count = ItsyScape.Utility.xpForLevel(50)
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Faith",
			Count = ItsyScape.Utility.xpForLevel(50)
		}
	},

	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	AccuracySlash  = ItsyScape.Utility.styleBonusForWeapon(70),
	DefenseSlash   = ItsyScape.Utility.styleBonusForItem(70, 0.5),
	DefenseRanged  = 1,
	StrengthMelee  = ItsyScape.Utility.strengthBonusForWeapon(70),
	Prayer         = 25,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_TWO_HANDED,
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.EquipmentModel {
	Type = "ItsyScape.Game.Skin.ModelSkin",
	Filename = "Resources/Game/Skins/AncientCeremonial/Zweihander.lua",
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(75) * 5,
	Weight = 20,
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.ResourceName {
	Value = "Ancient zweihander",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Capable of slaying all but the toughest of foes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientZweihander"
}

