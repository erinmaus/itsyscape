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
	Step "PreTutorial_ArrivedAtIsland",
	Step "PreTutorial_Teleported"
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

Description "PreTutorial_ArrivedAtIsland" {
	before = "Plug the leaks as they pop up and help Rosalind attack the undead squids with the cannons!",
	after = "Thanks to you and Rosalind, the crew arrived at a mysterous Yendorian island. But the ship was still badly damaged..."
}
