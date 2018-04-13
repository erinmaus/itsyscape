--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/Actor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"

-- Actor, representing anything like an NPC, player, or monster.
local Actor = Class()

-- Represents an invalid ID.
Actor.NIL_ID = 0

function Actor:new()
	self.onAnimationPlayed = Callback()
	self.onSkinChanged = Callback()
	self.onMove = Callback()
	self.onTeleport = Callback()
end

-- Spawns the Actor, assigning it the given unique ID.
function Actor:spawn(id)
	Class.ABSTRACT()
end

-- Called when the Actor leaves the Stage.
--
-- Should set ID to Actor.NIL_ID.
function Actor:depart()
	Class.ABSTRACT()
end

-- Gets the Actor's unique ID, or Actor.NIL_ID if the actor is not spawned.
function Actor:getID()
	return Class.ABSTRACT()
end

-- Gets the name of the Actor.
function Actor:getName()
	return Class.ABSTRACT()
end

-- Sets the name of the Actor.
function Actor:setName(value)
	Class.ABSTRACT()
end

-- Gets the direction of the Actor, as a Vector.
function Actor:getDirection()
	return Class.ABSTRACT()
end

-- Gets the absolution position of the Actor in the world as a Vector.
--
-- When position changes, onTeleport should be called if the movement is instant,
-- otherwise onMove should be called.
function Actor:getPosition()
	return Class.ABSTRACT()
end

-- Gets the current health of the Actor.
function Actor:getCurrentHealth()
	return Class.ABSTRACT()
end

-- Gets the maximum health of the Actor.
function Actor:getMaximumHealth()
	return Class.ABSTRACT()
end

-- Makes the Actor play the Animation-like object on the provided slot.
--
-- If 'priority' is lower than the current animation's priority in the provided
-- slot, the animation is not played.
--
-- Should invoke Actor.onAnimationPlayed with the slot and animation if
-- successful.
--
-- Returns true if the animation was played, false otherwise.
function Actor:playAnimation(slot, priority, animation)
	return Class.ABSTRACT()
end

-- Sets a skin at the provided slot.
--
-- skin should be a Skin-like object.
--
-- Should invoke Actor.onSkinChanged with the slot, priority, and skin.
function Actor:setSkin(slot, priority, skin)
	Class.ABSTRACT()
end

-- Returns the skins at the slot, or nil if no skin is set.
--
-- Return values are in the order skin1, priority1, ..., skinN, priorityN.
function Actor:getSkin(slot)
	return Class.ABSTRACT()
end

return Actor
