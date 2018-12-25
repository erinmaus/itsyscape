--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Bones.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Supplies
do
	ItsyScape.Resource.Item "Bait" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Bait"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bait",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bait"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Good for fish, or if you're on a diet.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Bait"
	}
end

-- Sardines
do
	ItsyScape.Resource.Prop "Sardine_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(1)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "Sardine",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(2)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a sardine swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 5,
		SpawnTime = 20,
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "Sardine_Default"
	}

	ItsyScape.Resource.Item "Sardine" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Beady eyes! Needs cooked.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Sardine"
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 4,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Sardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedSardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(3)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "Sardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntSardine",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = 1
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = FailAction
	}

	ItsyScape.Meta.CookingFailedAction {
		Output = FailAction,
		Start = 1,
		Stop = 6,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedSardine" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Fire",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Range",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Bit salty. Better with rice.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(4),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedSardine"
	}

	ItsyScape.Resource.Item "BurntSardine" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt sardine",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Not even rice can make this better...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntSardine"
	}
end

-- Sea bass
do
	ItsyScape.Resource.Prop "SeaBass_Default" {
		ItsyScape.Action.Fish() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(5)
			},

			Input {
				Resource = ItsyScape.Resource.Item "Bait",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "SeaBass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(5)
			}
		}
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicFish",
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "There's a sea bass swimming in the water.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Meta.GatherableProp {
		Health = 10,
		SpawnTime = 30,
		Resource = ItsyScape.Resource.Prop "SeaBass_Default"
	}

	ItsyScape.Resource.Item "SeaBass" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Fire",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Range",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Only worth a few Bells. Whatever Bells are.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(6),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "SeaBass"
	}

	local EatAction = ItsyScape.Action.Eat()

	ItsyScape.Meta.HealingPower {
		HitPoints = 6,
		Action = EatAction
	}

	local CookAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(5)
		},

		Input {
			Resource = ItsyScape.Resource.Item "SeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedSeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForResource(6)
		}
	}

	local FailAction = ItsyScape.Action.Cook() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = ItsyScape.Utility.xpForLevel(1)
		},

		Input {
			Resource = ItsyScape.Resource.Item "SeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntSeaBass",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Cooking",
			Count = 1
		}
	}

	ItsyScape.Meta.HiddenFromSkillGuide {
		Action = FailAction
	}

	ItsyScape.Meta.CookingFailedAction {
		Output = FailAction,
		Start = 5,
		Stop = 10,
		Action = CookAction
	}

	ItsyScape.Resource.Item "CookedSeaBass" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tastes like fish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(6),
		Weight = 1.1,
		Resource = ItsyScape.Resource.Item "CookedSeaBass"
	}

	ItsyScape.Resource.Item "BurntSeaBass" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt sea bass",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Tastes like charred fish.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntFish",
		Resource = ItsyScape.Resource.Item "BurntSeaBass"
	}
end
