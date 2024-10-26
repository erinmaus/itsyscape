--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/NPC.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local HullItem = ItsyScape.Resource.SailingItem "Hull_NPC_Isabelle_Exquisitor"

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Hull_NPC_Isabelle_Exquisitor",
		CanCustomizeColor = 1,
		ItemGroup = "Hull",
		Resource = HullItem
	}

	ItsyScape.Meta.SailingItemStats {
		Health = 150,
		Distance = 800,
		Defense = 50,
		Speed = 150,
		Resource = HullItem
	}

	ItsyScape.Meta.ResourceName {
		Value = "Isabelle's Exquisitor hull",
		Language = "en-US",
		Resource = HullItem
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "An exquisite hull made from the finest of woods.",
		Language = "en-US",
		Resource = HullItem
	}

	local HullProp = ItsyScape.Resource.Prop "Sailing_Hull_NPC_Isabelle_Exquisitor"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = HullProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Exquisitor",
		Language = "en-US",
		Resource = HullProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The flagship of Isabelle's merchant fleet. It's armed from port to starboard, making pirates and sea monsters alike think twice about engaging...",
		Language = "en-US",
		Resource = HullProp
	}
end