--------------------------------------------------------------------------------
-- Resources/Game/DB/Sailing/NPC.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ITEMS = {
	{
		type = "Cannon",
		defaultPropID = "Sailing_Cannon",
		peepID = "Resources.Game.Peeps.Props.BasicCannon2",
		items = {
			{
				id = "Itsy_Gilded",
				name = "Gilded itsy cannon",
				description = "The fanciest itsy cannon you'll ever find."
			},
			{
				id = "BloodMithril",
				name = "Blood mithril cannon",
				description = "The lightest metal in the Realm infused with blackmelt to survive the corrosive effects of sea water to make an extremely threatening cannon."
			}
		}
	},
	{
		type = "Capstan",
		defaultPropID = "Sailing_Capstan",
		items = {
			{
				id = "ExquisiteDragonBone",
				name = "Exquisite dragon bone capstan",
				description = "An expensive capstan made from mahogany and dragon bone."
			}
		}
	},
	{
		type = "Figurehead",
		defaultPropID = "Sailing_Figurehead",
		items = {
			{
				id = "ExquisiteDragonSkull",
				name = "Exquisite dragon skull figurehead",
				description = "A figurehead made from the skull of an ancient dragon. Strike fear into your foes!"
			}
		}
	},
	{
		type = "Helm",
		defaultPropID = "Sailing_Helm",
		items = {
			{
				id = "ExquisiteMahogany",
				name = "Exquisite mahogany helm",
				description = "The workmanship of this helm is unmatched."
			}
		}
	},
	{
		type = "Hull",
		defaultPropID = "Sailing_Hull",
		items = {
			{
				id = "Galleon_Wood",
				name = "Wooden galleon hull",
				description = "A massive hull made from strong wood.",
			},
			{
				id = "Galleon_BloodMithril",
				name = "Blood mithril galleon hull",
				description = "A massive hull made from the only seaworthy metal in the Realm.",
			}
		}
	},
	{
		type = "Mast",
		slots = {
			"ForeMast",
			"MainMast",
			"RearMast"
		},
		defaultPropID = {
			ForeMast = "Sailing_ForeMast",
			MainMast = "Sailing_MainMast",
			RearMast = "Sailing_RearMast"
		},
		items = {
			{
				id = "ExquisiteMahogany",
				name = "Exquisite mahogany mast",
				description = "A strong mast made from mahogany."
			},
			{
				id = "BloodMithril",
				name = "Blood mithril mast",
				description = "This mast is nigh unbreakable by cannonfire.",
			}
		}
	},
	{
		type = "Rail",
		defaultPropID = "Sailing_Rail",
		items = {
			{
				id = "Galleon_ExquisiteFiligree",
				name = "Exquisite mahogany filigree",
				description = "Mahogany rails adorned with wooden filigree."
			},
			{
				id = "Galleon_BloodMithril",
				name = "Exquisite mahogany filigree",
				description = "Brutal blood mithril. Keeps you from falling overboard..."
			}
		}
	},
	{
		type = "Sail",
		slots = {
			"Sail_ForeMast",
			"Sail_MainMast",
			"Sail_RearMast"
		},
		defaultPropID = {
			Sail_ForeMast = "Sailing_Sail_ForeMast",
			Sail_MainMast = "Sailing_Sail_MainMast",
			Sail_RearMast = "Sailing_Sail_RearMast"
		},
		items = {
			{
				id = "VelvetDragon",
				name = "Velvet dragon sails",
				description = "Sails made from an enchanted velvet featuring a mysterious dragon skull."
			},
			{
				id = "DeadPrincess",
				name = "Dead Princess sails",
				description = "Crown of thorns around tentacles, symbolizing the crew's kurse to hunt Cthulhu to the ends of the Realm."
			}
		}
	},
	{
		type = "Window",
		defaultPropID = "Sailing_Window",
		items = {
			{
				id = "Galleon_ExquisiteFiligree",
				name = "Exquisite filigree window",
				description = "Windows trimmed with mahogany and wooden filigree."
			},
			{
				id = "Galleon_BloodMithril",
				name = "Blood mithril window",
				description = "Windows trimmed with blood mithril."
			}
		}
	}
}

for _, itemGroup in ipairs(ITEMS) do
	for _, item in ipairs(itemGroup.items) do
		local SailingItemName = string.format("%s_%s", itemGroup.type, item.id)
		local SailingItem = ItsyScape.Resource.SailingItem(SailingItemName)

		ItsyScape.Meta.SailingItemDetails {
			ItemGroup = itemGroup.type,
			IsUnique = itemGroup.unique and 1 or 0,
			Resource = SailingItem
		}

		ItsyScape.Meta.ResourceName {
			Value = item.name,
			Language = "en-US",
			Resource = SailingItem
		}

		ItsyScape.Meta.ResourceDescription {
			Value = item.description,
			Language = "en-US",	
			Resource = SailingItem
		}

		local slots = itemGroup.slots and itemGroup.slots or { itemGroup.type }
		local defaultPropID = type(itemGroup.defaultPropID) == "string" and { [itemGroup.type] = itemGroup.defaultPropID } or itemGroup.defaultPropID

		for index, slot in ipairs(slots) do
			local PropName = string.format("%s_%s", slot, item.id)
			local Prop = ItsyScape.Resource.Prop(PropName)

			ItsyScape.Meta.PeepID {
				Value = itemGroup.peepID or item.peepID or "Resources.Game.Peeps.Props.BasicSailingItem",
				Resource = Prop
			}

			ItsyScape.Meta.ResourceName {
				Value = item.name,
				Language = "en-US",
				Resource = Prop
			}

			ItsyScape.Meta.ResourceDescription {
				Value = item.description,
				Language = "en-US",	
				Resource = Prop
			}

			ItsyScape.Meta.PropAlias {
				Alias = ItsyScape.Resource.Prop(defaultPropID[slot]),
				Resource = Prop
			}

			ItsyScape.Meta.ShipSailingItemPropHotspot {
				Slot = slot,
				ItemGroup = itemGroup.type,
				Prop = Prop,
				SailingItem = SailingItem
			}
		end
	end
end

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

local ForeMastSailProp = ItsyScape.Resource.Prop "Sailing_Sail_ForeMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = ForeMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Foremast sail",
	Language = "en-US",
	Resource = ForeMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sails on a foremast for a ship.",
	Language = "en-US",
	Resource = ForeMastSailProp
}

local RearMastSailProp = ItsyScape.Resource.Prop "Sailing_Sail_RearMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = RearMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Rearmast sail",
	Language = "en-US",
	Resource = RearMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sails on a rearmast for a ship.",
	Language = "en-US",
	Resource = RearMastSailProp
}

local MainMastSailProp = ItsyScape.Resource.Prop "Sailing_Sail_MainMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = MainMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Mainmast sail",
	Language = "en-US",
	Resource = MainMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sails on a mainmast for a ship.",
	Language = "en-US",
	Resource = MainMastSailProp
}

local ForeMastSailProp = ItsyScape.Resource.Prop "Sailing_ForeMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = ForeMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Foremast",
	Language = "en-US",
	Resource = ForeMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "The foremast for a ship.",
	Language = "en-US",
	Resource = ForeMastSailProp
}

local RearMastSailProp = ItsyScape.Resource.Prop "Sailing_RearMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = RearMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Rearmast",
	Language = "en-US",
	Resource = RearMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "The rearmast for a ship.",
	Language = "en-US",
	Resource = RearMastSailProp
}

local MainMastSailProp = ItsyScape.Resource.Prop "Sailing_MainMast"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicSailingItem",
	Resource = MainMastSailProp
}

ItsyScape.Meta.ResourceName {
	Value = "Mainmast",
	Language = "en-US",
	Resource = MainMastSailProp
}

ItsyScape.Meta.ResourceDescription {
	Value = "The mainmast for a ship.",
	Language = "en-US",
	Resource = MainMastSailProp
}

do
	local SailingProp = ItsyScape.Resource.Prop "Sailing_Capstan"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Capstan",
		Language = "en-US",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Let's you raise and lower the anchor.",
		Language = "en-US",
		Resource = SailingProp
	}
end

do
	local SailingProp = ItsyScape.Resource.Prop "Sailing_Figurehead"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Figurehead",
		Language = "en-US",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Looks cool.",
		Language = "en-US",
		Resource = SailingProp
	}
end

do
	local SailingProp = ItsyScape.Resource.Prop "Sailing_Helm"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Helm",
		Language = "en-US",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Let's you steer the ship.",
		Language = "en-US",
		Resource = SailingProp
	}
end

do
	local SailingProp = ItsyScape.Resource.Prop "Sailing_Hull"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Hull",
		Language = "en-US",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Keeps water out.",
		Language = "en-US",
		Resource = SailingProp
	}
end

do
	local SailingProp = ItsyScape.Resource.Prop "Sailing_Window"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicSailingItem",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceName {
		Value = "Window",
		Language = "en-US",
		Resource = SailingProp
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Lets you see out.",
		Language = "en-US",
		Resource = SailingProp
	}
end

do
	ItsyScape.Resource.Prop "Cannon_Itsy_Gilded" {
		ItsyScape.Action.Fire()
	}
end

do
	ItsyScape.Resource.Prop "Helm_ExquisiteMahogany" {
		ItsyScape.Action.Steer()
	}
end
