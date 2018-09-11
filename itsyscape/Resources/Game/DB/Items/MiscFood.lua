--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/MiscFood.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local EatAction = ItsyScape.Action.Eat()
	ItsyScape.Resource.Item "CavePotato" {
		EatAction
	}

	ItsyScape.Meta.HealingPower {
		HitPoints = 4,
		Action = EatAction
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cave potato",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CavePotato"
	}
end
