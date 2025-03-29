--------------------------------------------------------------------------------
-- Resources/Game/DB/Powers/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local DefensiveStanceFail = ItsyScape.Resource.KeyItem "ActionFail_Power_RequireDefensiveStance"

	ItsyScape.Meta.ResourceName {
		Value = "Rite of bulwark",
		Language = "en-US",
		Resource = DefensiveStanceFail
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You need to be in the defensive or controlled stance to use this power.",
		Language = "en-US",
		Resource = DefensiveStanceFail
	}
end

do
	local OffensiveStanceFail = ItsyScape.Resource.KeyItem "ActionFail_Power_RequireOffensiveStance"

	ItsyScape.Meta.ResourceName {
		Value = "Rite of malice",
		Language = "en-US",
		Resource = OffensiveStanceFail
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "You need to be in the aggressive or controlled stance to use this power.",
		Language = "en-US",
		Resource = OffensiveStanceFail
	}
end
