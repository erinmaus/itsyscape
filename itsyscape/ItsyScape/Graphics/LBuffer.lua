--------------------------------------------------------------------------------
-- ItsyScape/Graphics/LBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local GBuffer = require "ItsyScape.Graphics.GBuffer"
local NLBuffer = require "nbunny.optimaus.lbuffer"

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
	self._buffer = NLBuffer(LBuffer.COLOR_FORMAT, gBuffer:getHandle())
end

-- Resizes the LBuffer. The previous contents are lost.
function LBuffer:resize(gBuffer)
	self._buffer:resize(gBuffer:getHandle())
end

-- Gets the depth of the LBuffer.
function LBuffer:getWidth()
	return self._buffer:getWidth()
end

-- Gets the height of the LBuffer.
function LBuffer:getHeight()
	return self._buffer:getHeight()
end

-- Frees all resources held by the LBuffer.
--
-- The contents are lost and the LBuffer cannot be used. Call LBuffer.resize to
-- return to a good state.
function LBuffer:release()
	self._buffer:release()
end

-- Binds the LBuffer.
--
-- All rendering will now occur on the LBuffer.
function LBuffer:use()
	self._buffer:use()
end

-- Gets the color binding of the LBuffer.
function LBuffer:getColor()
	return self._buffer:getColor()
end

-- Gets the depth/stencil binding of the LBuffer.
function LBuffer:getDepthStencil()
	return self._buffer:getDepthStencil()
end

return LBuffer
