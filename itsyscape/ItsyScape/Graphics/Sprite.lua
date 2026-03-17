--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Sprite.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Sprite = Class()
Sprite.STACKS = true

function Sprite:new(spriteManager, node, offset)
	self.spriteManager = spriteManager
	self.node = node
	self.offset = offset:keep()
end

function Sprite:initParticleSystem(particleSystem, particleSystemProperties)
	for attribute, value in pairs(particleSystemProperties) do
		local setAttributeFunc = particleSystem['set' .. attribute]

		if setAttributeFunc then
			setAttributeFunc(particleSystem, unpack(value))
		else
			Log.error("Attribute '%s' is not a particle attribute.", attribute)
		end
	end

	if particleSystemProperties.Offset then
		particleSystem:setOffset(unpack(particleSystemProperties.Offset))
	end

	return particleSystem
end

function Sprite:getSpriteManager()
	return self.spriteManager
end

function Sprite:getSceneNode()
	return self.node
end

function Sprite:getOffset()
	return self.offset
end

function Sprite:spawn(...)
	self.isSpawned = true
end

function Sprite:poof()
	self.isSpawned = false
end

function Sprite:getIsSpawned()
	return self.isSpawned or false
end

function Sprite:isDone(time)
	return true
end

function Sprite:update(delta)
	-- Nothing.
end

function Sprite:draw(position, time)
	-- Nothing.
end

return Sprite
