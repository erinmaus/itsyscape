--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/PrideCapes.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local CAPES = {
	["Ace"] = {
		dyes = { "Black", "White", "Purple" }
	}
}

for name, props in pairs(CAPES) do
	local ItemName = string.format("%sPrideCape", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local CraftAction = ItsyScape.Action.Craft() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Input {
			Resource = ItsyScape.Resource.Item "CottonCloth",
			Count = 1
		}
	}

	for i = 1, #props.dyes do
		CraftAction {
			Input {
				Resource = ItsyScape.Resource.Item(string.format("%sDye", props.dyes[i])),
				Count = 1
			}
		}
	end

	CraftAction {
		Output {
			Resource = Item,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Crafting",
			Count = ItsyScape.Utility.xpForResource(10) * #props.dyes
		}
	}

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Defense",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	Item {
		EquipAction,
		DequipAction,
		CraftAction
	}

	ItsyScape.Meta.Equipment {
		DefenseStab = 5,
		DefenseCrush = 5,
		DefenseSlash = 5,
		DefenseRanged = 5,
		DefenseMagic = 5,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_BACK,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s pride cape", name),
		Language = "en-US",
		Resource = Item
	}


	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = string.format("Resources/Game/Skins/PrideCapes/%s.lua", name),
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Fabric",
		Value = "CottonCloth",
		Resource = Item
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(10) + ItsyScape.Utility.valueForItem(5) * #props.dyes,
		Weight = -1,
		Resource = Item 
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "A cape perfect for those who are ace.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AcePrideCape"
}
