--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/RatKing.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local RatKing = ItsyScape.Resource.Peep "RatKing"

	ItsyScape.Resource.Peep "RatKing" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.BaseRatKing",
		Resource = RatKing
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King",
		Language = "en-US",
		Resource = RatKing
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "King of disgusting!",
		Language = "en-US",
		Resource = RatKing
	}
end

do
	local RatKingUnleashed = ItsyScape.Resource.Peep "RatKingUnleashed"

	ItsyScape.Resource.Peep "RatKingUnleashed" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Rat.RatKingUnleashed",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rat King, The Empty King's Pet",
		Language = "en-US",
		Resource = RatKingUnleashed
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You are what you eat...",
		Language = "en-US",
		Resource = RatKingUnleashed
	}
end
