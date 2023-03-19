--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Fabrics.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Fabric",
		CategoryValue = "BlueCotton",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "BlueCotton" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Blue cotton",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCotton"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "How nice, it already has a pattern!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BlueCotton"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "BlueCotton"
	}
end

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Fabric",
		CategoryValue = "CottonCloth",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "CottonCloth" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cotton cloth",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonCloth"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Spun from cheep fur, obviously. Not from some plant... That would be weird!",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CottonCloth"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(11),
		Weight = 0.25,
		Resource = ItsyScape.Resource.Item "CottonCloth"
	}
end

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Fabric",
		CategoryValue = "SpiderSilk",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "SpiderSilk" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Spider silk",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SpiderSilk"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Fine silk made from spider webs.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SpiderSilk"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(21),
		Weight = 0.25,
		Resource = ItsyScape.Resource.Item "SpiderSilk"
	}
end

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Fabric",
		CategoryValue = "MysticCotton",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "MysticCotton" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mystic cotton",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MysticCotton"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A cotton with a kurse.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "MysticCotton"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(31),
		Weight = 0.25,
		Resource = ItsyScape.Resource.Item "MysticCotton"
	}
end

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Fabric",
		CategoryValue = "ZealotSilk",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "ZealotSilk" {
		CraftAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Zealot silk",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ZealotSilk"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The finest silk made by humans.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "ZealotSilk"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(31),
		Weight = 0.25,
		Resource = ItsyScape.Resource.Item "ZealotSilk"
	}
end
