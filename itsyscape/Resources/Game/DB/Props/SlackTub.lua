--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furnace.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local SlackTub = ItsyScape.Resource.Prop "SlackTub"

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.FurnitureProp",
	Resource = SlackTub
}

ItsyScape.Meta.ResourceName {
	Value = "Slack tub",
	Language = "en-US",
	Resource = SlackTub
}

ItsyScape.Meta.ResourceDescription {
	Value = "Water to cool hot metal... Or a pool! You do you.",
	Language = "en-US",
	Resource = SlackTub
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 2.5,
	SizeY = 2,
	SizeZ = 1,
	MapObject = SlackTub
}
