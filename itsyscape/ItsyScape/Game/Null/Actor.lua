--------------------------------------------------------------------------------
-- ItsyScape/Game/Null/Actor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Actor = require "ItsyScape.Game.Model.Actor"

local NullActor = Class(Actor)

function NullActor:spawn(id)
	self.id = id
end

function NullActor:depart()
	self.id = Actor.NIL_ID
end

function NullActor:getID()
	return self.id
end

function NullActor:getName()
	return "Null"
end

function NullActor:getResourceType()
	return "Peep"
end

function NullActor:getResourceName()
	return "Null"
end

function NullActor:setName(value)
	-- Nothing.
end

function NullActor:setDirection(direction)
	-- Nothing.
end

function NullActor:getDirection()
	return Vector.ZERO
end

function NullActor:teleport(position)
	self.onTeleport(self, position)
end

function NullActor:move(position)
	self.onMove(self, position)
end

function NullActor:getPosition()
	return Vector.ZERO
end

function NullActor:getTile()
	return 0, 0, 1
end

function NullActor:getBounds()
	return Vector.ZERO, Vector.ZERO
end

function NullActor:getActions(scope)
	return {}
end

function NullActor:poke(action, scope)
	-- Nothing.
end

function NullActor:getCurrentHitpoints()
	return 100
end

function NullActor:getMaximumHitpoints()
	return 100
end

function NullActor:playAnimation(slot, priority, animation, force)
	self.onAnimationPlayed(self, slot, priority, animation)
end

function NullActor:setBody(body)
	self.onTransmogrified(self, body)
end

function NullActor:setSkin(slot, priority, skin)
	self.onSkinChanged(self, slot, priority, skin)
end

function NullActor:unsetSkin(slot, priority, skin)
	self.onSkinRemoved(self, slot, priority, skin)
end

function NullActor:getSkin(slot)
	return
end

return NullActor
