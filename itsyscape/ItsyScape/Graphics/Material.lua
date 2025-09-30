--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Material.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local NMaterial = require "nbunny.optimaus.scenenodematerial"

local Material, Metatable = Class()

Material.DEFAULT_OUTLINE_THRESHOLD = 0.05

Material.UNIFORM_INTEGER = 1
Material.UNIFORM_FLOAT   = 2
Material.UNIFORM_TEXTURE = 3

-- Constructs a new Material from the shader and textures.
--
-- If no shader is provided, the shader is set to a falsey value.
--
-- Nil values in textures are ignored.
function Material:new(node, shader, ...)
	self._handle = node:getHandle():getMaterial()
	self._handle:setOutlineThreshold(Material.DEFAULT_OUTLINE_THRESHOLD)
	self.shader = shader or false
	self:setTextures(...)
end

function Material:getHandle()
	return self._handle
end

-- Gets the shader this Material uses.
function Material:getShader()
	return self.shader
end

-- Sets the shader to the provided value.
--
-- Does nothing if value is nil.
function Material:setShader(value)
	self.shader = value or self.shader
	if self.shader then
		self._handle:setShader(self.shader:getHandle())
	end
end

-- Unsets the shader.
function Material:unsetShader()
	self.shader = false
	self._handle:setShader(0)
end

-- Gets a boolean indicating if the Material is translucent.
function Material:getIsTranslucent()
	return self._handle:getIsTranslucent()
end

-- Gets a boolean indicating if the Material is translucent.
--
-- Defaults to 'false'.
function Material:setIsTranslucent(value)
	self._handle:setIsTranslucent(value or false)
end

function Material:getIsStencilWriteEnabled()
	return self._handle:getIsStencilWriteEnabled()
end

function Material:setIsStencilWriteEnabled(value)
	self._handle:setIsStencilWriteEnabled(value == nil and false or value)
end

function Material:getIsStencilMaskEnabled()
	return self._handle:getIsStencilMaskEnabled()
end

function Material:setIsStencilMaskEnabled(value)
	self._handle:setIsStencilMaskEnabled(value == nil and false or value)
end

-- Returns true if the Material should be fully lit, false otherwise.
function Material:getIsFullLit()
	return self._handle:getIsFullLit()
end

function Material:setIsFullLit(value)
	self._handle:setIsFullLit(value or false)
end

function Material:getIsParticulate()
	return self._handle:getIsParticulate()
end

function Material:setIsParticulate(value)
	self._handle:setIsParticulate(value or false)
end

function Material:getIsShadowCaster()
	return self._handle:getIsShadowCaster()
end

function Material:setIsShadowCaster(value)
	self._handle:setIsShadowCaster(value == nil and true or not not value)
end

function Material:getIsRendered()
	return self._handle:getIsRendered()
end

function Material:setIsRendered(value)
	self._handle:setIsRendered(value == nil and value or not not value)
end

-- If true, the node this material belongs to will use the camera's target position
-- for forward rendering light locality checks (sometimes good for massive objects)! If false,
-- will use the node's current position instead. Defaults to false.
function Material:getIsLightTargetPositionEnabled()
	return self._handle:getIsLightTargetPositionEnabled()
end

function Material:setIsLightTargetPositionEnabled(value)
	self._handle:setIsLightTargetPositionEnabled(value or false)
end

-- Returns true if the Material should not write to the depth buffer, false otherwise.
function Material:getIsZWriteDisabled()
	return self._handle:getIsZWriteDisabled()
end

function Material:setIsZWriteDisabled(value)
	self._handle:setIsZWriteDisabled(value or false)
end

-- Returns true if the Material should always be drawn, false otherwise.
-- Defaults to false (the object will only be drawn if visible).
function Material:getIsCullDisabled()
	return self._handle:getIsCullDisabled()
end

function Material:setIsCullDisabled(value)
	self._handle:setIsCullDisabled(value or false)
end

function Material:getOutlineThreshold()
	return self._handle:getOutlineThreshold()
end

function Material:setOutlineThreshold(value)
	self._handle:setOutlineThreshold(value or 0.5)
end

function Material:getZBias()
	return self._handle:getZBias()
end

function Material:setZBias(value)
	self._handle:setZBias(value)
end

function Material:getIsReflectiveOrRefractive()
	return self._handle:getIsReflectiveOrRefractive()
end

function Material:setIsReflectiveOrRefractive(value)
	self._handle:setIsReflectiveOrRefractive(value)
end

function Material:getReflectionPower()
	local result = self._handle:getReflectionPower()
	if result > 1 then
		return 0
	end

	return result
end

function Material:getRefractionPower()
	local result = self._handle:getReflectionPower()
	if result < 1 then
		return 0
	end

	return result - 1
end

function Material:setReflectionPower(value)
	self._handle:setReflectionPower(math.clamp(value, 0, 1))
end

function Material:setRefractionPower(value)
	self._handle:setReflectionPower(math.clamp(value, 0, 1) + 1)
end

function Material:getReflectionDistance()
	return self._handle:getReflectionDistance()
end

function Material:setReflectionDistance(value)
	self._handle:setReflectionDistance(value)
end

function Material:getRoughness()
	return self._handle:getRoughness()
end

function Material:setRoughness(value)
	self._handle:setRoughness(value)
end

function Material:getColor()
	return Color(self._handle:getColor())
end

function Material:setColor(value)
	self._handle:setColor((value or Color(1)):get())
end

function Material:getAlpha()
	return self:getColor().a
end

function Material:setAlpha(value)
	local c = self:getColor()
	self:setColor(Color(c.r, c.g, c.b, value))
end

function Material:getOutlineColor()
	return Color(self._handle:getOutlineColor())
end

function Material:setOutlineColor(value)
	self._handle:setOutlineColor((value or Color(0)):get())
end

function Material:getIsShimmerEnabled()
	return self._handle:getIsShimmerEnabled()
end

function Material:setIsShimmerEnabled(value)
	self._handle:setIsShimmerEnabled(value)
end

function Material:getShimmerColor()
	return Color(self._handle:getShimmerColor())
end

function Material:setShimmerColor(value)
	self._handle:setShimmerColor((value or Color(0)):get())
end

-- Gets the number of textures.
function Material:getNumTextures()
	return #self.textures
end

-- Gets a texture the specified index, or nil if there is no texture at that
-- index.
function Material:getTexture(index)
	return self.textures[index]
end

-- Sets the textures in one go.
--
-- Textures are expected to be TextureResource objects.
function Material:setTextures(...)
	local t = { n = select('#', ...), ... }

	self.textures = { n = {} }
	for i = 1, t.n do
		table.insert(self.textures, t[i])
		table.insert(self.textures.n, t[i]:getHandle())
	end

	self._handle:setTextures(unpack(self.textures.n))
end

-- Sets the texture at the specified index.
--
-- Textures are expected to be TextureResource objects.
--
-- If value is nil, nothing happens.
--
-- Indices are clamped to [1, Material.getNumTextures + 1]. In essence, values
-- exceeding Material.getNumTextures will be appended.
function Material:setTexture(index, value)
	index = index or 1
	index = math.min(#self.textures, index) + 1

	self.textures[index] = value or self.textures[index]
	self.textures.n[index] = self.textures[index]

	self._handle:setTextures(unpack(self.textures.n))
end

-- Unsets a texture at the specified index.
function Material:unsetTexture(index)
	table.remove(self.textures, index or 1)
	table.remove(self.textures.n, index or 1)

	self._handle:setTextures(unpack(self.textures.n))
end

function Material:send(uniformType, uniform, ...)
	local data = {}

	for i = 1, select("#", ...) do
		local values = select(i, ...)

		if type(values) == "table" then
			for _, a in ipairs(values) do
				if type(a) == "table" then
					for _, b in ipairs(a) do
						table.insert(data, b)
					end
				else
					table.insert(data, a)
				end
			end
		else
			table.insert(data, values)
		end
	end

	if uniformType == Material.UNIFORM_INTEGER then
		self._handle:setIntUniform(uniform, data)
	elseif uniformType == Material.UNIFORM_TEXTURE then
		self._handle:setTextureUniform(uniform, unpack(data))
	else
		self._handle:setFloatUniform(uniform, data)
	end
end

-- Compares Materials by resources.
--
-- Does not consider translucency.
function Metatable.__lt(a, b)
	return a._handle < b._handle
end

return Material
