--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicTV.lua
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
local Color = require "ItsyScape.Graphics.Color"
local TVBehavior = require "ItsyScape.Peep.Behaviors.TVBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"

local BasicTV = Class(BlockingProp)
function BasicTV:new(resource, name, ...)
	BlockingProp.new(self, resource, 'TV', ...)

	self:addBehavior(TVBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3.5, 1, 0.5)
end

function BasicTV:getPropState()
	local tv = self:getBehavior(TVBehavior)
	local i, j, layer
	local absolutePosition, localPosition
	if tv.isOn then
		if tv.target then
			absolutePosition = Utility.Peep.getAbsolutePosition(tv.target)
			localPosition = Utility.Peep.getPosition(tv.target)
			i, j, layer = Utility.Peep.getTile(tv.target)
		else
			absolutePosition = Utility.Map.getAbsoluteTilePosition(
				self:getDirector(),
				tv.i,
				tv.j,
				tv.layer or self:getBehavior(PositionBehavior).layer)
			localPosition = Utility.Map.getTilePosition(
				self:getDirector(),
				tv.i,
				tv.j,
				tv.layer or self:getBehavior(PositionBehavior).layer)
			i, j, layer = tv.i, tv.j, tv.layer
		end
	else
		absolutePosition = Vector.ZERO
		localPosition = Vector.ZERO
		i, j, layer = 0
	end

	return {
		isOn = tv.isOn,
		channel = tv.channel,
		color = { tv.color:get() },
		absolutePosition = { absolutePosition:get() },
		localPosition = { localPosition:get() },
		i = i, j = j, layer = layer
	}
end

return BasicTV
