--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/TypeProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local TypeProvider = Class()

function TypeProvider:serialize(obj, result, state, exceptions)
	Class.ABSTRACT()
end

function TypeProvider:deserialize(obj, state)
	return Class.ABSTRACT()
end

local Quaternion = require "ItsyScape.Common.Math.Quaternion"
TypeProvider.Quaternion = Class(TypeProvider)
function TypeProvider.Quaternion:serialize(obj, result, state, exceptions)
	result.x = obj.x
	result.y = obj.y
	result.z = obj.z
	result.w = obj.w
end

function TypeProvider.Quaternion:deserialize(obj, state)
	return Quaternion(obj.x, obj.y, obj.z, obj.w)
end

local Ray = require "ItsyScape.Common.Math.Ray"
TypeProvider.Ray = Class(TypeProvider)
function TypeProvider.Ray:serialize(obj, result, state, exceptions)
	result.origin = state:serialize(obj.origin)
	reuslt.direction = state:serialize(obj.direction)
end

function TypeProvider.Ray:deserialize(obj, state)
	return Ray(state:deserialize(obj.origin), state:deserialize(obj.direction))
end

local Vector = require "ItsyScape.Common.Math.Vector"
TypeProvider.Vector = Class(TypeProvider)
function TypeProvider.Vector:serialize(obj, result, state, exceptions)
	result.x = obj.x
	result.y = obj.y
	result.z = obj.z
end

function TypeProvider.Vector:deserialize(obj, state)
	return Vector(obj.x, obj.y, obj.z)
end

local CacheRef = require "ItsyScape.Game.CacheRef"
TypeProvider.CacheRef = Class(TypeProvider)
function TypeProvider.CacheRef:serialize(obj, result, state, exceptions)
	result.resourceTypeID = obj:getResourceTypeID()
	result.filename = obj:getFilename()
end

function TypeProvider.CacheRef:deserialize(obj, state)
	return CacheRef(obj.resourceTypeID, obj.filename)
end

local PlayerStorage = require "ItsyScape.Game.PlayerStorage"
TypeProvider.PlayerStorage = Class(TypeProvider)
function TypeProvider.PlayerStorage:serialize(obj, result, state, exceptions)
	result.storage = obj:serialize()
end

function TypeProvider.PlayerStorage:deserialize(obj, state)
	local storage = PlayerStorage()
	storage:deserialize(obj.storage)

	return storage
end

local Color = require "ItsyScape.Graphics.Color"
TypeProvider.Color = Class(TypeProvider)
function TypeProvider.Color:serialize(obj, result, state, exceptions)
	result.r = obj.r
	result.g = obj.g
	result.b = obj.b
	result.a = obj.a
end

function TypeProvider.Color:deserialize(obj, state)
	return Color(obj.r, obj.g, obj.b, obj.a)
end

local Decoration = require "ItsyScape.Graphics.Decoration"
TypeProvider.Decoration = Class(TypeProvider)
function TypeProvider.Decoration:serialize(obj, result, state, exceptions)
	result.decoration = obj:serialize()
end

function TypeProvider.Decoration:deserialize(obj, state)
	return Decoration(obj.decoration)
end

local Map = require "ItsyScape.World.Map"
TypeProvider.Map = Class(TypeProvider)
function TypeProvider.Map:serialize(obj, result, state, exceptions)
	result.map = obj:serialize()
end

function TypeProvider.Map:deserialize(obj, state)
	return Map.loadFromTable(obj.map)
end

local Tile = require "ItsyScape.World.Tile"
TypeProvider.Tile = Class(TypeProvider)
function TypeProvider.Tile:serialize(obj, result, state, exceptions)
	result.tile = state:serialize(obj:serialize())
end

function TypeProvider.Tile:deserialize(obj, state)
	return Tile(state:deserialize(obj.tile))
end

TypeProvider.Instance = Class(TypeProvider)
function TypeProvider.Instance:new(gameManager)
	self.gameManager = gameManager
end

function TypeProvider.Instance:serialize(obj, result, state, exceptions)
	result.id = (obj.getID and obj:getID()) or 0
end

function TypeProvider.Instance:deserialize(obj, state, exceptions)
	local instance = self.gameManager:getInstance(obj.typeName, obj.id)
	return instance and instance:getInstance()
end

return TypeProvider
