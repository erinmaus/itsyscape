--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_WhalingTemple/Peep.lua
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
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local WhalingTemple = Class(Map)
WhalingTemple.MIN_LIGHTNING_PERIOD = 4
WhalingTemple.MAX_LIGHTNING_PERIOD = 8

function WhalingTemple:new(resource, name, ...)
	Map.new(self, resource, name or 'WhalingTemple', ...)

	self:onZap()
end

function WhalingTemple:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_WhalingTemple_HeavyRain', 'Rain', {
		wind = { 15, 0, 0 },
		heaviness = 1
	})
end

function WhalingTemple:onZap()
	self.lightningTime = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function WhalingTemple:onBoom(ship)
	local player = Utility.Peep.getPlayer(self)
	if not player then
		return
	end

	local i, j, layer = Utility.Peep.getTile(player)

	local director = self:getDirector()
	local map = director:getMap(layer)

	i, j = Utility.Map.getRandomTile(map, i, j, 4, false)

	local position = Utility.Map.getAbsoluteTilePosition(director, i, j, layer)

	local stage = director:getGameInstance():getStage()
	stage:fireProjectile("StormLightning", Vector.ZERO, position, layer)
	self:pushPoke(0.5, "splode", position, layer)
end

function WhalingTemple:onSplode(position, layer)
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile("CannonSplosion", Vector.ZERO, position, layer)

	local instance = Utility.Peep.getInstance(self)
	for _, player in instance:iteratePlayers() do
		player:pokeCamera("shake", 0.5)
	end
end

function WhalingTemple:update(director, game)
	Map.update(self, director, game)

	self.lightningTime = self.lightningTime - self:getDirector():getGameInstance():getDelta()
	if self.lightningTime < 0 then
		self:onZap()
		self:onBoom()
	end
end

return WhalingTemple
