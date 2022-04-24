--------------------------------------------------------------------------------
-- Resources/Game/DB/SharedDropTables/Pirate.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local PrimaryDropTable = ItsyScape.Resource.DropTable "Pirate_Primary"
	local SecondaryDropTable = ItsyScape.Resource.DropTable "Pirate_Secondary"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Coins",
		Weight = 400,
		Count = 1000,
		Range = 500,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "BlackFlint",
		Weight = 100,
		Count = 2,
		Range = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Gunpowder",
		Weight = 100,
		Count = 5,
		Range = 4,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Dynamite",
		Weight = 50,
		Count = 6,
		Range = 4,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Sapphire",
		Weight = 25,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Emerald",
		Weight = 10,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Key_BlackmeltLagoon1",
		Weight = 5,
		Count = 1,
		Resource = PrimaryDropTable
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "Bones",
		Weight = 1,
		Count = 1,
		Resource = SecondaryDropTable
	}

	local Tier10Tertiary = ItsyScape.Resource.DropTable "Pirate_Tertiary_Tier10"

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronBar",
		Weight = 400,
		Count = 2,
		Range = 1,
		Noted = 1,
		Resource = Tier10Tertiary
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronDagger",
		Weight = 400,
		Count = 1,
		Resource = Tier10Tertiary
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronCannonball",
		Weight = 400,
		Count = 5,
		Range = 3,
		Resource = Tier10Tertiary
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronGrenade",
		Weight = 25,
		Count = 2,
		Range = 1,
		Resource = Tier10Tertiary
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronPistol",
		Weight = 100,
		Count = 1,
		Resource = Tier10Tertiary
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronBlunderbuss",
		Weight = 50,
		Count = 1,
		Resource = Tier10Tertiary
	}

	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "IronMusket",
		Weight = 50,
		Count = 1,
		Resource = Tier10Tertiary
	}
end
