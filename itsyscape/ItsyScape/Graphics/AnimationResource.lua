--------------------------------------------------------------------------------
-- ItsyScape/Graphics/AnimationResource.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local Animation = require "ItsyScape.Game.Animation.Animation"

local AnimationResource = Resource()

-- Basic AnimationResource resource class.
--
-- Stores an Animation.
function AnimationResource:new(animation)
	Resource.new(self)

	if self.animation then
		self.animation = animation
	else
		self.animation = false
	end
end

function AnimationResource:getResource()
	return self.animation
end

function AnimationResource:release()
	if self.animation then
		self.animation = false
	end
end

function AnimationResource:loadFromFile(filename, resourceManager)
	self:release()
	self.animation = Animation()
	self.animation:loadFromFile(filename)
end

function AnimationResource:getIsReady()
	if self.animation then
		return true
	else
		return false
	end
end

return AnimationResource
