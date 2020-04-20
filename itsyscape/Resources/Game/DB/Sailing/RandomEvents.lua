--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/RandomEvents.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local GiantSquidling = ItsyScape.Resource.SailingRandomEvent "GiantSquidling" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(1)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Giant Squidling",
		Language = "en-US",
		Resource = GiantSquidling
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An attack at sea by a giant squidling!",
		Language = "en-US",
		Resource = GiantSquidling
	}

	ItsyScape.Meta.SailingRandomEvent {
		Weight = 1000,
		Resource = GiantSquidling
	}
end

do
	local MeagerCyclone = ItsyScape.Resource.SailingRandomEvent "MeagerCyclone" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(1)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Meager cyclone",
		Language = "en-US",
		Resource = MeagerCyclone
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A storm brings with it some opportunities!",
		Language = "en-US",
		Resource = MeagerCyclone
	}

	ItsyScape.Meta.SailingRandomEvent {
		Weight = 1000,
		Resource = MeagerCyclone
	}
end

do
	local BlackTentacleScouts = ItsyScape.Resource.SailingRandomEvent "BlackTentacleScouts" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(10)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Black Tentacle scouts",
		Language = "en-US",
		Resource = BlackTentacleScouts
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Scouts from the Black Tentacle board your ship!",
		Language = "en-US",
		Resource = BlackTentacleScouts
	}

	ItsyScape.Meta.SailingRandomEvent {
		Weight = 500,
		Resource = BlackTentacleScouts
	}
end

do
	local RumbridgeNavyScout = ItsyScape.Resource.SailingRandomEvent "RumbridgeNavyScout" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(15)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rumbridge Navy scouts",
		Language = "en-US",
		Resource = RumbridgeNavyScout
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Scouts from the Rumbridge navy find you and attack!",
		Language = "en-US",
		Resource = RumbridgeNavyScout
	}

	ItsyScape.Meta.SailingRandomEvent {
		Weight = 750,
		IsPirate = 1,
		Resource = RumbridgeNavyScout
	}
end

do
	local DyeMerchant = ItsyScape.Resource.SailingRandomEvent "DyeMerchant" {
		ItsyScape.Action.SailingUnlock() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Sailing",
				Count = ItsyScape.Utility.xpForLevel(15)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dye merchant raid",
		Language = "en-US",
		Resource = DyeMerchant
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Board the dye merchant's ship and raid their dyes!",
		Language = "en-US",
		Resource = DyeMerchant
	}

	ItsyScape.Meta.SailingRandomEvent {
		Weight = 500,
		IsPirate = 1,
		Resource = DyeMerchant
	}
end
