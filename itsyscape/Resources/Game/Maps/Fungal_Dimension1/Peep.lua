--------------------------------------------------------------------------------
-- Resources/Game/Maps/Fungal_Dimension1/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local Dimension = Class(Map)
Dimension.MIN_LIGHTNING_PERIOD = 3
Dimension.MAX_LIGHTNING_PERIOD = 6
Dimension.LIGHTNING_TIME = 0.5
Dimension.MAX_AMBIENCE = 2

function Dimension:new(resource, name, ...)
	Map.new(self, resource, name or 'Fungal_Dimension1', ...)
end

function Dimension:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Fungal_Dimension1_Rain', 'Rain', {
		wind = { -15, 0, 0 },
		color = { 1, 0, 0, 1 },
		heaviness = 0.25
	})

	Utility.Map.spawnMap(self, "Fungal_Dimension2", Vector(512, 0, 0))

	self.lightning = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Light_Lightning"))[1]
	self.lightningTime = 0

	self:zap()
end

function Dimension:zap()
	self.wait = math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
	Log.info("CRACKLE-BOOM-ZAP!")
end

function Dimension:update(director, game)
	local delta = game:getDelta()

	if self.lightningTime > 0 then
		local player = game:getPlayer():getActor():getPeep()
		if player:getBehavior(PositionBehavior).layer == self:getLayer() then
			self.lightningTime = self.lightningTime - delta

			local mu = math.min(math.max(self.lightningTime / self.LIGHTNING_TIME, 0), 1)

			self.lightning:setAmbience(self.MAX_AMBIENCE * mu)
		else
			self.lightningTime = 0
			self.lightning:setAmbience(0)
		end
	else
		self.wait = self.wait - delta
		if self.wait <= 0 then
			self:zap()
			self.lightningTime = self.LIGHTNING_TIME
		end
	end
end

return Dimension
