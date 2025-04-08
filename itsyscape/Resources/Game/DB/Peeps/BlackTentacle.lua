--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/BlackTentacle.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local CapnRaven = ItsyScape.Resource.Peep "CapnRaven" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.CapnRaven.CapnRaven",
		Resource = CapnRaven
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Cap'n Raven",
		Resource = CapnRaven
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "In the running to become the legendary Queen of the Pirates...",
		Resource = CapnRaven
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "LitBullseyeLantern",
		Count = 1,
		Resource = CapnRaven
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(99),
		Resource = CapnRaven
	}
end
