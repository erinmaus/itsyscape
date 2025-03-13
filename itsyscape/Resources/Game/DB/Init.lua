------------------------------------------------------------------------------
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
	ResourceType "ItemUserdata"
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

	Meta "PeepHealth" {
		Hitpoints = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "Dummy" {
		Tier = Meta.TYPE_INTEGER,
		CombatStyle = Meta.TYPE_INTEGER,

		Hitpoints = Meta.TYPE_INTEGER,
		Size = Meta.TYPE_REAL,

		Weapon = Meta.TYPE_TEXT,
		Shield = Meta.TYPE_TEXT,

		ChaseDistance = Meta.TYPE_REAL,
		AttackDistance = Meta.TYPE_REAL,
		AttackCooldown = Meta.TYPE_REAL,
		AttackProjectile = Meta.TYPE_TEXT,

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
		Count = Meta.TYPE_REAL,
		Noted = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	ResourceType "Boss"
	Meta "Boss" {
		Boss = Meta.TYPE_RESOURCE,
		Target = Meta.TYPE_RESOURCE,
		RequireKill = Meta.TYPE_INTEGER,
		Category = Meta.TYPE_TEXT
	}

	Meta "BossCategory" {
		Category = Meta.TYPE_TEXT,
		Name = Meta.TYPE_TEXT,
		Description = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT
	}

	Meta "BossDropTable" {
		Boss = Meta.TYPE_RESOURCE,
		DropTable = Meta.TYPE_RESOURCE
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

	Meta "PropAlias" {
		Alias = Meta.TYPE_RESOURCE,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "PropAnchor" {
		OffsetI = Meta.TYPE_INTEGER,
		OffsetJ = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

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
		Layer = Meta.TYPE_INTEGER,
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
		PanX = Meta.TYPE_REAL,
		PanY = Meta.TYPE_REAL,
		PanZ = Meta.TYPE_REAL,
		ZoomZ = Meta.TYPE_REAL,
		SingleTile = Meta.TYPE_INTEGER,
		MapObject = Meta.TYPE_RESOURCE
	}

	Meta "PropMapObject" {
		Prop = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE,
		IsMultiLayer = Meta.TYPE_INTEGER,
		DoesNotDespawn = Meta.TYPE_INTEGER,
		DoesNotRespawn = Meta.TYPE_INTEGER
	}

	Meta "PeepMapObject" {
		Peep = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE,
		DoesNotDespawn = Meta.TYPE_INTEGER,
		DoesNotRespawn = Meta.TYPE_INTEGER,
		DoesRespawn = Meta.TYPE_INTEGER
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

	Meta "NamedPeepAction" {
		Name = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION,
		Peep = Meta.TYPE_RESOURCE
	}

	ResourceType "Raid"

	Meta "RaidDestination" {
		Map = Meta.TYPE_RESOURCE,
		Anchor = Meta.TYPE_TEXT,
		Raid = Meta.TYPE_RESOURCE
	}

	Meta "RaidGroup" {
		Raid = Meta.TYPE_RESOURCE,
		Map = Meta.TYPE_RESOURCE
	}

	ActionType "Travel"
	ActionType "PartyTravel"

	Meta "TravelDestination" {
		Map = Meta.TYPE_RESOURCE,
		Arguments = Meta.TYPE_TEXT,
		Anchor = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION,
		IsInstance = Meta.TYPE_INTEGER
	}

	Meta "LocalTravelDestination" {
		Map = Meta.TYPE_RESOURCE,
		Anchor = Meta.TYPE_TEXT,
		Action = Meta.TYPE_ACTION
	}

	Meta "PartyTravelDestination" {
		Action = Meta.TYPE_ACTION,
		Raid = Meta.TYPE_RESOURCE,
		AnchorOverride = Meta.TYPE_TEXT
	}

	Meta "PartyTravelDestinationMapOverride" {
		Action = Meta.TYPE_ACTION,
		Raid = Meta.TYPE_RESOURCE,
		Map = Meta.TYPE_RESOURCE
	}

	Meta "GatherableProp" {
		Health = Meta.TYPE_REAL,
		SpawnTime = Meta.TYPE_REAL,
		Resource = Meta.TYPE_RESOURCE
	}

	ActionType "Talk"
	ActionType "Yell"
	ActionType "Pet"

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
	ActionType "InvisibleAttack"

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
		StrengthSailing = Meta.TYPE_INTEGER,
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

	Meta "PeepSkinColor" {
		Priority = Meta.TYPE_REAL,
		Slot = Meta.TYPE_INTEGER,
		Color = Meta.TYPE_TEXT,
		H = Meta.TYPE_REAL,
		S = Meta.TYPE_REAL,
		L = Meta.TYPE_REAL,
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

	Meta "ItemUserdata" {
		Item = Meta.TYPE_RESOURCE,
		Userdata = Meta.TYPE_RESOURCE
	}

	Meta "UserdataHint" {
		Value = Meta.TYPE_TEXT,
		Language = Meta.TYPE_TEXT,
		Userdata = Meta.TYPE_RESOURCE
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

	ActionType "Dresser_Search"

	ItsyScape.Meta.ActionTypeVerb {
		Value = "Search",
		XProgressive = "Searching",
		Language = "en-US",
		Type = "Dresser_Search"
	}

	ActionType "Loot"
	ActionType "Reward"
	ActionType "LootBag"
	ResourceType "DropTable"

	ItsyScape.Meta.ActionTypeVerb {
		Value = "Loot",
		XProgressive = "Looting",
		Language = "en-US",
		Type = "LootBag"
	}

	ResourceType "LootCategory"

	ItsyScape.Resource.LootCategory "Legendary"

	ItsyScape.Meta.ResourceName {
		Value = "Legendary",
		Language = "en-US",
		Resource = ItsyScape.Resource.LootCategory "Legendary"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The most desirable and rarest loot.",
		Language = "en-US",
		Resource = ItsyScape.Resource.LootCategory "Legendary"
	}

	ItsyScape.Resource.LootCategory "Special"

	ItsyScape.Meta.ResourceName {
		Value = "Special",
		Language = "en-US",
		Resource = ItsyScape.Resource.LootCategory "Special"
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Special loot, like for quests.",
		Language = "en-US",
		Resource = ItsyScape.Resource.LootCategory "Special"
	}

	Meta "LootCategory" {
		Item = Meta.TYPE_RESOURCE,
		Category = Meta.TYPE_RESOURCE
	}

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
		ActionType "QuestStart"
		ActionType "QuestStep"
		ActionType "QuestComplete"

	Meta "QuestStep" {
		StepID = Meta.TYPE_INTEGER,
		Quest = Meta.TYPE_RESOURCE,
		KeyItem = Meta.TYPE_RESOURCE,
		ParentID = Meta.TYPE_INTEGER,
		NextID = Meta.TYPE_INTEGER,
		PreviousID = Meta.TYPE_INTEGER
	}

	ResourceType "KeyItem"

	Meta "KeyItemLocationHint" {
		Map = Meta.TYPE_RESOURCE,
		MapObject = Meta.TYPE_RESOURCE,
		KeyItem = Meta.TYPE_RESOURCE
	}

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

	Meta "CombatPowerTier" {
		Tier = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CombatPowerZealCost" {
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
	ActionType "Teleport_Antilogika"
	ActionType "Teleport_AntilogikaReturn"

	Meta "AntilogikaTeleportDestination" {
		ReturnAnchor = Meta.TYPE_TEXT,
		ReturnMap = Meta.TYPE_RESOURCE,
		Portal = Meta.TYPE_RESOURCE
	}

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

	Meta "Cannon" {
		-- In degrees.
		MinXRotation = Meta.TYPE_REAL,
		MaxXRotation = Meta.TYPE_REAL,
		MinYRotation = Meta.TYPE_REAL,
		MaxYRotation = Meta.TYPE_REAL,

		Range = Meta.TYPE_INTEGER,
		AmmoType = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CannonballPathProperties" {
		Speed = Meta.TYPE_REAL,
		SpeedMultiplier = Meta.TYPE_REAL,
		SpeedOffset = Meta.TYPE_REAL,

		GravityX = Meta.TYPE_REAL,
		GravityY = Meta.TYPE_REAL,
		GravityZ = Meta.TYPE_REAL,
		GravityMultiplierX = Meta.TYPE_REAL,
		GravityMultiplierY = Meta.TYPE_REAL,
		GravityMultiplierZ = Meta.TYPE_REAL,
		GravityOffsetX = Meta.TYPE_REAL,
		GravityOffsetY = Meta.TYPE_REAL,
		GravityOffsetZ = Meta.TYPE_REAL,

		Drag = Meta.TYPE_REAL,
		DragMultiplier = Meta.TYPE_REAL,
		DragOffset = Meta.TYPE_REAL,

		Timestep = Meta.TYPE_REAL,
		TimestepMultiplier = Meta.TYPE_REAL,
		TimestepOffset = Meta.TYPE_REAL,

		MaxSteps = Meta.TYPE_INTEGER,
		MaxStepsMultiplier = Meta.TYPE_REAL,
		MaxStepsOffset = Meta.TYPE_REAL,

		Resource = Meta.TYPE_RESOURCE
	}

	Meta "CannonAmmo" {
		AmmoType = Meta.TYPE_INTEGER,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "MapShip" {
		SizeClass = Meta.TYPE_TEXT,
		Map = Meta.TYPE_RESOURCE
	}

	Meta "SailingItemDetails" {
		Prop = Meta.TYPE_TEXT,
		CanCustomizeColor = Meta.TYPE_INTEGER,
		IsPirate = Meta.TYPE_INTEGER,
		IsUnique = Meta.TYPE_INTEGER,
		ItemGroup = Meta.TYPE_TEXT,
		Resource = Meta.TYPE_RESOURCE
	}

	Meta "SailingItemStats" {
		Health = Meta.TYPE_INTEGER,
		Distance = Meta.TYPE_INTEGER,
		Defense = Meta.TYPE_INTEGER,
		Speed = Meta.TYPE_INTEGER,
		Turn = Meta.TYPE_INTEGER,
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

	Meta "ItemSailingItemMapping" {
		Item = Meta.TYPE_RESOURCE,
		SailingItem = Meta.TYPE_RESOURCE
	}

	Meta "ShipSailingItemMapObjectHotspot" {
		Slot = Meta.TYPE_TEXT,
		ItemGroup = Meta.TYPE_TEXT,
		MapObject = Meta.TYPE_RESOURCE,
		Map = Meta.TYPE_RESOURCE
	}

	Meta "ShipSailingItemPropHotspot" {
		Slot = Meta.TYPE_TEXT,
		ItemGroup = Meta.TYPE_TEXT,
		Prop = Meta.TYPE_RESOURCE,
		SailingItem = Meta.TYPE_RESOURCE
	}

	Meta "ShipSailingItem" {
		Red1 = Meta.TYPE_INTEGER,
		Green1 = Meta.TYPE_INTEGER,
		Blue1 = Meta.TYPE_INTEGER,
		Red2 = Meta.TYPE_INTEGER,
		Green2 = Meta.TYPE_INTEGER,
		Blue2 = Meta.TYPE_INTEGER,
		IsColorCustomized = Meta.TYPE_INTEGER,
		Slot = Meta.TYPE_TEXT,
		ItemGroup = Meta.TYPE_TEXT,
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

	ItsyScape.Meta.ActionTypeVerb {
		Value = "Obtain",
		XProgressive = "Obtain",
		Language = "en-US",
		Type = "ObtainSecondary"
	}

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

	ResourceType "Book"
	ItsyScape.Resource.Book "IsabellesJournal"
	ItsyScape.Resource.Book "Necronomicon"

do
	local Human = ItsyScape.Resource.Peep "Human"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Human.BaseHuman",
		Resource = Human
	}
end

ItsyScape.Utility.xpForLevel = Curve.XP_CURVE
ItsyScape.Utility.valueForItem = Curve.VALUE_CURVE
ItsyScape.Utility.CurveConfig = require "ItsyScape.Game.CurveConfig"

local RESOURCE_CURVE = Curve(nil, nil, nil, nil)
ItsyScape.Utility.xpForResource = function(a)
	local point1 = RESOURCE_CURVE(a)
	local point2 = RESOURCE_CURVE(a + 1)
	local xp = point2 - point1

	return math.floor(xp / ItsyScape.Utility.CurveConfig.SkillXP:evaluate(a) + 0.5)
end

-- Calculates the sum style bonus for an item of the specified tier.
--
-- Modifications should be made to 'tier' for stylistic reasons. The result
-- should be distributed among the armor pieces.
--
-- Weapons (offensive bonuses) are handled differently; use styleBonusForWeapon.
function ItsyScape.Utility.styleBonusForItem(tier, weight)
	weight = weight or 1
	return math.max(math.ceil(ItsyScape.Utility.CurveConfig.StyleBonus:evaluate(tier) * weight), 1)
end

-- Calculates the style bonus for a weapon of the given 'tier'.
function ItsyScape.Utility.styleBonusForWeapon(tier, weight)
	weight = weight or 1
	return math.max(math.ceil(ItsyScape.Utility.styleBonusForItem(tier + 10) / 3 * weight), 1)
end

function ItsyScape.Utility.strengthBonusForWeapon(tier, weight)
	weight = weight or 1
	return math.max(math.ceil(ItsyScape.Utility.CurveConfig.StrengthBonus:evaluate(tier) * weight), 1)
end

ItsyScape.Utility.ARMOR_HELMET_WEIGHT     = 19 / 100
ItsyScape.Utility.ARMOR_BODY_WEIGHT       = 42 / 100
ItsyScape.Utility.ARMOR_GLOVES_WEIGHT     = 12 / 100
ItsyScape.Utility.ARMOR_BOOTS_WEIGHT      = 14 / 100
ItsyScape.Utility.ARMOR_SHIELD_WEIGHT     = 31 / 100
ItsyScape.Utility.WEAPON_PRIMARY_WEIGHT   = 1.0
ItsyScape.Utility.WEAPON_SECONDARY_WEIGHT = 0.8
ItsyScape.Utility.ARMOR_OFFENSIVE_WEIGHT  = 1 / 3.5

function ItsyScape.Utility.styleBonusForHead(tier)
	return ItsyScape.Utility.styleBonusForItem(tier, ItsyScape.Utility.ARMOR_HELMET_WEIGHT)
end

function ItsyScape.Utility.styleBonusForBody(tier)
	return ItsyScape.Utility.styleBonusForItem(tier, ItsyScape.Utility.ARMOR_BODY_WEIGHT)
end

function ItsyScape.Utility.styleBonusForHands(tier)
	return ItsyScape.Utility.styleBonusForItem(tier, ItsyScape.Utility.ARMOR_GLOVES_WEIGHT)
end

function ItsyScape.Utility.styleBonusForFeet(tier)
	return ItsyScape.Utility.styleBonusForItem(tier, ItsyScape.Utility.ARMOR_BOOTS_WEIGHT)
end

function ItsyScape.Utility.styleBonusForShield(tier)
	return ItsyScape.Utility.styleBonusForItem(tier, ItsyScape.Utility.ARMOR_SHIELD_WEIGHT)
end


ItsyScape.Utility.Equipment = require "ItsyScape.Game.Equipment"
ItsyScape.Utility.Weapon = {}
ItsyScape.Utility.Weapon.STYLE_NONE    = 0
ItsyScape.Utility.Weapon.STYLE_MAGIC   = 1
ItsyScape.Utility.Weapon.STYLE_ARCHERY = 2
ItsyScape.Utility.Weapon.STYLE_MELEE   = 3

ItsyScape.Utility.Vector = require "ItsyScape.Common.Math.Vector"
ItsyScape.Utility.Quaternion = require "ItsyScape.Common.Math.Quaternion"
ItsyScape.Utility.Color = require "ItsyScape.Graphics.Color"

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

function ItsyScape.Utility.questStep(from, to, ActionType)
	if type(from) ~= 'table' then
		from = { from }
	end

	local Step = (ActionType or ItsyScape.Action.QuestStep)() {
		Output {
			Resource = ItsyScape.Resource.KeyItem(to),
			Count = 1
		}
	}

	for i = 1, #from do
		local resource = ItsyScape.Resource.KeyItem(from[i])
		local resourceRequirement = Requirement {
			Resource = resource,
			Count = 1
		}

		Step { resourceRequirement }

		resource {
			Step
		}
	end

	return Step
end

function ItsyScape.Utility.Quest(questName)
	local Quest = ItsyScape.Resource.Quest(questName)

	local id = 1
	local function resolve(steps, parent)
		for i = 1, #steps do
			local s = steps[i]

			if s.type == 'step' then
				if not (parent.id == 0 and i == #steps and steps[i - 1] and steps[i - 1].type == 'branch') then
					if i == 1 then
						s.parent = parent.id
					end

					s.id = id
					id = id + 1

					s.nodes = {}

					for j = 1, #s.inputs do
						s.nodes[j] = {
							keyItem = ItsyScape.Resource.KeyItem(s.inputs[j])
						}
					end

					if i > 1 then
						for j = 1, #steps[i - 1].nodes do
							steps[i - 1].nodes[j].next = s.id
						end

						for j = 1, #s.nodes do
							s.nodes[j].previous = steps[i - 1].id
						end
					end
				end
			elseif s.type == 'branch' then
				for j = 1, #s.branches do
					local branch = s.branches[j]
					resolve(branch, steps[i - 1])
				end
			else
				error("expected step or branch in quest")
			end
		end
	end


	local function materialize(steps)
		for i = 1, #steps do
			local step = steps[i]

			if step.type == 'step' then
				for j = 1, #step.nodes do
					ItsyScape.Meta.QuestStep {
						StepID = step.id,
						Quest = Quest,
						KeyItem = step.nodes[j].keyItem,
						ParentID = step.parent,
						NextID = step.nodes[j].next,
						PreviousID = step.nodes[j].previous
					}
				end
			elseif step.type == 'branch' then
				for j = 1, #step.branches do
					materialize(step.branches[j])
				end
			end
		end
	end

	return function(steps)
		if type(steps) ~= 'table' then
			error("expected table")
		end

		local Start = ItsyScape.Action.QuestStart() {
			Output {
				Resource = ItsyScape.Resource.KeyItem(steps[1].inputs[1]),
				Count = 1
			}
		}

		if steps.requirements then
			Start(steps.requirements)
		end

		local Complete = ItsyScape.Action.QuestComplete() {
			Requirement {
				Resource = ItsyScape.Resource.KeyItem(steps[#steps].inputs[1]),
				Count = 1
			}
		}

		if steps.rewards then
			Complete(steps.rewards)
		end

		Quest {
			Start,
			Complete
		}

		resolve(steps, { id = 0 })
		materialize(steps)
	end
end

function ItsyScape.Utility.QuestStep(inputs)
	if type(inputs) == 'string' then
		inputs = { inputs }
	end

	local result = {
		type = 'step',
		inputs = inputs,
		constraints = {},
		nodes = {}
	}

	local function __call(_, t)
		for i = 1, #t do
			table.insert(result.constraints, t[i])
		end

		return result
	end

	return setmetatable(result, { __call = __call })
end

function ItsyScape.Utility.QuestBranch(branches)
	return {
		type = 'branch',
		branches = branches,
		nodes = {}
	}
end

function ItsyScape.Utility.QuestStepDescription(keyItem)
	local KeyItem = ItsyScape.Resource.KeyItem(keyItem)
	return function(t)
		assert(type(t) == 'table', "missing description")
		assert(type(t.before) == 'string', "missing before description")
		assert(type(t.after) == 'string', "missing after description")

		ItsyScape.Meta.ResourceDescription {
			Value = t.before,
			Language = t.language or "en-US",
			Resource = KeyItem
		}

		ItsyScape.Meta.ResourceDescription {
			Value = t.after,
			Language = t.language or "en-US",
			Resource = KeyItem
		}
	end
end

function ItsyScape.Utility.skins(resource, skins)
	for _, skin in ipairs(skins) do
		local slot = skin.slot
		local priority = skin.priority
		local filename = skin.filename
		local resourceType = skin.type or "ItsyScape.Game.Skin.ModelSkin"

		if slot and priority and filename then
			ItsyScape.Meta.PeepSkin {
				Type = resourceType,
				Filename = string.format("Resources/Game/Skins/%s", filename),
				Priority = priority,
				Slot = slot,
				Resource = resource
			}

			for _, c in ipairs(skin.colors or {}) do
				if type(c) == "string" then
					ItsyScape.Meta.PeepSkinColor {
						Priority = priority,
						Slot = slot,
						Color = c,
						Resource = resource,
					}
				else
					ItsyScape.Meta.PeepSkinColor {
						Priority = priority,
						Slot = slot,
						Color = c.color or "ff0000",
						H = c.h,
						S = c.s,
						L = c.l,
						Resource = resource,
					}
				end
			end
		else
			local info = debug.getinfo(2, "Sl")
			local message = string.format(
				"%s:%d: Could not apply skin to resource: missing one or more fields (slot = %s, priority = %s, or filename = %s)",
				info.source, info.currentline,
				tostring(slot),
				tostring(priority),
				tostring(filename))
			ItsyScape.Error(message)
		end
	end
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
include "Resources/Game/DB/Userdata.lua"
include "Resources/Game/DB/Skills.lua"
include "Resources/Game/DB/Cooking/Init.lua"

-- Important key items
include "Resources/Game/DB/KeyItems.lua"
include "Resources/Game/DB/Peeps/Bosses.lua"

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
include "Resources/Game/DB/Items/Veggies.lua"
include "Resources/Game/DB/Items/Candles.lua"
include "Resources/Game/DB/Items/Isabellium.lua"
include "Resources/Game/DB/Items/TreeSecondaries.lua"
include "Resources/Game/DB/Items/EquipmentPlaceholders.lua"

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
include "Resources/Game/DB/Items/FishingRods.lua"
include "Resources/Game/DB/Items/UpAndComingHeroArmor.lua"

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
include "Resources/Game/DB/Creeps/YeastBeast.lua"
include "Resources/Game/DB/Creeps/RatKing.lua"
include "Resources/Game/DB/Creeps/SewerSpider.lua"
include "Resources/Game/DB/Creeps/GrubMite.lua"
include "Resources/Game/DB/Creeps/Rat.lua"
include "Resources/Game/DB/Creeps/TrashHeap.lua"
include "Resources/Game/DB/Creeps/AncientKaradon.lua"
include "Resources/Game/DB/Creeps/Pig.lua"
include "Resources/Game/DB/Creeps/Cheep.lua"
include "Resources/Game/DB/Creeps/Cthulhu.lua"
include "Resources/Game/DB/Creeps/Whale.lua"
include "Resources/Game/DB/Creeps/Behemoth.lua"
include "Resources/Game/DB/Creeps/PetrifiedSpider.lua"
include "Resources/Game/DB/Creeps/BarrelMimic.lua"
include "Resources/Game/DB/Creeps/CrateMimic.lua"
include "Resources/Game/DB/Creeps/Mantok.lua"
include "Resources/Game/DB/Creeps/Dummy.lua"

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
include "Resources/Game/DB/Peeps/Veggies.lua"
include "Resources/Game/DB/Peeps/BlackTentacle.lua"
include "Resources/Game/DB/Peeps/Humans.lua"
include "Resources/Game/DB/Peeps/Disemboweled.lua"
include "Resources/Game/DB/Peeps/ExperimentX.lua"

-- Gods
include "Resources/Game/DB/Gods/Yendor.lua"
include "Resources/Game/DB/Gods/Gammon.lua"

-- Shops
include "Resources/Game/DB/Shops/GeneralStore.lua"
include "Resources/Game/DB/Shops/FishingStore.lua"
include "Resources/Game/DB/Shops/Alchemist.lua"
include "Resources/Game/DB/Shops/Butcher.lua"
include "Resources/Game/DB/Shops/Crafter.lua"
include "Resources/Game/DB/Shops/CookingStore.lua"

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
do
	ItsyScape.Resource.Prop "Null" {
		-- Nothing.
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = ItsyScape.Resource.Prop "Null"
	}
end

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
include "Resources/Game/DB/Props/CSGBuilding.lua"
include "Resources/Game/DB/Props/Farm.lua"
include "Resources/Game/DB/Props/Altars.lua"
include "Resources/Game/DB/Props/MilkOMatic.lua"
include "Resources/Game/DB/Props/Target.lua"
include "Resources/Game/DB/Props/Sky.lua"
include "Resources/Game/DB/Props/Jungle.lua"

-- Cooking
include "Resources/Game/DB/Cooking/Ingredients.lua"
include "Resources/Game/DB/Cooking/Recipes.lua"

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
include "Resources/Game/DB/Sailing/NPC.lua"
include "Resources/Game/DB/Sailing/Ships/Exquisitor.lua"

-- Maps
include "Resources/Game/DB/Maps/Rumbridge.lua"
include "Resources/Game/DB/Maps/ViziersRock.lua"
include "Resources/Game/DB/Maps/PreTutorial/PreTutorial.lua"
include "Resources/Game/DB/Maps/Fungal/Fungal.lua"
include "Resources/Game/DB/Maps/Sailing.lua"
include "Resources/Game/DB/Maps/EmptyRuins.lua"
include "Resources/Game/DB/Maps/Yendorian.lua"

-- Quests
include "Resources/Game/DB/Quests/IslandsOfMadness/Quest.lua"
include "Resources/Game/DB/Quests/CalmBeforeTheStorm/Quest.lua"
include "Resources/Game/DB/Quests/RavensEye/Quest.lua"
include "Resources/Game/DB/Quests/MysteriousMachinations/Quest.lua"
include "Resources/Game/DB/Quests/SuperSupperSaboteur/Quest.lua"

-- Minigames
include "Resources/Game/DB/Minigames/ChickenPolitickin.lua"

-- Drop tables
include "Resources/Game/DB/SharedDropTables/Pirate.lua"
include "Resources/Game/DB/SharedDropTables/Human.lua"

-- Trailer
include "Resources/Game/DB/Trailer/Trailer.lua"

-- Art
include "Resources/Game/DB/Art/Rage/Rage.lua"

do
	ActionType "Debug_Ascend"
	ActionType "Debug_Teleport"
	ActionType "Debug_Save"
	ActionType "Debug_AntilogikaTeleport"
	ActionType "Debug_AntilogikaWarp"
	ActionType "Debug_AntilogikaNoise"

	local equipAction =  ItsyScape.Action.Equip() {
		Requirement {
			Resource = ItsyScape.Resource.Skill "Magic",
			Count = ItsyScape.Utility.xpForLevel(10)
		}
	}

	local ascendAction = ItsyScape.Action.Debug_Ascend()
	local teleportAction = ItsyScape.Action.Debug_Teleport()
	local saveAction = ItsyScape.Action.Debug_Save()
	local antilogikaTeleportAction = ItsyScape.Action.Debug_AntilogikaTeleport()
	local antilogikaWarpAction = ItsyScape.Action.Debug_AntilogikaWarp()
	local antilogikaNoiseAction = ItsyScape.Action.Debug_AntilogikaNoise()

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
		Value = "Teleport-Antilogika",
		Language = "en-US",
		XProgressive = "Teleporting-through-random-dimensions",
		Action = antilogikaTeleportAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Warp-Dimensions-Antilogika",
		Language = "en-US",
		XProgressive = "Warping-dimensions'",
		Action = antilogikaWarpAction
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Generate-Noise-Antilogika",
		Language = "en-US",
		XProgressive = "Warping-dimensions'",
		Action = antilogikaNoiseAction
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
		antilogikaTeleportAction,
		antilogikaWarpAction,
		antilogikaNoiseAction,
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
