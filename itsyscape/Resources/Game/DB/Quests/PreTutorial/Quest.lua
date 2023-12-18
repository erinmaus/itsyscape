--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/CalmBeforeTheStorm/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

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
ItsyScape.Resource.KeyItem "PreTutorial_CraftedToyWeapon"

local Quest = ItsyScape.Utility.Quest
local Step = ItsyScape.Utility.QuestStep

Quest "PreTutorial" {
	Step "PreTutorial_Start",
	Step "PreTutorial_TalkedToButler1",
	Step {
		"PreTutorial_ReadPowernomicon",
		"PreTutorial_SearchedCrate"
	},
	Step "PreTutorial_LearnedToMakeGhostspeakAmulet",
	Step "PreTutorial_MineCopper",
	Step "PreTutorial_SmeltCopperBar",
	Step "PreTutorial_SmithCopperAmulet",
	Step "PreTutorial_EnchantedCopperAmulet",
	Step "PreTutorial_MadeGhostspeakAmulet",
	Step {
		"PreTutorial_TalkedToGhostBoy",
		"PreTutorial_TalkedToGhostGirl",
	},
	Step {
		"PreTutorial_GotShadowLogs",
		"PreTutorial_CraftedToyWeapon",
		"PreTutorial_SavedGhostBoy",
		"PreTutorial_FishedLarry",
		"PreTutorial_CookedLarry",
		"PreTutorial_SavedGhostGirl",
	},
	Step "PreTutorial_TalkedToButler2",
	Step "PreTutorial_WokeUp",
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hans advised to look in the shed for tools.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SearchedCrate"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You searched the crate and found a bunch of useful tools.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SearchedCrate"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "There might be information about speaking to ghosts in the Powernomicon, located upstairs.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You read the Powernomicon and learned how to make a ghostpeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_ReadPowernomicon"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "To start Restless Ghosts, find Hans in the haunted mansion located somewhere in Azathoth.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_Start"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hans, the Zombi butler, might know what's wrong.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler1"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Learning how to make a ghostspeak amulet may help.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_LearnedToMakeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You learned how to make the ghost speak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_LearnedToMakeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Mine some copper from the basement using the pickaxe you obtained in the storage shed.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MineCopper"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You mined some copper in the basement.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MineCopper"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Smelt a copper bar using the furnace in the shed, near the courtyard.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmeltCopperBar"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You smelted a copper bar.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmeltCopperBar"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Smith a copper bar on the anvil in the shed using the hammer you obtained to make a copper amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmithCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You smithed a copper amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SmithCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Enchant the copper amulet using the Enchant spell. Maybe Hans knows more?",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_EnchantedCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You enchanted the copper amulet to make a ghostspeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_EnchantedCopperAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You haven't made the ghost speak amulet yet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MadeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You made the ghostspeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_MadeGhostspeakAmulet"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Talk to Elizabeth, the ghost girl, using the ghostspeak amulet to find out what's wrong.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You spoke to Elizabeth, the ghost girl, using the ghostspeak amulet and found out she needs something macabre to eat. What about cooking a goldfish?",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Talk to Edward, the ghost boy, using the ghostspeak amulet.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You talked to Edward, the ghost boy, using the ghostspeak amulet and found out he's scared of the monster under the bed. It only appears if you have a toy weapon, like those made from wood.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Save Elizabeth by feeding her something macabre.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Save Edward by defeating the monster under the bed.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostBoy"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Talk to the Butler to find out what's next.",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedToButler2"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "Hans will teleport you to Isabelle Island.",
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
	Value = "You saved Elizabeth by giving her the goldfish, Larry, to eat. How morbid!",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SavedGhostGirl"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "You saved the Edward by defeating the monster (ew, it was a maggot!) under the bed.",
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

local Description = ItsyScape.Utility.QuestStepDescription

Description "PreTutorial_GotShadowLogs" {
	before = "Cut down a tree for some logs so you can craft a toy weapon.",
	after = "You obtained some shadow logs from a tree."
}

Description "PreTutorial_CraftedToyWeapon" {
	before = "Craft some shadow logs into a toy weapon using your knife.",
	after = "Using some shadow logs and a knife, you crafted a toy weapon."
}

Description "PreTutorial_FishedLarry" {
	before = "Fish Larry, the pet goldfish, from the courtyard pond.",
	after = "Larry was fished from the pond. And remember, fish can't breathe outside of water..."
}

Description "PreTutorial_CookedLarry" {
	before = "Cook Larry on the cooking range in the kitchen.",
	after = "Poor Larry was cooked. Hope this is macabre enough for Elizabeth..."
}
