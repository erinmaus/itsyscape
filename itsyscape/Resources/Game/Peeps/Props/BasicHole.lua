--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicHole.lua
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
local Utility = require "ItsyScape.Game.Utility"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local Tile = require "ItsyScape.World.Tile"

local BasicHole = Class(BlockingProp)

function BasicHole:update(...)
	BlockingProp.update(self, ...)

	local rotation = self:getBehavior(RotationBehavior)
	rotation.rotation = Utility.Peep.getTileRotation(self)
end

return BasicHole
