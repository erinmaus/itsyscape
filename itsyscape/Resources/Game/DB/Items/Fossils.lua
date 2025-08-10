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
	local Ore = ItsyScape.Resource.Item(ore.item)

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

	local RockName = string.format("%sFossil", name)
	local Rock = ItsyScape.Resource.Prop(RockName)

	local MineAction = ItsyScape.Action.Mine()

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

	ItsyScape.Meta.ResourceName {
		Value = ore.name,
		Language = "en-US",
		Resource = Rock
	}
end

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
