--------------------------------------------------------------------------------
-- Resources/Game/TileSets/RumbridgeMainland/Ground.lua
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

local RumbridgeMainlandGround = Class(GroundDecorations)

function RumbridgeMainlandGround:new()
	GroundDecorations.new(self, "RumbridgeMainland")

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLOR = Color(0.5, 0.7, 0.1, 1.0),
		FEATURE = "grass"
	})

	self:registerTile("brick", BrickBlock:Bind(self) {
		COLOR = Color(0.7, 0.7, 0.7, 1.0),
		FEATURE = "brick",
		SCALE = Vector.ONE,
		NUM_FEATURES = 3
	})

	self:registerTile("brick_wide", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("8cbbc3"),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 3
	})

	self:registerTile("brick_wide_dark", BrickBlock:Bind(self) {
		COLOR = Color(0.2, 0.2, 0.2, 1.0),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 3
	})

	self:registerTile("wood", BrickBlock:Bind(self) {
		COLOR = Color(0.5, 0.3, 0.2, 1.0),
		FEATURE = "plank",
		SCALE = Vector.ONE,
		NUM_FEATURES = 2
	})
end

return RumbridgeMainlandGround
