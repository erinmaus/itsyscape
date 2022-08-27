--------------------------------------------------------------------------------
-- Resources/Game/DB/Gods/Theodyssius.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Peep "Theodyssius" {
	-- Nothing.
}

ItsyScape.Meta.ResourceTag {
	Value = "Eldritch",
	Resource = ItsyScape.Resource.Peep "Theodyssius"
}

ItsyScape.Meta.ResourceTag {
	Value = "Angelic",
	Resource = ItsyScape.Resource.Peep "Theodyssius"
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Theodyssius.Theodyssius",
	Resource = ItsyScape.Resource.Peep "Theodyssius"
}

ItsyScape.Meta.ResourceName {
	Value = "Theodyssius, Ascended Insanity",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Theodyssius"
}

ItsyScape.Meta.ResourceDescription {
	Value = "First Seraph of Bastiel, driven to insanity by her exile at the Insanitorium.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Peep "Theodyssius"
}

ItsyScape.Resource.Prop "Theodyssius_Head" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Theodyssius.TheodyssiusHead",
	Resource = ItsyScape.Resource.Prop "Theodyssius_Head"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = ItsyScape.Resource.Prop "Theodyssius_Head"
}

ItsyScape.Meta.ResourceName {
	Value = "Theodyssius's head",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Theodyssius"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Well, less of a head and more of an eye.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Theodyssius"
}
