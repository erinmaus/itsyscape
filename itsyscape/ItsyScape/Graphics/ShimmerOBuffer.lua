--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShimmerOBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local ShimmerOBuffer = Class()

ShimmerOBuffer.SHIMMER_COLOR_INDEX = 1

ShimmerOBuffer.SHIMMER_COLOR_FORMAT = 'rgba8'

function ShimmerOBuffer:new(width, height)
	self._buffer = NGBuffer(ShimmerOBuffer.SHIMMER_COLOR_FORMAT);
	self:resize(width, height)
end

function ShimmerOBuffer:getHandle()
	return self._buffer
end

function ShimmerOBuffer:resize(width, height)
	self._buffer:resize(width, height)
end

function ShimmerOBuffer:getWidth()
	return self._buffer:getWidth()
end

function ShimmerOBuffer:getHeight()
	return self._buffer:getHeight()
end

function ShimmerOBuffer:release()
	self._buffer:release()
end

function ShimmerOBuffer:use()
	self._buffer:use()
end

function ShimmerOBuffer:getShimmerColor()
	return self._buffer:getCanvas(ShimmerOBuffer.SHIMMER_COLOR_INDEX)
end

function ShimmerOBuffer:getDepthStencil()
	return self._buffer:getDepthStencil()
end

return ShimmerOBuffer
