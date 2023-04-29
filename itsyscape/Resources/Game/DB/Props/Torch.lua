--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Torch.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Torch_Default" {
	ItsyScape.Action.Light_Prop() {
		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		}
	},

	ItsyScape.Action.Snuff()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTorch",
	Resource = ItsyScape.Resource.Prop "Torch_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Torch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Torch_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Lights the way.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Torch_Default"
}

ItsyScape.Resource.Prop "Torch_Unlightable" {
	ItsyScape.Action.Light_Prop() {
		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		}
	},

	ItsyScape.Action.Snuff()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicTorch",
	Resource = ItsyScape.Resource.Prop "Torch_Unlightable"
}

ItsyScape.Meta.ResourceName {
	Value = "Torch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Torch_Unlightable"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This torch can't be lit by normal means.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Torch_Unlightable"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Torch_Default",
	Resource = ItsyScape.Resource.Prop "Torch_Unlightable"
}
