--------------------------------------------------------------------------------
-- Resources/Game/DB/Init.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

_LOG_SUFFIX = "GameDB"

local Curve = require "ItsyScape.Game.Curve"

Game "ItsyScape"
	ResourceType "Object"
	ResourceType "Item"
	ResourceType "Skill"

	ResourceType "Peep" -- NPCs, mobs, whatever

	Meta "PeepStat" {
		Skill = Meta.TYPE_RESOURCE,
		Value = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepID" {
		Value = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "Peep" {
		Singleton = Meta.TYPE_INTEGER,
		SingletonID = Meta.TYPE_TEXT,
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
		Count = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepInventoryItem" {
		Item = Meta.TYPE_RESOURCE,
		Count = Meta.TYPE_INTEGER,
		Noted = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "None"

	ActionType "Bank"
	ActionType "Collect"

	ResourceType "Shop"
		ActionType "Shop"
		ActionType "Buy"
		
		Meta "Shop" {
			ExchangeRate = Meta.TYPE_REAL,
			Currency = Meta.TYPE_RESOURCE,
			Resource = Meta.TYPE_RESOURCE
		}

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

	Meta "MapObjectRectanglePassage" {
		X1 = Meta.TYPE_REAL,
		Z1 = Meta.TYPE_REAL,
		X2 = Meta.TYPE_REAL,
		Z2 = Meta.TYPE_REAL,
		Map = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "MapObjectReference" {
		Name = Meta.TYPE_TEXT,
		Map = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "MapObjectSize" {
		SizeX = Meta.TYPE_REAL,
		SizeY = Meta.TYPE_REAL,
		SizeZ = Meta.TYPE_REAL,
		OffsetX = Meta.TYPE_REAL,
		OffsetY = Meta.TYPE_REAL,
		OffsetZ = Meta.TYPE_REAL,
		SingleTile = Meta.TYPE_INTEGER,
		MapObject = Meta.TYPE_RESOURCE
	}

	Meta "PropMapObject" {
		Prop = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE,
		IsMultiLayer = Meta.TYPE_INTEGER
	}

	Meta "PeepMapObject" {
		Peep = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE
	}

	Meta "MapObjectGroup" {
		MapObjectGroup = Meta.TYPE_TEXT,
		Map = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE
	}

	Meta "NamedMapAction" {
		Name = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION,
		Map = Meta.TYPE_RESOURCE
	}

	ActionType "Travel"

	Meta "TravelDestination" {
		Map = Meta.TYPE_RESOURCE,
		Arguments = Meta.TYPE_TEXT,
		Anchor = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION
	}

	Meta "GatherableProp" {
		Health = Meta.TYPE_REAL,
		SpawnTime = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Talk"
	ActionType "Yell"

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
		Name = Meta.TYPE_TEXT,

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

	Meta "PeepSkin" {
		Type = Meta.TYPE_TEXT,
		Filename = Meta.TYPE_TEXT,
		Priority = Meta.TYPE_REAL,
		Slot = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PeepBody" {
		Type = Meta.TYPE_TEXT,
		Filename = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "Item" {
		Value = Meta.TYPE_REAL,
		Weight = Meta.TYPE_REAL,
		Untradeable = Meta.TYPE_INTEGER,
		Unnoteable = Meta.TYPE_INTEGER,
		Stackable = Meta.TYPE_INTEGER,
		HasUserdata = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "Prayer" {
		Drain = Meta.TYPE_INTEGER,
		IsNonCombat = Meta.TYPE_INTEGER,
		Style = Meta.TYPE_TEXT,
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

	Meta "ResourceCategoryGroup" {
		Key = Meta.TYPE_TEXT,
		Value = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Name = Meta.TYPE_TEXT,
		Tier = Meta.TYPE_INTEGER
	}

	Meta "ActionTypeVerb" {
		Value = Meta.TYPE_TEXT,
		XProgressive = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Type = Meta.TYPE_TEXT,
	}

	Meta "ActionVerb" {
		Value = Meta.TYPE_TEXT,
		XProgressive = Meta.TYPE_TEXT,
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
		ItsyScape.Meta.ActionTypeVerb {
			Value = "Equip",
			XProgressive = "Equipping",
			Language = "en-US",
			Type = "Equip"

		}

	ActionType "Dequip"
		ItsyScape.Meta.ActionTypeVerb {
			Value = "Dequip",
			XProgressive = "Dequipping",
			Language = "en-US",
			Type = "Dequip"

		}

	ActionType "Open"
	ActionType "Close"

	ActionType "Loot"
	ActionType "Reward"
	ResourceType "DropTable"

	Meta "DropTableEntry" {
		Item = Meta.TYPE_RESOURCE,
		Weight = Meta.TYPE_REAL,
		Count = Meta.TYPE_INTEGER,
		Range = Meta.TYPE_INTEGER,
		Noted = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "RewardEntry" {
		Action = Meta.TYPE_ACTION,
		Weight = Meta.TYPE_REAL
	}

	ActionType "Eat"
	Meta "HealingPower" {
		HitPoints = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	ResourceType "Quest"
		ActionType "QuestStep"
		ActionType "QuestStart"
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

	Meta "ActionEvent" {
		Event = Meta.TYPE_TEXT,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionEventTextArgument" {
		Value = Meta.TYPE_TEXT,
		Key = Meta.TYPE_TEXT,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionEventIntegerArgument" {
		Value = Meta.TYPE_INTEGER,
		Key = Meta.TYPE_TEXT,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionEventRealArgument" {
		Value = Meta.TYPE_REAL,
		Key = Meta.TYPE_TEXT,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionEventResourceArgument" {
		Value = Meta.TYPE_RESOURCE,
		Key = Meta.TYPE_TEXT,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionEventActionArgument" {
		Value = Meta.TYPE_ACTION,
		Key = Meta.TYPE_TEXT,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ActionEventTarget" {
		Value = Meta.TYPE_RESOURCE,
		Slot = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "ForagingAction" {
		Tier = Meta.TYPE_INTEGER,
		Factor = Meta.TYPE_REAL,
		Action = Meta.TYPE_ACTION
	}

	ActionType "Pull"
	ActionType "Sleep"

	ActionType "Dig"
	ActionType "DigUp"

	Meta "Cannon" {
		Range = Meta.TYPE_INTEGER,
		MinDamage = Meta.TYPE_INTEGER,
		MaxDamage = Meta.TYPE_INTEGER,
		Cannonball = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CookingFailedAction" {
		Output = Meta.TYPE_ACTION,
		Start = Meta.TYPE_INTEGER,
		Stop = Meta.TYPE_INTEGER,
		Action = Meta.TYPE_ACTION
	}

	Meta "Tier" {
		Tier = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "HiddenFromSkillGuide" {
		Action = Meta.TYPE_ACTION
	}

	ResourceType "Power"
	ActionType "Activate"

	Meta "CombatPowerCoolDown" {
		BaseCoolDown = Meta.TYPE_INTEGER,
		MaxReduction = Meta.TYPE_INTEGER,
		MinLevel = Meta.TYPE_INTEGER,
		MaxLevel = Meta.TYPE_INTEGER,
		Skill = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PowerSpec" {
		IsInstant = Meta.TYPE_INTEGER,
		IsQuick = Meta.TYPE_INTEGER,
		NoTarget = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Rotate"
	Meta "RotateActionDirection" {
		RotationX = Meta.TYPE_REAL,
		RotationY = Meta.TYPE_REAL,
		RotationZ = Meta.TYPE_REAL,
		RotationW = Meta.TYPE_REAL,
		Action = Meta.TYPE_ACTION
	}

	ActionType "Teleport"

	ResourceType "SailingShip"
	ResourceType "SailingItem"
	ResourceType "SailingCrew"
	ResourceType "SailingFirstMate"
	ResourceType "SailingMapAnchor"
	ResourceType "SailingSeaChart"
	ResourceType "SailingRandomEvent"
	ActionType "SailingBuy"
		ItsyScape.Meta.ActionTypeVerb {
			Value = "Buy",
			XProgressive = "Buying",
			Language = "en-US",
			Type = "SailingBuy"

		}
	ActionType "SailingUnlock"
		ItsyScape.Meta.ActionTypeVerb {
			Value = "Unlock",
			XProgressive = "Unlocking",
			Language = "en-US",
			Type = "SailingUnlock"

		}
	ActionType "Sail"
		ItsyScape.Meta.ActionTypeVerb {
			Value = "Sailing",
			XProgressive = "Sailing",
			Language = "en-US",
			Type = "Sailing"

		}

	Meta "SailingItemDetails" {
		Prop = Meta.TYPE_TEXT,
		CanCustomizeColor = Meta.TYPE_INTEGER,
		IsPirate = Meta.TYPE_INTEGER,
		ItemGroup = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "SailingItemStats" {
		Health = Meta.TYPE_INTEGER,
		Distance = Meta.TYPE_INTEGER,
		Defense = Meta.TYPE_INTEGER,
		Speed = Meta.TYPE_INTEGER,
		Storage = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "SailingItemGroupNameDescription" {
		ItemGroup = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Name = Meta.TYPE_TEXT,
		Description = Meta.TYPE_TEXT
	}

	Meta "SailingCrewName" {
		Value = Meta.TYPE_TEXT,
		Gender = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "SailingCrewClass" {
		Value = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "SailingMapLocation" {
		AnchorI = Meta.TYPE_REAL,
		AnchorJ = Meta.TYPE_REAL,
		RealityWarpDistanceMultiplier = Meta.TYPE_REAL,
		IsPort = Meta.TYPE_INTEGER,
		Map = Meta.TYPE_RESOURCE,
		SeaChart = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "MapSeaChart" {
		SeaChart = Meta.TYPE_RESOURCE,
		Map = Meta.TYPE_RESOURCE
	}

	Meta "ShipSailingItem" {
		Red1 = Meta.TYPE_INTEGER,
		Green1 = Meta.TYPE_INTEGER,
		Blue1 = Meta.TYPE_INTEGER,
		Red2 = Meta.TYPE_INTEGER,
		Green2 = Meta.TYPE_INTEGER,
		Blue2 = Meta.TYPE_INTEGER,
		IsColorCustomized = Meta.TYPE_INTEGER,
		Ship = Meta.TYPE_RESOURCE,
		SailingItem = Meta.TYPE_RESOURCE
	}

	Meta "SailingRandomEvent" {
		Weight = Meta.TYPE_INTEGER,
		IsPirate = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "SailingRandomEventIsland" {
		PositionX = Meta.TYPE_REAL,
		PositionY = Meta.TYPE_REAL,
		PositionZ = Meta.TYPE_REAL,
		Radius = Meta.TYPE_REAL,
		Map = Meta.TYPE_RESOURCE
	}

	ResourceType "Cutscene"

	Meta "CutsceneMapObject" {
		Name = Meta.TYPE_TEXT,
		Cutscene = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CutsceneMap" {
		Name = Meta.TYPE_TEXT,
		Cutscene = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE,
	}

	Meta "CutscenePeep" {
		Name = Meta.TYPE_TEXT,
		Cutscene = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CutsceneProp" {
		Name = Meta.TYPE_TEXT,
		Cutscene = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CutsceneCamera" {
		Name = Meta.TYPE_TEXT,
		Cutscene = Meta.TYPE_RESOURCE
	}

	ItsyScape.Resource.Peep "CameraDolly"

	ItsyScape.Meta.ResourceName {
		Value = "Camera dolly",
		Language = "en-US",
		Resource = ItsyScape.Resource.Peep "CameraDolly"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "It's a figment of your imagination.",
		Resource = ItsyScape.Resource.Peep "CameraDolly"
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.CameraDolly.CameraDolly",
		Resource = ItsyScape.Resource.Peep "CameraDolly"
	}

	ResourceType "Dream"

	Meta "DreamRequirement" {
		Map = Meta.TYPE_RESOURCE,
		KeyItem = Meta.TYPE_RESOURCE,
		Anchor = Meta.TYPE_TEXT,
		Dream = Meta.TYPE_RESOURCE
	}

	ActionType "ObtainSecondary"

	Meta "SecondaryWeight" {
		Weight = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "DynamicSkillMultiplier" {
		MinMultiplier = Meta.TYPE_INTEGER,
		MaxMultiplier = Meta.TYPE_INTEGER,
		MinLevel = Meta.TYPE_INTEGER,
		MaxLevel = Meta.TYPE_INTEGER,
		Skill = Meta.TYPE_RESOURCE,
		Action = Meta.TYPE_ACTION
	}

ItsyScape.Utility.xpForLevel = Curve.XP_CURVE
ItsyScape.Utility.valueForItem = Curve.VALUE_CURVE

local RESOURCE_CURVE = Curve(nil, nil, nil, nil)
ItsyScape.Utility.xpForResource = function(a)
	local point1 = RESOURCE_CURVE(a)
	local point2 = RESOURCE_CURVE(a + 1)
	return math.floor((point2 - point1) / 4)
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
ItsyScape.Utility.Weapon = {}
ItsyScape.Utility.Weapon.STYLE_NONE    = 0
ItsyScape.Utility.Weapon.STYLE_MAGIC   = 1
ItsyScape.Utility.Weapon.STYLE_ARCHERY = 2
ItsyScape.Utility.Weapon.STYLE_MELEE   = 3

ItsyScape.Utility.Vector = require "ItsyScape.Common.Math.Vector"
ItsyScape.Utility.Quaternion = require "ItsyScape.Common.Math.Quaternion"

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

do
	ItsyScape.Resource.Item "Null" {
		-- Nothing.
	}

	ItsyScape.Meta.Item {
		Untradeable = 1,
		Unnoteable = 1,
		Resource = ItsyScape.Resource.Item "Null"
	}

	ItsyScape.Meta.ResourceName {
		Value = "Null",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Null"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Better than a dwarf's head.",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "Null"
	}
end

-- Skills
include "Resources/Game/DB/Skills.lua"

-- Important key items
include "Resources/Game/DB/KeyItems.lua"

-- Items
-- Materials
include "Resources/Game/DB/Items/Tiers.lua"
include "Resources/Game/DB/Items/Tools.lua"
include "Resources/Game/DB/Items/Ores.lua"
include "Resources/Game/DB/Items/Logs.lua"
include "Resources/Game/DB/Items/Bars.lua"
include "Resources/Game/DB/Items/Runes.lua"
include "Resources/Game/DB/Items/Bones.lua"
include "Resources/Game/DB/Items/Fish.lua"
include "Resources/Game/DB/Items/Incense.lua"
include "Resources/Game/DB/Items/IncenseIngredients.lua"
include "Resources/Game/DB/Items/Leathers.lua"
include "Resources/Game/DB/Items/Feathers.lua" -- leathers, feathers, oh my
include "Resources/Game/DB/Items/Fabrics.lua"
include "Resources/Game/DB/Items/Gems.lua"
include "Resources/Game/DB/Items/Dyes.lua"
include "Resources/Game/DB/Items/PrideCapes.lua"
include "Resources/Game/DB/Items/Buckets.lua"
include "Resources/Game/DB/Items/Lanterns.lua"
include "Resources/Game/DB/Items/FruitTrees.lua"
include "Resources/Game/DB/Items/Meat.lua"
include "Resources/Game/DB/Items/MiningSecondaries.lua"
include "Resources/Game/DB/Items/Gunpowder.lua"

-- Equipment
include "Resources/Game/DB/Items/Amulets.lua"
include "Resources/Game/DB/Items/Arrows.lua"
include "Resources/Game/DB/Items/Bows.lua"
include "Resources/Game/DB/Items/Pickaxes.lua"
include "Resources/Game/DB/Items/Hatchets.lua"
include "Resources/Game/DB/Items/MetalEquipment.lua"
include "Resources/Game/DB/Items/LeatherArmor.lua"
include "Resources/Game/DB/Items/MagicArmor.lua"
include "Resources/Game/DB/Items/MagicWeapons.lua"
include "Resources/Game/DB/Items/MiscClothes.lua"
include "Resources/Game/DB/Items/Rusty.lua"
include "Resources/Game/DB/Items/ToyWeapons.lua"
include "Resources/Game/DB/Items/Trinkets.lua"
include "Resources/Game/DB/Items/PartyHats.lua"
include "Resources/Game/DB/Items/CreepyDoll.lua"
include "Resources/Game/DB/Items/SuperiorTier50.lua"
include "Resources/Game/DB/Items/AncientCeremonial.lua"
include "Resources/Game/DB/Items/IronFlamethrower.lua"
include "Resources/Game/DB/Items/Bullets.lua"
include "Resources/Game/DB/Items/Guns.lua"

-- Misc
include "Resources/Game/DB/Items/Currency.lua"
include "Resources/Game/DB/Items/MiscFood.lua"

-- Legendaries
include "Resources/Game/DB/Items/Legendaries/TimeTurner.lua"
include "Resources/Game/DB/Items/Legendaries/UnholySacrificialKnife.lua"
include "Resources/Game/DB/Items/Legendaries/Ganymede.lua"

-- Creeps
include "Resources/Game/DB/Creeps/Cow.lua"
include "Resources/Game/DB/Creeps/ChestMimic.lua"
include "Resources/Game/DB/Creeps/Chicken.lua"
include "Resources/Game/DB/Creeps/Goblin.lua"
include "Resources/Game/DB/Creeps/Nymph.lua"
include "Resources/Game/DB/Creeps/Skelemental.lua"
include "Resources/Game/DB/Creeps/Skeleton.lua"
include "Resources/Game/DB/Creeps/Zombi.lua"
include "Resources/Game/DB/Creeps/Ghost.lua"
include "Resources/Game/DB/Creeps/Mummy.lua"
include "Resources/Game/DB/Creeps/GoryMass.lua"
include "Resources/Game/DB/Creeps/FungalDemogorgon.lua"
include "Resources/Game/DB/Creeps/Sleepyrosy.lua"
include "Resources/Game/DB/Creeps/SaberToothShrimp.lua"
include "Resources/Game/DB/Creeps/MagmaSnail.lua"
include "Resources/Game/DB/Creeps/MagmaJellyfish.lua"
include "Resources/Game/DB/Creeps/Chocoroach.lua"
include "Resources/Game/DB/Creeps/Boop.lua"
include "Resources/Game/DB/Creeps/Theodyssius.lua"

-- Peeps
include "Resources/Game/DB/Peeps/Banker.lua"
include "Resources/Game/DB/Peeps/GeneralStoreOwner.lua"
include "Resources/Game/DB/Peeps/FishingStoreOwner.lua"
include "Resources/Game/DB/Peeps/Sailor.lua"
include "Resources/Game/DB/Peeps/Tutors.lua"
include "Resources/Game/DB/Peeps/Yendorian.lua"
include "Resources/Game/DB/Peeps/Tinkerer.lua"
include "Resources/Game/DB/Peeps/TheEmptyKing.lua"
include "Resources/Game/DB/Peeps/Drakkenson.lua"
include "Resources/Game/DB/Peeps/Svalbard.lua"

-- Gods
include "Resources/Game/DB/Gods/Yendor.lua"
include "Resources/Game/DB/Gods/Gammon.lua"

-- Shops
include "Resources/Game/DB/Shops/GeneralStore.lua"
include "Resources/Game/DB/Shops/FishingStore.lua"
include "Resources/Game/DB/Shops/Alchemist.lua"
include "Resources/Game/DB/Shops/Butcher.lua"

-- Spells
include "Resources/Game/DB/Spells/ModernMisc.lua"
include "Resources/Game/DB/Spells/ModernTeleports.lua"
include "Resources/Game/DB/Spells/ModernCombat.lua"

-- Prayers
include "Resources/Game/DB/Prayers/Murmurs.lua"

-- Powers
include "Resources/Game/DB/Powers/Magic.lua"
include "Resources/Game/DB/Powers/Archery.lua"
include "Resources/Game/DB/Powers/Melee.lua"
include "Resources/Game/DB/Powers/Defense.lua"

-- Misc gameplay things
include "Resources/Game/DB/Effects/Immunities.lua"
include "Resources/Game/DB/Effects/Misc.lua"

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
include "Resources/Game/DB/Props/Torch.lua"
include "Resources/Game/DB/Props/TrapDoor.lua"
include "Resources/Game/DB/Props/Furniture.lua"
include "Resources/Game/DB/Props/Range.lua"
include "Resources/Game/DB/Props/Bones.lua"
include "Resources/Game/DB/Props/Chandelier.lua"
include "Resources/Game/DB/Props/Azathoth.lua"
include "Resources/Game/DB/Props/Books.lua"
include "Resources/Game/DB/Props/Rocks.lua"
include "Resources/Game/DB/Props/Hole.lua"
include "Resources/Game/DB/Props/Doors.lua"
include "Resources/Game/DB/Props/OldOnesTech.lua"
include "Resources/Game/DB/Props/Stairs.lua"
include "Resources/Game/DB/Props/Shops.lua"
include "Resources/Game/DB/Props/ChemistTable.lua"

-- Sailing
include "Resources/Game/DB/Props/Sails.lua"
include "Resources/Game/DB/Props/Cannons.lua"
include "Resources/Game/DB/Props/BoatFoam.lua"
include "Resources/Game/DB/Props/Helms.lua"
include "Resources/Game/DB/Effects/Sailing.lua"
include "Resources/Game/DB/Sailing/General.lua"
include "Resources/Game/DB/Sailing/Tier1.lua"
include "Resources/Game/DB/Sailing/Crew.lua"
include "Resources/Game/DB/Sailing/FirstMates.lua"
include "Resources/Game/DB/Sailing/MapAnchors.lua"
include "Resources/Game/DB/Sailing/Coconut.lua"
include "Resources/Game/DB/Sailing/Maps.lua"
include "Resources/Game/DB/Sailing/Rowboat.lua"
include "Resources/Game/DB/Sailing/KeyItems.lua"
include "Resources/Game/DB/Sailing/RandomEvents.lua"

-- Maps
include "Resources/Game/DB/Maps/Rumbridge.lua"
include "Resources/Game/DB/Maps/PreTutorial/PreTutorial.lua"
include "Resources/Game/DB/Maps/Fungal/Fungal.lua"
include "Resources/Game/DB/Maps/Sailing.lua"

-- Quests
include "Resources/Game/DB/Quests/PreTutorial/Quest.lua"
include "Resources/Game/DB/Quests/CalmBeforeTheStorm/Quest.lua"
include "Resources/Game/DB/Quests/RavensEye/Quest.lua"
include "Resources/Game/DB/Quests/MysteriousMachinations/Quest.lua"

-- Minigames
include "Resources/Game/DB/Minigames/ChickenPolitickin.lua"

-- Drop tables
include "Resources/Game/DB/SharedDropTables/Pirate.lua"

-- Trailer
include "Resources/Game/DB/Trailer/Trailer.lua"

do
	ActionType "Debug_Ascend"
	ActionType "Debug_Teleport"
	ActionType "Debug_Save"

	local equipAction =  ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}

	local ascendAction = ItsyScape.Action.Debug_Ascend()
	local teleportAction = ItsyScape.Action.Debug_Teleport()
	local saveAction = ItsyScape.Action.Debug_Save()

	ItsyScape.Meta.ActionVerb {
		Value = "Ascend",
		XProgressive = "Ascending-to-godhood",
		Language = "en-US",
		Action = ascendAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Teleport",
		Language = "en-US",
		XProgressive = "Teleporting-through-dimensions",
		Action = teleportAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Save",
		XProgressive = "Saving-the-world",
		Language = "en-US",
		Action = saveAction
	}

	ItsyScape.Resource.Item "AmuletOfYendor" {
		equipAction,
		ItsyScape.Action.Dequip(),
		ascendAction,
		teleportAction,
		saveAction
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

	ItsyScape.Meta.ResourceDescription {
		Value = "The most divine artefact of the slain angel, granting godhood to those who possess it",
		Language = "en-US",
		Resource = ItsyScape.Resource.Item "AmuletOfYendor"
	}

	ItsyScape.Utility.tag(ItsyScape.Resource.Item "AmuletOfYendor", "x_debug")

	include "Resources/Game/DB/Items/ErrinTheHeathen.lua"
end
