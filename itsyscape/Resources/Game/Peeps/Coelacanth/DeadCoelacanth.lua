--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Coelacanth/DeadCoelacanth.lua
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
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"

local DeadCoelacanth = Class(BlockingProp)

function DeadCoelacanth:new(...)
	BlockingProp.new(self, ...)

	local scale = self:getBehavior(ScaleBehavior)
	scale.scale = Vector(2, 1, 2)

	local rotation = self:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi / 8) 
end

return DeadCoelacanth
