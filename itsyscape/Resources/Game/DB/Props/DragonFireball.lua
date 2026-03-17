--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/DragonFireball.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local DragonFireball = ItsyScape.Resource.Prop "DragonFireball"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Dragon.DragonFireball",
	Resource = DragonFireball
}

ItsyScape.Meta.ResourceName {
	Value = "Dragonfyreball",
	Language = "en-US",
	Resource = DragonFireball
}

ItsyScape.Meta.ResourceDescription {
	Value = "Dodge that or you're in for a world of pain!",
	Language = "en-US",
	Resource = DragonFireball
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 0.5,
	SizeY = 0.5,
	SizeZ = 0.5,
	MapObject = DragonFireball
}
