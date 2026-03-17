------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/Woodcutting.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Cursor = ItsyScape.Resource.Prop "WoodcuttingCursor"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.BasicCursor",
		Resource = Cursor
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 1.5,
		SizeY = 1,
		SizeZ = 1.5,
		MapObject = Cursor
	}
end

do
	local Woodcutting1 = ItsyScape.Resource.ActionCommand "Woodcut1"

	ItsyScape.Meta.ActionCommandMap {
		Map = ItsyScape.Resource.Map "Skilling_Woodcutting1",
		Resource = Woodcutting1
	}
end

do
	local Woodcutting1 = ItsyScape.Resource.ActionCommand "Woodcut50"

	ItsyScape.Meta.ActionCommandMap {
		Map = ItsyScape.Resource.Map "Skilling_Woodcutting50",
		Resource = Woodcutting1
	}
end
