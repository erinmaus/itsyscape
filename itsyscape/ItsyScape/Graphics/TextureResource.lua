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
local NTextureResource = require "nbunny.optimaus.textureresource"
local NTextureResourceInstance = require "nbunny.optimaus.textureresourceinstance"

local TextureResource = Resource(NTextureResource)

-- Basic TextureResource resource class.
--
-- Stores a Love2D image.
function TextureResource:new(image)
	Resource.new(self)
	self:getHandle():setTexture(image)
end

function TextureResource:getResource()
	return self:getHandle():getTexture()
end

-- Gets the width of the TextureResource.
function TextureResource:getWidth()
	local image = self:getResource()
	if image then
		return image:getWidth()
	else
		return 0
	end
end

-- Gets the height of the TextureResource.
function TextureResource:getHeight()
	local image = self:getResource()
	if image then
		return image:getHeight()
	else
		return 0
	end
end

function TextureResource:release()
	self:getHandle():setTexture()
end

function TextureResource:loadFromFile(filename, resourceManager)
	local image = love.graphics.newImage(filename) 
	image:setFilter('nearest', 'nearest')
	self:getHandle():setTexture(image)
end

function TextureResource:getIsReady()
	return self:getHandle():getTexture() ~= nil
end

return TextureResource
