ItsyScape.Resource.Item "GoldenRing" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.ResourceName {
	Value = "Golden ring",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GoldenRing"
}

ItsyScape.Meta.ResourceCategory {
	Key = "Metal",
	Value = "Gold",
	Resource = ItsyScape.Resource.Item "GoldenRing"
}

ItsyScape.Meta.Item {
	Value = ItsyScape.Utility.valueForItem(30),
	Resource = ItsyScape.Resource.Item "GoldenRing"
}

ItsyScape.Resource.Item "GoldenRing" {
	ItsyScape.Action.Equip(),
	ItsyScape.Action.Dequip()
}

ItsyScape.Meta.Equipment {
	StrengthMelee = ItsyScape.Utility.strengthBonusForWeapon(1) / 3,
	StrengthMagic = ItsyScape.Utility.strengthBonusForWeapon(1) / 3,
	StrengthRanged = ItsyScape.Utility.strengthBonusForWeapon(1) / 3,
	Prayer = 10,
	EquipSlot = ItsyScape.Utility.Equipment.PLAYER_SLOT_FINGER,
	Resource = ItsyScape.Resource.Item "GoldenRing"
}

ItsyScape.Meta.ResourceDescription {
	Value = "A pretty useful trinket.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Item "GoldenRing"
}
