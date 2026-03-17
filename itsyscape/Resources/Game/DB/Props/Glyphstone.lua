--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Glyphstone.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Rock = ItsyScape.Resource.Prop "GlyphstoneRock"
local WeakOre = ItsyScape.Resource.Item "WeakGlyphstoneFragment"

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(25),
	Weight = 0,
	Resource = WeakOre
}

ItsyScape.Meta.ResourceName {
	Value = "Weak glyphstone fragment",
	Language = "en-US",
	Resource = WeakOre
}

ItsyScape.Meta.ResourceDescription {
	Value = "Speech fragments of the Old One's tongue made physical. They appear to have eroded due to time and are barely useful.",
	Language = "en-US",
	Resource = WeakOre
}

ItsyScape.Meta.ResourceName {
	Value = "Glyphstone rock",
	Language = "en-US",
	Resource = Rock
}

ItsyScape.Meta.ResourceDescription {
	Value = "The speech of the Old One's tongue made physical. This rock must be a part of an incantation and defacing it will weaken the incantation.",
	Language = "en-US",
	Resource = Rock
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = Rock
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicRock",
	Resource = Rock
}

ItsyScape.Meta.GatherableProp {
	SpawnTime = math.huge,
	Resource = Rock
}

local WeakRock = ItsyScape.Resource.Prop "GlyphstoneRock_Weak"

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "GlyphstoneRock",
	Resource = WeakRock
}

ItsyScape.Meta.PropAnchor {
	OffsetI = 0,
	OffsetJ = 0,
	Resource = WeakRock
}

local MineAction = ItsyScape.Action.Mine() {
	Requirement {
		Resource = ItsyScape.Resource.Skill "Mining",
		Count = ItsyScape.Utility.xpForLevel(1)
	},

	Output {
		Resource = ItsyScape.Resource.Skill "Mining",
		Count = ItsyScape.Utility.xpForLevel(10)
	},

	Output {
		Resource = WeakOre,
		Count = 1
	}
}

ItsyScape.Meta.ActionVerb {
	Value = "Deface",
	XProgressive = "Defacing",
	Language = "en-US",
	Action = MineAction
}

WeakRock {
	MineAction
}

ItsyScape.Meta.ResourceName {
	Value = "Glyphstone rock",
	Language = "en-US",
	Resource = WeakRock
}

ItsyScape.Meta.ResourceDescription {
	Value = "The speech of the Old One's tongue made physical. This rock must be a part of an incantation and defacing it will weaken the incantation.",
	Language = "en-US",
	Resource = WeakRock
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicRock",
	Resource = WeakRock
}

ItsyScape.Meta.GatherableProp {
	SpawnTime = math.huge,
	Resource = WeakRock
}
