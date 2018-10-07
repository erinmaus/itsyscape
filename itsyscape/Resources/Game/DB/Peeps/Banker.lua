--------------------------------------------------------------------------------
-- Resources/Game/DB/Peeps/Goblin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "FancyBanker" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Goblin.FancyBanker",
	Resource = ItsyScape.Resource.Peep "FancyBanker"
}

ItsyScape.Meta.ResourceName {
	Value = "Banker",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FancyBanker"
}

local TalkAction = ItsyScape.Action.Talk()

ItsyScape.Meta.TalkSpeaker {
	Resource = ItsyScape.Resource.Peep "FancyBanker_Default",
	Name = "Banker",
	Action = TalkAction
}

ItsyScape.Meta.TalkDialog {
	Script = "Resources/Game/Peeps/Banker/DefaultBankerDialog_en-US.lua",
	Language = "en-US",
	Action = TalkAction
}

ItsyScape.Resource.Peep "FancyBanker_Default" {
	TalkAction,
	ItsyScape.Action.Bank()
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Banker.FancyBanker",
	Resource = ItsyScape.Resource.Peep "FancyBanker_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Banker",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "FancyBanker_Default"
}
