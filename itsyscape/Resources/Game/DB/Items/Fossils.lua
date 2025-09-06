--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Fossils.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local ORES = {
	["Shell"] = {
		name = "Shell fossil",
		item = "SmallShellFossil",
		hidden = true,

		tier = 15,
		weight = 6,
		health = 100,

		uniques = {
			"SmallShellFossil",
			"LargeShellFossil",
			"SmallTrilobyteFossil",
			"LargeTrilobyteFossil"
		}
	},

	["AncientWhale"] = {
		name = "Ancient whale skull",
		item = "AncientWhaleSkull",

		tier = 30,
		weight = 34,
		health = 250,

		secondaries = {
			"Sapphire",
			"Emerald",
			"Ruby",
			"Diamond",
			"BlackGold",
			"CoarseSageRockSalt",
			"CoarseDexterousRockSalt",
			"CoarseKosherRockSalt",
			"CoarseWarriorRockSalt",
			"CoarseToughRockSalt",
			"CoarseArtisanRockSalt",
			"CoarseGathererRockSalt",
			"CoarseAdventurerRockSalt",
		}
	},

	["AncientVelocirex"] = {
		name = "Ancient velocirex skull",
		item = "AncientVelocirexSkull",

		tier = 60,
		weight = 117,
		health = 500,
		secondaries = {
			"Sapphire",
			"Emerald",
			"Ruby",
			"Diamond",
			"BlackGold",
			"CoarseSageRockSalt",
			"CoarseDexterousRockSalt",
			"CoarseKosherRockSalt",
			"CoarseWarriorRockSalt",
			"CoarseToughRockSalt",
			"CoarseArtisanRockSalt",
			"CoarseGathererRockSalt",
			"CoarseAdventurerRockSalt",
		}
	}
}

for name, ore in spairs(ORES) do
	local ItemName = string.format("%sFossil", name)
	local Ore = not ore.hidden and ItsyScape.Resource.Item(ore.item)

	if Ore then
		ItsyScape.Meta.Item {
			Value = ItsyScape.Utility.valueForItem(ore.tier + 10) * 2,
			Weight = ore.weight,
			Resource = Ore
		}

		ItsyScape.Meta.ResourceCategory {
			Key = "Fossil",
			Value = name,
			Resource = Ore
		}

		ItsyScape.Meta.ResourceName {
			Value = ore.name,
			Language = "en-US",
			Resource = Ore
		}
	end

	local RockName = string.format("%sFossil", name)
	local Rock = ItsyScape.Resource.Prop(RockName)

	local MineAction = ItsyScape.Action.Mine()

	if Ore then
		MineAction {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(math.max(ore.tier, 0) + 20)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(math.max(ore.tier, 1) + 20) * 3
			},

			Output {
				Resource = Ore,
				Count = 1
			}
		}
	else
		MineAction {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(math.max(ore.tier, 0) + 20)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(math.max(ore.tier, 1) + 20) * 3
			},

			Output {
				Resource = ItsyScape.Resource.Item(ore.item),
				Count = 1
			}
		}

		ItsyScape.Meta.HiddenFromSkillGuide {
			Action = MineAction
		}
	end

	ItsyScape.Meta.ActionDifficulty {
		Value = math.max(ore.tier + 15),
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

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = Rock
	}

	Rock { MineAction }

	local SecondaryActions = {}
	if ore.secondaries then
		for i = 1, #ore.secondaries do
			local Action = ItsyScape.Action.ObtainSecondary() {
				Output {
					Resource = ItsyScape.Resource.Item(ore.secondaries[i]),
					Count = 1
				}
			}

			ItsyScape.Meta.HiddenFromSkillGuide {
				Action = Action
			}
			
			table.insert(SecondaryActions, Action)
		end
	end

	Rock(SecondaryActions)

	local UniqueActions = {}
	if ore.uniques then
		for i = 1, #ore.uniques do
			local Action = ItsyScape.Action.ObtainSecondary() {
				Output {
					Resource = ItsyScape.Resource.Item(ore.uniques[i]),
					Count = 1
				}
			}
			
			table.insert(UniqueActions, Action)
		end
	end

	Rock(UniqueActions)

	ItsyScape.Meta.ResourceName {
		Value = ore.name,
		Language = "en-US",
		Resource = Rock
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "Full of sea creature fossils.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ShellFossil"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 1.5,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "ShellFossil"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The velocirex was an early, flightless dragon. Archeologists theorize it couldn't breathe fire because its bones couldn't withstand the heat.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientVelocirexSkull"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The velocirex was much larger than the modern dragon, but it couldn't fly. Though, this leads to the question: did dragons evolve wings due to avoid an even greater apex predator...?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AncientVelocirexFossil"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 12,
	SizeY = 8,
	SizeZ = 1.5,
	OffsetY = 1.5,
	MapObject = ItsyScape.Resource.Prop "AncientVelocirexFossil"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A whale skull dating back millions of years. Whales don't seem to have evolved much",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AncientWhaleSkull"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A whale skull decorated by an ancient people. What significance do the squiggles mean?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AncientWhaleFossil"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 12,
	SizeY = 5,
	SizeZ = 1.5,
	OffsetY = 2.5,
	MapObject = ItsyScape.Resource.Prop "AncientWhaleFossil"
}

ItsyScape.Resource.Item "SmallShellFossil" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(15),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "SmallShellFossil"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Shell fossil",
	Resource = ItsyScape.Resource.Item "SmallShellFossil"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A small shell fossil from a sea creature of a time primeval.",
	Resource = ItsyScape.Resource.Item "SmallShellFossil"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(20),
	Resource = ItsyScape.Resource.Item "SmallShellFossil"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 500,
	Resource = ItsyScape.Resource.Item "SmallShellFossil"
}

ItsyScape.Resource.Item "LargeShellFossil" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(25),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(25),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "LargeShellFossil"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Large shell fossil",
	Resource = ItsyScape.Resource.Item "LargeShellFossil"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A rare, large shell fossil from a time immemorial. If only fossils could speak...",
	Resource = ItsyScape.Resource.Item "LargeShellFossil"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(20),
	Resource = ItsyScape.Resource.Item "LargeShellFossil"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 250,
	Resource = ItsyScape.Resource.Item "LargeShellFossil"
}

ItsyScape.Resource.Item "SmallTrilobyteFossil" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(15),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(15),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "SmallTrilobyteFossil"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Trilobyte fossil",
	Resource = ItsyScape.Resource.Item "SmallTrilobyteFossil"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A small trilobyte fossil... Ew, how gross this must've been! Like a cockroach crustacean hybrid...",
	Resource = ItsyScape.Resource.Item "SmallTrilobyteFossil"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(20),
	Resource = ItsyScape.Resource.Item "SmallTrilobyteFossil"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 300,
	Resource = ItsyScape.Resource.Item "SmallTrilobyteFossil"
}

ItsyScape.Resource.Item "LargeTrilobyteFossil" {
	ItsyScape.Action.ObtainSecondary() {
		Requirement {
			Count = ItsyScape.Utility.xpForLevel(25),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = ItsyScape.Utility.xpForResource(25),
			Resource = ItsyScape.Resource.Skill "Mining"
		},

		Output {
			Count = 1,
			Resource = ItsyScape.Resource.Item "LargeTrilobyteFossil"
		}
	}
}

ItsyScape.Meta.ResourceName {
	Language = "en-US",
	Value = "Large trilobyte fossil",
	Resource = ItsyScape.Resource.Item "LargeTrilobyteFossil"
}

ItsyScape.Meta.ResourceDescription {
	Language = "en-US",
	Value = "A large trilobyte fossil. Makes the skin crawl...",
	Resource = ItsyScape.Resource.Item "LargeTrilobyteFossil"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = ItsyScape.Utility.valueForItem(20),
	Resource = ItsyScape.Resource.Item "LargeTrilobyteFossil"
}

ItsyScape.Meta.SecondaryWeight {
	Weight = 150,
	Resource = ItsyScape.Resource.Item "LargeTrilobyteFossil"
}

