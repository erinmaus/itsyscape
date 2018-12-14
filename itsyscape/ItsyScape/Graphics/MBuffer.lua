--------------------------------------------------------------------------------
-- ItsyScape/Graphics/MBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

-- Represents the MBuffer.
--
-- An MBuffer is a mobile rendering buffer.
local MBuffer = Class()

-- Index of the color binding.
--
-- In the shader, these start at one less.
MBuffer.COLOR_INDEX = 1

-- Formats of the color and depth/stencil bindings.
MBuffer.COLOR_FORMAT = 'rgba4'
MBuffer.DEPTH_STENCIL_FORMAT = 'depth24stencil8'

-- Constructs a new MBuffer.
function MBuffer:new(width, height)
	self:resize(width, height)
end

-- Resizes the MBuffer. The previous contents are lost.
function MBuffer:resize(width, height)
	self:release()

	width = math.max(width or 1, 1)
	height = math.max(height or 1, 1)

	self.width = width
	self.height = height

	self.color = love.graphics.newCanvas(
		width, height, { format = MBuffer.COLOR_FORMAT })

	self.depth = love.graphics.newCanvas(
		width, height, { format = MBuffer.DEPTH_STENCIL_FORMAT })
end

-- Gets the depth of the MBuffer.
function MBuffer:getWidth()
	return self.width
end

-- Gets the height of the MBuffer.
function MBuffer:getHeight()
	return self.height
end

-- Frees all resources held by the MBuffer.
--
-- The contents are lost and the MBuffer cannot be used. Call MBuffer.resize to
-- return to a good state.
function MBuffer:release()
	if self.color then
		self.color:release()
		self.color = false
	end

	if self.depth then
		self.depth:release()
		self.depth = false
	end
end

-- Binds the MBuffer.
--
-- All rendering will now occur on the MBuffer.
function MBuffer:use()
	love.graphics.setCanvas({ self.color, depthstencil = self.depth })
end

-- Gets the color binding of the MBuffer.
function MBuffer:getColor()
	return self.color
end

-- Gets the depth/stencil binding of the MBuffer.
function MBuffer:getDepthStencil()
	return self.depth
end

return MBuffer
