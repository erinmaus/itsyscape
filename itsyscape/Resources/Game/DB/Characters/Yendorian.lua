--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/Yendorian.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Character = ItsyScape.Resource.Character "Yendorian"

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Yendorian",
	Resource = Character
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A race of sea-slug monsters descended from Yendor's shadow, known as her First Children. They are neither living nor dead. They hate life and wish to subjugate mortals.",
	Resource = Character
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Yendorian"
}
