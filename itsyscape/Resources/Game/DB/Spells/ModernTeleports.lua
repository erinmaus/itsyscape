--------------------------------------------------------------------------------
-- Resources/Game/DB/Spells/ModernMisc.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Meta.ResourceName {
		Value = "Tower Teleport",
		Language = "en-US",
		Resource = ItsyScape.Resource.Spell "TowerTeleport"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Teleports to the top of Isabelle Island's tower.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Spell "TowerTeleport"
	}

	local CastAction = ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Quest "PreTutorial",
			Count = 1
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_StartGame",
		Map = ItsyScape.Resource.Map "IsabelleIsland_Tower_Floor5",
		Action = CastAction
	}

	ItsyScape.Resource.Spell "TowerTeleport" {
		CastAction
	}
end

do
	ItsyScape.Meta.ResourceName {
		Value = "Vizier's Rock Teleport",
		Language = "en-US",
		Resource = ItsyScape.Resource.Spell "ViziersRockTeleport"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Teleports to the city center of Vizier's Rock.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Spell "ViziersRockTeleport"
	}

	local CastAction = ItsyScape.Action.Cast() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Quest "PreTutorial",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "AirRune",
			Count = 10
		},

		Input {
			Resource = ItsyScape.Resource.Item "FireRune",
			Count = 5
		}
	}

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_Teleport",
		Map = ItsyScape.Resource.Map "ViziersRock_Town_Center",
		Action = CastAction
	}

	ItsyScape.Resource.Spell "ViziersRockTeleport" {
		CastAction
	}
end
