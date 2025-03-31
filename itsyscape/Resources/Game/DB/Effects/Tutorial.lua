--------------------------------------------------------------------------------
-- Resources/Game/DB/Effects/Tutorial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Effect "Tutorial_NoDamage" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "No damage (tutorial)",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Tutorial_NoDamage"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The attacker deals no damage.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Tutorial_NoDamage"
}

ItsyScape.Resource.Effect "Tutorial_NoKill" {
	-- Nothing.
}

ItsyScape.Meta.ResourceName {
	Value = "No kill (tutorial)",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Tutorial_NoKill"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The attacker cannot kill the foe.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Effect "Tutorial_NoKill"
}
