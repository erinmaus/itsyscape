--------------------------------------------------------------------------------
-- Resources/Peeps/HighChambersYendor/LightLock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local MirrorBehavior = require "ItsyScape.Peep.Behaviors.MirrorBehavior"
local BasicMirror = require "Resources.Game.Peeps.Props.BasicMirror"

local LightLock = Class(BasicMirror)

function LightLock:new(...)
	BasicMirror.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)
end

function LightLock:onFinalize(...)
	BasicMirror.onFinalize(self, ...)

	local mirror = self:getBehavior(MirrorBehavior)
	mirror.reflection = Vector(0)
	mirror.range = math.pi * 2
end

return LightLock
