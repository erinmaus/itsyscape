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
	-- Nothing.
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
