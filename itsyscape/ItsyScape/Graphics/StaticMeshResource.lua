--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShaderResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local StaticMesh = require "ItsyScape.Graphics.StaticMesh"
local Resource = require "ItsyScape.Graphics.Resource"
local NStaticMeshResource = require "nbunny.optimaus.staticmeshresource"

local StaticMeshResource = Resource(NStaticMeshResource)

function StaticMeshResource:new(mesh)
	Resource.new(self)

	self.mesh = mesh or false
end

function StaticMeshResource:getResource()
	return self.mesh
end

function StaticMeshResource:release()
	if self.mesh then
		self.mesh:release()
		self.mesh = false
	end
end

function StaticMeshResource:loadFromFile(filename)
	local file = Resource.readLua(filename)
	self.mesh = StaticMesh(file, self:getHandle())
end

function StaticMeshResource:getIsReady()
	if self.mesh then
		return true
	else
		return false
	end
end

return StaticMeshResource
