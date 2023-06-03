--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/AncientKaradon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local AncientKaradon = ItsyScape.Resource.Peep "AncientKaradon"

	ItsyScape.Resource.Peep "AncientKaradon" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Creep",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient karadon",
		Language = "en-US",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An angler fish long thought to be extinct; it preys on the souls of humans, damning them to eternal suffering to power its angler.",
		Language = "en-US",
		Resource = AncientKaradon
	}

	ItsyScape.Meta.Dummy {
		Tier = 40,
		CombatStyle = ItsyScape.Utility.Weapon.STYLE_MAGIC,

		Hitpoints = 500,
		Size = 3,

		ChaseDistance = math.huge,
		AttackDistance = 16,
		AttackCooldown = 3,
		AttackProjectile = "WaterBlast",

		Resource = AncientKaradon
	}
end

do
	local AncientKaradonPriest = ItsyScape.Resource.Peep "AncientKaradonPriest"

	ItsyScape.Resource.Peep "AncientKaradonPriest" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ancient karadon",
		Language = "en-US",
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An angler fish long thought to be extinct; it preys on the souls of humans, damning them to eternal suffering to power its angler.",
		Language = "en-US",
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.Dummy {
		Hitpoints = 100,

		Weapon = "SpindlyLongbow",
		Shield = "AncientKaradonBuckler",

		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientKaradonBody",
		Count = 1,
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientKaradonGloves",
		Count = 1,
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AncientKaradonBoots",
		Count = 1,
		Resource = AncientKaradonPriest
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "AdamantArrow",
		Count = 10000,
		Resource = AncientKaradonPriest
	}
end
