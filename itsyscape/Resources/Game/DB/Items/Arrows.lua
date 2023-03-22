--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Arrows.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local METALS = {
	["Bronze"] = {
		tier = 1,
		count = 15
	},

	["Iron"] = {
		tier = 10,
		count = 20
	},

	["BlackenedIron"] = {
		niceName = "Blackened iron",
		tier = 20,
		count = 25
	},

	["Mithril"] = {
		tier = 30,
		count = 30
	},

	["Adamant"] = {
		tier = 40,
		count = 35
	},

	["Itsy"] = {
		tier = 50,
		count = 40
	}
}

for name, metal in spairs(METALS) do
	local ItemName = string.format("%sArrow", name)
	local Item = ItsyScape.Resource.Item(ItemName)

	local ArrowheadName = string.format("%sArrowhead", name)
	local ArrowheadItem = ItsyScape.Resource.Item(ArrowheadName)

	local EquipAction = ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Dexterity",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		}
	}

	local DequipAction = ItsyScape.Action.Dequip()

	local FletchAction15 = ItsyScape.Action.Fletch() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Feather",
			Count = metal.count
		},

		Input {
			Resource = ItsyScape.Resource.Item "ArrowShaft",
			Count = metal.count
		},

		Input {
			Resource = ArrowheadItem,
			Count = metal.count
		},

		Output {
			Resource = Item,
			Count = metal.count
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = math.max(ItsyScape.Utility.xpForResource(metal.tier + 1), metal.count)
		}
	}

	local FletchAction1 = ItsyScape.Action.Fletch() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Feather",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "ArrowShaft",
			Count = 1
		},

		Input {
			Resource = ArrowheadItem,
			Count = 1
		},

		Output {
			Resource = Item,
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = math.max(math.floor(ItsyScape.Utility.xpForResource(metal.tier + 1) / metal.count), 1)
		}
	}

	local SmithAction = ItsyScape.Action.Smith() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(metal.tier)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Hammer",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item(string.format("%sBar", name)),
			Count = 1
		},

		Output {
			Resource = ArrowheadItem,
			Count = metal.count
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForResource(metal.tier + 1)
		}
	}

	ItsyScape.Meta.Item {
		Value = math.min(math.floor(ItsyScape.Utility.valueForItem(metal.tier + 2) / metal.count), metal.count) * metal.tier,
		Weight = 0,
		Stackable = 1,
		Resource = Item
	}

	ItsyScape.Meta.Item {
		Value = math.min(math.floor(ItsyScape.Utility.valueForItem(metal.tier + 1) / metal.count), metal.count) * metal.tier,
		Weight = 0,
		Stackable = 1,
		Resource = ArrowheadItem
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = ArrowheadItem
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Arrow",
		Value = name,
		Resource = Item
	}

	ItsyScape.Meta.RangedAmmo {
		Type = ItsyScape.Utility.Equipment.AMMO_ARROW,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s arrow", metal.niceName or name),
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s arrowhead", name),
		Language = "en-US",
		Resource = ArrowheadItem
	}

	ItsyScape.Meta.Equipment {
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(metal.tier + 6),
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_QUIVER,
		Resource = Item
	}

	Item {
		EquipAction,
		DequipAction,
		FletchAction15,
		FletchAction1
	}

	ArrowheadItem {
		SmithAction
	}

	ItsyScape.Utility.tag(Item, "archery")
end

ItsyScape.Meta.ResourceDescription {
	Value = "Weak, but it'll still get to the point.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BronzeArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Pretty primitive, but not quite stone age.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BronzeArrowhead"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sharp!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Iron age technology.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronArrowhead"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Just as good as steel.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlackenedIronArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Cutting edge medieval tech.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "BlackenedIronArrowhead"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Light, but packs a punch.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "MithrilArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Delicate and hard to make.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "MithrilArrowhead"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Deadly!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AdamantArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "That was tough to smith!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AdamantArrowhead"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Make sure to shoot away from yourself.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ItsyArrow"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Ready and waiting to become flighted arrows.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ItsyArrowhead"
}

do
	local ArrowShaft = ItsyScape.Resource.Item "ArrowShaft"

	ItsyScape.Meta.Item {
		Value = 1,
		Weight = 0,
		Stackable = 1,
		Resource = ArrowShaft
	}

	ItsyScape.Meta.ResourceName {
		Value = "Arrow shaft",
		Language = "en-US",
		Resource = ArrowShaft
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Baby arrow, yearning to take flight.",
		Language = "en-US",
		Resource = ArrowShaft
	}

	local FletchAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Fletch",
		XProgressive = "Fletching",
		Language = "en-US",
		Action = FletchAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Arrow",
		ActionType = "Fletch",
		Action = FletchAction
	}

	ArrowShaft {
		FletchAction
	}
end
