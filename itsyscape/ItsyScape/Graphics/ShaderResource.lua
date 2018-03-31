--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShaderResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Basic ShaderResource resource class.
--
-- This object can be sorted by values returned by getID.
local ShaderResource = Class()
ShaderResource.CURRENT_ID = 1

ShaderResource.Source = Class()
function ShaderResource.Source:new(pixel, vertex)
	self.pixel = pixel
	self.vertex = vertex
end

function ShaderResource.Source:getPixelSource()
	return self.pixel
end

function ShaderResource.Source:getVertexSource()
	return self.vertex
end

-- Constructs a new shader from the provided pixel and vertex shaders.
function ShaderResource:new(pixel, vertex)
	self.shader = ShaderResource.Source(pixel, vertex)

	self.id = ShaderResource.CURRENT_ID
	ShaderResource.CURRENT_ID = ShaderResource.CURRENT_ID + 1
end

-- Gets the underlying shader source.
function ShaderResource:getResource()
	return self.shader
end

-- Gets the ID of the ShaderResource.
function ShaderResource:getID()
	return self.id
end

return ShaderResource
