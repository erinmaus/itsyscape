do
	local GlyphboundYendorian = ItsyScape.Resource.Peep "GlyphboundYendorian" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.GlyphboundYendorian.GlyphboundYendorian",
		Resource = GlyphboundYendorian
	}

	ItsyScape.Meta.ResourceName {
		Value = "Glyphbound Yendorian",
		Language = "en-US",
		Resource = GlyphboundYendorian
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The result of a twisted experiment to understand the nature of the soul. The Yendorian remains on the Realm in perpetuity, unable to move on or fade away.",
		Language = "en-US",
		Resource = GlyphboundYendorian
	}
end

do
	local StoneGlyphboundYendorian = ItsyScape.Resource.Prop "StoneGlyphboundYendorian"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.GlyphboundYendorian.StoneGlyphboundYendorian",
		Resource = StoneGlyphboundYendorian
	}

	local ChargeAction = ItsyScape.Action.Interact() {
		Input {
			Resource = ItsyScape.Resource.Item "Ectoplasm",
			Count = 10
		}
	}

	ItsyScape.Meta.ActionVerb {
		Value = "Charge",
		XProgressive = "Charging",
		Language = "en-US",
		Action = ChargeAction
	}

	ItsyScape.Meta.NamedPeepAction {
		Name = "Charge",
		Action = ChargeAction,
		Peep = StoneGlyphboundYendorian
	}

	StoneGlyphboundYendorian {
		ChargeAction
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 4,
		SizeZ = 1.5,
		MapObject = StoneGlyphboundYendorian
	}

	ItsyScape.Meta.ResourceName {
		Value = "Stone Yendorian",
		Language = "en-US",
		Resource = StoneGlyphboundYendorian
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The soul of a Yendorian is encased in special glyphstone, bound to the Realm forever.",
		Language = "en-US",
		Resource = StoneGlyphboundYendorian
	}
end
