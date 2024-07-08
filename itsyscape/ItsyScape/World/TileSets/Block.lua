--------------------------------------------------------------------------------
-- ItsyScape/World/TileSets/Block.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Block, Metatable = Class()

function Block.Bind(Type, largeTileSet)
	return function(t)
		local block = Type(largeTileSet)

		for key, value in pairs(t) do
			if Type[key] ~= nil and key:match("[A-Z][0-9A-Z_]*") then
				local isSameLuaType = type(value) == type(Type[key]) and not (type(value) == "table" and getmetatable(value) ~= nil)
				local valueClassType, typeClassType = Class.getType(value), Class.getType(Type[key])
				local isSameType = type(value) == "table" and Class.isDerived(valueClassType, typeClassType)
				assert(isSameLuaType or isSameType, string.format("%s is not the same Lua type or Class", key))

				block[key] = value
			end
		end

		block:bind()

		return block
	end
end

function Block:new()
	self._cache = {}
end

function Block:_getCacheIndex(i, j, w, h, x, y, subW, subH)
	return (j - 1) * w + (i - 1) + 1, (y - 1) * subW + (x - 1) + 1
end

function Block:addCache(i, j, w, h, x, y, subW, subH, g)
	local index1, index2 = self:_getCacheIndex(i, j, w, h, x, y, subW, subH)

	local c = self._cache[index1] or {}
	assert(not c[index2])

	c[index2] = g
	self._cache[index1] = c
end

function Block:getCache(i, j, w, h, x, y, subW, subH)
	local index1, index2  = self:_getCacheIndex(i, j, w, h, x, y, subW, subH)
	return self._cache[index1] and self._cache[index1][index2]
end

function Block:bind()
	-- Nothing.
end

function Block:emit(drawType, tileSet, map, i, j, w, h, tileSetTile, tileSize)
	return Class.ABSTRACT()
end

function Metatable:__call(...)
	return self:emit(...)
end

return Block
