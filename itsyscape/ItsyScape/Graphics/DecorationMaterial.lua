--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DecorationMaterial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local serpent = require "serpent"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local Material = require "ItsyScape.Graphics.Material"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local StringBuilder = require "ItsyScape.Common.StringBuilder"

local DecorationMaterial = Class()

function DecorationMaterial:new(d)
	self.uniforms = {}
	self.properties = {
		color = Color(1),
		alpha = 1,
		outlineColor = Color(0),
		outlineThreshold = 0.5,
		isReflectiveOrRefractive = false,
		reflectionPower = 1,
		reflectionDistance = 2,
		roughness = 0
	}
	self.set = {}

	self.textures = {}
	self.texture = false
	self.shader = "Resources/Shaders/Decoration"

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	end
end

function DecorationMaterial:apply(sceneNode, resourceManager)
	local material = sceneNode:getMaterial()

	local textures = {}
	for _, textureFilename in ipairs(self.textures) do
		local TextureType
		if textureFilename:match("%.lua$") then
			TextureType = LayerTextureResource
		else
			TextureType = TextureResource
		end

		resourceManager:queue(
			TextureType,
			textureFilename,
			function(texture)
				table.insert(textures, texture)
			end)
	end

	if self.texture then
		local TextureType
		if self.texture:match("%.lua$") then
			TextureType = LayerTextureResource
		else
			TextureType = TextureResource
		end

		resourceManager:queue(
			TextureType,
			self.texture,
			function(texture)
				table.insert(textures, 1, texture)
			end)
	end

	resourceManager:queueEvent(function()
		if #textures >= 1 then
			material:setTextures(unpack(textures))
		end
	end)

	if self.shader then
		resourceManager:queue(
			ShaderResource,
			self.shader,
			function(shader)
				material:setShader(shader)
			end)
	end

	resourceManager:queueEvent(function()
		for uniformName, uniformValue in pairs(self.uniforms) do
			if uniformValue then
				if uniformValue.type == "texture" then
					material:send(Material.UNIFORM_TEXTURE, uniformName, textures[uniformValue.value[1]]:getResource())
				elseif uniformValue.type == "float" then
					material:send(Material.UNIFORM_FLOAT, uniformName, uniformValue.value)
				elseif uniformValue.type == "integer" then
					material:send(Material.UNIFORM_INTEGER, uniformName, uniformValue.value)
				end
			end
		end

		for name, property in pairs(self.properties) do
			if self.set[name] then
				local func = "set" .. name:sub(1, 1):upper() .. name:sub(2)
				material[func](material, property)
			end
		end
	end)
end

function DecorationMaterial:loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result)
end

function DecorationMaterial:loadFromTable(t)
	self.shader = t.shader == nil and self.shader or t.shader
	self.texture = t.texture or false

	self.set.texture = t.texture ~= nil
	self.set.shader = t.shader ~= nil

	table.clear(self.uniforms)
	table.clear(self.textures)

	if t.uniforms then
		for uniformName, inUniformValue in pairs(t.uniforms) do
			if inUniformValue then
				local uniformType = inUniformValue[1]

				local outUniformValue
				if uniformType == "texture" then
					table.insert(self.textures, inUniformValue[2])
					if self.texture then
						outUniformValue = { #self.textures + 1 }
					else
						outUniformValue = { #self.textures }
					end
				else
					outUniformValue = { unpack(inUniformValue, 2, #inUniformValue) }
				end

				self.uniforms[uniformName] = {
					type = uniformType,
					value = outUniformValue
				}
			else
				self.uniforms[uniformName] = {
					type = "unset",
					value = false
				}
			end
		end
	end

	local properties = t.properties or {}
	if properties.color ~= nil then
		self.set.color = true

		if type(properties.color) == "string" then
			self.properties.color = Color.fromHexString(properties.color)
		else
			self.properties.color = Color(unpack(properties.color))
		end
	else
		self.properties.color = Color(1)
	end

	if properties.alpha ~= nil then
		self.set.alpha = true
		self.properties.alpha = properties.alpha
	else
		self.properties.alpha = 1
	end

	if properties.outlineColor ~= nil then
		self.set.outlineColor = true

		if type(properties.outlineColor) == "string" then
			self.properties.outlineColor = Color.fromHexString(properties.outlineColor)
		else
			self.properties.outlineColor = Color(unpack(properties.outlineColor))
		end
	else
		self.properties.outlineColor = Color(0)
	end

	if properties.outlineThreshold ~= nil then
		self.set.outlineThreshold = true
		self.properties.outlineThreshold = properties.outlineThreshold
	else
		self.properties.outlineThreshold = 0.5
	end

	if properties.isTranslucent ~= nil then
		self.set.isTranslucent = true
		self.properties.isTranslucent = not not properties.isTranslucent
	else
		self.properties.isTranslucent = nil
	end

	if properties.isReflectiveOrRefractive ~= nil then
		self.set.isReflectiveOrRefractive = true
		self.properties.isReflectiveOrRefractive = not not properties.isReflectiveOrRefractive
	else
		self.properties.isReflectiveOrRefractive = false
	end

	if properties.isRefractive ~= nil then
		self.set.isRefractive = true
		self.properties.isRefractiveOrRefractive = not not properties.isRefractive
	end

	if properties.reflectionPower ~= nil then
		self.set.reflectionPower = true
		self.properties.reflectionPower = properties.reflectionPower
	else
		self.properties.reflectionPower = 1
	end

	if properties.reflectionDistance ~= nil then
		self.set.reflectionDistance = true
		self.properties.reflectionDistance = properties.reflectionDistance
	else
		self.properties.reflectionDistance = 2
	end

	if properties.roughness ~= nil then
		self.set.roughness = true
		self.properties.roughness = properties.roughness
	else
		self.properties.roughness = 0
	end
end

function DecorationMaterial:replace(other)
	local o = other:serialize()

	local result = self:serialize()
	if o.shader then
		result.shader = o.shader
	end

	if o.texture then
		result.texture = o.texture
	end

	for k, v in pairs(o.properties) do
		result.properties[k] = v
	end

	for k, v in pairs(o.uniforms) do
		result.uniforms[k] = v
	end

	return DecorationMaterial(result)
end

function DecorationMaterial:serialize()
	local shader
	if self.set.shader then
		shader = self.shader
	end

	local texture
	if self.set.texture then
		texture = self.texture
	end

	local result = {
			shader = shader,
			texture = texture,
			uniforms = {},
			properties = {
				color = self.set.color and self.properties.color:toHexString() or nil,
				alpha = self.set.alpha and self.properties.alpha or nil,
				outlineColor = self.set.outlineColor and self.properties.outlineColor:toHexString() or nil,
				outlineThreshold = self.set.outlineThreshold and self.properties.outlineThreshold or nil,
				isTranslucent = self.set.isTranslucent and self.properties.isTranslucent or nil,
				isReflectiveOrRefractive = self.set.isReflectiveOrRefractive and self.properties.isReflectiveOrRefractive or nil,
				reflectionPower = self.set.reflectionPower and self.properties.reflectionPower or nil,
				reflectionDistance = self.set.reflectionDistance and self.properties.reflectionDistance or nil,
				roughness = self.set.roughness and self.properties.roughness or nil
			}
		}

	for uniformName, uniformValue in pairs(self.uniforms) do
		if uniformValue.type ~= "unset" then
			result.uniforms[uniformName] = {
				uniformValue.type,
				unpack(uniformValue.value)
			}
		else
			result.uniforms[uniformValue] = false
		end
	end

	return result
end

function DecorationMaterial:toString()
	return serpent.block(self:serialize(), { comment = false })
end

return DecorationMaterial
