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

if love.graphics then
	TextureResource.OUTLINE_MIPMAP_SHADER = love.graphics.newShader([[
		uniform vec2 scape_MipmapBlockSize;
		uniform vec2 scape_MipmapTexelScale;

		vec4 effect(vec4 color, Image image, vec2 textureCoordinate, vec2 screenCoordinates)
		{
			vec4 currentSample = Texel(image, textureCoordinate);
			float currentSampleLength = length(currentSample);
			for (float x = 0; x <= scape_MipmapBlockSize.x; x += scape_MipmapTexelScale.x)
			{
				for (float y = 0; y <= scape_MipmapBlockSize.y; y += scape_MipmapTexelScale.y)
				{
					vec4 subSample = Texel(image, textureCoordinate + vec2(x, y));
					float subSampleLength = length(subSample);
					if (subSample.a > 0.5 && (subSampleLength < currentSampleLength || subSample.a > currentSample.a))
					{
						currentSample.rgb = subSample.rgb;
						currentSample.a = max(subSample.a, currentSample.a);
						currentSampleLength = subSampleLength;
					}
				}
			}

			currentSample.a = step(0.3, currentSample.a);
			return vec4(currentSample.r, currentSample.g, currentSample.b, currentSample.a);
		}
	]])
end

TextureResource.PASSES = {
	["Deferred"] = RendererPass.PASS_DEFERRED,
	["Forward"] = RendererPass.PASS_FORWARD,
	["Mobile"] = RendererPass.PASS_MOBILE,
	["Outline"] = RendererPass.PASS_OUTLINE,
	["Reflection"] = RendererPass.PASS_REFLECTION,
	["Shadow"] = RendererPass.PASS_SHADOW
}

TextureResource.BOUND_TEXTURES = {
	["Specular"] = true,
	["Heightmap"] = true
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

function TextureResource.generateOutlineImage(image)
	local width = image:getWidth()
	local height = image:getHeight()

	local previousWidth = width
	local previousHeight = height
	local previousImage = image

	--local widthBreakpoint = math.max(image:getWidth() / 8, 256)
	--local heightBreakpoint = math.max(image:getHeight() / 8, 256)
	local widthBreakpoint = 0
	local heightBreakpoint = 0

	love.graphics.push("all")
	
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setShader(TextureResource.OUTLINE_MIPMAP_SHADER)
	local mipmaps = {}
	repeat
		local canvas = love.graphics.newCanvas(width, height)
		local blockWidth = previousWidth / width
		local blockHeight = previousHeight / height
		local texelScaleX = 1.0 / previousWidth
		local texelScaleY = 1.0 / previousHeight
		TextureResource.OUTLINE_MIPMAP_SHADER:send("scape_MipmapTexelScale", { texelScaleX, texelScaleY })
		TextureResource.OUTLINE_MIPMAP_SHADER:send("scape_MipmapBlockSize", { blockWidth * texelScaleX, blockHeight * texelScaleY })

		if width < widthBreakpoint or height < heightBreakpoint then
			previousImage:setFilter("linear", "linear")
			love.graphics.setShader()
		else
			previousImage:setFilter("nearest", "nearest")
		end

		love.graphics.clear(1, 1, 1, 0)
		love.graphics.setCanvas(canvas)
		previousImage:setWrap("clamp")
		love.graphics.draw(previousImage, 0, 0, 0, width / previousWidth, height / previousHeight)
		love.graphics.setCanvas()

		table.insert(mipmaps, canvas)

		previousWidth = width
		previousHeight = height
		previousImage = canvas

		width = math.max(math.floor(width / 2), 1)
		height = math.max(math.floor(height / 2), 1)
	until previousWidth == 1 and previousHeight == 1

	local result = love.graphics.newCanvas(image:getWidth(), image:getHeight(), { mipmaps = "manual" })
	love.graphics.setShader()
	for level, mipmap in ipairs(mipmaps) do
		love.graphics.setCanvas(result, level)
		love.graphics.clear(1, 1, 1, 0)
		love.graphics.draw(mipmap)
	end

	love.graphics.pop()
	result:setMipmapFilter("linear")
	result:setFilter("linear", "linear")
	result:setWrap("repeat")

	return result
end

function TextureResource:loadFromFile(filename, resourceManager)
	local imageData = Resource.readImageData(filename)
	local image = love.graphics.newImage(imageData)
	imageData:release()

	image:setFilter('nearest', 'nearest')
	image:setWrap("repeat")
	self:getHandle():setTexture(image)

	for passFilename, passID in pairs(self.PASSES) do
		local perPassTextureFilename = filename:gsub(
			"(.*)(%..+)$",
			string.format("%%1@%s%%2", passFilename))

		if perPassTextureFilename ~= filename and love.filesystem.getInfo(perPassTextureFilename) then
			local perPassImage = love.graphics.newImage(perPassTextureFilename)
			perPassImage:setFilter("linear", "linear")
			perPassImage:setWrap("repeat")

			if passID == RendererPass.PASS_OUTLINE then
				perPassImage = TextureResource.generateOutlineImage(perPassImage)
			end

			self:getHandle():setPerPassTexture(passID, perPassImage)

			if coroutine.running() then
				coroutine.yield()
			end
		end
	end

	for passFilename in pairs(self.BOUND_TEXTURES) do
		local boundTextureFilename = filename:gsub(
			"(.*)(%..+)$",
			string.format("%%1@%s%%2", passFilename))

		if boundTextureFilename ~= filename and love.filesystem.getInfo(boundTextureFilename) then
			local boundImage = love.graphics.newImage(boundTextureFilename)
			boundImage:setFilter('linear', 'linear')
			boundImage:setWrap("repeat")

			self:getHandle():setBoundTexture(passFilename, boundImage)

			if coroutine.running() then
				coroutine.yield()
			end
		end
	end
end

function TextureResource:getIsReady()
	return self:getHandle():getTexture() ~= nil
end

return TextureResource
