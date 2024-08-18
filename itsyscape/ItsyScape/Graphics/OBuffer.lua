--------------------------------------------------------------------------------
-- ItsyScape/Graphics/OBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local OBuffer = Class()

OBuffer.OUTLINE_INDEX = 1

OBuffer.OUTLINE_FORMAT = 'rgba8'
OBuffer.NORMAL_FORMAT = 'rgba16f'
OBuffer.DEPTH_STENCIL_FORMAT = 'depth24'

function OBuffer:new(width, height)
	self._buffer = NGBuffer(OBuffer.OUTLINE_FORMAT);
	self:resize(width, height)
end

function OBuffer:getHandle()
	return self._buffer
end

function OBuffer:resize(width, height)
	self._buffer:resize(width, height)
end

function OBuffer:getWidth()
	return self._buffer:getWidth()
end

function OBuffer:getHeight()
	return self._buffer:getHeight()
end

function OBuffer:release()
	self._buffer:release()
end

function OBuffer:use()
	self._buffer:use()
end

function OBuffer:getOutline()
	return self._buffer:getCanvas(OBuffer.OUTLINE_INDEX)
end

function OBuffer:getDepthStencil()
	return self._buffer:getDepthStencil()
end

return OBuffer
