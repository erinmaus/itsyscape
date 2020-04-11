--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/ApplySkinInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"

local ApplySkinInstance = Class(CommandInstance)

function ApplySkinInstance:new(command)
	self.command = command or false
end

function ApplySkinInstance:start(animatable)
	if self.command then
		local skin = CacheRef(self.command:getSkinType(), self.command:getFilename())
		animatable:setSkin(self.command:getSlot(), self.command:getPriority(), skin)
	end
end

function ApplySkinInstance:pending(time, windingDown)
	if self.command then
		return time <= self.command:getDuration() and not windingDown
	end
end

function ApplySkinInstance:getDuration(windingDown)
	if self.command then
		return self.command:getDuration()
	end

	return 0
end

function ApplySkinInstance:stop(animatable)
	if self.command then
		local skin = CacheRef(self.command:getSkinType(), self.command:getFilename())
		animatable:setSkin(self.command:getSlot(), false, skin)
	end
end

return ApplySkinInstance
