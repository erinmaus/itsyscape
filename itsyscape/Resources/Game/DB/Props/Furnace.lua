--------------------------------------------------------------------------------
-- Resources/Game/DB/Props/Furnace.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

ItsyScape.Resource.Prop "Furnace" {
	ItsyScape.Action.Smelt() {
		-- Nothing.
	}
}

ItsyScape.Meta.PropGraphics {
	Mesh = "Resources/Game/Models/Furnace_Default/Model.lstatic",
	Texture = "Resources/Game/Models/Furnace_Default/Texture.png",
	Group = "furnace",
	Resource = ItsyScape.Resource.Prop "Furnace"
}
