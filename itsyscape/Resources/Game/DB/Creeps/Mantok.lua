--------------------------------------------------------------------------------
-- Resources/Game/DB/Gods/Mantok.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Mantok"

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Mantok"
}

ItsyScape.Meta.ResourceTag {
	Value = "Undead",
	Resource = ItsyScape.Resource.Peep "Mantok"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Mantok.Mantok",
	Resource = ItsyScape.Resource.Peep "Mantok"
}

ItsyScape.Meta.ResourceName {
	Value = "Corpse of Man'tok, the First One",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Mantok"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Man'tok fell to the Realm through a rift it opened a millenia ago. Wherever Man'tok goes, Yendor soon follows...",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Mantok"
}

ItsyScape.Resource.Prop "Mantok_Head" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Mantok.CorpseBumps",
	Resource = ItsyScape.Resource.Prop "Mantok_Head"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "Mantok_Head"
}

ItsyScape.Meta.ResourceName {
	Value = "Head of Man'tok",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Mantok"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Wait, isn't Man'tok JUST a head?",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Mantok"
}
