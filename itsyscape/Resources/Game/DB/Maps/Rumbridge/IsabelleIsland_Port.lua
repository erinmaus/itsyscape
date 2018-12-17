--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Rumbridge/IsabelleIsland_Port.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local TalkAction = ItsyScape.Action.Talk()
	local SailAction = ItsyScape.Action.Travel()

	ItsyScape.Meta.TravelDestination {
		Anchor = "Anchor_Spawn",
		Map = ItsyScape.Resource.Map "Ship_IsabelleIsland_PortmasterJenkins",
		Arguments = "map=IsabelleIsland_Ocean",
		Action = SailAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Sail",
		Language = "en-US",
		Action = SailAction
	}

	ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins" {
		TalkAction,
		SailAction
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.PortmasterJenkins.PortmasterJenkins",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.ResourceName {
		Language = "en-US",
		Value = "Portmaster Jenkins",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.ResourceDescription {
		Language = "en-US",
		Value = "Ex-ex-ex-pirate now on the good side of the law, again...",
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "SailorsHat",
		Count = 1,
		Resource = ItsyScape.Resource.Peep "IsabelleIsland_Port_PortmasterJenkins"
	}
end
