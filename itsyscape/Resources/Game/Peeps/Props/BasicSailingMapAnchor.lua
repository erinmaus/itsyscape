--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicSailingMapAnchor.lua
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
local Prop = require "Resources.Game.Peeps.Props.PassableProp"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local BasicSailingMapAnchor = Class(Prop)

function BasicSailingMapAnchor:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2, 2, 2)

	self.mapLocation = false
	self.mapAnchor = false
	self.currentMapLocation = false

	self:addPoke('assignMapLocation')
end

function BasicSailingMapAnchor:onAssignMapLocation(mapLocation, playerMapLocation)
	self.mapLocation = mapLocation
	self.playerMapLocation = playerMapLocation

	if mapLocation then
		self.mapAnchor = mapLocation:get("Resource")

		local gameDB = self:getDirector():getGameDB()
		self:setName(Utility.getName(self.mapAnchor, gameDB) or "*" .. self.mapAnchor.name)
	else
		self.mapAnchor = false
	end
end

function BasicSailingMapAnchor:getPropState()
	local gameDB = self:getDirector():getGameDB()

	if self.mapLocation and self.playerMapLocation and self.mapAnchor then
		return {
			name = Utility.getName(self.mapAnchor, gameDB),
			description = Utility.getDescription(self.mapAnchor, gameDB),
			i = self.mapLocation:get("AnchorI"),
			j = self.mapLocation:get("AnchorI"),
			distance = Utility.Sailing.getDistanceBetweenLocations(self.playerMapLocation, self.mapLocation)
		}
	else
		return {}
	end
end

return BasicSailingMapAnchor
