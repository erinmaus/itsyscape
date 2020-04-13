--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Hole.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Hole_Default" {
	-- Nothing.
}

ItsyScape.Meta.PeepID {
	Value = "Resources.Game.Peeps.Props.BasicHole",
	Resource = ItsyScape.Resource.Prop "Hole_Default"
}

ItsyScape.Meta.ResourceName {
	Value = "Hole",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Hole_Default"
}

ItsyScape.Meta.ResourceDescription {
	Value = "Why not plant a tree? Hashtag climate change.",
	Language = "en-US",
	Resource = ItsyScape.Resource.Prop "Hole_Default"
}
