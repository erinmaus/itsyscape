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
	Value = "Can you put a couple of ghost children to rest?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "PreTutorial"
}

ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"
ItsyScape.Resource.KeyItem "PreTutorial_SearchedCrate"

ItsyScape.Utility.questStep(
	"PreTutorial_Start",
	"PreTutorial_TalkedToButler1"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToButler1",
	"PreTutorial_ReadPowernomicon"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToButler1",
	"PreTutorial_SearchedCrate"
)

ItsyScape.Utility.questStep(
	{
		"PreTutorial_ReadPowernomicon",
		"PreTutorial_SearchedCrate"
	},
	"PreTutorial_LearnedToMakeGhostspeakAmulet"
)

ItsyScape.Utility.questStep(
	"PreTutorial_LearnedToMakeGhostspeakAmulet",
	"PreTutorial_MineCopper"
)

ItsyScape.Utility.questStep(
	"PreTutorial_LearnedToMakeGhostspeakAmulet",
	"PreTutorial_SmeltCopperBar"
)

ItsyScape.Utility.questStep(
	"PreTutorial_LearnedToMakeGhostspeakAmulet",
	"PreTutorial_SmithCopperAmulet"
)

ItsyScape.Utility.questStep(
	"PreTutorial_LearnedToMakeGhostspeakAmulet",
	"PreTutorial_EnchantedCopperAmulet"
)

ItsyScape.Utility.questStep(
	{
		"PreTutorial_MineCopper",
		"PreTutorial_SmeltCopperBar",
		"PreTutorial_SmithCopperAmulet",
		"PreTutorial_EnchantedCopperAmulet"
	},
	"PreTutorial_MadeGhostspeakAmulet"
)

ItsyScape.Utility.questStep(
	"PreTutorial_MadeGhostspeakAmulet",
	"PreTutorial_TalkedToGhostGirl"
)

ItsyScape.Utility.questStep(
	"PreTutorial_MadeGhostspeakAmulet",
	"PreTutorial_TalkedToGhostBoy"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToGhostGirl",
	"PreTutorial_SavedGhostGirl"
)

ItsyScape.Utility.questStep(
	"PreTutorial_TalkedToGhostBoy",
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
	Value = "You need to search the crate.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SearchedCrate"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You searched the crate and found a bunch of useful tools.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SearchedCrate"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to read the Powernomicon.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You read the Powernomicon and learned how to make a ghostpeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"
}

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
	Value = "You need to learn how to make the ghost speak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_LearnedToMakeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You learned how to make the ghost speak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_LearnedToMakeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to mine some copper from the basement using the pickaxe you obtained in the storage shed.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MineCopper"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You mined some copper in the basement.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MineCopper"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to smelt a copper bar using the furnace in the shed, near the courtyard.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmeltCopperBar"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You smelted a copper bar.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmeltCopperBar"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to smith a copper amulet on the anvil in the shed using the hammer you obtained.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmithCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to smithed a copper amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmithCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to enchant the copper amulet using the Enchant spell. Runes for this spell can be obtained from the Powernomicon.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_EnchantedCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You enchanted the copper amulet to make a ghostspeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_EnchantedCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to make the ghostpeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MadeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You made the ghostspeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MadeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Elizabeth, the ghost girl, using the ghostspeak amulet to find out what's wrong.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You spoke to Elizabeth, the ghost girl, using the ghostspeak amulet and found out she needs something dramatic to eat. What about cooking a goldfish?",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You need to talk to Edward, the ghost boy, using the ghostspeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Edward, the ghost boy, using the ghostspeak amulet and found out he's scared of the monster under the bed. It only appears if you have a toy weapon, like those made from wood.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostBoy"
}

-- next

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
	Value = "You need to let Hans teleport you to Isabelle Island.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_WokeUp"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You started Restless Ghosts.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Hans, the Zombi butler. Turns out two sick children once in his care refuse to pass on. You need to find a way to talk to ghosts.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler1"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You saved the ghost girl by giving her the goldfish, Larry, to eat. How morbid!",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You saved the ghost boy by defeating the monster under the bed.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to the Butler and found out he's in service to The Empty King.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler2"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hans teleported you to Isabelle Island. Quest complete!",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_WokeUp"
}
