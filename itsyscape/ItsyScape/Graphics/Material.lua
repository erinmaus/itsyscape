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
local NMaterial = require "nbunny.scenenodematerial"

local Material, Metatable = Class()

-- Constructs a new Material from the shader and textures.
--
-- If no shader is provided, the shader is set to a falsey value.
--
-- Nil values in textures are ignored.
function Material:new(node, shader, ...)
	self._handle = node._handle:getMaterial()
	self.shader = shader or false
	self:setTextures(...)
	self.isTranslucent = false
	self.isFullLit = false
	self.color = Color(1, 1, 1, 1)
	self.uniforms = {}
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
		self._handle:setShader(self.shader:getID())
	end
end

-- Sets a uniform to pass on to the shader.
--
-- If 'value' is nil, the uniform is unset.
--
-- 'key' must be a string.
function Material:setUniform(key, value)
	if type(key) == 'string' then
		self.uniforms[key] = value
	end
end

-- Gets an iterator over the uniforms.
function Material:getUniforms()
	return pairs(self.uniforms)
end

-- Unsets the shader.
function Material:unsetShader()
	self.shader = false
	self._handle:setShader(0)
end

-- Gets a boolean indicating if the Material is translucent.
function Material:getIsTranslucent()
	return self.isTranslucent or self.color.a < 1
end

-- Gets a boolean indicating if the Material is translucent.
--
-- Defaults to 'false'.
function Material:setIsTranslucent(value)
	self.isTranslucent = value or false
end

-- Returns true if the Material should be fully lit, false otherwise.
function Material:getIsFullLit(value)
	return self.isFullLit
end

function Material:setIsFullLit(value)
	self.isFullLit = value or false
end

function Material:getColor()
	return self.color
end

function Material:setColor(value)
	self.color = value or color
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
		table.insert(self.textures.n, t[i]:getID())
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
	self.textures.n[index] = self.textures[index]:getID()

	self._handle:setTextures(unpack(self.textures.n))
end

-- Unsets a texture at the specified index.
function Material:unsetTexture(index)
	table.remove(self.textures, index or 1)
	table.remove(self.textures.n, index or 1)

	self._handle:setTextures(unpack(self.textures.n))
end

-- Compares Materials by resources.
--
-- Does not consider translucency.
function Metatable.__lt(a, b)
	return a._handle < b._handle
end

return Material
