--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/Block.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Block, Metatable = Class()

function Block.Bind(Type, groundDecorations)
	return function(t)
		local block = Type(groundDecorations)

		for key, value in pairs(t) do
			if Type[key] and key:match("[A-Z][0-9A-Z_]*") then
				local isSameLuaType = type(value) == type(Type[key]) and type(value) ~= "table"
				local valueClassType, typeClassType = Class.getType(value), Class.getType(Type[key])
				local isSameType = type(value) == "table" and Class.isDerived(valueClassType, typeClassType)
				assert(isSameLuaType or isSameType, string.format("%s is not the same Lua type or Class", key))

				block[key] = value
			end
		end

		return block
	end
end

function Block:new(groundDecorations)
	self.groundDecorations = groundDecorations
end

function Block:getGroundDecorations()
	return self.groundDecorations
end

function Block:addFeature(id, position, rotation, scale, color)
	self.groundDecorations:addFeature(id, position, rotation, scale, color)
end

function Block:noise(...)
	return self.groundDecorations:noise(...)
end

function Block:emit(tileSet, map, i, j, tileSetTile, mapTile)
	return Class.ABSTRACT()
end

function Metatable:__call(_, tileSet, map, i, j, tileSetTile, mapTile)
	return self:emit(tileSet, map, i, j, tileSetTile, mapTile)
end

return Block
