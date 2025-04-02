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

	self.nodes = {}
end

function SpriteManager:clear()
	for i = 1, #self.sprites do
		self.sprites[i]:poof()
	end

	table.clear(self.sprites)
	table.clear(self.nodes)
	table.clear(self.times)
end

function SpriteManager:getResources()
	return self.resourceManager
end

function SpriteManager:add(spriteID, node, offset, ...)
	local TypeName = string.format("Resources.Game.Sprites.%s", spriteID)
	local Type = require(TypeName)

	local nodes = self.nodes[node]
	if not nodes then
		nodes = {}
		self.nodes[node] = nodes
	end

	local numNodesOfType = 0
	for i = 1, #nodes do
		if nodes[i].id == spriteID then
			numNodesOfType = numNodesOfType + 1
		end
	end

	local sprite = Type(self, node, offset + numNodesOfType * Vector(0, 0.5, 0))
	sprite:spawn(...)

	table.insert(nodes, { sprite = sprite, id = spriteID })
	self.nodes[sprite] = node

	table.insert(self.sprites, sprite)
	self.times[sprite] = 0

	return sprite
end

function SpriteManager:poof(sprite)
	for i = 1, #self.sprites do
		if self.sprites[i] == sprite then
			local node = self.nodes[sprite]
			local nodes = self.nodes[node]
			for i = 1, #nodes do
				if nodes[i].sprite == sprite then
					table.remove(nodes, i)
					break
				end
			end

			if #nodes == 0 then
				self.nodes[node] = nil
			end
			self.nodes[sprite] = nil

			table.remove(self.sprites, i)
			self.times[sprite] = nil
			break
		end
	end
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
			self:poof(sprite)
			sprite:poof()
		else
			sprite:update(delta)

			index = index + 1
			time = time + delta
			self.times[sprite] = time
		end
	end
end

function SpriteManager:_isVisible(scene, node)
	local current = node
	while current do
		if current == scene then
			return true
		end

		current = current:getParent()
	end

	return false
end

function SpriteManager:draw(scene, camera, delta)
	local realWidth, realHeight = love.window.getMode()
	local scaledWidth, scaledHeight, scaleX, scaleY, paddingX, paddingY = love.graphics.getScaledMode()

	-- I messed something up with the fork in love.window.getMode that screws up
	-- the camera:apply() call (if camera:apply() is called BEFORE getMode)
	camera:apply()

	local positions = {}
	for i = 1, #self.sprites do
		local sprite = self.sprites[i]
		local transform = sprite:getSceneNode():getTransform():getGlobalDeltaTransform(delta)
		local position = Vector(transform:transformPoint(0, 0, 0)) + sprite:getOffset()

		local x, y, z = love.graphics.project(position:get())
		x = x / realWidth * scaledWidth
		y = y / realHeight * scaledHeight

		positions[sprite] = Vector(x, y, z)
	end

	table.sort(self.sprites, function(a, b)
		local i = positions[a]
		local j = positions[b]
		return i.z > j.z
	end)

	local width, height = love.graphics.getScaledMode()
	love.graphics.setBlendMode('alpha')
	love.graphics.origin()
	love.graphics.scale(scaleX, scaleY, 1)
	love.graphics.translate(paddingX, paddingY)
	love.graphics.ortho(realWidth, realHeight)

	for i = 1, #self.sprites do
		local sprite = self.sprites[i]
		local time = self.times[sprite]
		local position = positions[sprite]

		if self:_isVisible(scene, sprite:getSceneNode()) and position.z <= 1 then
			sprite:draw(position, time)
		end
	end
end

return SpriteManager
