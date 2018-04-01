--------------------------------------------------------------------------------
-- ItsyScape/Graphics/LBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local GBuffer = require "ItsyScape.Graphics.GBuffer"

-- Represents the LBuffer.
--
-- An LBuffer is the result of a GBuffer with lighting. It is dependent on a
-- GBuffer and must be resized when the GBuffer is resized.
local LBuffer = Class()

-- Index of the color and normal/specular bindings, starting at 1.
--
-- In the shader, these start at one less.
LBuffer.COLOR_INDEX = 1

-- Formats of the color and depth/stencil bindings.
LBuffer.COLOR_FORMAT = 'rgba8'
LBuffer.DEPTH_STENCIL_FORMAT = GBuffer.DEPTH_STENCIL_FORMAT

-- Constructs a new LBuffer from the provided GBuffer.
function LBuffer:new(gBuffer)
	self:resize(gBuffer)
end

-- Resizes the LBuffer. The previous contents are lost.
function LBuffer:resize(gBuffer)
	self:release()

	self.gBuffer = gBuffer

	self.color = love.graphics.newCanvas(
		gBuffer:getWidth(), gBuffer:getHeight(), { format = LBuffer.COLOR_FORMAT })
end

-- Gets the depth of the LBuffer.
function LBuffer:getWidth()
	return self.gBuffer:getWidth()
end

-- Gets the height of the LBuffer.
function LBuffer:getHeight()
	return self.gBuffer:getHeight()
end

-- Frees all resources held by the LBuffer.
--
-- The contents are lost and the LBuffer cannot be used. Call LBuffer.resize to
-- return to a good state.
function LBuffer:release()
	if self.color then
		self.color:release()
		self.color = false
	end
end

-- Binds the LBuffer.
--
-- All rendering will now occur on the LBuffer.
function LBuffer:use()
	love.graphics.setCanvas({ self.color, depthstencil = self.depthStencil })
end

-- Gets the color binding of the LBuffer.
function LBuffer:getColor()
	return self.color
end

-- Gets the depth/stencil binding of the LBuffer.
function LBuffer:getDepthStencil()
	return self.gBuffer:getDepthStencil()
end

return LBuffer
