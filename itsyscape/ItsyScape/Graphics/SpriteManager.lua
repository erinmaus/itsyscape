--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SpriteManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local SpriteManager = Class()

function SpriteManager:new(resourceManager)
	self.resourceManager = resourceManager
	self.sprites = {}
	self.times = {}
end

function SpriteManager:getResources()
	return self.resourceManager
end

function SpriteManager:add(spriteID, node, offset, ...)
	local TypeName = string.format("Resources.Game.Sprites.%s", spriteID)
	local Type = require(TypeName)

	local sprite = Type(self, node, offset)
	sprite:spawn(...)

	table.insert(self.sprites, sprite)
	self.times[sprite] = 0

	return sprite
end

function SpriteManager:reset(sprite)
	if self.times[sprite] then
		self.times[sprite] = 0
	end
end

function SpriteManager:update(delta)
	local index = 1
	while index <= #self.sprites do
		local sprite = self.sprites[index]
		local time = self.times[sprite]

		if sprite:isDone(time) then
			table.remove(self.sprites, index)
			self.times[sprite] = nil
			sprite:poof()
		else
			index = index + 1
			time = time + delta
			self.times[sprite] = time
		end
	end
end

function SpriteManager:draw(camera, delta)
	camera:apply()

	local positions = {}
	for i = 1, #self.sprites do
		local sprite = self.sprites[i]
		local transform = sprite:getSceneNode():getTransform():getGlobalDeltaTransform(delta)
		local position = Vector(transform:transformPoint(0, 0, 0)) + sprite:getOffset()

		positions[sprite] = Vector(love.graphics.project(position.x, position.y, position.z))
	end

	local width, height = love.window.getMode()
	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.ortho(width, height)

	for i = 1, #self.sprites do
		local sprite = self.sprites[i]
		local time = self.times[sprite]
		local position = positions[sprite]

		sprite:draw(position, time)
	end
end

return SpriteManager
