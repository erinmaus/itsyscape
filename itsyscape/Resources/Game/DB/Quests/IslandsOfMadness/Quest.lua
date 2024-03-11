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
local Branch = ItsyScape.Utility.QuestBranch

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

	Step "PreTutorial_CollectedAzatiteShards",
	Step "PreTutorial_MinedCopper",
	Step "PreTutorial_SmeltedWeirdBars",

	Step {
		"PreTutorial_SmithedUpAndComingHeroItem",
		"PreTutorial_SmithedUpAndComingHeroHelmet",
		"PreTutorial_SmithedUpAndComingHeroGloves",
		"PreTutorial_SmithedUpAndComingHeroPlatebody",
		"PreTutorial_SmithedUpAndComingHeroBoots"
	},
	Step "PreTutorial_SmithedUpAndComingHeroArmor",

	Step "PreTutorial_FoundInjuredYendorian",
	Branch {
		{
			Step "PreTutorial_InsultedYendorian",
			Step "PreTutorial_DefeatedInjuredYendorian",
			Step "PreTutorial_InformedJenkins",
			Branch {
				{
					Step "PreTutorial_TurnedInSupplies",
					Step "PreTutorial_Teleported"
				},
				{
					Step "PreTutorial_DidNotTurnInSupplies",
					Step "PreTutorial_Teleported"
				}
			}
		},
		{
			Step "PreTutorial_ReasonedWithYendorian",
			Step "PreTutorial_DefeatedInjuredYendorian",
			Step "PreTutorial_InformedJenkins",
			Branch {
				{
					Step "PreTutorial_TurnedInSupplies",
					Step "PreTutorial_Teleported"
				},
				{
					Step "PreTutorial_DidNotTurnInSupplies",
					Step "PreTutorial_Teleported"
				}
			}
		},
		{
			Step "PreTutorial_DidACowardlyThing",
			Step "PreTutorial_DefeatedInjuredYendorian",
			Step "PreTutorial_InformedJenkins",
			Branch {
				{
					Step "PreTutorial_TurnedInSupplies",
					Step "PreTutorial_Teleported"
				},
				{
					Step "PreTutorial_DidNotTurnInSupplies",
					Step "PreTutorial_Teleported"
				}
			}
		}
	},

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

ItsyScape.Meta.ResourceDescription {
	Value = "Talk about the mine under the Whaling Temple.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedAboutMine"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Told to get more azatite shards from the yenderling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_GetMoreAzatiteShards"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Talked about the weather.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_TalkedAboutWeather"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Told about how to prevent the Yendorian special attack.",
	Language = "en-US",
	Resource = ItsyScape.Resource.KeyItem "PreTutorial_PreventYendorianSpecialAttack"
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
	after = "The yenderling was tanky, but after Rosalind taught you the importance of stances you were able to take it down."
}

Description "PreTutorial_CollectedAzatiteShards" {
	before = "Collect the azatite shards dropped by the yenderling.",
	after = "The yenderling dropped a few azatite shards. You picked them up."
}

Description "PreTutorial_MinedCopper" {
	before = "Rosalind suggested you make some armor for what lay ahead. You'll need to mine some copper using the pickaxe Rosalind gave you.",
	after = "Taking Rosalind's suggestion to make some armor for what lay ahead, you mined some copper using the pickaxe Rosalind gave you."
}

Description "PreTutorial_SmeltedWeirdBars" {
	before = "Rosalind told you about a weird alloy you can make using azatite shards and copper. Smelt some weird alloy bars at the furnace to make the bars.",
	after = "Taking Rosalind's suggestion to make some armor for what lay ahead, you mined some copper."
}

Description "PreTutorial_SmithedUpAndComingHeroItem" {
	before = "With the weird alloy bars, smith the up-and-coming armor at the anvil.",
	after = "You started smithing the up-and-coming armor at the anvil."
}

Description "PreTutorial_SmithedUpAndComingHeroHelmet" {
	before = "Smith a helmet from the weird alloy.",
	after = "You smithed a helmet from the weird alloy."
}

Description "PreTutorial_SmithedUpAndComingHeroGloves" {
	before = "Smith gloves from the weird alloy.",
	after = "You smithed gloves from the weird alloy."
}

Description "PreTutorial_SmithedUpAndComingHeroPlatebody" {
	before = "Smith a platebody from the weird alloy.",
	after = "You smithed a platebody from the weird alloy."
}

Description "PreTutorial_SmithedUpAndComingHeroBoots" {
	before = "Smith boots from the weird alloy.",
	after = "You smithed boots from the weird alloy."
}

Description "PreTutorial_SmithedUpAndComingHeroArmor" {
	before = "You need to smith a complete set of up-and-coming hero armor.",
	after = "You smithed a complete set of up-and-coming hero armor."
}

Description "PreTutorial_FoundInjuredYendorian" {
	before = "There's a little bit of the cave left to explore.",
	after = "After exploring the cave and surfacing, you and Rosalind discovered an injured Yendorian soldier. It asked what you're doing on Yendor's holy island."
}

Description "PreTutorial_InsultedYendorian" {
	before = "Will you insult the Yendorian?",
	after = "For some reason, you decided to insult the Yendorian. Rosalind was not happy, and the Yendorian was enraged."
}

Description "PreTutorial_ReasonedWithYendorian" {
	before = "Will you reason with the Yendorian?",
	after = "You and Rosalind tried to reason with the Yendorian but failed."
}

Description "PreTutorial_DidACowardlyThing" {
	before = "Will you flee from the Yendorian?",
	after = "You could not flee from the Yendorian and Rosalind did not like your display of cowardice."
}

Description "PreTutorial_DefeatedInjuredYendorian" {
	before = "The injured Yendorian soldier was aggressive! Fight back!",
	after = "You and Rosalind defeated the Yendorian soldier together. Good job!"
}

Description "PreTutorial_InformedJenkins" {
	before = "Give Jenkins a status update.",
	after = "You and Rosalind gave Jenkins a status update about the Yendorian and portal."
}

Description "PreTutorial_DidNotTurnInSupplies" {
	before = "Don't turn in any supplies.",
	after = "Rosalind had gathered some supplies when you rested and turned them in to Jenkins."
}

Description "PreTutorial_TurnedInSupplies" {
	before = "Turn in some supplies.",
	after = "Jenkins took some logs and fish off your hands."
}

Description "PreTutorial_Teleported" {
	before = "Go back to the portal and teleport to Isabelle Island.",
	after = "You went through the portal to Isabelle Island. Quest complete!"
}
