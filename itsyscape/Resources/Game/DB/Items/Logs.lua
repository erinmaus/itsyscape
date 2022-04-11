--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Logs.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local LOGS = {
	["Common"] = {
		tier = 0,
		weight = 8,
		health = 6,
		tinderbox = "Tinderbox",
		variants = { "Snowy" }
	},

	["Shadow"] = {
		tier = 0,
		weight = -2,
		health = 3,
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
		health = 20,
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
		tier = 20,
		weight = 15,
		health = 150,
		tinderbox = "Tinderbox"
	}
}

for name, log in pairs(LOGS) do
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
		Value = string.format("%s logs", name),
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
			Resource = ItsyScape.Resource.Skill "Fletching",
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
			Resource = ItsyScape.Resource.Skill "Fletching",
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
			Count = ItsyScape.Utility.xpForResource(math.max(log.tier, 1)) * 4
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

	Tree { ChopAction }

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
				Count = ItsyScape.Utility.xpForResource(math.max(log.tier, 1)) * 4
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
