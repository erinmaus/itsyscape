--------------------------------------------------------------------------------
-- Resources/Game/DB/Maps/Yendorian.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Bush = ItsyScape.Resource.Prop "TentacleBush_Default"

	ItsyScape.Meta.ResourceName {
		Value = "Tentacle bush",
		Language = "en-US",
		Resource = Bush
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Better not try and chop that... It just might fight back!",
		Language = "en-US",
		Resource = Bush
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = Bush
	}
end

do
	local Ballista = ItsyScape.Resource.Prop "YendorianBallista"

	ItsyScape.Meta.ResourceName {
		Value = "Yedorian ballista",
		Language = "en-US",
		Resource = Ballista
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "A Yendorian will literally use a ballista like a human uses a crossbow!",
		Language = "en-US",
		Resource = Ballista
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Ballista
	}
end

do
	local Pillar = ItsyScape.Resource.Prop "YendorianRuins_Pillar"

	ItsyScape.Meta.ResourceName {
		Value = "Yendorian pillar",
		Language = "en-US",
		Resource = Pillar
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "It floats in rhythm with a weak heartbeat... But who - or what - does the hearbeat belong to?",
		Language = "en-US",
		Resource = Pillar
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = Pillar
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 5.5,
		SizeY = 9.5,
		SizeZ = 5.5,
		MapObject = Pillar
	}
end

do
	local Rock = ItsyScape.Resource.Prop "YendorianRuins_Rock"

	ItsyScape.Meta.ResourceName {
		Value = "Weathered Yendorian pillar",
		Language = "en-US",
		Resource = Rock
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "This pillar has weathered to nothing more than a rock.",
		Language = "en-US",
		Resource = Rock
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.StaticProp",
		Resource = Rock
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 3.5,
		SizeY = 2.5,
		SizeZ = 3.5,
		MapObject = Rock
	}
end

do
	local WhaleSkeleton = ItsyScape.Resource.Prop "WhaleSkeleton"

	ItsyScape.Meta.ResourceName {
		Value = "Whale skeleton",
		Language = "en-US",
		Resource = WhaleSkeleton
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The remains of a great whale, dragged to land and left to die by Yendorians. Evidently, it was never resurrected.",
		Language = "en-US",
		Resource = WhaleSkeleton
	}

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = WhaleSkeleton
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 6.5,
		SizeY = 4.5,
		SizeZ = 16.5,
		MapObject = WhaleSkeleton
	}
end
