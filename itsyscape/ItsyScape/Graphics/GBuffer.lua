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
local NGBuffer = require "nbunny.optimaus.gbuffer"

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
	self._buffer = NGBuffer(GBuffer.COLOR_FORMAT, GBuffer.POSITION_FORMAT, GBuffer.NORMAL_SPECULAR_FORMAT);
	self:resize(width, height)
end

function GBuffer:getHandle()
	return self._buffer
end

-- Resizes the GBuffer. The previous contents are lost.
--
-- The dimensions are clamped to at least 1.
function GBuffer:resize(width, height)
	self._buffer:resize(width, height)
end

-- Gets the depth of the GBuffer.
function GBuffer:getWidth()
	return self._buffer:getWidth()
end

-- Gets the height of the GBuffer.
function GBuffer:getHeight()
	return self._buffer:getHeight()
end

-- Frees all resources held by the GBuffer.
--
-- The width and height will be 0 after this call.
--
-- The contents are lost and the GBuffer cannot be used. Call GBuffer.resize to
-- return to a good state.
function GBuffer:release()
	self._buffer:release()
end

-- Binds the GBuffer.
--
-- All rendering will now occur on the GBuffer.
function GBuffer:use()
	self._buffer:use()
end

-- Gets the color binding of the GBuffer.
function GBuffer:getColor()
	return self._buffer:getCanvas(GBuffer.COLOR_INDEX)
end

-- Gets the position binding of the GBuffer.
function GBuffer:getPosition()
	return self._buffer:getCanvas(GBuffer.POSITION_INDEX)
end

-- Gets the normal/specular binding of the GBuffer.
function GBuffer:getNormalSpecular()
	return self._buffer:getCanvas(GBuffer.NORMAL_SPECULAR_INDEX)
end

-- Gets the depth/stencil binding of the GBuffer.
function GBuffer:getDepthStencil()
	return self._buffer:getDepthStencil()
end

return GBuffer
