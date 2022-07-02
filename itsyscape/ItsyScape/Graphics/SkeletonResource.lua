--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SkeletonResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local Skeleton = require "ItsyScape.Graphics.Skeleton"
local NSkeletonResource = require "nbunny.optimaus.skeletonresource"

local SkeletonResource = Resource(NSkeletonResource)

-- Basic SkeletonResource resource class.
--
-- Stores a skeleton.
function SkeletonResource:new(skeleton)
	Resource.new(self)

	if skeleton then
		self.skeleton = skeleton
	else
		self.skeleton = false
	end
end

function SkeletonResource:getResource()
	return self.skeleton
end

function SkeletonResource:release()
	if self.skeleton then
		self.skeleton = false
	end
end

function SkeletonResource:loadFromFile(filename, resourceManager)
	self:release()

	local file = Resource.readLua(filename)
	self.skeleton = Skeleton(file, self:getHandle())
end

function SkeletonResource:getIsReady()
	if self.skeleton then
		return true
	else
		return false
	end
end

return SkeletonResource
