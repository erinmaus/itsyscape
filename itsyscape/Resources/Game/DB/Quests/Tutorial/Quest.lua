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

Description "Tutorial_Finished" {
	before = "Watch out for Cthulhu's Infinite Soul Siphon!",
	after = {
		"Cthulhu unleashed the Infinite Soul Siphon incantation, destroying all your equipment and draining your skills.",
		"Rosalind banished Cthulhu moments before Cthulhu finished the Soul Siphon, saving you.",
		"Quest complete!"
	}
}
