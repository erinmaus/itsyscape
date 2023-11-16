--------------------------------------------------------------------------------
-- Resources/Game/DB/Userdata.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.ItemUserdata "ItemValueUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item value",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Defines the worth an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.UserdataHint {
		Value = "Adds value.",
		Language = "en-US",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Worth %s coin(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemValueUserdata_Description"
	}

	Meta "ItemValueUserdata" {
		Value = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item prayer restoration",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Restores prayer points by consuming an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.UserdataHint {
		Value = "Restores prayer points.",
		Language = "en-US",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Restores %d prayer points(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemPrayerRestorationUserdata_Description"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Greedily restores %d prayer points(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemPrayerRestorationUserdata_ZealousDescription"
	}

	Meta "ItemPrayerRestorationUserdata" {
		PrayerPoints = Meta.TYPE_INTEGER,
		IsZealous = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item healing",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Restores hitpoints by consuming an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.UserdataHint {
		Value = "Restores hitpoints.",
		Language = "en-US",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Heals %d hitpoint(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemHealingUserdata_Description"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Greedily heals %d hitpoint(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemHealingUserdata_ZealousDescription"
	}

	Meta "ItemHealingUserdata" {
		Hitpoints = Meta.TYPE_INTEGER,
		IsZealous = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item stat boosting",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Boosts or lowers stats by consuming an item.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemHealingUserdata"
	}

	ItsyScape.Meta.UserdataHint {
		Value = "Boosts, or maybe lowers, a stat.",
		Language = "en-US",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Raises %s by %d level(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemStatBoostUserdata_Buff"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lowers %s by %d level(s).",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemStatBoostUserdata_Debuff"
	}

	Meta "ItemStatBoostUserdata" {
		Skill = Meta.TYPE_RESOURCE,
		Boost = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}
end

do
	ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"

	ItsyScape.Meta.ResourceName {
		Value = "Item ingredients",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lists the ingredients in food.",
		Language = "en-US",
		Resource = ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"
	}

	ItsyScape.Meta.UserdataHint {
		Value = "Composed of ingredients from cooking",
		Language = "en-US",
		Userdata = ItsyScape.Resource.ItemUserdata "ItemIngredientsUserdata"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Ingredients: %s",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemIngredientsUserdata_Prefix"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "%s",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemIngredientsUserdata_Single"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "%dx %s",
		Language = "en-US",
		Resource = ItsyScape.Resource.KeyItem "Message_ItemIngredientsUserdata_Multiple"
	}
end
