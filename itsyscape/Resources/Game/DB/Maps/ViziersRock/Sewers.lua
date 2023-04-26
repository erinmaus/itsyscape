--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/ViziersRock/ViziersRock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Raid = ItsyScape.Resource.Raid "ViziersRockSewers"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Sewers of Vizier's Rock",
		Resource = ItsyScape.Resource.Raid "ViziersRockSewers"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "The sewers of the capital are crawling with pests! Exterminate them once and for all.",
		Resource = ItsyScape.Resource.Raid "ViziersRockSewers"
	}

	ItsyScape.Meta.RaidDestination {
		Raid = Raid,
		Map = ItsyScape.Resource.Map "ViziersRock_Sewers_Floor1",
		Anchor = "Anchor_FromCityCenter"
	}
end
