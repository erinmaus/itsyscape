--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Material.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

local Material, Metatable = Class()

-- Constructs a new Material from the shader and textures.
--
-- If no shader is provided, the shader is set to a falsey value.
--
-- Nil values in textures are ignored.
function Material:new(shader, ...)
	self.shader = shader or false
	self:setTextures(...)
	self.isTranslucent = false
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
end

-- Unsets the shader.
function Material:unsetShader()
	self.shader = false
end

-- Gets a boolean indicating if the Material is translucent.
function Material:getIsTranslucent()
	return self.isTranslucent
end

-- Gets a boolean indicating if the Material is translucent.
--
-- Defaults to 'false'.
function Material:setIsTranslucent(value)
	self.isTranslucent = value or false
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
function Material:setTextures(...)
	local t = { n = select('#', ...), ... }

	self.textures = {}
	for i = 1, t.n do
		table.insert(self.textures, t[i])
	end
end

-- Sets the texture at the specified index.
--
-- If value is nil, nothing happens.
--
-- Indices are clamped to [1, Material.getNumTextures + 1]. In essence, values
-- exceeding Material.getNumTextures will be appended.
function Material:setTexture(index, value)
	index = index or 1
	index = math.min(#self.textures, index) + 1

	self.textures[index] = value or self.textures[index]
end

-- Unsets a texture at the specified index.
function Material:unsetTexture(index)
	table.remove(self.textures, index or 1)
end

-- Compares Materials by resources.
--
-- Does not consider translucency.
function Metatable.__lt(a, b)
	if not a.shader and b.shader then
		return true
	elseif a.shader and not b.shader then
		return false
	elseif a.shader and b.shader and a.shader:getID() < b.shader:getID() then
		return true
	else
		for i = 1, #a.textures do
			if b.textures[i] and a.textures[i]:getID() < b.textures[i]:getID() then
				return true
			end
		end
	end

	return false
end

return Material
