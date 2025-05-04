--------------------------------------------------------------------------------
-- Resources/Game/DB/Effects/Misc.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Effect "FungalInfection" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "Fungal Infection",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "FungalInfection"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Deals 1-2 damage a second over 60 seconds.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "FungalInfection"
}

do
	local Favored = ItsyScape.Resource.Effect "Favored"

	ItsyScape.Meta.ResourceName {
		Value = "Gods' Favor",
		Language = "en-US",
		Resource = Favored
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "With the favor of the gods on your side, gain twice as much zeal.",
		Language = "en-US",
		Resource = Favored
	}
end
