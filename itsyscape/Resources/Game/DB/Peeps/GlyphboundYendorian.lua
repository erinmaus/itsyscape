do
	local GlyphboundYendorian = ItsyScape.Resource.Peep "GlyphboundYendorian" {
		ItsyScape.Action.Attack()
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Yendorian.GhostYendorian",
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
