--------------------------------------------------------------------------------
-- Resources/Peeps/Dog/Dog.lua
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
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Dog = Class(Creep)
Dog.SIT = 2

function Dog:new(resource, name, ...)
	Creep.new(self, resource, name or 'Dog', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 2, 1)
	size.pan = Vector(-1, 1, 0)
	size.zoom = 2

	self.isSitting = false
	self.sittingDuration = 0
end

function Dog:ready(director, game)
	Utility.Peep.Creep.setBody(self, "Dog")
	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Dog_IdleStand")
	Utility.Peep.Creep.addAnimation(self, "animation-idle-stand", "Dog_IdleStand")
	Utility.Peep.Creep.addAnimation(self, "animation-idle-sit", "Dog_IdleSit")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Dog_Walk")
	Utility.Peep.Creep.addAnimation(self, "animation-die", "Dog_Die")
	Utility.Peep.Creep.addAnimation(self, "animation-attack", "Dog_Attack")

	Creep.ready(self, director, game)
end

function Dog:update(director, game)
	Creep.update(self, director, game)

	local movement = self:getBehavior(MovementBehavior)
	local targetTile = self:getBehavior(TargetTileBehavior)
	local isMoving = movement.velocity:getLength() > 0.1 or targetTile
	local actor = self:getBehavior(ActorReferenceBehavior).actor

	if not isMoving then
		self.sittingDuration = self.sittingDuration + game:getDelta()
		if self.sittingDuration >= Dog.SIT and not self.isSitting then
			local resource = self:getResource(
				"animation-idle-sit",
				"ItsyScape.Graphics.AnimationResource")
			actor:playAnimation('main', 1, resource)
			self.isSitting = true
		end
	else
		self.sittingDuration = 0
		self.isSitting = false
	end
end

return Dog
