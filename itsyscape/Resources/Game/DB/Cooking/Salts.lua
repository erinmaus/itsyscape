--------------------------------------------------------------------------------
-- Resources/Game/DB/Cooking/Salts.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Item = ItsyScape.Resource.Item "FineSageSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineSageSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine sage salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase magical prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Magic",
		Boost = 3,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Boost = 3,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineDexterousSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineDexterousSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine dexterous salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase archery prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Archery",
		Boost = 3,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Boost = 3,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineKosherSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineKosherSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine kosher salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Has the ability to restore prayer.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 4,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineWarriorSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineWarriorSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine warrior salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase melee prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 3,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 3,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineToughSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineToughSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine tough salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase defensive capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Defense",
		Boost = 4,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineArtisanSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineArtisanSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine artisan salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase artisan capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Smithing",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Firemaking",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Crafting",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Cooking",
		Boost = 2,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineGathererSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineGathererSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine gatherer salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase gathering capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Mining",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Woodcutting",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Fishing",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Foraging",
		Boost = 2,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "FineAdventurerSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(10)
			},

			Input {
				Resource = ItsyScape.Resource.Item "FineAdventurerSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(11)
			}
		}
	}

	ItsyScape.Meta.ResourceName {
		Value = "Fine adventurer salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A salt good for cooking with. Can increase adventurering capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(11),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(11)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Antilogika",
		Boost = 2,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 2,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "SageSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "SageSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "SageSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Sage sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase magical prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Magic",
		Boost = 7,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Boost = 7,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "DexterousSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "DexterousSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "DexterousSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dexterous sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase archery prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Archery",
		Boost = 7,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Boost = 7,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "KosherSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "KosherSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "KosherSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Kosher sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Has the ability to restore prayer.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 8,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "WarriorSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "WarriorSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "WarriorSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Warrior sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase melee prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 7,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 7,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "ToughSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "ToughSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "ToughSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Tough sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase defensive capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Defense",
		Boost = 8,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "ArtisanSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "ArtisanSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "ArtisanSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Artisan sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase artisan capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Smithing",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Firemaking",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Crafting",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Cooking",
		Boost = 4,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "GathererSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "GathererSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "GathererSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Gatherer sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase gathering capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Mining",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Woodcutting",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Fishing",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Foraging",
		Boost = 4,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "AdventurerSeaSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Input {
				Resource = ItsyScape.Resource.Item "AdventurerSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(31)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForLevel(30)
			},

			Output {
				Resource = ItsyScape.Resource.Item "AdventurerSeaSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Fishing",
				Count = ItsyScape.Utility.xpForResource(20)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Adventurer sea salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A sea salt good for cooking with. Can increase adventurering capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(31),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(31)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Antilogika",
		Boost = 4,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 4,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseSageRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseSageRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseSageRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse sage rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase magical prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Magic",
		Boost = 14,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Wisdom",
		Boost = 14,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseDexterousRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseDexterousRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseDexterousRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse dexterous rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase archery prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Archery",
		Boost = 14,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Dexterity",
		Boost = 14,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseKosherRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseKosherRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseKosherRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse kosher rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Has the ability to restore prayer.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemPrayerRestorationUserdata"
	}

	ItsyScape.Meta.ItemPrayerRestorationUserdata {
		PrayerPoints = 20,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseWarriorRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseWarriorRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseWarriorRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse warrior rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase melee prowess.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Attack",
		Boost = 14,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Strength",
		Boost = 14,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseToughRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseToughRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseToughRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse tough rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase defensive capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Defense",
		Boost = 18,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseArtisanRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseArtisanRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseArtisanRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse artisan rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase artisan capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Smithing",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Firemaking",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Crafting",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Engineering",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Cooking",
		Boost = 8,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseGathererRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseGathererRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseGathererRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse gatherer rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase gathering capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Mining",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Woodcutting",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Fishing",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Foraging",
		Boost = 8,
		Resource = Item
	}
end

do
	local Item = ItsyScape.Resource.Item "CoarseAdventurerRockSalt" {
		ItsyScape.Action.CookIngredient() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CoarseAdventurerRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Cooking",
				Count = ItsyScape.Utility.xpForResource(51)
			}
		},

		ItsyScape.Action.ObtainSecondary() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForLevel(50)
			},

			Output {
				Resource = ItsyScape.Resource.Item "CoarseAdventurerRockSalt",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Mining",
				Count = ItsyScape.Utility.xpForResource(30)
			}
		}
	}

	ItsyScape.Meta.SecondaryWeight {
		Weight = 20,
		Resource = Item
	}

	ItsyScape.Meta.ResourceName {
		Value = "Coarse adventurer rock salt",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A coarse rock salt good for cooking with. Can increase adventurering capabilities.",
		Language = "en-US",
		Resource = Item
	}

	ItsyScape.Meta.Ingredient {
		Item = Item,
		Ingredient = ItsyScape.Resource.Ingredient "Salt"
	}

	ItsyScape.Meta.Item {
		Stackable = 1,
		Value = ItsyScape.Utility.valueForItem(51),
		Resource = Item
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemValueUserdata"
	}

	ItsyScape.Meta.ItemValueUserdata {
		Resource = Item,
		Value = ItsyScape.Utility.valueForItem(51)
	}

	ItsyScape.Meta.ItemUserdata {
		Item = Item,
		Userdata = ItsyScape.Resource.ItemUserdata "ItemStatBoostUserdata"
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Sailing",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Antilogika",
		Boost = 8,
		Resource = Item
	}

	ItsyScape.Meta.ItemStatBoostUserdata {
		Skill = ItsyScape.Resource.Skill "Necromancy",
		Boost = 8,
		Resource = Item
	}
end

