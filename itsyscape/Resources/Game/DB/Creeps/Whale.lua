--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Whale.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local UndeadWhale = ItsyScape.Resource.Peep "UndeadWhale"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Whale.UndeadWhale",
		Resource = UndeadWhale
	}

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian whale",
		Language = "en-US",
		Resource = UndeadWhale
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Yendorian followers drown whales and then resurrect them to serve Yendor forever and guard the City in the Sea.",
		Language = "en-US",
		Resource = UndeadWhale
	}
end
