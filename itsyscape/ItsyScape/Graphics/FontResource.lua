--------------------------------------------------------------------------------
-- ItsyScape/Graphics/FontResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local FontResource = Resource()

-- Basic FontResource resource class.
--
-- Stores a font.
function FontResource:new(font)
	Resource.new(self)

	if font then
		self.font = font
	else
		self.font = false
	end
end

function FontResource:getResource()
	return self.font
end

function FontResource:release()
	if self.font then
		self.font:release()
		self.font = false
	end
end

function FontResource:loadFromFile(filename, resourceManager)
	self:release()

	local f, s = filename:match("([^@]*)(.*)")
	local size
	if s then
		size = tonumber(s:match("@(%d*)"))
	end

	self.font = love.graphics.newFont(f, size)
end

function FontResource:getIsReady()
	if self.font then
		return true
	else
		return false
	end
end

return FontResource
