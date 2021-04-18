--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Anvil.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local SpinAction = ItsyScape.Action.OpenCraftWindow()
ItsyScape.Meta.DelegatedActionTarget {
	CategoryKey = "Fiber",
	ActionType = "Craft",
	Action = SpinAction
}

ItsyScape.Meta.ActionVerb {
	Value = "Spin",
	XProgressive = "Spinning",
	Language = "en-US",
	Action = SpinAction
}

ItsyScape.Resource.Prop "SpinningWheel_Default" {
	SpinAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "SpinningWheel_Default"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1,
	SizeY = 2,
	SizeZ = 1,
	MapObject = ItsyScape.Resource.Prop "SpinningWheel_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Spinning wheel",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "SpinningWheel_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Round'n'round it goes, when it stops, nobody knows.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "SpinningWheel_Default"
}
