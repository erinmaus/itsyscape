--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/CalmBeforeTheStorm/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Quest "PreTutorial" {
	ItsyScape.Action.QuestComplete() {
		Requirement {
			Resource = ItsyScape.Resource.KeyItem "PreTutorial_WokeUp",
			Count = 1
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Restless Ghosts (Tutorial)",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "PreTutorial"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can you put a couple ghost children to rest?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "PreTutorial"
}

ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"

ItsyScape.Utility.questStep(
	"PreTutorial_Start",
	"PreTutorial_TalkedToButler1"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToButler1",
	"PreTutorial_SavedGhostGirl"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToButler1",
	"PreTutorial_SavedGhostBoy"
)

ItsyScape.Utility.questStep(
	{
		"PreTutorial_SavedGhostGirl",
		"PreTutorial_SavedGhostBoy",		
	},

	"PreTutorial_TalkedToButler2"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToButler2",
	"PreTutorial_WokeUp"
)

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to start Restless Ghosts.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Hans, the Zombi butler, to find out what's wrong.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler1"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to save the ghost girl.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to save the ghost boy.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to the Butler to find out what's next.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler2"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to wake up.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_WokeUp"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You started Restless Ghosts.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Hans, the Zombi butler. Turns out two sick children once in his care refuse to pass on.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler1"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You saved the ghost girl by giving her the goldfish, Larry.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You saved the ghost boy by defeating the monster under the bed.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to the Butler to find out you're just in a dream.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler2"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You woke up.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_WokeUp"
}
