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
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NTextureResource = require "nbunny.optimaus.textureresource"
local NTextureResourceInstance = require "nbunny.optimaus.textureresourceinstance"

local TextureResource = Resource(NTextureResource)

TextureResource.PASSES = {
	["Deferred"] = RendererPass.PASS_DEFERRED,
	["Forward"] = RendererPass.PASS_FORWARD,
	["Mobile"] = RendererPass.PASS_MOBILE,
	["Outline"] = RendererPass.PASS_OUTLINE
}

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

	for passFilename, passID in pairs(self.PASSES) do
		local perPassTextureFilename = filename:gsub(
			"(.*)(%..+)$",
			string.format("%%1@%s%%2", passFilename))

		if perPassTextureFilename ~= filename and love.filesystem.getInfo(perPassTextureFilename) then
			local perPassImage = love.graphics.newImage(perPassTextureFilename)
			perPassImage:setFilter("linear", "linear")

			self:getHandle():setPerPassTexture(passID, perPassImage)
		end
	end
end

function TextureResource:getIsReady()
	return self:getHandle():getTexture() ~= nil
end

return TextureResource
