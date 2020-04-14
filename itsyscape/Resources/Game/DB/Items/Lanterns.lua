--------------------------------------------------------------------------------
-- Resources/Game/DB/Items/Lanterns.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local CraftAction = ItsyScape.Action.OpenInventoryCraftWindow()

	ItsyScape.Meta.ActionVerb {
		Value = "Craft",
		Language = "en-US",
		Action = CraftAction
	}

	ItsyScape.Meta.DelegatedActionTarget {
		CategoryKey = "Lantern",
		ActionType = "Craft",
		Action = CraftAction
	}

	ItsyScape.Resource.Item "BullseyeLanternFrame" {
		ItsyScape.Action.Smith() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForLevel(15),
			},

			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(12),
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "IronBar",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BullseyeLanternFrame",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Smithing",
				Count = ItsyScape.Utility.xpForResource(15)
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(12)
			}
		},

		CraftAction
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Metal",
		Value = "Iron",
		Resource = ItsyScape.Resource.Item "BullseyeLanternFrame"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(16),
		Weight = 4.2,
		Resource = ItsyScape.Resource.Item "BullseyeLanternFrame"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bullseye lantern frame",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BullseyeLanternFrame"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Needs a lense and an enchantment to be useful.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BullseyeLanternFrame"
	}
end

do
	ItsyScape.Resource.Item "BullseyeLanternLense" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(12),
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "IronBlowpipe",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "BucketOfMoltenGlass",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BullseyeLanternLense",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(13)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Glass",
		Value = "Lense",
		Resource = ItsyScape.Resource.Item "BullseyeLanternLense"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(14),
		Weight = 0.2,
		Resource = ItsyScape.Resource.Item "BullseyeLanternLense"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Bullseye lantern lense",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BullseyeLanternLense"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Attach it to a bullseye lantern.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BullseyeLanternLense"
	}
end

do
	ItsyScape.Resource.Item "RainbowBullseyeLanternLense" {
		-- Nothing.
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Glass",
		Value = "Lense",
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLanternLense"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(25),
		Weight = 0.2,
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLanternLense"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Rainbow bullseye lantern lense",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLanternLense"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Attach it to a bullseye lantern.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLanternLense"
	}
end

do
	ItsyScape.Resource.Item "BullseyeLantern" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(12),
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "BullseyeLanternFrame",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "BullseyeLanternLense",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "BullseyeLantern",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(13)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Lantern",
		Value = "Bullseye",
		Resource = ItsyScape.Resource.Item "BullseyeLantern"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(18),
		Weight = 4.2,
		Resource = ItsyScape.Resource.Item "BullseyeLantern"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unlit bullseye lantern",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BullseyeLantern"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Needs an enchantment to be useful.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "BullseyeLantern"
	}
end

do
	ItsyScape.Resource.Item "LitBullseyeLantern" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Enchant() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(15)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CosmicRune",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "FireRune",
				Count = 10
			},
			
			Input {
				Resource = ItsyScape.Resource.Item "BullseyeLantern",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Item "LitBullseyeLantern",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForResource(15)
			}
		}
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_POCKET,
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Lantern",
		Value = "Bullseye",
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Enchanted",
		Value = "Iron",
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(20),
		Weight = 4.2,
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lit bullseye lantern",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Useful in dark places.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/BullseyeLantern/BullseyeLantern.lua",
		Resource = ItsyScape.Resource.Item "LitBullseyeLantern"
	}
end

do
	ItsyScape.Resource.Item "RainbowBullseyeLantern" {
		ItsyScape.Action.Craft() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForLevel(12),
			},

			Requirement {
				Resource = ItsyScape.Resource.Item "Hammer",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "BullseyeLanternFrame",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "RainbowBullseyeLanternLense",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Item "RainbowBullseyeLantern",
				Count = 1
			},

			Output {
				Resource = ItsyScape.Resource.Skill "Crafting",
				Count = ItsyScape.Utility.xpForResource(13)
			}
		}
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Lantern",
		Value = "Bullseye",
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLantern"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(25),
		Weight = 4.2,
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLantern"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Unlit rainbow bullseye lantern",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLantern"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Needs an enchantment to be useful.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "RainbowBullseyeLantern"
	}
end

do
	ItsyScape.Resource.Item "LitRainbowBullseyeLantern" {
		ItsyScape.Action.Equip(),
		ItsyScape.Action.Dequip(),
		ItsyScape.Action.Enchant() {
			Requirement {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForLevel(15)
			},

			Input {
				Resource = ItsyScape.Resource.Item "CosmicRune",
				Count = 1
			},

			Input {
				Resource = ItsyScape.Resource.Item "FireRune",
				Count = 10
			},
			
			Input {
				Resource = ItsyScape.Resource.Item "RainbowBullseyeLantern",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern",
				Count = 1
			},
			
			Output {
				Resource = ItsyScape.Resource.Skill "Magic",
				Count = ItsyScape.Utility.xpForResource(15)
			}
		}
	}

	ItsyScape.Meta.Equipment {
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_POCKET,
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Lantern",
		Value = "Bullseye",
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}

	ItsyScape.Meta.ResourceCategory {
		Key = "Enchanted",
		Value = "Iron",
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(30),
		Weight = 4.2,
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Lit rainbow bullseye lantern",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Helps with more than just phobias of the dark...",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/BullseyeLantern/BullseyeLantern_Rainbow.lua",
		Resource = ItsyScape.Resource.Item "LitRainbowBullseyeLantern"
	}
end
