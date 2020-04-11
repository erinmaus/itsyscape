--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/Wait.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Game.Animation.Commands.Command"
local WaitInstance = require "ItsyScape.Game.Animation.Commands.WaitInstance"
local SkeletonAnimation = require "ItsyScape.Graphics.SkeletonAnimation"

-- Command to wait.
--
-- Takes the form:
--
-- Wait(time) where 'time' is in seconds
local Wait, Metatable = Class(Command)

-- Constructs a new Wait command.
function Wait:new(time)
	self.duration = duration or 0
end

function Metatable:__call()
	return self
end

function Wait:instantiate()
	return WaitInstance(self)
end

function Wait:setDuration(value)
	self.duration = value or self.duration
end

function Wait:getDuration()
	return self.duration
end

return Wait
