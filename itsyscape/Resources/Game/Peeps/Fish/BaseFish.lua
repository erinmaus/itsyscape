--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Fish/BaseFish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseFish = Class(Creep)

function BaseFish:new(resource, name, ...)
	Creep.new(self, resource, name or "Fish_Base", ...)

	self:addPoke("reel")

	self:addBehavior(RotationBehavior)

	local movement = self:getBehavior(MovementBehavior)
	movement.maxSpeed = 6
	movement.float = 0.75

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 3.5)

	self.minReelCooldown = 2
	self.maxReelCooldown = 3
	self.currentReelCooldown = 0
end

function BaseFish:ready(director, game)
	Utility.Peep.Creep.setBody(self, "Fish")
	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Fish_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Fish_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-defend", "Fish_Defend")

	Creep.ready(self, director, game)
end

-- e -> { peep = I.Peep.Peep, tool = I.Game.ItemInstance }
function BaseFish:onReel(e)
	if self.currentReelCooldown > 0 then
		return
	end

	Utility.Peep.setMashinaState(self, "fish-reel", {
		["reel-peep"] = e and e.peep or false,
		["reel-tool-item"] = e and e.tool or false
	})

	self.currentReelCooldown = math.lerp(self.minReelCooldown, self.maxReelCooldown, love.math.random())
end

function BaseFish:update(director, game)
	Creep.update(self, director, game)

	Utility.Peep.face3D(self)

	self.currentReelCooldown = math.max(self.currentReelCooldown - game:getDelta())
end

return BaseFish
