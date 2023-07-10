--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Doors.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Door_IronGate" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicDoor",
	Resource = ItsyScape.Resource.Prop "Door_IronGate"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Door_IronGate"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron gate",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_IronGate"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs some grease.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_IronGate"
}

ItsyScape.Resource.Prop "Door_IronGate_Guardian" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicGuardianDoor",
	Resource = ItsyScape.Resource.Prop "Door_IronGate_Guardian"
}

ItsyScape.Meta.PropAlias {
	Alias = ItsyScape.Resource.Prop "Door_IronGate",
	Resource = ItsyScape.Resource.Prop "Door_IronGate_Guardian"
}

ItsyScape.Meta.MapObjectSize {
	SizeX = 1.5,
	SizeY = 2,
	SizeZ = 1.5,
	MapObject = ItsyScape.Resource.Prop "Door_IronGate_Guardian"
}

ItsyScape.Meta.ResourceName {
	Value = "Iron gate",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_IronGate_Guardian"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Needs some grease.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Door_IronGate_Guardian"
}