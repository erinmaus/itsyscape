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

	ResourceType "Peep" -- NPCs, mobs, whatever

	Meta "PeepStat" {
		Skill = Meta.TYPE_RESOURCE,
		Value = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepID" {
		Value = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepMashinaState" {
		State = Meta.TYPE_TEXT,
		Tree = Meta.TYPE_TEXT,
		IsDefault = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepEquipmentItem" {
		Item = Meta.TYPE_RESOURCE,
		Count = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepInventoryItem" {
		Item = Meta.TYPE_RESOURCE,
		Count = Meta.TYPE_INTEGER,
		Noted = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Bank"

	ResourceType "Shop"
	ActionType "Shop"
	ActionType "Buy"
	ActionType "Sell"

	Meta "ShopTarget" {
		Resource = Meta.TYPE_RESOURCE,
		Action = Meta.TYPE_ACTION
	}

	ResourceType "Prop" -- Trees, rocks, furnace, ...

	ResourceType "Map"
	ResourceType "MapObject"

	Meta "MapObjectLocation" {
		PositionX = Meta.TYPE_REAL,
		PositionY = Meta.TYPE_REAL,
		PositionZ = Meta.TYPE_REAL,
		RotationX = Meta.TYPE_REAL,
		RotationY = Meta.TYPE_REAL,
		RotationZ = Meta.TYPE_REAL,
		RotationW = Meta.TYPE_REAL,
		ScaleX = Meta.TYPE_REAL,
		ScaleY = Meta.TYPE_REAL,
		ScaleZ = Meta.TYPE_REAL,
		Direction = Meta.TYPE_REAL,
		Name = Meta.TYPE_TEXT,
		Map = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "MapObjectSize" {
		SizeX = Meta.TYPE_REAL,
		SizeY = Meta.TYPE_REAL,
		SizeZ = Meta.TYPE_REAL,
		MapObject = Meta.TYPE_RESOURCE
	}

	Meta "PropMapObject" {
		Prop = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE
	}

	Meta "PeepMapObject" {
		Peep = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE
	}

	ActionType "Travel"

	Meta "TravelDestination" {
		Map = Meta.TYPE_RESOURCE,
		Anchor = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION
	}

	Meta "GatherableProp" {
		Health = Meta.TYPE_REAL,
		SpawnTime = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Talk"

	Meta "TalkSpeaker" {
		Name = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE,
		Action = Meta.TYPE_ACTION
	}

	Meta "TalkDialog" {
		Script = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION
	}
	
	ActionType "OpenCraftWindow"          -- Invoked from world.
	ActionType "OpenInventoryCraftWindow" -- Invoked from inventory.
	ActionType "UseCraftWindow"

	Meta "DelegatedActionTarget" {
		CategoryKey = Meta.TYPE_TEXT,
		CategoryValue = Meta.TYPE_TEXT,
		ActionType = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION
	}

	ActionType "Attack"

	ResourceType "Spell"
	ActionType "Cast"

	Meta "CombatSpell" {
		Strength = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "Equipment" {
		-- Various stats.
		AccuracyStab = Meta.TYPE_INTEGER,
		AccuracySlash = Meta.TYPE_INTEGER,
		AccuracyCrush = Meta.TYPE_INTEGER,
		AccuracyMagic = Meta.TYPE_INTEGER,
		AccuracyRanged = Meta.TYPE_INTEGER,
		DefenseStab = Meta.TYPE_INTEGER,
		DefenseSlash = Meta.TYPE_INTEGER,
		DefenseCrush = Meta.TYPE_INTEGER,
		DefenseMagic = Meta.TYPE_INTEGER,
		DefenseRanged = Meta.TYPE_INTEGER,
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

	Meta "RangedAmmo" {
		Type = Meta.TYPE_INTEGER,
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

	Meta "ResourceTag" {
		Value = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "ResourceCategory" {
		Key = Meta.TYPE_TEXT,
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

	Meta "ResourceDescription" {
		Value = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "ActionDifficulty" {
		Value = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionSpawnProp" {
		Prop = Meta.TYPE_RESOURCE,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionSpawnPeep" {
		Peep = Meta.TYPE_RESOURCE,
		Action = Meta.TYPE_ACTION
	}

	ActionType "Equip"
	ActionType "Dequip"

	ActionType "Open"
	ActionType "Close"

	ActionType "Loot"
	ResourceType "DropTable"

	Meta "DropTableEntry" {
		Item = Meta.TYPE_RESOURCE,
		Weight = Meta.TYPE_REAL,
		Count = Meta.TYPE_INTEGER,
		Range = Meta.TYPE_INTEGER,
		Noted = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Eat"
	Meta "HealingPower" {
		HitPoints = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	ResourceType "Quest"
		ActionType "QuestStep"
		ActionType "QuestComplete"

	ResourceType "KeyItem"

	ResourceType "Effect"
	Meta "Enchantment" {
		Effect = Meta.TYPE_RESOURCE,
		Action = Meta.TYPE_ACTION
	}

	Meta "DebugAction" {
		Action = Meta.TYPE_ACTION
	}

	Meta "SkillAction" {
		ActionType = Meta.TYPE_TEXT,
		Skill = Meta.TYPE_RESOURCE
	}

	ActionType "Pick"
	ActionType "Sleep"

ItsyScape.Utility.xpForLevel = Curve.XP_CURVE
ItsyScape.Utility.valueForItem = Curve.VALUE_CURVE

local RESOURCE_CURVE = Curve(nil, nil, nil, 10)
ItsyScape.Utility.xpForResource = function(a)
	return RESOURCE_CURVE(a + 1)
end

-- Calculates the sum style bonus for an item of the specified tier.
--
-- Modifications should be made to 'tier' for stylistic reasons. The result
-- should be distributed among the armor pieces.
--
-- Weapons (offensive bonuses) are handled differently; use styleBonusForWeapon.
function ItsyScape.Utility.styleBonusForItem(tier, weight)
	weight = weight or 1

	local A = 1 / 40
	local B = 2
	local C = 10

	return math.floor(math.floor(A * tier ^ 2 + B * tier + C) * weight)
end

-- Calculates the style bonus for a weapon of the given 'tier'.
function ItsyScape.Utility.styleBonusForWeapon(tier, weight)
	return math.floor(ItsyScape.Utility.styleBonusForItem(tier + 10) / 3, weight)
end

function ItsyScape.Utility.strengthBonusForWeapon(tier, weight)
	local A = 1 / 100
	local B = 1.5
	local C = 5

	return math.floor(A * tier ^ 2 + B * tier + C)
end

ItsyScape.Utility.ARMOR_HELMET_WEIGHT     = 0.3
ItsyScape.Utility.ARMOR_BODY_WEIGHT       = 0.5
ItsyScape.Utility.ARMOR_GLOVES_WEIGHT     = 0.1
ItsyScape.Utility.ARMOR_BOOTS_WEIGHT      = 0.2
ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT   = 1.0
ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT = 0.8
ItsyScape.Utility.ARMOR_OFFENSIVE_WEIGHT  = 0.1

ItsyScape.Utility.Equipment = require "ItsyScape.Game.Equipment"

function ItsyScape.Utility.tag(resource, value)
	ItsyScape.Meta.ResourceTag {
		Value = value,
		Resource = resource
	}
end

function ItsyScape.Utility.categorize(resource, key, value)
	ItsyScape.Meta.ResourceCategory {
		Key = key,
		Value = value,
		Resource = resource
	}
end

function ItsyScape.Utility.questStep(from, to)
	if type(from) ~= 'table' then
		from = { from }
	end

	for i = 1, #from do
		ItsyScape.Resource.KeyItem(from[i]) {
			isSingleton = true
		}
	end

	local Step = ItsyScape.Action.QuestStep() {
		Output {
			Resource = ItsyScape.Resource.KeyItem(to),
			Count = 1
		}
	}

	for i = 1, #from do
		Step {
			Requirement {
				Resource = ItsyScape.Resource.KeyItem(from[i]),
				Count = 1
			}
		}
	end

	ItsyScape.Resource.KeyItem(to) {
		isSingleton = true,

		Step
	}
end

-- Skills
include "Resources/Game/DB/Skills.lua"

-- Items
-- Materials
include "Resources/Game/DB/Items/Tools.lua"
include "Resources/Game/DB/Items/Ores.lua"
include "Resources/Game/DB/Items/Logs.lua"
include "Resources/Game/DB/Items/Bars.lua"
include "Resources/Game/DB/Items/Runes.lua"
include "Resources/Game/DB/Items/Bones.lua"
include "Resources/Game/DB/Items/Incense.lua"
include "Resources/Game/DB/Items/IncenseIngredients.lua"
include "Resources/Game/DB/Items/Leathers.lua"
include "Resources/Game/DB/Items/Feathers.lua" -- leathers, feathers, oh my
include "Resources/Game/DB/Items/Fabrics.lua"

-- Equipment
include "Resources/Game/DB/Items/Arrows.lua"
include "Resources/Game/DB/Items/Bows.lua"
include "Resources/Game/DB/Items/Pickaxes.lua"
include "Resources/Game/DB/Items/Hatchets.lua"
include "Resources/Game/DB/Items/MetalArmor.lua"
include "Resources/Game/DB/Items/LeatherArmor.lua"
include "Resources/Game/DB/Items/MagicArmor.lua"
include "Resources/Game/DB/Items/MagicWeapons.lua"
include "Resources/Game/DB/Items/MiscClothes.lua"

-- Misc
include "Resources/Game/DB/Items/Currency.lua"
include "Resources/Game/DB/Items/MiscFood.lua"

-- Creeps
include "Resources/Game/DB/Creeps/Cow.lua"
include "Resources/Game/DB/Creeps/Chicken.lua"
include "Resources/Game/DB/Creeps/Goblin.lua"
include "Resources/Game/DB/Creeps/Nymph.lua"
include "Resources/Game/DB/Creeps/Skelemental.lua"
include "Resources/Game/DB/Creeps/Skeleton.lua"
include "Resources/Game/DB/Creeps/Zombi.lua"

-- Peeps
include "Resources/Game/DB/Peeps/Banker.lua"
include "Resources/Game/DB/Peeps/GeneralStoreOwner.lua"
include "Resources/Game/DB/Peeps/Yendorian.lua"

-- Shops
include "Resources/Game/DB/Shops/GeneralStore.lua"

-- Spells
include "Resources/Game/DB/Spells/ModernCombat.lua"

-- Props
include "Resources/Game/DB/Props/Anvil.lua"
include "Resources/Game/DB/Props/Flax.lua"
include "Resources/Game/DB/Props/Furnace.lua"
include "Resources/Game/DB/Props/SpinningWheel.lua"
include "Resources/Game/DB/Props/Chest.lua"
include "Resources/Game/DB/Props/Ladder.lua"
include "Resources/Game/DB/Props/Portals.lua"
include "Resources/Game/DB/Props/Gravestone.lua"
include "Resources/Game/DB/Props/Lights.lua"

-- Maps
include "Resources/Game/DB/Maps/Rumbridge.lua"

-- Quests
include "Resources/Game/DB/Quests/CalmBeforeTheStorm/Quest.lua"

do
	ActionType "Debug_Ascend"
	ActionType "Debug_Teleport"

	local equipAction =  ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(100)
		}
	}

	local ascendAction = ItsyScape.Action.Debug_Ascend()
	local teleportAction = ItsyScape.Action.Debug_Teleport()

	ItsyScape.Meta.ActionVerb {
		Value = "Ascend",
		Language = "en-US",
		Action = ascendAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Teleport",
		Language = "en-US",
		Action = teleportAction
	}

	ItsyScape.Resource.Item "AmuletOfYendor" {
		equipAction,
		ItsyScape.Action.Dequip(),
		ascendAction,
		teleportAction
	}

	ItsyScape.Meta.Equipment {
		AccuracyStab = 50,
		AccuracySlash = 50,
		AccuracyCrush = 50,
		AccuracyMagic = 50,
		AccuracyRanged = 50,
		DefenseStab = 50,
		DefenseSlash = 50,
		DefenseCrush = 50,
		DefenseMagic = 50,
		DefenseRanged = 50,
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

	include "Resources/Game/DB/Items/ErrinTheHeathen.lua"
end
