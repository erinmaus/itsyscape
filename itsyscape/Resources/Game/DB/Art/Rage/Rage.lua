--------------------------------------------------------------------------------
-- Resources/Game/DB/Art/Rage/Rage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Monitor = ItsyScape.Resource.Prop "Art_Rage_Monitor"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.ArtRage.Monitor",
	Resource = Monitor
}

ItsyScape.Meta.ResourceName {
	Value = "Kursed monitor",
	Language = "en-US",
	Resource = Monitor
}

ItsyScape.Meta.ResourceDescription {
	Value = "This monitor is kursed by an angry god.",
	Language = "en-US",
	Resource = Monitor
}

local Case = ItsyScape.Resource.Prop "Art_Rage_Case"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = Case
}

ItsyScape.Meta.ResourceName {
	Value = "Kursed case",
	Language = "en-US",
	Resource = Case
}

ItsyScape.Meta.ResourceDescription {
	Value = "This case is kursed by an angry god.",
	Language = "en-US",
	Resource = Case
}

local Fire = ItsyScape.Resource.Prop "Art_Rage_Fire"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BlockingProp",
	Resource = Fire
}

ItsyScape.Meta.ResourceName {
	Value = "Oil fire",
	Language = "en-US",
	Resource = Fire
}

ItsyScape.Meta.ResourceDescription {
	Value = "Water won't put that out.",
	Language = "en-US",
	Resource = Fire
}
