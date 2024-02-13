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
	Step "PreTutorial_CapnRavenHitJenkins",
	Step "PreTutorial_Teleported"
}

local Description = ItsyScape.Utility.QuestStepDescription
