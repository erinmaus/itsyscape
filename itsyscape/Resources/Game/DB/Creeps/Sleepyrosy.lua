--------------------------------------------------------------------------------
-- Resources/Game/DB/Creeps/Sleepyrosy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Sleepyrosy" {
	ItsyScape.Action.Attack()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Sleepyrosy.Sleepyrosy",
	Resource = ItsyScape.Resource.Peep "Sleepyrosy"
}

ItsyScape.Meta.ResourceName {
	Value = "Sleepyrosy, Nightmare Daemon",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Sleepyrosy"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A daemon that feeds on nightmares, thought to have been banished by Bastiel eons ago. How did she end up here...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Sleepyrosy"
}
