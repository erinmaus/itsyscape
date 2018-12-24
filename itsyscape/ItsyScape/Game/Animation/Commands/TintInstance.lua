--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/TintInstance.lua
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

local TintInstance = Class(CommandInstance)

function TintInstance:new(command)
	self.command = command or false
end

function TintInstance:bind(animatable)
	if self.command then
		self.fromColor = Color(1, 1, 1, 1)
	end
end

function TintInstance:pending(time, windingDown)
	if self.command then
		return (self.command:getKeep() and not windingDown) or
		       time < self.command:getDuration()
	end
end

function TintInstance:getDuration(windingDown)
	if self.command:getKeep() and not windingDown then
		return math.huge
	end

	return self.command:getDuration()
end

function TintInstance:play(animatable, time)
	time = math.min(time, self.command:getDuration())

	if self.command then
		local delta = time / self.command:getDuration()
		if self.command:getReverse() then
			delta = 1 - delta
		end

		local tween = Tween[self.command:getTween()] or Tween.linear
		local mu = tween(delta, self.command:getTweenArgument())
		local color = self.fromColor:lerp(self.command:getColor(), mu)

		animatable:setColor(color)
	end
end

function TintInstance:stop(animatable)
	if self.fromColor then
		animatable:setColor(self.fromColor)
	end
end

return TintInstance
