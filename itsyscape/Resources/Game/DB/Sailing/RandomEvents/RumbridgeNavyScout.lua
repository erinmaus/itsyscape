--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/RandomEvents/RumbridgeNavyScout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Ship = ItsyScape.Resource.SailingShip "RandomEvent_RumbridgeNavyScout"

	ItsyScape.Meta.ShipSailingItem {
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy"
	}

	ItsyScape.Meta.ShipSailingItem {
		Red1 = 130,
		Green1 = 200,
		Blue1 = 220,
		Red2 = 130,
		Green2 = 200,
		Blue2 = 220,
		IsColorCustomized = 1,
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Hull_Common"
	}

	ItsyScape.Meta.ShipSailingItem {
		Red1 = 240,
		Green1 = 240,
		Blue1 = 200,
		IsColorCustomized = 1,
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Rigging_Common"
	}

	ItsyScape.Meta.ShipSailingItem {
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Helm_Common"
	}

	ItsyScape.Meta.ShipSailingItem {
		Red1 = 130,
		Green1 = 200,
		Blue1 = 220,
		IsColorCustomized = 1,
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Figurehead_Common"
	}

	ItsyScape.Meta.ShipSailingItem {
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Storage_CrudeChest"
	}

	ItsyScape.Meta.ShipSailingItem {
		Ship = Ship,
		SailingItem = ItsyScape.Resource.SailingItem "Cannon_Iron"
	}
end