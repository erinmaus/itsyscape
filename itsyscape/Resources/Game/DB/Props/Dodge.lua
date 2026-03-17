--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Dodge.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Dodge = ItsyScape.Resource.Prop "Dodge"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDodge",
	Resource = Dodge
}

ItsyScape.Meta.ResourceName {
	Value = "Dodge aura",
	Language = "en-US",
	Resource = Dodge
}

ItsyScape.Meta.ResourceDescription {
	Value = "A protective aura that appears when dodging. Helps you move faster.",
	Language = "en-US",
	Resource = Dodge
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0,
	SizeY = 0,
	SizeZ = 0,
	MapObject = Dodge
}
