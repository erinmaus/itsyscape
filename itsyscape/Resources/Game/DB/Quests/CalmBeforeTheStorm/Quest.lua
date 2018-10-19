--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/CalmBeforeTheStorm/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Quest "CalmBeforeTheStorm" {
	ItsyScape.Action.QuestComplete {
		Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_IsabelleDefeated",
		Count = 1
	}
}

ItsyScape.Utility.questStep(
	"CalmBeforeTheStorm_Start",
	"CalmBeforeTheStorm_TalkedToIsabelle1"
)

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to start Calm Before the Storm.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Isabelle before you leave.",
	Resource = ItsyScape.Resource.KeyItem "CalmBeforeTheStorm_TalkedToIsabelle1",
}
