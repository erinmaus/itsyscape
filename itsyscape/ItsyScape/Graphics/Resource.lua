--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Resource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local NResource = require "nbunny.optimaus.resource"
local NResourceInstance = require "nbunny.optimaus.resourceinstance"

-- Constructs a Resource type.
--
-- This object functions semantically like ItsyScape.Common.Class.
--
-- Since Resource is abstract, it cannot (and should not) be instantiated.
-- Instead, derived types should be instantiated.
--
-- A Resource has a few static fields and methods:
--  * getCurrentID: The ID of the next resource. In this sense, CURRENT_ID
--                  represents the *pending* current ID.
--  * allocateID:   Returns and post-increments getCurrentID. getCurrentID should be
--                  one more than the return value. For example, if allocateID()
--                  returns 1, getCurrentID will now be 2.
--  * wrap:         Wraps the provided resource instance. This is an impl detail.
local Resource = Class()
Resource._currentID = 0
Resource._pending = {}

-- Constructor. Allocates a new ID for the Resource, bumping CURRENT_ID.
function Resource:new()
	self._resourceInstance = self:getType().wrap(self)
end

function Resource:getHandle()
	return self._resourceInstance
end

-- Gets the underyling Resource.
function Resource:getResource()
	return Class.ABSTRACT()
end

-- Releases the underlying Resource.
function Resource:release()
	return Class.ABSTRACT()
end

-- Loads the underyling resource from 'filename'.
function Resource:loadFromFile(filename, resourceManager)
	return Class.ABSTRACT()
end

function Resource._queue(type, filename)
	local id = Resource._currentID + 1

	love.thread.getChannel('ItsyScape.Resource.File::input'):push({
		id = id,
		type = type,
		filename = filename
	})

	Resource._currentID = id

	return id
end

function Resource._poll(id, filename)
	local result
	repeat
		result = Resource._pending[id]
		if not result then
			coroutine.yield()
		end
	until result

	Resource._pending[id] = nil
	return result
end

function Resource.readFile(filename)
	if coroutine.running() then
		local id = Resource._queue("file", filename)
		local resource = Resource._poll(id, filename)

		return resource.value
	else
		return love.filesystem.read(filename)
	end
end

function Resource.readLua(filename)
	if coroutine.running() then
		local id = Resource._queue("lua", filename)
		local resource = Resource._poll(id)

		return buffer.decode(resource.table)
	else
		local source, error = love.filesystem.read(filename)
		if not source then
			Log.error("Couldn't load model %s: %s", filename, error)
			return {}
		end

		local s = "return " .. source
		return assert(setfenv(loadstring(s), {}))()
	end
end

function Resource.quit()
	love.thread.getChannel('ItsyScape.Resource.File::input'):push({
		type = 'quit'
	})
end

function Resource.update()
	local c = 0
	local result
	repeat
		result = love.thread.getChannel('ItsyScape.Resource.File::output'):pop()
		if result then
			Resource._pending[result.id] = result
			c = c + 1
		end
	until not result
end

-- Returns a boolean value indicating if the resource is ready (e.g., loaded).
function Resource:getIsReady()
	return Class.ABSTRACT()
end

-- Returns the ID of the resource.
--
-- The resource ID is an incrementing value, never re-used, that represents
-- a loaded resource.
function Resource:getID()
	return self._resourceInstance:getID()
end

-- Override the constructor to create a new type, not a new instance.
local function __call(self, NBunnyResource)
	local DerivedResource = Class(Resource, 1)
	local nbunnyResource = (NBunnyResource or NResource)()

	DerivedResource.RESOURCE = nbunnyResource

	function DerivedResource.getCurrentID()
		return nbunnyResource:getCurrentID()
	end

	function DerivedResource.allocateID()
		return nbunnyResource:allocateID()
	end

	function DerivedResource.wrap(r)
		return nbunnyResource:instantiate(r)
	end

	return DerivedResource
end

getmetatable(Resource).__call = __call

return Resource
