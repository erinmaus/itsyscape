--------------------------------------------------------------------------------
-- Resources/Game/DB/Spells/ModernMisc.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Meta.ResourceName {
	Value = "Enchant",
	Language = "en-US",
	Resource = ItsyScape.Resource.Spell "Enchant"
}

ItsyScape.Resource.Spell "Enchant" {
	ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		}
	}
}
