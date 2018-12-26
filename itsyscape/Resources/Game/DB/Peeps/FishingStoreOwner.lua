--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/FishingStore.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "FishingStoreOwner" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.FishingStore.FishingStoreOwner",
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner"
}

ItsyScape.Meta.ResourceName {
	Value = "Fisherman Shopkeeper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sells a general assortment of goods useful when fishing.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "BrownApron",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "FishermansHat",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner"
}

local ShopAction = ItsyScape.Action.Shop()

ItsyScape.Meta.ShopTarget {
	Resource = ItsyScape.Resource.Shop "Standard_FishingStore",
	Action = ShopAction
}

ItsyScape.Resource.Peep "FishingStoreOwner_Standard" {
	ShopAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.FishingStore.FishingStoreOwner",
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner_Standard"
}

ItsyScape.Meta.ResourceName {
	Value = "Fisherman Shopkeeper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner_Standard"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sells a general assortment of goods useful when fishing.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner_Standard"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "BrownApron",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner_Standard"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "FishermansHat",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "FishingStoreOwner_Standard"
}
