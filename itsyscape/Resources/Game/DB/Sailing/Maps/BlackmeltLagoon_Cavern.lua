--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/Maps/BlackmeltLagoon_Cavern.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Item "Key_BlackmeltLagoon1" {
	-- Nothing.
}

ItsyScape.Meta.Item {
	Value = 10000,
	Untradeable = 1,
	Resource = ItsyScape.Resource.Item "Key_BlackmeltLagoon1"
}

ItsyScape.Meta.ResourceName {
	Value = "Black Tentacle treasury key",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Key_BlackmeltLagoon1"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Grants access to the Black Tentacle's treasury under the Blackmelt Lagoon.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Key_BlackmeltLagoon1"
}

do
	local Coins10KReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 20000
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = Coins10KReward,
		Weight = 500
	}

	local Coins100KReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Coins",
			Count = 100000
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = Coins100KReward,
		Weight = 200
	}

	local GoldBarReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldBar",
			Count = 2
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldBarReward,
		Weight = 200
	}

	local GoldOreReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldOre",
			Count = 4
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldOreReward,
		Weight = 400
	}

	local GoldenRingReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldenRing",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldenRingReward,
		Weight = 100
	}

	local GoldenAmuletReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "GoldenAmulet",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = GoldenAmuletReward,
		Weight = 50
	}

	local CopperAmuletReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "CopperAmulet",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = CopperAmuletReward,
		Weight = 200
	}

	ItsyScape.Resource.DropTable "Sailing_BlackmeltLagoon_Cavern_Chest_Gold" {
		Coins10KReward,
		Coins100KReward,
		GoldBarReward,
		GoldOreReward,
		GoldenRingReward,
		GoldenAmuletReward,
		CopperAmuletReward
	}
end

do
	local SapphireReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Sapphire",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = SapphireReward,
		Weight = 40
	}

	local EmeraldReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Emerald",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = EmeraldReward,
		Weight = 20
	}

	local RubyReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Ruby",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = RubyReward,
		Weight = 10
	}

	local DiamondReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Diamond",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = DiamondReward,
		Weight = 5
	}

	ItsyScape.Resource.DropTable "Sailing_BlackmeltLagoon_Cavern_Chest_Gems" {
		SapphireReward,
		EmeraldReward,
		RubyReward,
		DiamondReward
	}
end

do
	local TimeTurnerReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "TimeTurner",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = TimeTurnerReward,
		Weight = 1
	}

	local PiratesHatWithBeardReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "PiratesHatWithBeard",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = PiratesHatWithBeardReward,
		Weight = 199
	}

	local PiratesHatReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "PiratesHat",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = PiratesHatReward,
		Weight = 725
	}

	local KeyReward = ItsyScape.Action.Reward() {
		Output {
			Resource = ItsyScape.Resource.Item "Key_BlackmeltLagoon1",
			Count = 1
		}
	}

	ItsyScape.Meta.RewardEntry {
		Action = KeyReward,
		Weight = 75
	}

	ItsyScape.Resource.DropTable "Sailing_BlackmeltLagoon_Cavern_Chest_Legendary" {
		TimeTurnerReward,
		PiratesHatWithBeardReward,
		PiratesHatReward
	}
end
