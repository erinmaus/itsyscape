--------------------------------------------------------------------------------
-- ItsyScape/Game/Skin/ModelSkin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Skin = require "ItsyScape.Game.Skin.Skin"

local ModelSkin = Class(Skin)

-- Constructs a ModelSkin.
function ModelSkin:new()
	self.model = false
	self.texture = false
	self.isBlocking = true
end

-- Constructs a ModelSkin from a file at filename.
--
-- Structure of file is:
-- {
--   model = "<path to model>"     -- Absolute path to the model.
--   texture = "<path to texture>" -- Optional. Absolute path to the texture.
--   blocking = <boolean>          -- Optional. Whether or not the ModelSkin is blocking.
--                                 -- Defaults to true.
-- }
function ModelSkin:loadFromFile(filename)
	local file = "return " .. love.filesystem.read(filename)
	local chunk = assert(loadstring(file))
	local result = setfenv(chunk, {})()

	self.model = CacheRef("ItsyScape.Graphics.ModelResource", result.model)
	if result.texture then
		self.texture = CacheRef("ItsyScape.Graphics.TextureResource", result.texture)
	else
		self.texture = false
	end

	if result.isBlocking == nil then
		self.isBlocking = true
	else
		-- Ensure isBlocking is a boolean, not a truthy value.
		if result.isBlocking then
			self.isBlocking = true
		else
			self.isBlocking = false
		end
	end
end

-- Gets the model CacheRef.
function ModelSkin:getModel()
	return self.model
end

-- Gets the texture CacheRef. If the model is untextured, returns false.
function ModelSkin:getTexture()
	return self.texture
end

function ModelSkin:getIsBlocking()
	return self.isBlocking
end

return ModelSkin
