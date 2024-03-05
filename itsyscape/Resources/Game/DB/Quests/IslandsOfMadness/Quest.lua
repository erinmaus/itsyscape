--------------------------------------------------------------------------------
-- Resources/Game/DB/Quest/IslandsOfMadness/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Meta.ResourceName {
	Value = "Islands of Madness",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "PreTutorial"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can you survive a chance encounter with Cthulhu?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "PreTutorial"
}

local Quest = ItsyScape.Utility.Quest
local Step = ItsyScape.Utility.QuestStep

Quest "PreTutorial" {
	Step "PreTutorial_Start",
	Step "PreTutorial_CthulhuRises",
	Step "PreTutorial_DefendShip",
	Step "PreTutorial_ArriveAtTheWhalingTemple",

	Step "PreTutorial_FoundTrees",
	Step "PreTutorial_ChoppedTree",
	Step "PreTutorial_CraftedWeapon",

	Step "PreTutorial_FoundFish",
	Step "PreTutorial_KilledMaggot",
	Step "PreTutorial_Fished",
	Step "PreTutorial_CookedFish",

	Step "PreTutorial_ExploreDungeon",
	Step "PreTutorial_FoundYenderling",
	Step "PreTutorial_SlayedYenderling",

	Step "PreTutorial_Teleported"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sleep at the makeshift bed near the bridge before the trapdoor entrance.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_SleptAtBed"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Learn about stances from Rosalind.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_LearnedAboutStances"
}

local Description = ItsyScape.Utility.QuestStepDescription

Description "PreTutorial_Start" {
	before = "Help Jenkins deal with Cap'n Raven.",
	after = "Cap'n Raven wants the loot on Jenkin's ship."
}

Description "PreTutorial_CthulhuRises" {
	before = "Get some cannonballs and fire the cannons at Cap'n Raven's ship, the Dead Princess!",
	after = "After defending you and the crew for Cap'n Raven, both Cap'n Raven's ship, the Dead Princess, and Jenkin's ship, the Soaked Log, were pulled into the current of a whirlpool that Cthulhu rose out of!"
}

Description "PreTutorial_DefendShip" {
	before = "Plug the leaks as they pop up and help Rosalind attack the undead squids with the cannons!",
	after = "Thanks to you and Rosalind, the crew survived the encounter with Cthulhu and the squids. But the ship was still badly damaged..."
}

Description "PreTutorial_ArriveAtTheWhalingTemple" {
	before = "Jenkins plotted a course for the abandoned Yendorian outpost, the Whaling Temple.",
	after = "Jenkins and the crew, including you, arrived safely at the abandoned Yendorian outpost, the Whaling Temple."
}

Description "PreTutorial_FoundTrees" {
	before = "Jenkins asked if you could get some wood to repair the ship. Find some suitable trees.",
	after = "While exploring the island, you and Rosalind discover some shadow fir trees."
}

Description "PreTutorial_ChoppedTree" {
	before = "Rosalind gave you an axe to chop the trees.",
	after = "After chopping a tree, you got some wood to repair Jenkin's ship."
}

Description "PreTutorial_CraftedWeapon" {
	before = "Looks like you can craft some weapons from the wood.",
	after = "You crafted some shadow logs into a weapon."
}

Description "PreTutorial_FoundFish" {
	before = "The crew needs some food. Find some fish on the island.",
	after = "There are some sardines conviently surrounded by giant maggots."
}

Description "PreTutorial_KilledMaggot" {
	before = "Slay a giant maggot to use it as bait.",
	after = "You slayed a giant maggot and gathered some bait."
}

Description "PreTutorial_Fished" {
	before = "Using the fishing rod Rosalind gave you, fish up some sardines.",
	after = "After coming across some sardines, you fished them up. Now they need to be cooked!"
}

Description "PreTutorial_CookedFish" {
	before = "The sardines need to be cooked.",
	after = "You cooked the sardines."
}

Description "PreTutorial_ExploreDungeon" {
	before = "Looks like there's a trapdoor north of the bridge, better investigate!",
	after = "You entered the trapdoor north of the bridge and discovered a cave under the island."
}

Description "PreTutorial_FoundYenderling" {
	before = "Explore the cave.",
	after = "Under the Whaling Temple, you and Rosalind discovered a yenderling."
}

Description "PreTutorial_SlayedYenderling" {
	before = "Slay the yenderling.",
	after = "The yenderlign was tanky, but after Rosalind taught you the importance of stances you were able to take it down."
}
