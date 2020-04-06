--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Crew.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Coconut_Default" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Item "Coconut",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Sailing",
			Count = 10
		}
	}
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Coconut_Default"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = ItsyScape.Resource.Prop "Coconut_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Coconut",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Coconut_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Are coconuts ... nuts?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Coconut_Default"
}

local EatAction = ItsyScape.Action.Eat()

ItsyScape.Meta.HealingPower {
	HitPoints = 2,
	Action = EatAction
}

ItsyScape.Resource.Item "Coconut" {
	EatAction
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(16),
	Stackable = 1,
	Resource = ItsyScape.Resource.Item "Coconut"
}

ItsyScape.Meta.ResourceName {
	Value = "Coconut",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Coconut"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Somehow a convenient bite-sized snack!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Coconut"
}
