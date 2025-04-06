--------------------------------------------------------------------------------
-- Resources/Game/DB/Characters/VizierRockKnight.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
do
	local Character = ItsyScape.Resource.Character "VizierRockKnight"

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Vizier's Rock knights",
		Resource = Character
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Ferocious knights in service to Vizier-King Yohn. They will give their lives for the Vizier-King without hesitation.",
		Resource = Character
	}

	ItsyScape.Meta.CharacterTeam {
		Character = Character,
		Team = ItsyScape.Resource.Team "Humanity"
	}
end
