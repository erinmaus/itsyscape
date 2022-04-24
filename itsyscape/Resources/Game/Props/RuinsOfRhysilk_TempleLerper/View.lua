--------------------------------------------------------------------------------
-- Resources/Game/Props/RuinsOfRhysilk_CastleLerper/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationLerpView = require "Resources.Game.Props.Common.DecorationLerpView"

local CastleLerper = Class(DecorationLerpView)
CastleLerper.TIME_MULTIPLIER = math.pi / 4

function CastleLerper:getCurrentDecorationName()
	return "Resources/Game/Maps/Sailing_RuinsOfRhysilk_UndergroundTemple/Decorations/Castle1.ldeco"
end

function CastleLerper:getNextDecorationName()
	return "Resources/Game/Maps/Sailing_RuinsOfRhysilk_UndergroundTemple/Decorations/Castle2.ldeco"
end

function CastleLerper:update(delta)
	DecorationLerpView.update(self, delta)

	self.time = (self.time or 0) + delta
	local mu = math.abs(math.sin(self.time * CastleLerper.TIME_MULTIPLIER))

	self:lerp(mu)
end

return CastleLerper
