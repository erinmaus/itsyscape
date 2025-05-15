local M = include "Resources/Game/Maps/Sailing_HumanityEdge/DB/Default.lua"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Maps.Sailing_HumanityEdge.Peep",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceName {
	Value = "Humanity's Edge",
	Language = "en-US",
	Resource = M._MAP
}

ItsyScape.Meta.ResourceDescription {
	Value = "The edge between humanity and the corpse islands of Yendor's sprawling necropolis archipelago.",
	Language = "en-US",
	Resource = M._MAP
}

M["Light_Ambient"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Ambient",
		Map = M._MAP,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AmbientLight_Default",
		MapObject = M["Light_Ambient"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 231,
		ColorGreen = 168,
		ColorBlue = 194,
		Resource = M["Light_Ambient"]
	}

	ItsyScape.Meta.AmbientLight {
		Ambience = 0.4,
		Resource = M["Light_Ambient"]
	}
end

M["Light_Sun"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Sun",
		Map = M._MAP,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "DirectionalLight_Default",
		MapObject = M["Light_Sun"]
	}

	ItsyScape.Meta.Light {
		ColorRed = 234,
		ColorGreen = 162,
		ColorBlue = 33,
		Resource = M["Light_Sun"]
	}

	ItsyScape.Meta.DirectionalLight {
		DirectionX = 4,
		DirectionY = 3,
		DirectionZ = 4,
		CastsShadows = 1,
		Resource = M["Light_Sun"]
	}
end

M["Light_Fog"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Light_Fog",
		Map = M._MAP,
		Resource = M["Light_Fog"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Fog_Default",
		MapObject = M["Light_Fog"]
	}
end

M["Water"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Water",
		Map = M._MAP,
		Resource = M["Water"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "EndlessWater",
		MapObject = M["Water"]
	}
end

M["YendorianShipFire1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 128,
		PositionY = 0,
		PositionZ = -16,
		ScaleX = 48,
		ScaleY = 48,
		ScaleZ = 48,
		Name = "YendorianShipFire1",
		Map = M._MAP,
		Resource = M["YendorianShipFire1"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["YendorianShipFire1"]
	}
end

M["YendorianShipFire2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 112,
		PositionY = 0,
		PositionZ = -18,
		ScaleX = 24,
		ScaleY = 24,
		ScaleZ = 24,
		Name = "YendorianShipFire2",
		Map = M._MAP,
		Resource = M["YendorianShipFire2"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["YendorianShipFire2"]
	}
end

M["YendorianShipFire3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 144,
		PositionY = 0,
		PositionZ = -14,
		ScaleX = 28,
		ScaleY = 28,
		ScaleZ = 28,
		Name = "YendorianShipFire3",
		Map = M._MAP,
		Resource = M["YendorianShipFire3"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Art_Rage_Fire",
		MapObject = M["YendorianShipFire3"]
	}
end

M["Fireflies"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 0,
		PositionY = 0,
		PositionZ = 0,
		Name = "Fireflies",
		Map = M._MAP,
		Resource = M["Fireflies"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Firefly_Default",
		MapObject = M["Fireflies"]
	}
end

M["Anchor_Spawn"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 141,
		PositionY = 3,
		PositionZ = 173,
		Direction = -1,
		Name = "Anchor_Spawn",
		Map = M._MAP,
		Resource = M["Anchor_Spawn"]
	}
end

M["Anchor_MeetKnightCommander"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 99,
		PositionY = 3,
		PositionZ = 167,
		Name = "Anchor_MeetKnightCommander",
		Map = M._MAP,
		Resource = M["Anchor_MeetKnightCommander"]
	}
end

M["Anchor_EncounterYendorianScout"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 61,
		PositionY = 3,
		PositionZ = 177,
		Name = "Anchor_EncounterYendorianScout",
		Map = M._MAP,
		Resource = M["Anchor_EncounterYendorianScout"]
	}
end

M["Anchor_DefeatYendorianScout"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 3,
		PositionZ = 163,
		Name = "Anchor_DefeatYendorianScout",
		Map = M._MAP,
		Resource = M["Anchor_DefeatYendorianScout"]
	}
end

M["Anchor_EncounterYenderhounds"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 53,
		PositionY = 6,
		PositionZ = 158,
		Name = "Anchor_EncounterYenderhounds",
		Map = M._MAP,
		Resource = M["Anchor_EncounterYenderhounds"]
	}
end

M["Anchor_KnightCommander_StandGuard_Fish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 5,
		PositionZ = 165,
		Name = "Anchor_KnightCommander_StandGuard_Fish",
		Map = M._MAP,
		Resource = M["Anchor_KnightCommander_StandGuard_Fish"]
	}
end

M["Anchor_Orlando_PostFish"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 64,
		PositionY = 4.5,
		PositionZ = 149,
		Name = "Anchor_Orlando_PostFish",
		Map = M._MAP,
		Resource = M["Anchor_Orlando_PostFish"]
	}
end

M["Anchor_Orlando_Duel"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 67,
		PositionY = 5,
		PositionZ = 161,
		Direction = -1,
		Name = "Anchor_Orlando_Duel",
		Map = M._MAP,
		Resource = M["Anchor_Orlando_Duel"]
	}
end

M["Anchor_KnightCommander_Duel"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 5,
		PositionZ = 157,
		Direction = -1,
		Name = "Anchor_KnightCommander_Duel",
		Map = M._MAP,
		Resource = M["Anchor_KnightCommander_Duel"]
	}
end

M["Anchor_Player_Duel"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 63,
		PositionY = 5,
		PositionZ = 161,
		Direction = 1,
		Name = "Anchor_Player_Duel",
		Map = M._MAP,
		Resource = M["Anchor_Player_Duel"]
	}
end

M["Anchor_Peak"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 131,
		PositionY = 16,
		PositionZ = 79,
		Name = "Anchor_Peak",
		Map = M._MAP,
		Resource = M["Anchor_Peak"]
	}
end

M["PeakYendorian1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_PeakObstacles",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["PeakYendorian1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 119,
		PositionY = 5,
		PositionZ = 139,
		Direction = 1,
		Name = "PeakYendorian1",
		Map = M._MAP,
		Resource = M["PeakYendorian1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Swordfish",
		MapObject = M["PeakYendorian1"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AggressiveIdleLogic.lua",
		IsDefault = 1,
		Resource = M["PeakYendorian1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_RiteLogic.lua",
		Resource = M["PeakYendorian1"]
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 100,
		Resource = M["PeakYendorian1"]
	}

	ItsyScape.Meta.Equipment {
		AccuracyRanged = ItsyScape.Utility.styleBonusForWeapon(30, 1),
		DefenseStab = -1000,
		DefenseSlash = -1000,
		DefenseCrush = -1000,
		DefenseMagic = -1000,
		DefenseRanged = -1000,
		Prayer = 55,
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(30),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["PeakYendorian1"]
	}

	M["PeakYendorian1"] {
		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Sailing_HumanityEdge_MiscDropTable",
				Count = 1
			}
		}
	}
end

M["PeakYendorian2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_PeakObstacles",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["PeakYendorian2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 157,
		PositionY = 5,
		PositionZ = 125,
		Direction = 1,
		Name = "PeakYendorian2",
		Map = M._MAP,
		Resource = M["PeakYendorian2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
		MapObject = M["PeakYendorian2"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AggressiveIdleLogic.lua",
		IsDefault = 1,
		Resource = M["PeakYendorian2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_DeflectLogic.lua",
		Resource = M["PeakYendorian2"]
	}

	ItsyScape.Meta.PeepHealth {
		Hitpoints = 100,
		Resource = M["PeakYendorian2"]
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = ItsyScape.Utility.styleBonusForWeapon(30, 1),
		DefenseStab = -1000,
		DefenseSlash = -1000,
		DefenseCrush = -1000,
		DefenseMagic = -1000,
		DefenseRanged = -1000,
		Prayer = 55,
		StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(30),
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["PeakYendorian2"]
	}

	M["PeakYendorian2"] {
		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Sailing_HumanityEdge_MiscDropTable",
				Count = 1
			}
		}
	}
end

M["PeakYenderhound"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_PeakObstacles",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["PeakYenderhound"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 175,
		PositionY = 9,
		PositionZ = 113,
		Direction = 1,
		Name = "PeakYenderhound",
		Map = M._MAP,
		Resource = M["PeakYenderhound"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yenderhound",
		MapObject = M["PeakYenderhound"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AttackLogic.lua",
		Resource = M["PeakYenderhound"]
	}

	M["PeakYenderhound"] {
		ItsyScape.Action.Loot() {
			Output {
				Resource = ItsyScape.Resource.DropTable "Sailing_HumanityEdge_MiscDropTable",
				Count = 1
			}
		}
	}
end

M["Battle1_Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattlePirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle1_Pirate1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 153,
		PositionY = 3,
		PositionZ = 17,
		Direction = 1,
		Name = "Battle1_Pirate1",
		Map = M._MAP,
		Resource = M["Battle1_Pirate1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle1_Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyMusket",
		Count = 1,
		Resource = M["Battle1_Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBullet",
		Count = 10000,
		Resource = M["Battle1_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle1_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua",
		Resource = M["Battle1_Pirate1"]
	}

	M["Battle1_Pirate1"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle1_Pirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattlePirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle1_Pirate2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 155,
		PositionY = 3,
		PositionZ = 17,
		Direction = 1,
		Name = "Battle1_Pirate2",
		Map = M._MAP,
		Resource = M["Battle1_Pirate2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle1_Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyPistol",
		Count = 1,
		Resource = M["Battle1_Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBullet",
		Count = 10000,
		Resource = M["Battle1_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle1_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua",
		Resource = M["Battle1_Pirate2"]
	}

	M["Battle1_Pirate2"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle1_Yendorian"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattleYendorians",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle1_Yendorian"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 155,
		PositionY = 3,
		PositionZ = 17,
		Direction = 1,
		Name = "Battle1_Yendorian",
		Map = M._MAP,
		Resource = M["Battle1_Yendorian"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Ballista",
		MapObject = M["Battle1_Yendorian"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AttackLogic.lua",
		Resource = M["Battle1_Yendorian"]
	}
end

M["Battle2_Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattlePirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle2_Pirate1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 155,
		PositionY = 3,
		PositionZ = 25,
		Direction = 1,
		Name = "Battle2_Pirate1",
		Map = M._MAP,
		Resource = M["Battle2_Pirate1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle2_Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBlunderbuss",
		Count = 1,
		Resource = M["Battle2_Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBullet",
		Count = 10000,
		Resource = M["Battle2_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle2_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua",
		Resource = M["Battle2_Pirate1"]
	}

	M["Battle2_Pirate1"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle2_Pirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattlePirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle2_Pirate2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 153,
		PositionY = 3,
		PositionZ = 25,
		Direction = 1,
		Name = "Battle2_Pirate2",
		Map = M._MAP,
		Resource = M["Battle2_Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyMusket",
		Count = 1,
		Resource = M["Battle2_Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBullet",
		Count = 10000,
		Resource = M["Battle2_Pirate2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle2_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle2_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua",
		Resource = M["Battle2_Pirate2"]
	}

	M["Battle2_Pirate2"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle2_Yendorian"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattleYendorians",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle2_Yendorian"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 157,
		PositionY = 3,
		PositionZ = 25,
		Direction = 1,
		Name = "Battle2_Yendorian",
		Map = M._MAP,
		Resource = M["Battle2_Yendorian"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Mast",
		MapObject = M["Battle2_Yendorian"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle2_Yendorian"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AttackLogic.lua",
		Resource = M["Battle2_Yendorian"]
	}
end

M["Battle3_Pirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattlePirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle3_Pirate1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 163,
		PositionY = 3,
		PositionZ = 47,
		Name = "Battle3_Pirate1",
		Map = M._MAP,
		Resource = M["Battle3_Pirate1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle3_Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBlunderbuss",
		Count = 1,
		Resource = M["Battle3_Pirate1"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBullet",
		Count = 10000,
		Resource = M["Battle3_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle3_Pirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua",
		Resource = M["Battle3_Pirate1"]
	}

	M["Battle3_Pirate1"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle3_Pirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattlePirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle3_Pirate2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 175,
		PositionY = 3,
		PositionZ = 47,
		Name = "Battle3_Pirate2",
		Map = M._MAP,
		Resource = M["Battle3_Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyMusket",
		Count = 1,
		Resource = M["Battle3_Pirate2"]
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyBullet",
		Count = 10000,
		Resource = M["Battle3_Pirate2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle3_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle3_Pirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Pirate_AttackLogic.lua",
		Resource = M["Battle3_Pirate2"]
	}

	M["Battle3_Pirate2"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle3_Yendorian"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_BattleYendorians",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Battle3_Yendorian"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 169,
		PositionY = 3,
		PositionZ = 47,
		Name = "Battle3_Yendorian",
		Map = M._MAP,
		Resource = M["Battle3_Yendorian"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Swordfish",
		MapObject = M["Battle3_Yendorian"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle3_Yendorian"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yendorian_AttackLogic.lua",
		Resource = M["Battle3_Yendorian"]
	}
end

M["Battle_ShipPirate1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Battle_ShipPirate1",
		Map = M._MAP,
		Resource = M["Battle_ShipPirate1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle_ShipPirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "gun-yendorians",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle_ShipPirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "gun-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_Phase4Logic.lua",
		Resource = M["Battle_ShipPirate1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "gun-player-cutscene",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_CutsceneLogic.lua",
		Resource = M["Battle_ShipPirate1"]
	}

	M["Battle_ShipPirate1"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Battle_ShipPirate2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Battle_ShipPirate2",
		Map = M._MAP,
		Resource = M["Battle_ShipPirate2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["Battle_ShipPirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "gun-yendorians",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Battle_ShipPirate2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "gun-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Gunner_Phase4Logic.lua",
		Resource = M["Battle_ShipPirate2"]
	}

	M["Battle_ShipPirate2"] {
		ItsyScape.Action.InvisibleAttack()
	}
end

M["Anchor_Cutscene_Ships1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 188,
		PositionY = 0,
		PositionZ = 16,
		Name = "Anchor_Cutscene_Ships1",
		Map = M._MAP,
		Resource = M["Anchor_Cutscene_Ships1"]
	}
end

M["Anchor_Cutscene_Ships2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 128,
		PositionY = 0,
		PositionZ = 8,
		Name = "Anchor_Cutscene_Ships2",
		Map = M._MAP,
		Resource = M["Anchor_Cutscene_Ships2"]
	}
end

M["Anchor_Cutscene_Peak1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 131,
		PositionY = 36,
		PositionZ = 79,
		Name = "Anchor_Cutscene_Peak1",
		Map = M._MAP,
		Resource = M["Anchor_Cutscene_Peak1"]
	}
end

M["Anchor_Cutscene_Peak2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 157,
		PositionY = 48,
		PositionZ = 57,
		Name = "Anchor_Cutscene_Peak2",
		Map = M._MAP,
		Resource = M["Anchor_Cutscene_Peak2"]
	}
end

M["Anchor_Cutscene_Peak3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 171,
		PositionY = 3,
		PositionZ = 35,
		Name = "Anchor_Cutscene_Peak3",
		Map = M._MAP,
		Resource = M["Anchor_Cutscene_Peak3"]
	}
end

M["Anchor_Dolly_KeelhaulerSpawn_Done"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 159,
		PositionY = 3,
		PositionZ = 55,
		Direction = 1,
		Name = "Anchor_Dolly_KeelhaulerSpawn_Done",
		Map = M._MAP,
		Resource = M["Anchor_Dolly_KeelhaulerSpawn_Done"]
	}
end

M["Keelhauler"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Keelhauler",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Keelhauler"]
	}

	local rotation = ItsyScape.Utility.Quaternion.Y_90:slerp(ItsyScape.Utility.Quaternion.Y_180, 0.5):getNormal()

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 159,
		PositionY = 3,
		PositionZ = 55,
		RotationX = rotation.x,
		RotationY = rotation.y,
		RotationZ = rotation.z,
		RotationW = rotation.w,
		Name = "Keelhauler",
		Map = M._MAP,
		Resource = M["Keelhauler"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Keelhauler",
		MapObject = M["Keelhauler"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack-phase-2",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Keelhauler_Phase2AttackLogic.lua",
		Resource = M["Keelhauler"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack-phase-3",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Keelhauler_Phase3AttackLogic.lua",
		Resource = M["Keelhauler"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack-phase-4",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Keelhauler_Phase4AttackLogic.lua",
		Resource = M["Keelhauler"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack-phase-5",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Keelhauler_Phase5AttackLogic.lua",
		Resource = M["Keelhauler"]
	}
end

M["Anchor_VsPirates"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 171,
		PositionY = 3,
		PositionZ = 35,
		Name = "Anchor_VsPirates",
		Map = M._MAP,
		Resource = M["Anchor_VsPirates"]
	}
end

M["Anchor_KnightCommander_EngagePirates"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 123,
		PositionY = 3,
		PositionZ = 55,
		Name = "Anchor_KnightCommander_EngagePirates",
		Map = M._MAP,
		Resource = M["Anchor_KnightCommander_EngagePirates"]
	}
end

M["CapnRaven"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Pirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["CapnRaven"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 171,
		PositionY = 3,
		PositionZ = 31,
		Direction = 1,
		Name = "CapnRaven",
		Map = M._MAP,
		Resource = M["CapnRaven"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CapnRaven",
		MapObject = M["CapnRaven"]
	}
end

M["CapnRaven_PirateBodyGuard1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Pirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["CapnRaven_PirateBodyGuard1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 169,
		PositionY = 3,
		PositionZ = 31,
		Direction = -1,
		Name = "CapnRaven_PirateBodyGuard1",
		Map = M._MAP,
		Resource = M["CapnRaven_PirateBodyGuard1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["CapnRaven_PirateBodyGuard1"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyLongsword",
		Count = 1,
		Resource = M["CapnRaven_PirateBodyGuard1"]
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = -50,
		StrengthMelee = -40,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["CapnRaven_PirateBodyGuard1"]
	}

	M["CapnRaven_PirateBodyGuard1"] {
		ItsyScape.Action.Attack()
	}
end

M["CapnRaven_PirateBodyGuard2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Pirates",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["CapnRaven_PirateBodyGuard2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 173,
		PositionY = 3,
		PositionZ = 31,
		Direction = 1,
		Name = "CapnRaven_PirateBodyGuard2",
		Map = M._MAP,
		Resource = M["CapnRaven_PirateBodyGuard2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Pirate_BlackTentacle",
		MapObject = M["CapnRaven_PirateBodyGuard2"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ItsyLongsword",
		Count = 1,
		Resource = M["CapnRaven_PirateBodyGuard2"]
	}

	ItsyScape.Meta.Equipment {
		AccuracySlash = -50,
		StrengthMelee = -40,
		Slot = ItsyScape.Utility.Equipment.PLAYER_SLOT_SELF,
		Resource = M["CapnRaven_PirateBodyGuard2"]
	}

	M["CapnRaven_PirateBodyGuard2"] {
		ItsyScape.Action.Attack()
	}
end

M["BalsaTree"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 5,
		PositionZ = 151,
		Name = "BalsaTree",
		Map = M._MAP,
		Resource = M["BalsaTree"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "BalsaTree_Default",
		MapObject = M["BalsaTree"]
	}
end


M["Tutorial_DroppedItemsAnchor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_DroppedItems",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Tutorial_DroppedItemsAnchor"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 141,
		PositionY = 3,
		PositionZ = 173,
		Name = "Tutorial_DroppedItemsAnchor",
		Map = M._MAP,
		Resource = M["Tutorial_DroppedItemsAnchor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Peep "Anchor_Default",
		MapObject = M["Tutorial_DroppedItemsAnchor"]
	}

	ItsyScape.Meta.KeyItemLocationHint {
		Map = M._MAP,
		MapObject = M["Tutorial_DroppedItemsAnchor"],
		KeyItem = ItsyScape.Resource.KeyItem "Tutorial_GatheredItems"
	}
end

M["Passage_TutorialStart"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_TutorialStart",
		Map = M._MAP,
		Resource = M["Passage_TutorialStart"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 133,
		Z1 = 165,
		X2 = 145,
		Z2 = 177,
		Map = M._MAP,
		Resource = M["Passage_TutorialStart"]
	}
end

M["CameraDolly"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Cutscene",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["CameraDolly"]
	}

	ItsyScape.Meta.MapObjectLocation {
		Name = "CameraDolly",
		Map = M._MAP,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "CameraDolly",
		MapObject = M["CameraDolly"]
	}
end

M["Orlando"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Team",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Orlando"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 139,
		PositionY = 3,
		PositionZ = 173,
		Direction = 1,
		Name = "Orlando",
		Map = M._MAP,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Orlando",
		MapObject = M["Orlando"]
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "TerrifyingFishingRod",
		Count = 1,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "ItsyHatchet",
		Count = 1,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "Tinderbox",
		Count = 1,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-look-away-from-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_LookAwayLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-follow-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FollowLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-disengage-follow-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_DisengageFollowLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-general-attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-fish",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_FishLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-chop",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_ChopLogic.lua",
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-deflect",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Orlando_DeflectLogic.lua",
		Resource = M["Orlando"]
	}
end

M["Knight1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_TeamKnights",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Knight1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 145,
		PositionY = 3,
		PositionZ = 141,
		Direction = 1,
		Name = "Knight1",
		Map = M._MAP,
		Resource = M["Knight1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Knight",
		MapObject = M["Knight1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Knight_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Knight1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["Knight1"]
	}
end

M["Knight2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_TeamKnights",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Knight2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 163,
		PositionY = 3,
		PositionZ = 143,
		Direction = 1,
		Name = "Knight2",
		Map = M._MAP,
		Resource = M["Knight2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Knight",
		MapObject = M["Knight2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Knight_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Knight2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["Knight2"]
	}
end

M["Knight3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_TeamKnights",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Knight3"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 131,
		PositionY = 3,
		PositionZ = 151,
		Direction = 1,
		Name = "Knight3",
		Map = M._MAP,
		Resource = M["Knight3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Knight",
		MapObject = M["Knight3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Knight_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Knight3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["Knight3"]
	}
end

M["Knight4"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_TeamKnights",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Knight4"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 169,
		PositionY = 3,
		PositionZ = 175,
		Direction = 1,
		Name = "Knight4",
		Map = M._MAP,
		Resource = M["Knight4"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Knight",
		MapObject = M["Knight4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Knight_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["Knight4"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["Knight4"]
	}
end

M["MiningKnight1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_TeamKnights",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["MiningKnight1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 155,
		PositionY = 0,
		PositionZ = 163,
		Direction = 1,
		Name = "MiningKnight1",
		Map = M._MAP,
		Resource = M["MiningKnight1"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Mining",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = M["MiningKnight1"]
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "AdamantPickaxe",
		Count = 1,
		Resource = M["MiningKnight1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Knight",
		MapObject = M["MiningKnight1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Knight_MineLogic.lua",
		IsDefault = 1,
		Resource = M["MiningKnight1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["MiningKnight1"]
	}
end

M["MiningKnight2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_TeamKnights",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["MiningKnight2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 157,
		PositionY = 0,
		PositionZ = 157,
		Direction = 1,
		Name = "MiningKnight2",
		Map = M._MAP,
		Resource = M["MiningKnight2"]
	}

	ItsyScape.Meta.PeepStat {
		Skill = ItsyScape.Resource.Skill "Mining",
		Value = ItsyScape.Utility.xpForLevel(50),
		Resource = M["MiningKnight2"]
	}

	ItsyScape.Meta.PeepInventoryItem {
		Item = ItsyScape.Resource.Item "AdamantPickaxe",
		Count = 1,
		Resource = M["MiningKnight2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_Knight",
		MapObject = M["MiningKnight2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Knight_MineLogic.lua",
		IsDefault = 1,
		Resource = M["MiningKnight2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["MiningKnight2"]
	}
end

M["AzatiteMeteor"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 155,
		PositionY = 0,
		PositionZ = 159,
		Name = "AzatiteMeteor",
		Map = M._MAP,
		Resource = M["AzatiteMeteor"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "AzatiteMeteor_Default",
		MapObject = M["AzatiteMeteor"]
	}
end

M["KnightCommander"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Team",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["KnightCommander"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 99,
		PositionY = 3,
		PositionZ = 161,
		Direction = 1,
		Name = "KnightCommander",
		Map = M._MAP,
		Resource = M["KnightCommander"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "IsabelleIsland_KnightCommander",
		MapObject = M["KnightCommander"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-follow-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_KnightCommander_FollowLogic.lua",
		Resource = M["KnightCommander"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-disengage-follow-player",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_KnightCommander_DisengageFollowLogic.lua",
		Resource = M["KnightCommander"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-general-attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_GeneralAttackLogic.lua",
		Resource = M["KnightCommander"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-stand-guard",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_KnightCommander_StandGuardLogic.lua",
		Resource = M["KnightCommander"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "tutorial-duel",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_KnightCommander_DuelLogic.lua",
		Resource = M["KnightCommander"]
	}
end

M["Passage_KnightCommander"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_KnightCommander",
		Map = M._MAP,
		Resource = M["Passage_KnightCommander"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 94,
		Z1 = 160,
		X2 = 102,
		Z2 = 170,
		Map = M._MAP,
		Resource = M["Passage_KnightCommander"]
	}
end

M["YendorianScout"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_YendorianScout",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["YendorianScout"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 3,
		PositionZ = 163,
		Direction = 1,
		Name = "YendorianScout",
		Map = M._MAP,
		Resource = M["YendorianScout"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yendorian_Scout",
		MapObject = M["YendorianScout"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_YendorianScout_IdleLogic.lua",
		IsDefault = 1,
		Resource = M["YendorianScout"]
	}
end

M["Flare"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Flare",
		Map = M._MAP,
		Resource = M["Flare"]
	}

	ItsyScape.Meta.PropMapObject {
		Prop = ItsyScape.Resource.Prop "Flare",
		MapObject = M["Flare"]
	}
end

M["Anchor_Flare"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 5,
		PositionZ = 163,
		Name = "Anchor_Flare",
		Map = M._MAP,
		Resource = M["Anchor_Flare"]
	}
end

M["Anchor_FlareHidden"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = -1000,
		PositionY = -1000,
		PositionZ = -1000,
		Name = "Anchor_FlareHidden",
		Map = M._MAP,
		Resource = M["Anchor_FlareHidden"]
	}
end

M["Passage_Scout"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Scout",
		Map = M._MAP,
		Resource = M["Passage_Scout"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 40,
		Z1 = 164,
		X2 = 50,
		Z2 = 187,
		Map = M._MAP,
		Resource = M["Passage_Scout"]
	}
end

M["Passage_FishingArea"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_FishingArea",
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 50,
		Z1 = 136,
		X2 = 72,
		Z2 = 168,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 56,
		Z1 = 134,
		X2 = 70,
		Z2 = 136,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 58,
		Z1 = 132,
		X2 = 68,
		Z2 = 134,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 72,
		Z1 = 144,
		X2 = 76,
		Z2 = 162,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 76,
		Z1 = 146,
		X2 = 76,
		Z2 = 164,
		Map = M._MAP,
		Resource = M["Passage_FishingArea"]
	}
end

M["Yenderhound1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Yenderhounds",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Yenderhound1"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 73,
		PositionY = 5,
		PositionZ = 161,
		Direction = 1,
		Name = "Yenderhound1",
		Map = M._MAP,
		Resource = M["Yenderhound1"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yenderhound",
		MapObject = M["Yenderhound1"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AggressiveIdleLogic.lua",
		IsDefault = 1,
		Resource = M["Yenderhound1"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AttackLogic.lua",
		Resource = M["Yenderhound1"]
	}
end

M["Yenderhound2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Yenderhounds",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Yenderhound2"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 79,
		PositionY = 5,
		PositionZ = 157,
		Direction = 1,
		Name = "Yenderhound2",
		Map = M._MAP,
		Resource = M["Yenderhound2"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yenderhound",
		MapObject = M["Yenderhound2"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AggressiveIdleLogic.lua",
		IsDefault = 1,
		Resource = M["Yenderhound2"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AttackLogic.lua",
		Resource = M["Yenderhound1"]
	}
end

M["Yenderhound3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectGroup {
		MapObjectGroup = "Tutorial_Yenderhounds",
		Map = M._MAP,
		IsInstanced = 1,
		MapObject = M["Yenderhound3"]
	}

	ItsyScape.Meta.MapObjectLocation {
		PositionX = 75,
		PositionY = 5,
		PositionZ = 153,
		Direction = 1,
		Name = "Yenderhound3",
		Map = M._MAP,
		Resource = M["Yenderhound3"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Yenderhound",
		MapObject = M["Yenderhound3"],
		DoesNotDespawn = 1,
		DoesNotRespawn = 1
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "idle",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AggressiveIdleLogic.lua",
		IsDefault = 1,
		Resource = M["Yenderhound3"]
	}

	ItsyScape.Meta.PeepMashinaState {
		State = "attack",
		Tree = "Resources/Game/Maps/Sailing_HumanityEdge/Scripts/Tutorial_Yenderhound_AttackLogic.lua",
		Resource = M["Yenderhound1"]
	}
end



M["Anchor_Dolly_KeelhaulerSpawn_Start"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 159,
		PositionY = 7,
		PositionZ = 55,
		Direction = 1,
		Name = "Anchor_Dolly_KeelhaulerSpawn_Start",
		Map = M._MAP,
		Resource = M["Anchor_Dolly_KeelhaulerSpawn_Start"]
	}
end

M["Passage_Peak"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Peak",
		Map = M._MAP,
		Resource = M["Passage_Peak"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 128,
		Z1 = 76,
		X2 = 134,
		Z2 = 83,
		Map = M._MAP,
		Resource = M["Passage_Peak"]
	}
end

M["Anchor_PeakEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 151,
		PositionY = 10,
		PositionZ = 109,
		Name = "Anchor_PeakEntrance",
		Map = M._MAP,
		Resource = M["Anchor_PeakEntrance"]
	}
end

M["Passage_PeakEntrance"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_PeakEntrance",
		Map = M._MAP,
		Resource = M["Passage_PeakEntrance"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 148,
		Z1 = 106,
		X2 = 154,
		Z2 = 112,
		Map = M._MAP,
		Resource = M["Passage_PeakEntrance"]
	}
end

M["Passage_PeakBlocker"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_PeakBlocker",
		Map = M._MAP,
		Resource = M["Passage_PeakBlocker"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 141,
		Z1 = 110,
		X2 = 145,
		Z2 = 114,
		Map = M._MAP,
		Resource = M["Passage_PeakBlocker"]
	}
end

M["Passage_Yenderhounds"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Yenderhounds",
		Map = M._MAP,
		Resource = M["Passage_Yenderhounds"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 50,
		Z1 = 154,
		X2 = 56,
		Z2 = 162,
		Map = M._MAP,
		Resource = M["Passage_Yenderhounds"]
	}
end

M["Anchor_Barrier1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 25,
		PositionY = 3,
		PositionZ = 163,
		Name = "Anchor_Barrier1",
		Map = M._MAP,
		Resource = M["Anchor_Barrier1"]
	}
end

M["Passage_Barrier1"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Barrier1",
		Map = M._MAP,
		Resource = M["Passage_Barrier1"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 6,
		Z1 = 142,
		X2 = 102,
		Z2 = 150,
		Map = M._MAP,
		Resource = M["Passage_Barrier1"]
	}
end

M["Passage_Barrier2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Barrier2",
		Map = M._MAP,
		Resource = M["Passage_Barrier2"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 96,
		Z1 = 144,
		X2 = 102,
		Z2 = 160,
		Map = M._MAP,
		Resource = M["Passage_Barrier2"]
	}
end

M["Anchor_Barrier2"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 65,
		PositionY = 5,
		PositionZ = 165,
		Name = "Anchor_Barrier2",
		Map = M._MAP,
		Resource = M["Anchor_Barrier2"]
	}
end

M["Passage_Barrier3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectReference {
		Name = "Passage_Barrier3",
		Map = M._MAP,
		Resource = M["Passage_Barrier3"]
	}

	ItsyScape.Meta.MapObjectRectanglePassage {
		X1 = 98,
		Z1 = 28,
		X2 = 104,
		Z2 = 44,
		Map = M._MAP,
		Resource = M["Passage_Barrier3"]
	}
end

M["Anchor_Barrier3"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 117,
		PositionY = 3,
		PositionZ = 37,
		Name = "Anchor_Barrier3",
		Map = M._MAP,
		Resource = M["Anchor_Barrier3"]
	}
end

M["SeafarerGuildMaster"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 175,
		PositionY = 3,
		PositionZ = 175,
		Direction = -1,
		Name = "SeafarerGuildMaster",
		Map = M._MAP,
		Resource = M["SeafarerGuildMaster"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rumbridge_Port_SeafarerGuildmaster",
		MapObject = M["SeafarerGuildMaster"]
	}
end

M["Rosalind"] = ItsyScape.Resource.MapObject.Unique()
do
	ItsyScape.Meta.MapObjectLocation {
		PositionX = 140,
		PositionY = 3,
		PositionZ = 140,
		Direction = 1,
		Name = "Rosalind",
		Map = M._MAP,
		Resource = M["Rosalind"]
	}

	ItsyScape.Meta.PeepMapObject {
		Peep = ItsyScape.Resource.Peep "Rosalind",
		MapObject = M["Rosalind"]
	}
end

-- Orlando talk action.
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "Orlando",
		Main = "quest_tutorial_main",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["CapnRaven"],
		Name = "CapnRaven",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["KnightCommander"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Knight1"],
		Name = "X_OtherVizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "Talk",
		Action = TalkAction,
		Peep = M["Orlando"]
	}

	M["Orlando"] {
		TalkAction,
		ItsyScape.Action.InvisibleAttack()
	}
end

-- Ser Commander talk action.
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_main",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["KnightCommander"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Knight1"],
		Name = "X_VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "Talk",
		Action = TalkAction,
		Peep = M["KnightCommander"]
	}

	M["KnightCommander"] {
		TalkAction,
		ItsyScape.Action.InvisibleAttack()
	}
end

-- Rosalind talk action.
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "Rosalind",
		Main = "quest_tutorial_main",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Rosalind"],
		Name = "Rosalind",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["Rosalind"] {
		TalkAction
	}
end

-- Robert talk action.
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "Orlando",
		Main = "quest_tutorial_talk_with_robert",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["SeafarerGuildMaster"],
		Name = "SeafarerGuildMaster",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["SeafarerGuildMaster"] {
		TalkAction
	}
end

-- Cap'n Raven talk action.
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "CapnRaven",
		Main = "quest_tutorial_main",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["CapnRaven"],
		Name = "CapnRaven",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Battle_ShipPirate1"],
		Name = "X_Pirate",
		Action = TalkAction
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "Talk",
		Action = TalkAction,
		Peep = M["CapnRaven"]
	}
end

-- Knights talk actions.
do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_random_knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Knight1"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["Knight1"] {
		TalkAction
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_random_knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Knight2"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["Knight2"] {
		TalkAction
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_random_knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Knight3"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["Knight3"] {
		TalkAction
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_random_knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Knight4"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["Knight4"] {
		TalkAction
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_mining_knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["MiningKnight1"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["MiningKnight1"] {
		TalkAction
	}
end

do
	local TalkAction = ItsyScape.Action.Talk()

	ItsyScape.Meta.TalkCharacter {
		Character = ItsyScape.Resource.Character "VizierRockKnight",
		Main = "quest_tutorial_mining_knight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["MiningKnight2"],
		Name = "VizierRockKnight",
		Action = TalkAction
	}

	ItsyScape.Meta.TalkSpeaker {
		Resource = M["Orlando"],
		Name = "Orlando",
		Action = TalkAction
	}

	M["MiningKnight2"] {
		TalkAction
	}
end

do
	ItsyScape.Meta.DropTableEntry {
		Item = ItsyScape.Resource.Item "CookedLightningStormfish",
		Weight = 1,
		Count = 3,
		Resource = ItsyScape.Resource.DropTable "Sailing_HumanityEdge_MiscDropTable"
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_HumanityEdge_SummonKeelhauler"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = M["CapnRaven"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_HumanityEdge_Flare"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Scout",
		Cutscene = Cutscene,
		Resource = M["YendorianScout"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Flare",
		Cutscene = Cutscene,
		Resource = M["Flare"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_HumanityEdge_FoundScout"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Scout",
		Cutscene = Cutscene,
		Resource = M["YendorianScout"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_HumanityEdge_FoundYenderhounds"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_HumanityEdge_Peak"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = M["CapnRaven"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Orlando",
		Cutscene = Cutscene,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "KnightCommander",
		Cutscene = Cutscene,
		Resource = M["KnightCommander"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Yendorian1",
		Cutscene = Cutscene,
		Resource = M["Battle1_Yendorian"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Yendorian2",
		Cutscene = Cutscene,
		Resource = M["Battle2_Yendorian"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Yendorian3",
		Cutscene = Cutscene,
		Resource = M["Battle3_Yendorian"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Pirate1",
		Cutscene = Cutscene,
		Resource = M["Battle_ShipPirate1"]
	}
end

do
	local Cutscene = ItsyScape.Resource.Cutscene "Sailing_HumanityEdge_DefeatedKeelhauler"

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CameraDolly",
		Cutscene = Cutscene,
		Resource = M["CameraDolly"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "CapnRaven",
		Cutscene = Cutscene,
		Resource = M["CapnRaven"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Keelhauler",
		Cutscene = Cutscene,
		Resource = M["Keelhauler"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "Orlando",
		Cutscene = Cutscene,
		Resource = M["Orlando"]
	}

	ItsyScape.Meta.CutsceneMapObject {
		Name = "KnightCommander",
		Cutscene = Cutscene,
		Resource = M["KnightCommander"]
	}
end
