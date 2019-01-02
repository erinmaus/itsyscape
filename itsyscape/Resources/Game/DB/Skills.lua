--------------------------------------------------------------------------------
-- Resources/Game/DB/Skills.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Skill "Magic"
	ActionType "Runecraft"

	ItsyScape.Meta.SkillAction {
		ActionType = "Runecraft",
		Skill = ItsyScape.Resource.Skill "Magic"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Cast",
		Skill = ItsyScape.Resource.Skill "Magic"
	}

ItsyScape.Resource.Skill "Wisdom"
ItsyScape.Resource.Skill "Archery"
ItsyScape.Resource.Skill "Dexterity"
ItsyScape.Resource.Skill "Strength"
ItsyScape.Resource.Skill "Attack"
ItsyScape.Resource.Skill "Defense"
ItsyScape.Resource.Skill "Constitution"

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Magic"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Wisdom"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Archery"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Dexterity"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Strength"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Attack"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Defense"
}

ItsyScape.Meta.SkillAction {
	ActionType = "Equip",
	Skill = ItsyScape.Resource.Skill "Constitution"
}

ItsyScape.Resource.Skill "Faith"
	ItsyScape.Meta.SkillAction {
		ActionType = "Bury",
		Skill = ItsyScape.Resource.Skill "Faith"
	}

	ActionType "Bury"

ItsyScape.Resource.Skill "Mining"
	ActionType "Mine"

	ItsyScape.Meta.SkillAction {
		ActionType = "Mine",
		Skill = ItsyScape.Resource.Skill "Mining"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Equip",
		Skill = ItsyScape.Resource.Skill "Mining"
	}

ItsyScape.Resource.Skill "Smithing"
	ActionType "Smith"
	ActionType "Smelt"

	ItsyScape.Meta.SkillAction {
		ActionType = "Smith",
		Skill = ItsyScape.Resource.Skill "Smithing"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Smelt",
		Skill = ItsyScape.Resource.Skill "Smithing"
	}

ItsyScape.Resource.Skill "Crafting"
	ActionType "Craft"

	ItsyScape.Meta.SkillAction {
		ActionType = "Craft",
		Skill = ItsyScape.Resource.Skill "Crafting"
	}

ItsyScape.Resource.Skill "Woodcutting"
	ActionType "Chop"

	ItsyScape.Meta.SkillAction {
		ActionType = "Chop",
		Skill = ItsyScape.Resource.Skill "Woodcutting"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Equip",
		Skill = ItsyScape.Resource.Skill "Woodcutting"
	}

ItsyScape.Resource.Skill "Firemaking"
	ActionType "Light"
	ActionType "Light_Prop"
		ItsyScape.Meta.ActionTypeVerb {
			Value = "Light",
			Language = "en-US",
			Type = "Light_Prop"
		}
	ActionType "Burn"

	ItsyScape.Meta.SkillAction {
		ActionType = "Light",
		Skill = ItsyScape.Resource.Skill "Firemaking"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Burn",
		Skill = ItsyScape.Resource.Skill "Firemaking"
	}

ItsyScape.Resource.Skill "Fletching"
	ActionType "Fletch"

	ItsyScape.Meta.SkillAction {
		ActionType = "Fletch",
		Skill = ItsyScape.Resource.Skill "Fletching"
	}

ItsyScape.Resource.Skill "Cooking"
	ActionType "Cook"

	ItsyScape.Meta.SkillAction {
		ActionType = "Cook",
		Skill = ItsyScape.Resource.Skill "Cooking"
	}

ItsyScape.Resource.Skill "Fishing"
	ActionType "Fish"

	ItsyScape.Meta.SkillAction {
		ActionType = "Fish",
		Skill = ItsyScape.Resource.Skill "Fishing"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Equip",
		Skill = ItsyScape.Resource.Skill "Fishing"
	}

ItsyScape.Resource.Skill "Sailing"
	ActionType "Fire"

	ItsyScape.Meta.SkillAction {
		ActionType = "Fire",
		Skill = ItsyScape.Resource.Skill "Dexterity"
	}

	ItsyScape.Meta.SkillAction {
		ActionType = "Fire",
		Skill = ItsyScape.Resource.Skill "Strength"
	}

--ItsyScape.Resource.Skill "Thieving"
	ActionType "Pickpocket"

ItsyScape.Meta.ResourceName {
	Value = "Magic",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Magic"
}

ItsyScape.Meta.ResourceName {
	Value = "Wisdom",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Wisdom"
}

ItsyScape.Meta.ResourceName {
	Value = "Archery",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Archery"
}

ItsyScape.Meta.ResourceName {
	Value = "Dexterity",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Dexterity"
}

ItsyScape.Meta.ResourceName {
	Value = "Strength",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Strength"
}

ItsyScape.Meta.ResourceName {
	Value = "Attack",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Attack"
}

ItsyScape.Meta.ResourceName {
	Value = "Defense",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Defense"
}

ItsyScape.Meta.ResourceName {
	Value = "Constitution",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Constitution"
}

ItsyScape.Meta.ResourceName {
	Value = "Faith",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Faith"
}

ItsyScape.Meta.ResourceName {
	Value = "Mining",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Mining"
}

ItsyScape.Meta.ResourceName {
	Value = "Smithing",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Smithing"
}

ItsyScape.Meta.ResourceName {
	Value = "Crafting",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Crafting"
}

ItsyScape.Meta.ResourceName {
	Value = "Woodcutting",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Woodcutting"
}

ItsyScape.Meta.ResourceName {
	Value = "Firemaking",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Firemaking"
}

ItsyScape.Meta.ResourceName {
	Value = "Fletching",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Fletching"
}

ItsyScape.Meta.ResourceName {
	Value = "Fletching",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Fletching"
}

ItsyScape.Meta.ResourceName {
	Value = "Fishing",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Fishing"
}

ItsyScape.Meta.ResourceName {
	Value = "Cooking",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Cooking"
}

ItsyScape.Meta.ResourceName {
	Value = "Sailing",
	Language = "en-US",
	Resource = ItsyScape.Resource.Skill "Sailing"
}
