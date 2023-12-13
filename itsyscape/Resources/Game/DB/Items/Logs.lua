--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Logs.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local SECONDARIES = {
	"CommonBlackSpider",
	"CommonTreeMoth",
	"CommonTreeBeetle",
	"RobinEgg",
	"CardinalEgg",
	"BlueJayEgg",
	"WrenEgg",
}

local LOGS = {
	["Common"] = {
		tier = 0,
		weight = 8,
		health = 3,
		tinderbox = "Tinderbox",
		variants = { "Snowy" },
		secondaries = {
			"Leaf",
			"Branch"
		}
	},

	["Shadow"] = {
		tier = 0,
		weight = -2,
		health = 2,
		tinderbox = "Tinderbox",
		variants = { "Stormy" }
	},

	["Rotten"] = {
		tier = 5,
		weight = 7,
		health = 1,
		tinderbox = false
	},

	["Willow"] = {
		tier = 10,
		weight = 6,
		health = 7,
		tinderbox = "Tinderbox",
		secondaries = {
			"Leaf",
			"Branch"
		}
	},

	["Oak"] = {
		tier = 20,
		weight = 4,
		health = 15,
		tinderbox = "Tinderbox",
		secondaries = {
			"Leaf",
			"Branch"
		}
	},

	["Maple"] = {
		tier = 30,
		weight = 3,
		health = 50,
		tinderbox = "Tinderbox"
	},

	["FoxFir"] = {
		niceName = "Fox fir",
		tier = 35,
		weight = 16,
		health = 30,
		tinderbox = "Tinderbox",
		secondaries = {
			"Leaf",
			"Branch",
			"Flower"
		}
	},

	["Yew"] = {
		tier = 40,
		weight = 6,
		health = 100,
		tinderbox = "Tinderbox",
		secondaries = {
			"Leaf",
			"Branch"
		}
	},

	["PetrifiedSpider"] = {
		niceName = "Petrified spider",
		tier = 50,
		weight = 2,
		health = 250,
		tinderbox = "Tinderbox"
	},

	["Coconut"] = {
		tier = 15,
		weight = 2,
		health = 20,
		tinderbox = "Tinderbox",
		peepID = "Resources.Game.Peeps.CoconutTree.CoconutTree",
		variants = { "Stormy" }
	},

	["Azathothian"] = {
		tier = 90,
		weight = -10,
		health = 255,
		tinderbox = "Tinderbox"
	},

	["FossilizedOak"] = {
		niceName = "Fossilized oak",
		tier = 25,
		weight = 15,
		health = 150,
		tinderbox = "Tinderbox",
		secondaries = {
			"Branch"
		}
	}
}

for name, log in spairs(LOGS) do
	local ItemName = string.format("%sLogs", name)
	local Log = ItsyScape.Resource.Item(ItemName)

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(log.tier),
		Weight = log.weight,
		Resource = Log
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Wood",
		Value = name,
		Resource = Log
	}

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s logs", log.niceName or name),
		Language = "en-US",
		Resource = Log
	}

	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		XProgressive = "Crafting",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Wood",
		CategoryValue = name,
		Action = CraftAction
	}

	local FletchAction = ItsyScape.Action.Fletch() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = ItsyScape.Utility.xpForLevel(math.max(log.tier, 1))
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Knife",
			Count = 1
		},

		Input {
			Resource = Log,
			Count = 1,
		},

		Output {
			Resource = ItsyScape.Resource.Item "ArrowShaft",
			Count = math.max(log.tier, 1) * 15
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Engineering",
			Count = math.max(math.floor(ItsyScape.Utility.xpForResource(math.max(log.tier + 1, 1)) / 2), 1)
		}
	}

	local TreeName = string.format("%sTree_Default", name)
	local Tree = ItsyScape.Resource.Prop(TreeName)

	local ChopAction = ItsyScape.Action.Chop()

	ChopAction {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForLevel(math.max(log.tier, 0))
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Woodcutting",
			Count = ItsyScape.Utility.xpForResource(math.max(log.tier, 1))
		},

		Output {
			Resource = Log,
			Count = 1
		}
	}

	ItsyScape.Meta.ActionDifficulty {
		Value = math.max(log.tier + 10),
		Action = ChopAction
	}

	ItsyScape.Meta.GatherableProp {
		Health = log.health,
		SpawnTime = log.tier + 10,
		Resource = Tree
	}

	ItsyScape.Meta.PeepID {
		Value = log.peepID or "Resources.Game.Peeps.Props.BasicTree",
		Resource = Tree
	}

	ItsyScape.Meta.PropAnchor {
		OffsetI = 0,
		OffsetJ = 0,
		Resource = Tree
	}

	Tree { ChopAction }

	for _, secondary in ipairs(log.secondaries or {}) do
		local SecondaryItemName = string.format("%s%s", name, secondary)
		local SecondaryItem = ItsyScape.Resource.Item(SecondaryItemName)

		SecondaryItem {
			ItsyScape.Action.ObtainSecondary() {
				Requirement {
					Resource = ItsyScape.Resource.Skill "Woodcutting",
					Count = ItsyScape.Utility.xpForLevel(math.max(log.tier, 0))
				},

				Output {
					Resource = ItsyScape.Resource.Skill "Woodcutting",
					Count = ItsyScape.Utility.xpForResource(math.max(log.tier, 1))
				},

				Output {
					Resource = SecondaryItem,
					Count = 1
				}
			}
		}

		ItsyScape.Meta.SecondaryWeight {
			Weight = 500,
			Resource = SecondaryItem
		}

		ItsyScape.Meta.Item {
			Stackable = 1,
			Value = ItsyScape.Utility.valueForItem(math.max(log.tier, 1)),
			Resource = SecondaryItem
		}

		Tree {
			ItsyScape.Action.ObtainSecondary() {
				Output {
					Resource = SecondaryItem,
					Count = 1
				}
			}
		}
	end

	for _, secondary in ipairs(SECONDARIES or {}) do
		Tree {
			ItsyScape.Action.ObtainSecondary() {
				Output {
					Resource = ItsyScape.Resource.Item(secondary),
					Count = 1
				}
			}
		}
	end

	if log.variants then
		for i = 1, #log.variants do
			local VariantName = string.format("%sTree_%s", name, log.variants[i])
			local Variant = ItsyScape.Resource.Prop(VariantName) {
				ChopAction
			}

			ItsyScape.Meta.PeepID {
				Value = log.peepID or "Resources.Game.Peeps.Props.BasicTree",
				Resource = Variant
			}

			ItsyScape.Meta.ResourceName {
				Value = string.format("%s tree", log.niceName or name),
				Language = "en-US",
				Resource = Variant
			}
		end
	end

	ItsyScape.Meta.ResourceName {
		Value = string.format("%s tree", log.niceName or name),
		Language = "en-US",
		Resource = Tree
	}

	local LightAction
	if log.tinderbox then
		local FireName = string.format("%sFire", name)
		local Fire = ItsyScape.Resource.Prop(FireName)

		ItsyScape.Meta.PropAnchor {
			OffsetI = 0,
			OffsetJ = 0,
			Resource = Fire
		}

		local CookAction = ItsyScape.Action.OpenCraftWindow()
		ItsyScape.Meta.DelegatedActionTarget {
			CategoryKey = "CookingMethod",
			CategoryValue = "Fire",
			Action = CookAction
		}

		ItsyScape.Meta.ActionVerb {
			Value = "Cook",
			XProgressive = "Cooking",
			Language = "en-US",
			Action = CookAction
		}

		ItsyScape.Meta.Tier {
			Tier = math.max(log.tier, 1),
			Resource = Fire
		}

		LightAction = ItsyScape.Action.Light()

		LightAction {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForLevel(math.max(log.tier, 0))
			},

			Requirement {
				Resource = ItsyScape.Resource.Item(log.tinderbox),
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Firemaking",
				Count = ItsyScape.Utility.xpForResource(math.max(log.tier + 1, 1))
			},

			Input {
				Resource = Log,
				Count = 1
			}
		}

		ItsyScape.Meta.ActionSpawnProp {
			Prop = Fire,
			Action = LightAction
		}

		ItsyScape.Meta.GatherableProp {
			SpawnTime = 15,
			Resource = Fire
		}

		ItsyScape.Meta.ResourceName {
			Value = string.format("%s fire", log.niceName or name),
			Language = "en-US",
			Resource = Fire
		}

		ItsyScape.Meta.PeepID {
			Value = "Resources.Game.Peeps.Props.BasicFire",
			Resource = Fire
		}

		Fire {
			CookAction
		}
	end

	Log {
		CraftAction,
		FletchAction,
		LightAction
	}
end

ItsyScape.Meta.ResourceDescription {
	Value = "Logs from trees commonly found across the Realm.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CommonLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An evergreen found all over the Realm.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CommonTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "This fire won't last long.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CommonFire"
}

ItsyScape.Meta.ResourceName {
	Value = "Common leaf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CommonLeaf"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A leaf from the most common tree in the Realm.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CommonLeaf"
}

ItsyScape.Meta.ResourceName {
	Value = "Common branch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CommonBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A branch from the most common tree in the Realm. Good for kindling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CommonBranch"
}

ItsyScape.Resource.Item "CommonBranch" {
	ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "CommonBranch",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}
}

ItsyScape.Meta.ResourceDescription {
	Value = "Logs found from a common willow.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WillowLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Found near water.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "WillowTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "These logs are damp. Miracle they lit at all.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "WillowFire"
}

ItsyScape.Meta.ResourceName {
	Value = "Willow leaf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WillowLeaf"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A single leaf from a willow tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WillowLeaf"
}

ItsyScape.Meta.ResourceName {
	Value = "Willow branch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WillowBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A branch from a willow tree. Good for kindling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "WillowBranch"
}

ItsyScape.Resource.Item "WillowBranch" {
	ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(10)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "WillowBranch",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(10)
		}
	}
}

ItsyScape.Meta.ResourceDescription {
	Value = "Some solid oak logs, good for weapon making and other things.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "OakLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A beautiful oak tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "OakTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A fire burning from some oak logs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "OakFire"
}

ItsyScape.Meta.ResourceName {
	Value = "Oak leaf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "OakLeaf"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A single leaf from an oak tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "OakLeaf"
}

ItsyScape.Meta.ResourceName {
	Value = "Oak branch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "OakBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A branch from an oak tree. Good for kindling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "OakBranch"
}

ItsyScape.Resource.Item "OakBranch" {
	ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(20)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "OakBranch",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(20)
		}
	}
}

ItsyScape.Meta.ResourceDescription {
	Value = "What pretty pink logs!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "MapleLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Such a stand out tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MapleTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Wow, even the fire is pink!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "MapleFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Sturdy logs perfect for crafting and engineering.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YewLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What has this tree seen over the years?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "YewTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Probably can smoke some meat over that aromatic fire.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "YewFire"
}

ItsyScape.Meta.ResourceName {
	Value = "Yew leaf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YewLeaf"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A single leaf from a yew tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YewLeaf"
}

ItsyScape.Meta.ResourceName {
	Value = "Yew branch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YewBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A branch from a yew tree. Good for kindling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "YewBranch"
}

ItsyScape.Resource.Item "YewBranch" {
	ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(40)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "YewBranch",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(40)
		}
	}
}

ItsyScape.Meta.ResourceDescription {
	Value = "Even though these aren't technically wooden logs, they can be used as such.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "PetrifiedSpiderLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "An ancient species of spider, now extinct, petrified as a part of the horrible ritual that banished the gods.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "PetrifiedSpiderTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Wouldn't want to breathe those fumes in...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "PetrifiedSpiderFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "I hope I don't get sick from these!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "AzathothianLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Leaking multidimensional energy from Azathoth, Yendor's home.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AzathothianTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A fire that burns blue with the fiery of Yendor.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "AzathothianFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "These logs are useless...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "ShadowLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A shadow of the great common fir tree of the Realm.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ShadowTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A shadow of the great common fir tree of the Realm, whipped around in a frenzy.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ShadowTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A sickly fire.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "ShadowFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Probably useful... But for what?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "CoconutLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hopefully you're not allergic...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CoconutTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Hopefully the tree doesn't fall...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CoconutTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "What a crazy fire!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "CoconutFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "These logs are rotten and damp; they won't light.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "RottenLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A dead, rotten tree; not even good for firewood.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "RottenTree_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Fox fir leaf",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirLeaf"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A single leaf from an oak tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirLeaf"
}

ItsyScape.Meta.ResourceName {
	Value = "Fox fir flower",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirFlower"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A sharp, black flower. Used to mourn the dead, it never withers or wilts.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirFlower"
}

ItsyScape.Meta.ResourceName {
	Value = "Fox fir branch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A branch from an oak tree. Good for kindling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirBranch"
}

ItsyScape.Resource.Item "FoxFirBranch" {
	ItsyScape.Action.Burn() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(35)
		},

		Requirement {
			Resource = ItsyScape.Resource.Item "Tinderbox",
			Count = 1
		},

		Input {
			Resource = ItsyScape.Resource.Item "FoxFirBranch",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(39.5)
		}
	}
}

ItsyScape.Meta.ResourceDescription {
	Value = "A fire made from fox fir logs. Gets really hot!",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FoxFirFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Heavy logs from a fox fir.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FoxFirLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "According to Bastiel's Book of Feathers, the fox fir was a gift from Bastiel to His people, representing that He would always keep the sun burning and provide a joyous afterlife for His followers.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FoxFirTree_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Fossilized oak branch",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FossilizedOakBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A branch from a fossilized oak tree. Good for kindling.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FossilizedOakBranch"
}

ItsyScape.Meta.ResourceDescription {
	Value = "That's a regal fire, fit for Yendor's most favored tree.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FossilizedOakFire"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Logs from a tree only found at the Ruins of Rh'ysilk.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "FossilizedOakLogs"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A tree with shell so hard it can shatter axes.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FossilizedOakTree_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "The tree needs no leaves, for it draws its health from Yendor...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "FossilizedOakTree_Default"
}

ItsyScape.Resource.Prop "Charcoal" {
	ItsyScape.Action.Pick() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Output {
			Resource = ItsyScape.Resource.Item "Charcoal",
			Count = 10
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Firemaking",
			Count = ItsyScape.Utility.xpForResource(1)
		}
	}
}

ItsyScape.Meta.ResourceName {
	Value = "Charcoal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Charcoal"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Burnt remains of some logs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Charcoal"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicCharcoal",
	Resource = ItsyScape.Resource.Prop "Charcoal"
}

ItsyScape.Meta.ResourceName {
	Value = "Charcoal",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Charcoal"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Burnt remains of some logs.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "Charcoal"
}

ItsyScape.Meta.Item {
	Stackable = 1,
	Value = 1,
	Resource = ItsyScape.Resource.Item "Charcoal"
}
