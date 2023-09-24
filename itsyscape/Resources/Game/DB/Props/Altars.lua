--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/ChemistTable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local PrayAction = ItsyScape.Action.Offer()

ItsyScape.Meta.ActionVerb {
	Value = "Pray",
	XProgressive = "Praying",
	Language = "en-US",
	Action = PrayAction
}

ItsyScape.Resource.Prop "Altar_Bastiel1" {
	PrayAction
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Altar_Bastiel1"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 3.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Altar_Bastiel1"
}

ItsyScape.Meta.ResourceName {
	Value = "Bastiliean altar",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Altar_Bastiel1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An altar to the Old One, Bastiel. He is said to bring order and justice to the world, but He has been banished for over a thousand years... Is that true?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Altar_Bastiel1"
}
