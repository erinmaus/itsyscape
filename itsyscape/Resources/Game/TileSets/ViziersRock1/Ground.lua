--------------------------------------------------------------------------------
-- Resources/Game/TileSets/ViziersRock1/Ground.lua
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

local ViziersRock = Class(GroundDecorations)

function ViziersRock:new()
	GroundDecorations.new(self, "ViziersRock1")

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLOR = Color.fromHexString("a3ae87"),
		FEATURE = "grass"
	})

	self:registerTile("grass_red", GrassBlock:Bind(self) {
		COLOR = Color.fromHexString("a02c2c"),
		FEATURE = "grass"
	})

	self:registerTile("stone", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("474a57"),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 4,
		ONLY_FLAT = false
	})

	self:registerTile("stone_dirty", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("82634c"),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 4,
		ONLY_FLAT = false
	})

	self:registerTile("dirt", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("785845"),
		FEATURE = "pebble",
		SCALE = Vector.ONE,
		NUM_FEATURES = 5,
		ONLY_FLAT = false
	})

	self:registerTile("sand", BrickBlock:Bind(self) {
		COLOR = Color(1, 1, 1, 1),
		FEATURE = "shell",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 4,
		ROTATION_RANGE = math.pi * 2,
		ONLY_FLAT = false
	})

	self:registerTile("mud", BrickBlock:Bind(self) {
		COLOR = Color(1, 1, 1, 1),
		FEATURE = "garbage",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 5,
		ROTATION_RANGE = math.pi * 2,
		ONLY_FLAT = false
	})

	self:registerTile("wood", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("694c39"),
		FEATURE = "plank",
		SCALE = Vector(1, 1, 1),
		NUM_FEATURES = 2,
		ONLY_FLAT = false
	})
end

return ViziersRock
