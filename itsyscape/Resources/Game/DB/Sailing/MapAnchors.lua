--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/MapAnchors.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local MapAnchorProp = ItsyScape.Resource.Prop "Sailing_MapAnchor_Default"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingMapAnchor",
		Resource = MapAnchorProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Anchor",
		Language = "en-US",
		Resource = MapAnchorProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A location you can sail to.",
		Language = "en-US",
		Resource = MapAnchorProp
	}

	MapAnchorProp {
		ItsyScape.Action.Sail()
	}
end

local CHART_MAIN = ItsyScape.Resource.SailingSeaChart "Main"
do
	ItsyScape.Meta.ResourceName {
		Value = "Common Sea Chart",
		Language = "en-US",
		Resource = CHART_MAIN
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A common sea chart of the known world.",
		Language = "en-US",
		Resource = CHART_MAIN
	}
end

do
	ItsyScape.Meta.SailingMapLocation {
		AnchorI = 41,
		AnchorJ = 40,
		IsPort = 1,
		Map = ItsyScape.Resource.Map "Rumbridge_Port",
		SeaChart = CHART_MAIN,
		Resource = ItsyScape.Resource.SailingMapAnchor "Rumbridge_Port"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Port",
		Language = "en-US",
		IsPort = 1,
		Resource = ItsyScape.Resource.SailingMapAnchor "Rumbridge_Port"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Home to the worst drunkards in the Realm.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "Rumbridge_Port"
	}
end

do
	ItsyScape.Meta.SailingMapLocation {
		AnchorI = 28,
		AnchorJ = 48,
		RealityWarpDistanceMultiplier = -0.9,
		IsPort = 1,
		Map = ItsyScape.Resource.Map "IsabelleIsland_Port",
		SeaChart = CHART_MAIN,
		Resource = ItsyScape.Resource.SailingMapAnchor "IsabelleIsland_Port"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle Island Port",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "IsabelleIsland_Port"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Home to the two-faced merchant, Isabelle.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "IsabelleIsland_Port"
	}
end

do
	ItsyScape.Meta.SailingMapLocation {
		AnchorI = 46,
		AnchorJ = 48,
		Map = ItsyScape.Resource.Map "Sailing_MermanFortress",
		SeaChart = CHART_MAIN,
		Resource = ItsyScape.Resource.SailingMapAnchor "MermanFortress"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Merman Fortress",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "MermanFortress"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "When the sun sets at the Merman Fortress, all hope seems lost.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "MermanFortress"
	}
end

do
	ItsyScape.Meta.SailingMapLocation {
		AnchorI = 48,
		AnchorJ = 56,
		Map = ItsyScape.Resource.Map "Sailing_BlackmeltLagoon",
		SeaChart = CHART_MAIN,
		Resource = ItsyScape.Resource.SailingMapAnchor "BlackmeltLagoon"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Blackmelt Lagoon",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "BlackmeltLagoon"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A lagoon with plenty of fishing opportunities...",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "BlackmeltLagoon"
	}
end

do
	ItsyScape.Meta.SailingMapLocation {
		AnchorI = 40,
		AnchorJ = 46,
		Map = ItsyScape.Resource.Map "Sailing_MheesaIsland",
		SeaChart = CHART_MAIN,
		Resource = ItsyScape.Resource.SailingMapAnchor "MheesaIsland"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Mheesa Island",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "MheesaIsland"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Home to a bumbling Idiot King of a rather small kingdom.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "MheesaIsland"
	}
end

do
	ItsyScape.Meta.SailingMapLocation {
		AnchorI = 37,
		AnchorJ = 53,
		RealityWarpDistanceMultiplier = 1.1,
		Map = ItsyScape.Resource.Map "Sailing_RuinsOfRhysilk",
		SeaChart = CHART_MAIN,
		Resource = ItsyScape.Resource.SailingMapAnchor "RuinsOfRhysilk"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ruins of Rh'ysilk",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "RuinsOfRhysilk"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Legends have it, Yendor was slain underneath the island prior to the terrible ritual that banished the gods from the Realm.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingMapAnchor "RuinsOfRhysilk"
	}
end
