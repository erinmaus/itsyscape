--------------------------------------------------------------------------------
-- Resources/Game/DB/Clutter/Religious.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

do
	local Symbol = ItsyScape.Resource.Prop "Clutter_Symbol_Bastiel1"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Symbol
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = Symbol
	}

	ItsyScape.Meta.ResourceName {
		Value = "Symbol of bastiel",
		Language = "en-US",
		Resource = Symbol
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "The rays of Bastiel's gaze manifested angels who built the world in His image.",
		Language = "en-US",
		Resource = Symbol
	}
end

do
	local Candles = ItsyScape.Resource.Prop "Clutter_Candles_Bastiel1"

	ItsyScape.Meta.PeepID {
		Value = "Resources.Game.Peeps.Props.PassableProp",
		Resource = Candles
	}

	ItsyScape.Meta.MapObjectSize {
		SizeX = 0.5,
		SizeY = 0.5,
		SizeZ = 0.5,
		MapObject = Candles
	}

	ItsyScape.Meta.ResourceName {
		Value = "Candles for bastiel",
		Language = "en-US",
		Resource = Candles
	}

	ItsyScape.Meta.ResourceDescription {
		Value = "Candles that small of petrichor.",
		Language = "en-US",
		Resource = Candles
	}
end
