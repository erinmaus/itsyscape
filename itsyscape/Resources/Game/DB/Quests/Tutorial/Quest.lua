--------------------------------------------------------------------------------
-- Resources/Game/DB/Quests/Tutorial/Quest.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Meta.ResourceName {
	Value = "The Ultimate Weapon",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "Tutorial"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Can you create a prototype god slaying weapon?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Quest "Tutorial"
}

local Quest = ItsyScape.Utility.Quest
local Step = ItsyScape.Utility.QuestStep
local Branch = ItsyScape.Utility.QuestBranch

Quest "Tutorial" {
	Step "Tutorial_Start",
	Step "Tutorial_GatheredItems",
	Step "Tutorial_EquippedItems",
	Step "Tutorial_FoundScout",
	Step "Tutorial_DefeatedScout",
	Step "Tutorial_FoundYenderhounds",
	Step "Tutorial_DefeatedYenderhounds",
	Step "Tutorial_FishedLightningStormfish",
	Step "Tutorial_CookedLightningStormfish",
	Step "Tutorial_FoundPeak",
	Step "Tutorial_FoundYendorians",
	Step "Tutorial_DefeatedKeelhauler",
	Step "Tutorial_Finished"
}

local Description = ItsyScape.Utility.QuestStepDescription

Description "Tutorial_Start" {
	before = "Talk to Orlando at Humanity's Edge to begin this quest.",
	after = "After being hit by a fluke lightning strike, Orlando wakes you back up."
}

Description "Tutorial_GatheredItems" {
	before = "The shock of the lightning strike knocked all your items from your inventory. Go pick them up!",
	after = "Orlando helped you pick up all the items you dropped after the lightning strike."
}

Description "Tutorial_EquippedItems" {
	before = "Some of the dropped items were equipment. You should probably gear back up!",
	after = "Some of the dropped items were equipment, so you equipped them to gear back up for the fights ahead."
}

Description "Tutorial_FoundScout" {
	before = "Go forth and explore.",
	after = "After exploring the island, you and Orlando discovered a Yendorian scout."
}

Description "Tutorial_DefeatedScout" {
	before = "Defeat the Yendorian scout before it alerts the others!",
	after = "Oh no! Despite defeating the Yendorian scout, in his last moments, he sent up a flare, alerting the Yendorian party further ahead."
}

Description "Tutorial_FoundYenderhounds" {
	before = "Push ahead to the peak of the island and scout out the enemy's numbers.",
	after = "A pack of Yenderhounds ambushed your party while heading to the island's peak."
}

Description "Tutorial_DefeatedYenderhounds" {
	before = "Defeat the Yenderhounds!",
	after = "With pretty significant damage, your party defeated the ferocious Yenderhounds."
}

Description "Tutorial_FishedLightningStormfish" {
	before = "The Yenderhounds wiped a portion of your party's food supplies, so you need to fish up some more.",
	after = "To replenish your party's food supplies, you fished up five lightning stormfish. Now to cook 'em!"
}

Description "Tutorial_CookedLightningStormfish" {
	before = "The lightning stormfish need to be cooked on the campfire Ser Orlando started.",
	after = "You cooked the lightning stormfish on the campfire Ser Orlando started."
}

Description "Tutorial_FoundPeak" {
	before = "You're close to the island's peak! Push ahead and discover the Yendorians number.",
	after = "You reached the peak of the island after a dangerous journey."
}

Description "Tutorial_FoundYendorians" {
	before = "You reached the island's peak! Ascend and discover the Yendorians number.",
	after = "Reaching the peak of the island, you discover the Yendorians and the Black Tentacles fighting! A quick cannon shot knocked you and Ser Orlando down into the fray."
}

Description "Tutorial_DefeatedKeelhauler" {
	before = "Defeat the Black Tentacles!",
	after = "The Black Tentacles unleashed the Keelhauler as a last resort, but you and Ser Orlando bested the ancient golem."
}

Description "Tutorial_Finished" {
	before = "Watch out for Cthulhu's Infinite Soul Siphon!",
	after = {
		"Cthulhu unleashed the Infinite Soul Siphon incantation, destroying all your equipment and draining your skills.",
		"Rosalind banished Cthulhu moments before Cthulhu finished the Soul Siphon, saving you.",
		"Quest complete!"
	}
}
