--------------------------------------------------------------------------------
-- ItsyScape/Graphics/TextureResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"

local TextureResource = Resource()

-- Basic TextureResource resource class.
--
-- Stores a Love2D image.
function TextureResource:new(image)
	Resource.new(self)

	if image then
		self.image = image
	else
		self.image = false
	end
end

function TextureResource:getResource()
	return self.image
end

-- Gets the width of the TextureResource.
function TextureResource:getWidth()
	if self.image then
		return self.image:getWidth()
	else
		return 0
	end
end

-- Gets the height of the TextureResource.
function TextureResource:getHeight()
	if self.image then
		return self.image:getHeight()
	else
		return 0
	end
end

function TextureResource:release()
	if self.image then
		self.image:release()
		self.image = false
	end
end

function TextureResource:loadFromFile(filename, resourceManager)
	self:release()
	self.image = love.graphics.newImage(filename)
end

function TextureResource:getIsReady()
	if self.image then
		return true
	else
		return false
	end
end

return TextureResource
