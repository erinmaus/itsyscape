--------------------------------------------------------------------------------
-- ItsyScape/Graphics/LayerTextureResource.lua
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

local LayerTextureResource = Resource(NTextureResource)

LayerTextureResource.TYPE_NONE  = 'none'
LayerTextureResource.TYPE_CUBE  = 'cube'
LayerTextureResource.TYPE_ARRAY = 'array'

LayerTextureResource.ROOT_PATH_PATTERN = "/?([^/]*)$"

LayerTextureResource.INDEX_ALL = 'all'
LayerTextureResource.INDEXES = {
	"plusX",
	"plusY",
	"plusZ",
	"minusX",
	"minusY",
	"minusZ"
}

function LayerTextureResource:new(image)
	Resource.new(self)
	self:getHandle():setTexture(image)
end

function LayerTextureResource:getResource()
	return self:getHandle():getTexture()
end

function LayerTextureResource:getWidth()
	local image = self:getResource()
	if image then
		return image:getWidth()
	else
		return 0
	end
end

function LayerTextureResource:getHeight()
	local image = self:getResource()
	if image then
		return image:getHeight()
	else
		return 0
	end
end

function LayerTextureResource:getLayerCount()
	local image = self:getResource()
	if image then
		return image:getLayerCount()
	else
		return 0
	end
end

function LayerTextureResource:getLayerType()
	return self.layerType or LayerTextureResource.TYPE_NONE
end

function LayerTextureResource:release()
	self:getHandle():setTexture(nil)
end

function LayerTextureResource:loadFromFile(filename, resourceManager)
	self:release()

	local r, e = loadstring('return ' .. love.filesystem.read(filename))
	if not r then
		Log.error("Error parsing layer texture '%s': %s", filename, e)
	end

	r, e = pcall(setfenv(r, {}))
	if not r then
		Log.error("Error processing layer texture '%s': %s", filename, e)
	end

	local t = {}
	if e.type == LayerTextureResource.TYPE_CUBE then
		for i = 1, #e do
			local slice = e[i]
			local defaultTexture = slice[LayerTextureResource.INDEX_ALL]
			for j = 1, #LayerTextureResource.INDEXES do
				local layerTexture = slice[LayerTextureResource.INDEXES[j]] or defaultTexture
				if not layerTexture then
					Log.warn(
						"Slice (index: %d) missing texture for name '%s'.",
						i,
						slice[LayerTextureResource.INDEXES[j]])
				else
					table.insert(t, layerTexture)
				end
			end
		end
	else
		if e.type ~= LayerTextureResource.TYPE_ARRAY then
			Log.warn("Unrecognized layer texture type '%s'; assuming '%s'.", e.type, LayerTextureResource.TYPE_ARRAY)
		end

		for i = 1, #e do
			table.insert(t, e[i])
		end
	end

	-- Normalize path
	local normalizedPath = filename:gsub(LayerTextureResource.ROOT_PATH_PATTERN, "")
	for i = 1, #t do
		t[i] = string.format("%s/%s", normalizedPath, t[i])
	end

	local settings = e.settings or nil

	local image = love.graphics.newArrayImage(t, settings)
	image:setFilter('nearest', 'nearest')
	self.layerType = e.type or LayerTextureResource.TYPE_ARRAY	
	self:getHandle():setTexture(image)
end

function LayerTextureResource:getIsReady()
	return self:getResource() ~= nil
end

return LayerTextureResource
