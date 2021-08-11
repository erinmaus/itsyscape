--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Decoration = require "ItsyScape.Graphics.Decoration"

local GroundDecorations = Class()
GroundDecorations.FUDGE = 50.3385959375047693

function GroundDecorations:new(id)
	self.decoration = Decoration({
		tileSetID = id
	})

	self.tileFunctions = {}
end

function GroundDecorations:noise(...)
	local args = { ... }
	for i = 1, #args do
		args[i] = args[i] * self.FUDGE
	end

	return love.math.noise(unpack(args))
end

function GroundDecorations:getDecoration()
	return self.decoration
end

function GroundDecorations:addFeature(id, position, rotation, scale, color)
	return self.decoration:add(id, position, rotation, scale, color)
end

function GroundDecorations:registerTile(name, func, ...)
	self.tileFunctions[name] = self.tileFunctions[name] or Callback()
	self.tileFunctions[name]:register(func, self, ...)
end

function GroundDecorations:emit(tileSet, map, i, j)
	local mapTile = map:getTile(i, j)
	local tileSetTile = tileSet:getTile(mapTile.flat)

	if tileSetTile then
		local name = tileSetTile.name
		local tileFunction = self.tileFunctions[name]
		if tileFunction then
			tileFunction(tileSet, map, i, j, tileSetTile, mapTile)
		end
	end
end

function GroundDecorations:emitAll(tileSet, map)
	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			self:emit(tileSet, map, i, j)
		end
	end
end 

return GroundDecorations
