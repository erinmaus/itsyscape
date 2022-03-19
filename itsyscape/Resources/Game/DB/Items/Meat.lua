--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Meat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	ItsyScape.Resource.Item "Beef" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Meat",
		Resource = ItsyScape.Resource.Item "Beef"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Beef",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Beef"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A common cut of beef.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Beef"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Beef"
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
			Resource = ItsyScape.Resource.Item "Beef",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedBeef",
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
			Resource = ItsyScape.Resource.Item "Beef",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntBeef",
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

	ItsyScape.Resource.Item "CookedBeef" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Meat",
		Resource = ItsyScape.Resource.Item "CookedBeef"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Fire",
		Resource = ItsyScape.Resource.Item "CookedBeef"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Range",
		Resource = ItsyScape.Resource.Item "CookedBeef"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked beef",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedBeef"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Well done beef. Probably tastes like rubber.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedBeef"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(4),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedBeef"
	}

	ItsyScape.Resource.Item "BurntBeef" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt beef",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntBeef"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "That's way over cooked...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntBeef"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntBeef"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntMeat",
		Resource = ItsyScape.Resource.Item "BurntBeef"
	}
end

do
	ItsyScape.Resource.Item "Pork" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Fish",
		Resource = ItsyScape.Resource.Item "Pork"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Pork",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Pork"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A common cut of pork.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Pork"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(3),
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "Pork"
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
			Resource = ItsyScape.Resource.Item "Pork",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "CookedPork",
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
			Resource = ItsyScape.Resource.Item "Pork",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Item "BurntPork",
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

	ItsyScape.Resource.Item "CookedPork" {
		CookAction,
		EatAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "Meat",
		Resource = ItsyScape.Resource.Item "CookedPork"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Fire",
		Resource = ItsyScape.Resource.Item "CookedPork"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "CookingMethod",
		Value = "Range",
		Resource = ItsyScape.Resource.Item "CookedPork"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Cooked pork",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedPork"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Aww, such a cute itsy porkchop.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "CookedPork"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(4),
		Weight = 0.5,
		Resource = ItsyScape.Resource.Item "CookedPork"
	}

	ItsyScape.Resource.Item "BurntPork" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceName {
		Value = "Burnt pork",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntPork"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Smells pretty bad.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BurntPork"
	}

	ItsyScape.Meta.Item {
		Value = 1,
		Stackable = 1,
		Resource = ItsyScape.Resource.Item "BurntPork"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Cooking",
		Value = "BurntMeat",
		Resource = ItsyScape.Resource.Item "BurntPork"
	}
end
