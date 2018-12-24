--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/Tint.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Game.Animation.Commands.Command"
local Color = require "ItsyScape.Graphics.Color"
local TintInstance = require "ItsyScape.Game.Animation.Commands.TintInstance"

-- Command to play an animation (lanim).
--
-- Takes the form:
--
-- Tint { [r], [g], [b], [a], duration, tween, repeat }
local Tint, Metatable = Class(Command)

function Tint:new(t)
	self.color = Color(unpack(t or {}))
	self.duration = t.duration or 0
	self.keep = t.keep or false
	self.tween = t.tween or 'linear'
	self.tweenArgument = t.tweenArgument or nil
end

function Tint:getColor()
	return self.color
end

function Tint:setColor(value)
	self.color = value or self.color
end

function Tint:getDuration()
	return self.duration
end

function Tint:setDuration(value)
	self.duration = value or self.duration
end

function Tint:getKeep()
	return self.keep
end

function Tint:setKeep(value)
	self.keep = value or self.keep
end

function Tint:getTween()
	return self.tween
end

function Tint:setTween(value)
	self.tween = value or self.tween
end

function Tint:getTweenArgument()
	return self.tweenArgument
end

function Tint:setTweenArgument(value)
	self.tweenArgument = value or nil
end

function Tint:instantiate()
	return TintInstance(self)
end

return Tint
