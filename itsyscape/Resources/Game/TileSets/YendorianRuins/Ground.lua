--------------------------------------------------------------------------------
-- Resources/Game/TileSets/YendorianRuins/Ground.lua
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

local YendorianRuinsGround = Class(GroundDecorations)

function YendorianRuinsGround:new()
	GroundDecorations.new(self, "YendorianRuins")

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLOR = Color.fromHexString("3e6d3a"),
		FEATURE = "grass"
	})

	self:registerTile("brick", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("444f58"),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 3
	})

	self:registerTile("rock", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("4a5b66"),
		FEATURE = "pebble",
		SCALE = Vector.ONE,
		NUM_FEATURES = 5
	})

	self:registerTile("dirt", BrickBlock:Bind(self) {
		COLOR = Color(1, 1, 1, 1),
		FEATURE = "shell",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 4,
		ROTATION_RANGE = math.pi * 2,
		ONLY_FLAT = false
	})

	self:registerTile("wood", BrickBlock:Bind(self) {
		COLOR = Color(0.3, 0.2, 0.3, 1.0),
		FEATURE = "plank",
		SCALE = Vector(1, 1, 1),
		NUM_FEATURES = 2
	})
end

return YendorianRuinsGround
