--------------------------------------------------------------------------------
-- Resources/Game/DB/Clutter/Cooking.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local StockPot = ItsyScape.Resource.Prop "Clutter_Cooking_StockPot"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = StockPot
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = StockPot
	}
end

do
	local FryingPan = ItsyScape.Resource.Prop "Clutter_Cooking_FryingPan"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = FryingPan
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = FryingPan
	}
end

do
	local CuttingBoard = ItsyScape.Resource.Prop "Clutter_Cooking_CuttingBoard"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = CuttingBoard
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = CuttingBoard
	}
end

do
	local BakingSheet = ItsyScape.Resource.Prop "Clutter_Cooking_BakingSheet"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = BakingSheet
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = BakingSheet
	}
end
