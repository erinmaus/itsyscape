--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/Rumbridge_Labs.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Resource.Peep "Hex" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Hex.BaseHex",
		Resource = ItsyScape.Resource.Peep "Hex"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Hex",
		Resource = ItsyScape.Resource.Peep "Hex"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "...she might be totally, irrevocably, permanently insane.",
		Resource = ItsyScape.Resource.Peep "Hex"
	}
end
