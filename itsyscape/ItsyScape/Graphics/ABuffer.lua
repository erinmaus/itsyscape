--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ABuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local ABuffer = Class()

ABuffer.ALPHA_INDEX = 1

ABuffer.ALPHA_FORMAT = 'rgba8'
ABuffer.COLOR_FORMAT = 'rgba32f'
ABuffer.OUTLINE_COLOR_INDEX = 'rgba8'
ABuffer.DEPTH_STENCIL_FORMAT = 'depth24'

function ABuffer:new(width, height)
	self._buffer = NGBuffer(ABuffer.ALPHA_FORMAT, ABuffer.COLOR_FORMAT, ABuffer.OUTLINE_COLOR_INDEX);
	self:resize(width, height)
end

function ABuffer:getHandle()
	return self._buffer
end

function ABuffer:resize(width, height)
	self._buffer:resize(width, height)
end

function ABuffer:getWidth()
	return self._buffer:getWidth()
end

function ABuffer:getHeight()
	return self._buffer:getHeight()
end

function ABuffer:release()
	self._buffer:release()
end

function ABuffer:use()
	self._buffer:use()
end

function ABuffer:getOutline()
	return self._buffer:getCanvas(ABuffer.ALPHA_INDEX)
end

function ABuffer:getDepthStencil()
	return self._buffer:getDepthStencil()
end

return ABuffer
