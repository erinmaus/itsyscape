--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Monastery.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Rumbridge_Monastery_StainedGlassWindow" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.PassableProp",
	Resource = ItsyScape.Resource.Prop "Rumbridge_Monastery_StainedGlassWindow"
}

ItsyScape.Meta.ResourceName {
	Value = "Stained glass window",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Rumbridge_Monastery_StainedGlassWindow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Gives me the chills...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Rumbridge_Monastery_StainedGlassWindow"
}

ItsyScape.Resource.Prop "Pew_RumbridgeMonastery" {
	-- Nothing
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.StaticProp",
	Resource = ItsyScape.Resource.Prop "Pew_RumbridgeMonastery"
}

ItsyScape.Meta.ResourceName {
	Value = "Pew",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Pew_RumbridgeMonastery"
}

ItsyScape.Meta.ResourceDescription {
	Value = "That's sure a comfy pew!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Pew_RumbridgeMonastery"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 4.5,
	SizeY = 3,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Pew_RumbridgeMonastery"
}

do
	local Monk = ItsyScape.Resource.Peep "BastielZealotMonk"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.BastielMonk.BastielZealotMonk",
		Resource = Monk
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bastiellian monk",
		Language = "en-US",
		Resource = Monk
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This monk is so devoted to Bastiel that their left eye overtook their head.",
		Language = "en-US",
		Resource = Monk
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/BastielMonk/BastielMonk_IdleLogic.lua",
		IsDefault = 1,
		Resource = Monk
	}
end

do
	local Monk = ItsyScape.Resource.Peep "RandomMonk"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.BastielMonk.RandomMonk",
		Resource = Monk
	}

	ItsyScape.Meta.ResourceName {
		Value = "Monk",
		Language = "en-US",
		Resource = Monk
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A devout follower of Bastiel, yearning to become closer with Him.",
		Language = "en-US",
		Resource = Monk
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Peeps/BastielMonk/RandomMonk_IdleLogic.lua",
		IsDefault = 1,
		Resource = Monk
	}
end
