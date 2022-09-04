--------------------------------------------------------------------------------
-- Resources/Game/Maps/RuinsOfRhysilk/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local Ruins = Class(Map)
Ruins.MIN_LIGHTNING_PERIOD = 2
Ruins.MAX_LIGHTNING_PERIOD = 4
Ruins.LIGHTNING_TIME = 0.75
Ruins.MAX_AMBIENCE = 3

function Ruins:new(resource, name, ...)
	Map.new(self, resource, name or 'RuinsOfRhysilk', ...)
end

function Ruins:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.spawnMapAtAnchor(self, "Ship_Player1", "Anchor_Ship")
	local beachedShip = Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_BeachedShip")
	beachedShip:poke('beach')

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_RuinsOfRhysilk_HeavyRain', 'Rain', {
		wind = { 15, 0, 0 },
		heaviness = 1
	})

	local player = Utility.Peep.getPlayer(self)
	local firstMate, pending = SailorsCommon.getActiveFirstMateResource(player)
	if not pending then
		Utility.spawnActorAtAnchor(self, firstMate, "Anchor_FirstMate", 0)
	end

	self.lightning = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Light_Lightning"))[1]
	self.lightningTime = 0
	self:zap()
end

function Ruins:zap()
	self.wait = math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function Ruins:boom()
	local instance = Utility.Peep.getInstance(self)
	for _, player in instance:iteratePlayers() do
		local actor = player:getActor()
		if actor then
			local animation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/SFX_LightningStrike/Script.lua")
			actor:playAnimation(
				'x-ruins-of-rhysilk-lightning',
				math.huge,
				animation)
		end
	end
end

function Ruins:update(director, game)
	local delta = game:getDelta()

	if self.lightningTime > 0 then
		self.lightningTime = self.lightningTime - delta

		local mu = math.min(math.max(self.lightningTime / self.LIGHTNING_TIME, 0), 1)

		self.lightning:setAmbience(self.MAX_AMBIENCE * mu)
	else
		self.wait = self.wait - delta
		if self.wait <= 0 then
			self:zap()
			self:boom()
			self.lightningTime = self.LIGHTNING_TIME
		end
	end
end

return Ruins
