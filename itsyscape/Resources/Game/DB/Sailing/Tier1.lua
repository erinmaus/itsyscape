--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Tier1.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.SailingItem "Ship" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 0
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 100000
			},

			Input {
				Resource = ItsyScape.Resource.Item "CommonLogs",
				Count = 100
			},

			Input {
				Resource = ItsyScape.Resource.Item "CottonCloth",
				Count = 100
			},

			Input {
				Resource = ItsyScape.Resource.Item "IronBar",
				Count = 50
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Ship",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Hull_Common",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Rigging_Common",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Sail_Common",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Helm_Common",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Figurehead_Common",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Storage_Crate",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Cannon_Iron",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Ship",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Ship",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lets you sail the Five Seas.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Ship",
	}
end

do
	ItsyScape.Resource.SailingItem "Hull_Common" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Hull_Common",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Hull_Common",
		CanCustomizeColor = 1,
		ItemGroup = "Hull",
		Resource = ItsyScape.Resource.SailingItem "Hull_Common"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 1000,
		Distance = 800,
		Defense = 100,
		Speed = 50,
		Resource = ItsyScape.Resource.SailingItem "Hull_Common"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Common hull",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Hull_Common",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A hull made from the most common tree in the Realm.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Hull_Common",
	}
end

do
	ItsyScape.Resource.SailingItem "Hull_Coconut" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(15)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 50000
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoconutLogs",
				Count = 50
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coconut",
				Count = 50
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Hull_Coconut",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		CanCustomizeColor = 1,
		ItemGroup = "Hull",
		Resource = ItsyScape.Resource.SailingItem "Hull_Coconut"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 600,
		Distance = 600,
		Defense = 50,
		Speed = 400,
		Resource = ItsyScape.Resource.SailingItem "Hull_Coconut"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coconut hull",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Hull_Coconut",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A lightweight hull made from coconut logs.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Hull_Coconut",
	}
end

do
	ItsyScape.Resource.SailingItem "Rigging_Common" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Rigging_Common",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Rigging_Common",
		CanCustomizeColor = 1,
		ItemGroup = "Rigging",
		Resource = ItsyScape.Resource.SailingItem "Rigging_Common"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 100,
		Distance = 0,
		Defense = 50,
		Speed = 50,
		Resource = ItsyScape.Resource.SailingItem "Rigging_Common"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Common rigging",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Rigging_Common",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Basic rigging to help you adjust the sails.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Rigging_Common",
	}
end

do
	ItsyScape.Resource.SailingItem "Sail_Common" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Sail_Common",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_CommonSail",
		CanCustomizeColor = 1,
		ItemGroup = "Sail",
		Resource = ItsyScape.Resource.SailingItem "Sail_Common"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 100,
		Defense = 0,
		Speed = 100,
		Resource = ItsyScape.Resource.SailingItem "Sail_Common"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Three-striped sail",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Sail_Common",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Only just seaworthy.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Sail_Common",
	}
end

do
	ItsyScape.Resource.SailingItem "Helm_Common" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Helm_Common",
				Count = 1
			}
		}
	}
	
	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_CommonHelm",
		CanCustomizeColor = 0,
		ItemGroup = "Helm",
		Resource = ItsyScape.Resource.SailingItem "Helm_Common"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 50,
		Defense = 0,
		Speed = 50,
		Resource = ItsyScape.Resource.SailingItem "Helm_Common"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Common helm",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Helm_Common",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Hard to move.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Helm_Common",
	}
end

do
	ItsyScape.Resource.SailingItem "Cannon_Iron" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Cannon_Iron",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_IronCannon",
		CanCustomizeColor = 0,
		ItemGroup = "Cannon",
		Resource = ItsyScape.Resource.SailingItem "Cannon_Iron"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 0,
		Defense = 0,
		Speed = 0,
		Resource = ItsyScape.Resource.SailingItem "Cannon_Iron"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Iron cannon",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Cannon_Iron",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The weakest cannon possible.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Cannon_Iron",
	}
end

do
	ItsyScape.Resource.SailingItem "Figurehead_Common" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Figurehead_Common",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_CommonFigurehead",
		CanCustomizeColor = 1,
		ItemGroup = "Figurehead",
		Resource = ItsyScape.Resource.SailingItem "Figurehead_Common"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 0,
		Defense = 0,
		Speed = 0,
		Resource = ItsyScape.Resource.SailingItem "Figurehead_Common"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Common figurehead",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Figurehead_Common",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Just for looks.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Figurehead_Common",
	}
end

do
	ItsyScape.Resource.SailingItem "Storage_Crate" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Storage_Crate",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_StorageCrate",
		CanCustomizeColor = 0,
		ItemGroup = "Storage",
		Resource = ItsyScape.Resource.SailingItem "Storage_Crate"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 0,
		Defense = 0,
		Speed = 0,
		Resource = ItsyScape.Resource.SailingItem "Storage_Crate"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Crate",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Storage_Crate",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Doesn't store much. Stores 30 items.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Storage_Crate",
	}
end

do
	ItsyScape.Resource.SailingItem "Storage_CrudeChest" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WillowLogs",
				Count = 50,
			},

			Input {
				Resource = ItsyScape.Resource.Item "IronBar",
				Count = 10,
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 50000,
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Storage_CrudeChest",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_CrudeChest",
		CanCustomizeColor = 0,
		ItemGroup = "Storage",
		Resource = ItsyScape.Resource.SailingItem "Storage_CrudeChest"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 0,
		Defense = 0,
		Speed = 0,
		Resource = ItsyScape.Resource.SailingItem "Storage_CrudeChest"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Crude chest",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Storage_CrudeChest",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Probably preferrable to getting eaten by a mimic, but only by a hair. Stores 60 items.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Storage_CrudeChest",
	}
end

do
	ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy" {
		ItsyScape.Action.SailingBuy() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(20)
			},

			Requirement {
				Resource = ItsyScape.Resource.Quest "RavensEye",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "Coins",
				Count = 20000
			},

			Output {
				Resource = ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy",
				Count = 1
			}
		}
	}

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Sailing_Player_RumbridgeNavySail",
		CanCustomizeColor = 0,
		ItemGroup = "Sail",
		Resource = ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy"
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 0,
		Distance = 200,
		Defense = 0,
		Speed = 150,
		Resource = ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge navy sail",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy",
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Sail flown by the Rumbridge navy.",
		Language = "en-US",
		Resource = ItsyScape.Resource.SailingItem "Sail_RumbridgeNavy",
	}
end
