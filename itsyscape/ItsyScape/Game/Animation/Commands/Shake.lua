--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/Shake.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Command = require "ItsyScape.Game.Animation.Commands.Command"
local Color = require "ItsyScape.Graphics.Color"
local ShakeInstance = require "ItsyScape.Game.Animation.Commands.ShakeInstance"

local Shake, Metatable = Class(Command)

function Shake:new(t)
	self.duration = t.duration or 0.5
	self.interval = t.interval or 1 / 15
	self.minOffset = t.minOffset or 0
	self.maxOffset = t.maxOffset or 1
end

function Shake:getDuration()
	return self.duration
end

function Shake:setDuration(value)
	self.duration = value or self.duration
end

function Shake:getInterval()
	return self.interval
end

function Shake:setInterval(value)
	self.interval = value or self.interval
end

function Shake:getMinOffset()
	return self.minOffset
end

function Shake:setMinOffset(value)
	self.minOffset = value or self.minOffset
end

function Shake:getMaxOffset()
	return self.maxOffset
end

function Shake:setMaxOffset(value)
	self.maxOffset = value or self.maxOffset
end

function Shake:instantiate()
	return ShakeInstance(self)
end

return Shake
