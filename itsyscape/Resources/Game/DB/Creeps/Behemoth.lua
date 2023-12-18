--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Behemoth.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Behemoth" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceTag {
	Value = "Mimic",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.Behemoth",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth, Lord of the Mimics",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A mimic shed from Gammon's rocky skin, it took the shape of a fortress and wrought havoc across The Empty Ruins until it was imprisoned by the The Empty King's elite zealots, the Priests of the Simulacrum.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Behemoth"
}

ItsyScape.Resource.Prop "BehemothSkin" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.BehemothSkin",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth's skin",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Makes the Behemoth look cool.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothSkin"
}

ItsyScape.Resource.Prop "BehemothMap" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Behemoth.BehemothMap",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.ResourceName {
	Value = "Behemoth's back",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This prop is a proxy for the Behemoth's backside (topside?).",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "BehemothMap"
}

ItsyScape.Meta.PeepMashinaState {
	State = "idle",
	Tree = "Resources/Game/Peeps/Behemoth/Behemoth_IdleLogic.lua",
	IsDefault = 1,
	Resource = ItsyScape.Resource.Peep "Behemoth"
}
