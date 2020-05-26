--------------------------------------------------------------------------------
-- ItsyScape/Graphics/GBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local GBuffer = Class()

-- Index of the color, position, and normal/specular bindings, starting at 1.
--
-- In the shader, these start at one less.
GBuffer.COLOR_INDEX = 1
GBuffer.POSITION_INDEX = 2
GBuffer.NORMAL_SPECULAR_INDEX = 3

-- Formats of the color, posotion, normal/specular, and depth/stencil bindings.
GBuffer.COLOR_FORMAT = 'rgba8'
GBuffer.POSITION_FORMAT = 'rgba16f'
GBuffer.NORMAL_SPECULAR_FORMAT = 'rgba16f'
GBuffer.DEPTH_STENCIL_FORMAT = 'depth24stencil8'

-- Constructs a new GBuffer with the provided dimensions.
--
-- The dimensions are clamped to at least 1.
function GBuffer:new(width, height)
	self:resize(width, height)
end

-- Resizes the GBuffer. The previous contents are lost.
--
-- The dimensions are clamped to at least 1.
function GBuffer:resize(width, height)
	self:release()

	width = math.max(width, 1)
	height = math.max(height, 1)

	self.width = width
	self.height = height

	self.color = love.graphics.newCanvas(
		width, height, { format = GBuffer.COLOR_FORMAT })
	self.position = love.graphics.newCanvas(
		width, height, { format = GBuffer.POSITION_FORMAT })
	self.normalSpecular = love.graphics.newCanvas(
		width, height, { format = GBuffer.NORMAL_SPECULAR_FORMAT })
	self.depthStencil = love.graphics.newCanvas(
		width, height, { format = GBuffer.DEPTH_STENCIL_FORMAT })
end

-- Gets the depth of the GBuffer.
function GBuffer:getWidth()
	return self.width
end

-- Gets the height of the GBuffer.
function GBuffer:getHeight()
	return self.height
end

-- Frees all resources held by the GBuffer.
--
-- The width and height will be 0 after this call.
--
-- The contents are lost and the GBuffer cannot be used. Call GBuffer.resize to
-- return to a good state.
function GBuffer:release()
	if self.color then
		self.color:release()
		self.color = false
	end

	if self.position then
		self.position:release()
		self.position = false
	end

	if self.normalSpecular then
		self.normalSpecular:release()
		self.normalSpecular = false
	end

	if self.depthStencil then
		self.depthStencil:release()
		self.depthStencil = false
	end

	self.width = 0
	self.height = 0
end

-- Binds the GBuffer.
--
-- All rendering will now occur on the GBuffer.
function GBuffer:use()
	love.graphics.setCanvas({
		self.color,
		self.position,
		self.normalSpecular,
		depthstencil = self.depthStencil })
end

-- Gets the color binding of the GBuffer.
function GBuffer:getColor()
	return self.color
end

-- Gets the position binding of the GBuffer.
function GBuffer:getPosition()
	return self.position
end

-- Gets the normal/specular binding of the GBuffer.
function GBuffer:getNormalSpecular()
	return self.normalSpecular
end

-- Gets the depth/stencil binding of the GBuffer.
function GBuffer:getDepthStencil()
	return self.depthStencil
end

return GBuffer
