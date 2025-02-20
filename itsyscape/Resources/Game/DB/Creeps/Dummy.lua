do
	local Dummy = ItsyScape.Resource.Peep "Dummy_Wizard" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "ItsyScape.Peep.Peeps.Player",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceName {
		Value = "Dummy wizard",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A dummy that can cast spells.",
		Language = "en-US",
		Resource = Dummy
	}

	ItsyScape.Meta.Dummy {
		Tier = 50,
		Hitpoints = 500,

		Weapon = "ScaryStaff",

		Resource = Dummy
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ZealotSilkGloves",
		Count = 1,
		Resource = Dummy
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ZealotSilkSlippers",
		Count = 1,
		Resource = Dummy
	}

	ItsyScape.Meta.PeepEquipmentItem {
		Item = ItsyScape.Resource.Item "ZealotSilkRobe",
		Count = 1,
		Resource = Dummy
	}
end
