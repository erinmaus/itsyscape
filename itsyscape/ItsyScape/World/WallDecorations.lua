--------------------------------------------------------------------------------
-- ItsyScape/World/WallDecorations.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"

local WallDecorations = Class()

WallDecorations.MegaTexture = Class()

function WallDecorations.MegaTexture:new(id, material)
	self.id = id
	self.material = DecorationMaterial(material)
end

function WallDecorations.MegaTexture:getID()
	return self.id
end

function WallDecorations.MegaTexture:getMaterial()
	return self.material
end

function WallDecorations:new(id)
	self.tileSetID = id
	self.wallMegaTextures = {}
end

function WallDecorations:registerMegaTexture(name, material)
	for _, megaTexture in ipairs(self.wallMegaTextures) do
		if megaTexture:getID() == name then
			return false
		end
	end

	table.insert(self.wallMegaTextures, WallDecorations.MegaTexture(name, material))
	return true
end

function WallDecorations:iterateMegaTextures()
	return ipairs(self.wallMegaTextures)
end

return WallDecorations
