--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_FarOcean.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Pirate.BasePirate",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Pirate",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Arrrrgh, matey.",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "PiratesHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Constitution",
		Value = ItsyScape.Utility.xpForLevel(5),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Value = ItsyScape.Utility.xpForLevel(10),
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_FarOcean_Pirate"
	}
end
