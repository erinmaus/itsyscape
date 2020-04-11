--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/WaitInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local CommandInstance = require "ItsyScape.Game.Animation.Commands.CommandInstance"
local Color = require "ItsyScape.Graphics.Color"

local WaitInstance = Class(CommandInstance)

function WaitInstance:new(command)
	self.command = command or false
end

function WaitInstance:pending(time, windingDown)
	if self.command then
		return self.command:getDuration() <= time and not windingDown
	end
end

function WaitInstance:getDuration(windingDown)
	if self.command then
		return self.command:getDuration()
	end

	return 0
end

return WaitInstance
