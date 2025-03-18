--------------------------------------------------------------------------------
-- Resources/Game/DB/Effects/Sailing.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Effect "X_ShipRock" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Ship Rocking Motion",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "X_ShipRock"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Don't rock the boat!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "X_ShipRock"
}

do
	local Water = ItsyScape.Resource.Prop "EndlessWater"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicOcean",
		Resource = Water
	}
end

do
	local ShadowVolume = ItsyScape.Resource.Prop "ShadowVolume"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = ShadowVolume
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0,
		SizeY = 0,
		SizeZ = 0,
		MapObject = ShadowVolume
	}
end
