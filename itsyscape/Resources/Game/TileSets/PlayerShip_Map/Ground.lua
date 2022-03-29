--------------------------------------------------------------------------------
-- Resources/Game/TileSets/PlayerShip_Map/Ground.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local GroundDecorations = require "ItsyScape.World.GroundDecorations"
local BrickBlock = require "ItsyScape.World.GroundDecorations.BrickBlock"

local PlayerShipGround = Class(GroundDecorations)

function PlayerShipGround:new()
	GroundDecorations.new(self, "PlayerShip_Map")

	self:registerTile("wood", BrickBlock:Bind(self) {
		USE_TILE_COLOR = true,
		FEATURE = "plank",
		SCALE = Vector.ONE,
		NUM_FEATURES = 2
	})
end

return PlayerShipGround
