--------------------------------------------------------------------------------
-- Resources/Game/TileSets/EmptyRuins/Ground.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local GroundDecorations = require "ItsyScape.World.GroundDecorations"
local BrickBlock = require "ItsyScape.World.GroundDecorations.BrickBlock"
local GrassBlock = require "ItsyScape.World.GroundDecorations.GrassBlock"

local EmptyRuinsGround = Class(GroundDecorations)

function EmptyRuinsGround:new()
	GroundDecorations.new(self, "EmptyRuins")

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLOR = Color(0.3, 0.5, 0.4, 1.0),
		FEATURE = "grass"
	})

	self:registerTile("purple-stone", BrickBlock:Bind(self) {
		COLOR = Color(0.3, 0.3, 0.5, 1.0),
		FEATURE = "brick",
		SCALE = Vector.ONE,
		NUM_FEATURES = 3
	})

	self:registerTile("green-stone", BrickBlock:Bind(self) {
		COLOR = Color(0.3, 0.5, 0.3, 1.0),
		FEATURE = "brick",
		SCALE = Vector.ONE,
		NUM_FEATURES = 3
	})

	self:registerTile("wood", BrickBlock:Bind(self) {
		COLOR = Color(0.3, 0.2, 0.3, 1.0),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 2
	})
end

return EmptyRuinsGround
