--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SkeletonAnimationResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"
local Resource = require "ItsyScape.Graphics.Resource"

local SkeletonAnimationResource = Resource()

function SkeletonAnimationResource:new(skeleton, animation)
	Resource.new(self)

	self.skeleton = skeleton or false
	self.animation = animation or false
end

function SkeletonAnimationResource:getResource()
	return self.animation
end

function SkeletonAnimationResource:release()
	if self.animation then
		self.animation = false
	end
end

function SkeletonAnimationResource:loadFromFile(filename, _, skeleton)
	local file = Resource.readLua(filename)
	self.animation = SkeletonAnimation(file, skeleton or self.skeleton)
end

function SkeletonAnimationResource:getIsReady()
	if self.animation then
		return true
	else
		return false
	end
end

return SkeletonAnimationResource
