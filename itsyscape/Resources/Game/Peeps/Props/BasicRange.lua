--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicRange.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BasicArtisanStation = require "Resources.Game.Peeps.Props.BasicArtisanStation"

local BasicRange = Class(BasicArtisanStation)

function BasicRange:new(...)
	BasicArtisanStation.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1, 1.5)

	self:addPoke("cook")
end

return BasicRange
