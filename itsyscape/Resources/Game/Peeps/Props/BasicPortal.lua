--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicPortal.lua
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
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"

local BasicPortal = Class(BlockingProp)
function BasicPortal:new(resource, name, ...)
	BlockingProp.new(self, resource, 'Portal', ...)

	self:addBehavior(TeleportalBehavior)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 3, 1.5)

	local components = {
		math.random(200, 255) / 255,
		math.random(100, 200) / 255,
		math.random(50, 100) / 255
	}

	local color = {}
	while #components > 0 do
		local index = math.random(#components)
		table.insert(color, components[index])
		table.remove(components, index)
	end

	self.color = Color(color[0], color[1], color[2], 1)
end

function BasicPortal:getColor()
	return self.color
end

function BasicPortal:setColor(value)
	self.color = value or self.color
end

function BasicPortal:getPropState()
	local teleportal = self:getBehavior(TeleportalBehavior)
	local position = Utility.Map.getAbsoluteTilePosition(
		self:getDirector(),
		teleportal.i,
		teleportal.j,
		teleportal.layer or self:getBehavior(PositionBehavior).layer)

	return {
		color = { self.color:get() },
		position = { position:get() }
	}
end

return BasicPortal
