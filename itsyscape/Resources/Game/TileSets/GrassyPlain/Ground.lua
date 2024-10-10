--------------------------------------------------------------------------------
-- Resources/Game/TileSets/GrassyPlain/Ground.lua
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
local GroundDecorations = require "ItsyScape.World.GroundDecorationsV2"
local GrassBlock = require "ItsyScape.World.GroundDecorations.GrassBlockV2"

local GrassyPlainGround = Class(GroundDecorations)

function GrassyPlainGround:new()
	GroundDecorations.new(self, "GrassyPlain")

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLOR = Color.fromHexString("558855"),
		FEATURE = "grass"
	})
end

return GrassyPlainGround
