--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/Goblin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "GeneralStoreOwner" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.GeneralStore.GeneralStoreOwner",
	Resource = ItsyScape.Resource.Peep "GeneralStoreOwner"
}

ItsyScape.Meta.ResourceName {
	Value = "General Store Shopkeeper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GeneralStoreOwner"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "BrownApron",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "GeneralStoreOwner"
}

local ShopAction = ItsyScape.Action.Shop()

ItsyScape.Meta.ShopTarget {
	Resource = ItsyScape.Resource.Shop "Standard_GeneralStore",
	Action = ShopAction
}

ItsyScape.Resource.Peep "GeneralStoreOwner_Standard" {
	ShopAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.GeneralStore.GeneralStoreOwner",
	Resource = ItsyScape.Resource.Peep "GeneralStoreOwner_Standard"
}

ItsyScape.Meta.ResourceName {
	Value = "General Store Shopkeeper",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "GeneralStoreOwner_Standard"
}

ItsyScape.Meta.PeepEquipmentItem {
	Item = ItsyScape.Resource.Item "BrownApron",
	Count = 1,
	Resource = ItsyScape.Resource.Peep "GeneralStoreOwner_Standard"
}
