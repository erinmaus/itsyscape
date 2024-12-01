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

do
	local HelmItem = ItsyScape.Resource.SailingItem "Helm_ExquisiteMahogany"

	ItsyScape.Meta.SailingItemDetails {
		Prop = "Helm_ExquisiteMahogany",
		CanCustomizeColor = 1,
		ItemGroup = "Helm",
		Resource = HelmItem
	}

	ItsyScape.Meta.SailingItemStats {
		Resource = HelmItem
	}

	ItsyScape.Meta.ResourceName {
		Value = "Exquisite mahogany helm",
		Language = "en-US",
		Resource = HelmItem
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A gold-trimmed mahogany helm.",
		Language = "en-US",
		Resource = HelmItem
	}

	local HelmProp = ItsyScape.Resource.Prop "Sailing_Helm_ExquisiteMahogany"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = HelmProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Exquisite mahogany helm",
		Language = "en-US",
		Resource = HelmProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "One of the finest helms money can buy.",
		Language = "en-US",
		Resource = HelmProp
	}
end

local GalleonForeMastSailProp = ItsyScape.Resource.Prop "Sailing_Sail_Galleon_ForeMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = GalleonForeMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Galleon foremast sail",
	Language = "en-US",
	Resource = GalleonForeMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sails on a foremast for a Galleon size-class ship.",
	Language = "en-US",
	Resource = GalleonForeMastSailProp
}

local GalleonRearMastSailProp = ItsyScape.Resource.Prop "Sailing_Sail_Galleon_RearMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = GalleonRearMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Galleon rearmast sail",
	Language = "en-US",
	Resource = GalleonRearMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sails on a rearmast for a Galleon size-class ship.",
	Language = "en-US",
	Resource = GalleonRearMastSailProp
}

local GalleonMainMastSailProp = ItsyScape.Resource.Prop "Sailing_Sail_Galleon_MainMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = GalleonMainMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Galleon mainmast sail",
	Language = "en-US",
	Resource = GalleonMainMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sails on a mainmast for a Galleon size-class ship.",
	Language = "en-US",
	Resource = GalleonMainMastSailProp
}

local GalleonForeMastSailProp = ItsyScape.Resource.Prop "Sailing_Galleon_ForeMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = GalleonForeMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Galleon foremast",
	Language = "en-US",
	Resource = GalleonForeMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "The foremast for a Galleon size-class ship.",
	Language = "en-US",
	Resource = GalleonForeMastSailProp
}

local GalleonRearMastSailProp = ItsyScape.Resource.Prop "Sailing_Galleon_RearMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = GalleonRearMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Galleon rearmast",
	Language = "en-US",
	Resource = GalleonRearMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "The rearmast for a Galleon size-class ship.",
	Language = "en-US",
	Resource = GalleonRearMastSailProp
}

local GalleonMainMastSailProp = ItsyScape.Resource.Prop "Sailing_Galleon_MainMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = GalleonMainMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Galleon mainmast",
	Language = "en-US",
	Resource = GalleonMainMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "The mainmast for a Galleon size-class ship.",
	Language = "en-US",
	Resource = GalleonMainMastSailProp
}
