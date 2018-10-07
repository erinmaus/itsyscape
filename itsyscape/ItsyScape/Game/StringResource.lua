--------------------------------------------------------------------------------
-- ItsyScape/Graphics/StringResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local StringResource = Resource()

-- Basic string resource class.
function StringResource:new(text)
	Resource.new(self)

	if text then
		self.text = text
	else
		self.text = false
	end
end

function StringResource:getResource()
	return self.text
end

function StringResource:release()
	if self.text then
		self.text = false
	end
end

function StringResource:loadFromFile(filename, resourceManager)
	self:release()
	self.text = love.filesystem.read(filename)
end

function StringResource:getIsReady()
	if self.text then
		return true
	else
		return false
	end
end

return StringResource
