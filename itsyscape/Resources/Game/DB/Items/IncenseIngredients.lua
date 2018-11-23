--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/IncenseIngredients.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "WeakGum" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Weight = 0.5,
	Resource = ItsyScape.Resource.Item "WeakGum"
}

ItsyScape.Meta.ResourceName {
	Value = "Weak gum",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WeakGum"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Despite the packaging, it's not food.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WeakGum"
}

ItsyScape.Resource.Item "FalteringFrankincense" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(1),
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "FalteringFrankincense"
}

ItsyScape.Meta.ResourceName {
	Value = "Faltering frankincense",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FalteringFrankincense"
}

ItsyScape.Meta.ResourceDescription {
	Value = "It's beginning to smell a lot like...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FalteringFrankincense"
}

ItsyScape.Resource.Item "FaintEasternBalsam" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(5),
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "FaintEasternBalsam"
}

ItsyScape.Meta.ResourceName {
	Value = "Faint eastern balsam",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FaintEasternBalsam"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Smells not bad. Perhaps even smells good.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FaintEasternBalsam"
}

ItsyScape.Resource.Item "EldritchMyrrh" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(10),
	Weight = 0,
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "EldritchMyrrh"
}

ItsyScape.Meta.ResourceName {
	Value = "Eldritch myrrh",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "EldritchMyrrh"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Looks like a small petrified blob of fear.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "EldritchMyrrh"
}