--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/BlackTentacles.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
do
	local Character = ItsyScape.Resource.Character "CapnRaven"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Cap'n Raven",
		Resource = Character
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "In the running to become one of the most famous pirates of all time.",
		Resource = Character
	}

	ItsyScape.Meta.CharacterTeam {
		Character = Character,
		Team = ItsyScape.Resource.Team "Humanity"
	}

	ItsyScape.Meta.CharacterTeam {
		Character = Character,
		Team = ItsyScape.Resource.Team "BlackTentacles"
	}
end

do
	local Character = ItsyScape.Resource.Character "BlackTentaclesPirate"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Black Tentacles pirate",
		Resource = Character
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Cap'n Raven's crew is chosen from the best pirates.",
		Resource = Character
	}

	ItsyScape.Meta.CharacterTeam {
		Character = Character,
		Team = ItsyScape.Resource.Team "Humanity"
	}

	ItsyScape.Meta.CharacterTeam {
		Character = Character,
		Team = ItsyScape.Resource.Team "BlackTentacles"
	}
end
