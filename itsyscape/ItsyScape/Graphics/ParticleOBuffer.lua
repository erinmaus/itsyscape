--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleOBuffer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local ParticleOBuffer = Class()

ParticleOBuffer.ALPHA_MASK_INDEX = 1

ParticleOBuffer.ALPHA_MASK_FORMAT = 'rgba8'
ParticleOBuffer.OUTLINE_COLOR_INDEX = 'rgba8'

function ParticleOBuffer:new(width, height)
	self._buffer = NGBuffer(ParticleOBuffer.ALPHA_MASK_FORMAT, ParticleOBuffer.OUTLINE_COLOR_INDEX);
	self:resize(width, height)
end

function ParticleOBuffer:getHandle()
	return self._buffer
end

function ParticleOBuffer:resize(width, height)
	self._buffer:resize(width, height)
end

function ParticleOBuffer:getWidth()
	return self._buffer:getWidth()
end

function ParticleOBuffer:getHeight()
	return self._buffer:getHeight()
end

function ParticleOBuffer:release()
	self._buffer:release()
end

function ParticleOBuffer:use()
	self._buffer:use()
end

function ParticleOBuffer:getAlphaMask()
	return self._buffer:getCanvas(ParticleOBuffer.ALPHA_MASK_INDEX)
end

function ParticleOBuffer:getDepthStencil()
	return self._buffer:getDepthStencil()
end

return ParticleOBuffer
