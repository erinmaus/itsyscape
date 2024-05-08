--------------------------------------------------------------------------------
-- ItsyScape/Graphics/PathTextureResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local PathTexture = require "ItsyScape.Graphics.PathTexture"

local PathTextureResource = Resource()

function PathTextureResource:new(texture)
	Resource.new(self)

	self.texture = texture or false
end

function PathTextureResource:getResource()
	return self.texture
end

function PathTextureResource:release()
	self.texture = false
end

function PathTextureResource:loadFromFile(filename, resourceManager)
	self:release()
	self.texture = PathTexture.loadFromFile(filename)
end

function PathTextureResource:getIsReady()
	if self.texture then
		return true
	else
		return false
	end
end

return PathTextureResource
