--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Flax.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Flax" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForLevel(1),
		},

		Output {
			Resource = ItsyScape.Resource.Item "Flax",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Foraging",
			Count = ItsyScape.Utility.xpForResource(2)
		}
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2,
	SizeY = 2.5,
	SizeZ = 2,
	MapObject = ItsyScape.Resource.Prop "Flax"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicFlax",
	Resource = ItsyScape.Resource.Prop "Flax"
}

ItsyScape.Meta.ResourceName {
	Value = "Flax",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Flax"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good in fiber.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Flax"
}

ItsyScape.Resource.Item "Flax"

ItsyScape.Meta.ResourceName {
	Value = "Flax",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Flax"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good in fiber, or was it good for fiber?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Flax"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Good in fiber.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Flax"
}
