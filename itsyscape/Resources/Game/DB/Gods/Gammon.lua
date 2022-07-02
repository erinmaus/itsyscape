--------------------------------------------------------------------------------
-- Resources/Game/DB/Gods/Gammon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Gammon_Base" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Gammon_Base"
}

ItsyScape.Meta.ResourceTag {
	Value = "OldOne",
	Resource = ItsyScape.Resource.Peep "Gammon_Base"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Gammon.BaseGammon",
	Resource = ItsyScape.Resource.Peep "Gammon_Base"
}

ItsyScape.Meta.ResourceName {
	Value = "Gammon, the Realm Breaker",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Gammon_Base"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Fear Gammon! For Its strength can shatter the cosmos itself, tearing holes into the Daemon Realm! Fear It! Fear!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Gammon_Base"
}
