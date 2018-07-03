--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Decoration.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"

local Decoration = Class()
Decoration.Feature = Class()

function Decoration.Feature:new(tileID, position, rotation, scale)
	self.tileID = tileID or false
	self.position = position or Vector(0)
	self.rotation = rotation or Quaternion(0)
	self.scale = scale or Vector(1)
end

function Decoration:getPosition()
	return self.position
end

function Decoration:setPosition(value)
	self.position = value or self.position
end

function Decoration:getRotation()
	return self.rotation
end

function Decoration:setRotation(value)
	self.rotation = value or self.rotation
end

function Decoration:getScale()
	return self.scale
end

function Decoration:setScale(value)
	self.scale = value or self.scale
end

function Decoration:new(d, skeleton)
	self.tileSetID = false
	self.features = {}

	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function Decoration:loadFromFile(filename, skeleton)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result, skeleton)
end

function Decoration:loadFromTable(t)
	self.tileSetID = t.tileSetID or self.tileSetID

	for i = 1, #t do
		local feature = t[i]
		local position = Vector(unpack(feature.position or { 0, 0, 0 }))
		local rotation = Quaternion(unpack(feature.rotation or { 0, 0, 0, 1 }))
		local scale = Vector(unpack(feature.scale or { 1, 1, 1 }))
		table.insert(self.features, Decoration.Feature(
			feature.id,
			position,
			rotation,
			scale
		))
	end
end

function Decoration:getTileSetID()
	return self.tileSetID
end

function Decoration:iterate()
	local index = 1

	return function()
		local current = self.features[index]
		if index <= #self.features then
			index = index + 1
		end

		return current
	end
end

return Decoration
