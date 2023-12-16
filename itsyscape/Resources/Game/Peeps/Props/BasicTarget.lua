--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local Tile = require "ItsyScape.World.Tile"

local BasicTarget = Class(PassableProp)

function BasicTarget:update(...)
	PassableProp.update(self, ...)

	if self.target then
		Utility.Peep.setPosition(self, Utility.Peep.getPosition(self.target))

		local status = self.target:getBehavior(CombatStatusBehavior)
		if status and status.dead then
			Utility.Peep.poof(self)
		end
	end

	local rotation = self:getBehavior(RotationBehavior)
	rotation.rotation = Utility.Peep.getTileRotation(self)
end

function BasicTarget:setTarget(target, description)
	self.target = target or false
	self.description = description or false
end

function BasicTarget:getPropState()
	local offset = self:hasBehavior(PositionBehavior) and self:getBehavior(PositionBehavior).offset

	return {
		name = self.target and self.target:getName(),
		description = self.description,
		offset = offset and { offset:get() }
	}
end

return BasicTarget
