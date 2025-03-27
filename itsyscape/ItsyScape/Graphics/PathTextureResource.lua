--------------------------------------------------------------------------------
-- ItsyScape/Graphics/PathTextureResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local PathTexture = require "ItsyScape.Graphics.PathTexture"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local PathTextureResource = Resource()

function PathTextureResource:new(texture)
	Resource.new(self)

	self.texture = texture or false
	self.perPassTextures = {}
end

function PathTextureResource:getResource()
	return self.texture
end

function PathTextureResource:release()
	self.texture = false
end

function PathTextureResource:loadFromFile(filename, resourceManager)
	self:release()
	self.texture = PathTexture.loadFromFile(filename)

	local modifiedFilename = filename:gsub("(.*)%.(.+)$", "%1.png")
	for passFilename, passID in pairs(TextureResource.PASSES) do
		local perPassTextureFilename = modifiedFilename:gsub(
			"(.*)(%..+)$",
			string.format("%%1@%s%%2", passFilename))

		if perPassTextureFilename ~= modifiedFilename and love.filesystem.getInfo(perPassTextureFilename) then
			local perPassImage = love.graphics.newImage(perPassTextureFilename)
			perPassImage:setFilter("linear", "linear")

			if passID == RendererPass.PASS_OUTLINE then
				perPassImage = TextureResource.generateOutlineImage(perPassImage)
			end

			self.perPassTextures[passID] = perPassImage
		end
	end

	return result
end

function PathTextureResource:copyPerPassTextures(destination)
	for passID, perPassImage in pairs(self.perPassTextures) do
		destination:getHandle():setPerPassTexture(passID, perPassImage)
	end
end

function PathTextureResource:getIsReady()
	if self.texture then
		return true
	else
		return false
	end
end

return PathTextureResource
