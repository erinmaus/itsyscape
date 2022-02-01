--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Ores.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ORES = {
	["Copper"] = {
		tier = 0,
		weight = 10.5,
		health = 8
	},

	["Tin"] = {
		tier = 0,
		weight = 9.1,
		health = 8
	},

	["Iron"] = {
		tier = 10,
		weight = 11.5,
		health = 20,
		variants = {
			"DeepSlate"
		}
	},

	["Adamant"] = {
		tier = 40,
		weight = 25,
		health = 100
	},

	["Itsy"] = {
		tier = 50,
		weight = 25,
		health = 100
	},

	["Gold"] = {
		tier = 55,
		weight = 20,
		health = 200
	}
}

for name, ore in pairs(ORES) do
	local ItemName = string.format("%sOre", name)
	local Ore = ItsyScape.Resource.Item(ItemName)

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(ore.tier),
		Weight = ore.weight,
		Resource = Ore
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = name,
		Resource = Ore
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s ore", name),
		Language = "en-US",
		Resource = Ore
	}

	local RockName = string.format("%sRock_Default", name)
	local Rock = ItsyScape.Resource.Prop(RockName)

	local MineAction = ItsyScape.Action.Mine()

	MineAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForLevel(math.max(ore.tier, 0))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Mining",
			Count = ItsyScape.Utility.xpForResource(math.max(ore.tier, 1)) * 3
		},

		Output {
			Resource = Ore,
			Count = 1
		}
	}

	ItsyScape.Meta.ActionDifficulty {
		Value = math.max(ore.tier + 10),
		Action = MineAction
	}

	ItsyScape.Meta.GatherableProp {
		Health = ore.health,
		SpawnTime = ore.tier + 10,
		Resource = Rock
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicRock",
		Resource = Rock
	}

	Rock { MineAction }

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s rock", name),
		Language = "en-US",
		Resource = Rock
	}

	if ore.variants then
		for i = 1, #ore.variants do
			local VariantRockName = string.format("%sRock_%s", name, ore.variants[i])
			local VariantRock = ItsyScape.Resource.Prop(VariantRockName)

			VariantRock {
				MineAction
			} 

			ItsyScape.Meta.ResourceName {
				Value = string.format("%s rock", name),
				Language = "en-US",
				Resource = VariantRock
			}

			ItsyScape.Meta.PeepID {
				Value = "Resources.Game.Peeps.Props.BasicRock",
				Resource = VariantRock
			}

			ItsyScape.Meta.GatherableProp {
				Health = ore.health,
				SpawnTime = ore.tier + 10,
				Resource = Rock
			}
		end
	end
end

ItsyScape.Meta.ResourceDescription {
	Value = "Needs smelting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CopperOre"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs smelting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "TinOre"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs smelting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "IronOre"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs smelting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AdamantOre"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs smelting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GoldOre"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs smelting.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ItsyOre"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains copper ore.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CopperRock_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains tin ore",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "TinRock_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains iron ore.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "IronRock_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains iron ore.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "IronRock_DeepSlate"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains adamant ore.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AdamantRock_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains itsy ore.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AdamantRock_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Contains gold ore.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "GoldRock_Default"
}

