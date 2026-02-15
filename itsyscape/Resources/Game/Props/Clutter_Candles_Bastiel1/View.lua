--------------------------------------------------------------------------------
-- Resources/Game/Props/Clutter_Candles_Bastiel1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local CandleView = require "Resources.Game.Props.Common.CandleView"

local Candles = Class(CandleView)

Candles.COLORS = {
	Color.fromHexString("3f4d60"),
	Color.fromHexString("262e39"),
	Color.fromHexString("cfdcec"),
	Color.fromHexString("a4b4ca"),
}

return Candles
