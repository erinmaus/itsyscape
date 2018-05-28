--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

Game "ItsyScape"
	ResourceType "Object"
	ResourceType "Item"
	ResourceType "Skill"

	Meta "Equipment" {
			AccuracyStab = Meta.TYPE_INTEGER,
			AccuracySlash = Meta.TYPE_INTEGER,
			AccuracyCrush = Meta.TYPE_INTEGER,
			AccuracyMagic = Meta.TYPE_INTEGER,
			AccuracyRanged = Meta.TYPE_INTEGER,
			DefenceStab = Meta.TYPE_INTEGER,
			DefenceSlash = Meta.TYPE_INTEGER,
			DefenceCrush = Meta.TYPE_INTEGER,
			DefenceMagic = Meta.TYPE_INTEGER,
			DefenceRanged = Meta.TYPE_INTEGER,
			StrengthMelee = Meta.TYPE_INTEGER,
			StrengthRanged = Meta.TYPE_INTEGER,
			StrengthMagic = Meta.TYPE_INTEGER,
			Prayer = Meta.TYPE_INTEGER,
			Item = Meta.TYPE_RESOURCE
	}

	Meta "Item" {
		Name = Meta.TYPE_TEXT,
		Value = Meta.TYPE_INTEGER,
		Weight = Meta.TYPE_REAL
	}

	Meta "ItemTag" {
		Value = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Equip"

	include "Resources/Game/DB/Skills.lua"

function ItsyScape.Utility.xpForLevel(level)
	-- TODO
	return 1
end

function ItsyScape.Utility.xpForResource(item)
	-- TODO
	return 1
end

function ItsyScape.Utility.valueForItem(tier)
	-- TODO
	return 1
end

function ItsyScape.Utility.tag(Item, value)
	ItsyScape.Meta "ItemTag" {
		Value = value,
		Resource = Item
	}
end

ItsyScape.Resource.Item "Iron full helm" {
	ItsyScape.Action.Smith() {
		Input {
			Resource = ItsyScape.Resource.Item "Iron bar",
			Count = 2
		},

		Output {
			Resource = ItsyScape.Resource.Item "Iron full helm",
			Count = 1
		},

		Output {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = 50
		},

		Requirement {
			Resource = ItsyScape.Resource.Skill "Smithing",
			Count = ItsyScape.Utility.xpForLevel(22)
		},
	}
}