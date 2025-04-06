--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/Dummy.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Character = ItsyScape.Resource.Character "Dummy"

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Dummy",
	Resource = Character
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "It just has got a head full of hay.",
	Resource = Character
}

ItsyScape.Meta.CharacterTeam {
	Character = Character,
	Team = ItsyScape.Resource.Team "Dummy"
}
