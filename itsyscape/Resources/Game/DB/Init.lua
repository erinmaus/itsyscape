--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Curve = require "ItsyScape.Game.Curve"

Game "ItsyScape"
	ResourceType "Object"
	ResourceType "Item"
	ResourceType "Skill"

	Meta "Equipment" {
			-- Various stats.
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

			-- The equip slot.
			--
			-- For a player, this corresponds to ItsyScape.Game.Equipment.PLAYER_SLOT_*.
			EquipSlot = Meta.TYPE_INTEGER,

			-- The equipment resource. Should be an Item.
			Resource = Meta.TYPE_RESOURCE
	}

	Meta "EquipmentModel" {
		Type = Meta.TYPE_TEXT,
		Filename = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "Item" {
		Value = Meta.TYPE_INTEGER,
		Weight = Meta.TYPE_REAL,
		Untradeable = Meta.TYPE_INTEGER,
		Unnoteable = Meta.TYPE_INTEGER,
		Stackable = Meta.TYPE_INTEGER,
		HasUserdata = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "ItemTag" {
		Value = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "ActionVerb" {
		Value = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION
	}

	Meta "ResourceName" {
		Value = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Equip"

ItsyScape.Utility.xpForLevel = Curve.XP_CURVE
ItsyScape.Utility.valueForItem = Curve.VALUE_CURVE
ItsyScape.Utility.xpForResource = function() return 1 end -- TODO
ItsyScape.Utility.Equipment = require "ItsyScape.Game.Equipment"

function ItsyScape.Utility.tag(Item, value)
	ItsyScape.Meta.ItemTag {
		Value = value,
		Resource = Item
	}
end

include "Resources/Game/DB/Skills.lua"

do
	local equipAction =  ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}

	ItsyScape.Resource.Item "AmuletOfYendor" {
		equipAction
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = 50,
		AccuracySlash = 50,
		AccuracyCrush = 50,
		AccuracyMagic = 50,
		AccuracyRanged = 50,
		DefenceStab = 50,
		DefenceSlash = 50,
		DefenceCrush = 50,
		DefenceMagic = 50,
		DefenceRanged = 50,
		StrengthMelee = 50,
		StrengthRanged = 50,
		StrengthMagic = 50,
		Prayer = 50,
		EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_NECK,
		Resource = ItsyScape.Resource.Item "AmuletOfYendor"
	}

	ItsyScape.Meta.EquipmentModel {
		Type = "ItsyScape.Game.Skin.ModelSkin",
		Filename = "Resources/Game/Skins/Amulets/AmuletOfYendor.lua",
		Resource = ItsyScape.Resource.Item "AmuletOfYendor"
	}

	ItsyScape.Meta.Item {
		Value = ItsyScape.Utility.valueForItem(120),
		Weight = -10,
		Untradeable = 1,
		Resource = ItsyScape.Resource.Item "AmuletOfYendor"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Amulet of Yendor",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AmuletOfYendor"
	}

	ItsyScape.Utility.tag(ItsyScape.Resource.Item "AmuletOfYendor", "x_debug")
end
