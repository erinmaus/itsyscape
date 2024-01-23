--------------------------------------------------------------------------------
-- Resources/Game/TileSets/IcyMountain/Ground.lua
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

local IcyMountain = Class(GroundDecorations)

function IcyMountain:new()
	GroundDecorations.new(self, "IcyMountain")

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLOR = Color.fromHexString("c5dced"),
		FEATURE = "grass"
	})

	self:registerTile("snow", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("c5dced"),
		FEATURE = "pebble",
		SCALE = Vector.ONE,
		NUM_FEATURES = 5,
		ONLY_FLAT = false
	})

	self:registerTile("stone", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("4b3b52"),
		FEATURE = "brick",
		SCALE = Vector(2, 1, 1),
		NUM_FEATURES = 4,
		ONLY_FLAT = false
	})

	self:registerTile("rock", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("4a3d47"),
		FEATURE = "pebble",
		SCALE = Vector.ONE,
		NUM_FEATURES = 5,
		ONLY_FLAT = false
	})

	self:registerTile("snow_drift", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("c5dced"),
		FEATURE = "pebble",
		SCALE = Vector.ONE,
		NUM_FEATURES = 5,
		ONLY_FLAT = false
	})

	self:registerTile("wood", BrickBlock:Bind(self) {
		COLOR = Color.fromHexString("594a40"),
		FEATURE = "plank",
		SCALE = Vector(1, 1, 1),
		NUM_FEATURES = 2
	})
end

return IcyMountain
