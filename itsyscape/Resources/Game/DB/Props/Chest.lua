--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Chest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Chest_Default"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicChest",
	Resource = ItsyScape.Resource.Prop "Chest_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Chest",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chest_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good for storage.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chest_Default"
}

ItsyScape.Resource.Prop "Chest_Instanced_Default"

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Chest_Default",
	Resource = ItsyScape.Resource.Prop "Chest_Instanced_Default"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.InstancedBasicChest",
	Resource = ItsyScape.Resource.Prop "Chest_Instanced_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Chest",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chest_Instanced_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Bet there's something good stuffed in there...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Chest_Instanced_Default"
}
