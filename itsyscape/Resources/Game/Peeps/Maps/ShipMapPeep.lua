--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/ShipMapPeep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local BossStat = require "ItsyScape.Game.BossStat"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Map = require "ItsyScape.Peep.Peeps.Map"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"

local ShipMapPeep = Class(Map)

function ShipMapPeep:new(resource, name, ...)
	Map.new(self, resource, name or 'ShipMapPeep', ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)
	self.time = 0

	self:addBehavior(BossStatsBehavior)

	self:addPoke('hit')
	self:addPoke('sink')

	self:addPoke('leak')
	self.leaks = 0
end

function ShipMapPeep:getPrefix()
	return "Small"
end

function ShipMapPeep:getSuffix()
	return "Default"
end

function ShipMapPeep:getCurrentHealth()
	if self.healthStat then
		return self.healthStat.currentValue
	else
		return self:getMaxHealth()
	end
end

function ShipMapPeep:getMaxHealth()
	return 100
end

function ShipMapPeep:onFinalize(...)
	self.healthStat = BossStat({
		icon = 'Resources/Game/UI/Icons/Skills/Sailing.png',
		text = "Ship's health",
		inColor = { 0.44, 0.78, 0.21, 1.0 },
		outColor = { 0.78, 0.21, 0.21, 1.0 },
		current = self:getMaxHealth(),
		max = self:getMaxHealth()
	})

	local stats = self:getBehavior(BossStatsBehavior)
	table.insert(stats.stats, self.healthStat)
end

function ShipMapPeep:onLoad(filename, args)
	Map.onLoad(self, filename, args)

	local game = self:getDirector():getGameInstance()
	local stage = game:getStage()

	local map = args['map']
	if map then
		Log.info('Ship map: %s.', map)
		local layer, script = stage:loadMapResource(map, {
			ship = filename,
			instance = self
		})

		-- TODO: get this from the map
		local WATER_ELEVATION = 2.25

		if script then
			local baseMap = stage:getMap(1)

			local x, z
			do
				local i, j = args['i'], args['j']
				if i and j then
					i = tonumber(i)
					j = tonumber(j)

					if i and j then
						i = i - baseMap:getWidth() / 2
						j = j - baseMap:getHeight() / 2

						local position = self:getBehavior(PositionBehavior)
						local map = stage:getMap(layer)
						position.position = map:getTileCenter(i, j)

						x = position.position.x
						z = position.position.z
					end
				end
			end

			x = (x or 0) + (baseMap:getWidth() + 0.5) * baseMap:getCellSize() / 2
			z = (z or 0) + (baseMap:getHeight()+ 0.5) * baseMap:getCellSize() / 2

			local boatFoamPropName = string.format("resource://BoatFoam_%s_%s", self:getPrefix(), self:getSuffix())
			local _, boatFoamProp = stage:placeProp(boatFoamPropName, layer)
			if boatFoamProp then
				local peep = boatFoamProp:getPeep()
				peep:listen('finalize', function()
					local position = peep:getBehavior(PositionBehavior)
					if position then
						position.position = Vector(x, WATER_ELEVATION, z)
					end
				end)
			end

			local boatFoamTrailPropName = string.format("resource://BoatFoamTrail_%s_%s", self:getPrefix(), self:getSuffix())
			local _, boatFoamTrailProp = stage:placeProp(boatFoamTrailPropName, layer)
			if boatFoamTrailProp then
				local peep = boatFoamTrailProp:getPeep()
				peep:listen('finalize', function()
					local position = peep:getBehavior(PositionBehavior)
					if position then
						position.position = Vector(x, WATER_ELEVATION, z)
					end
				end)
			end
		end
	else
		Log.warn("No ship map.")
	end
end

function ShipMapPeep:onHit(p)
	local health = math.max(self:getCurrentHealth() - p:getDamage(), 0)
	if self.healthStat then
		self.healthStat.currentValue = health
	end

	if health <= 0 then
		self:poke('sink')
	end
end

function ShipMapPeep:onLeak(p)
	local leak = p.leak
	leak:listen('poof', function()
		self.leaks = self.leaks - 1
	end)

	self.leaks = self.leaks + 1
end

function ShipMapPeep:update(director, game)
	Map.update(self, director, game)

	local delta = game:getDelta()

	local previousTime = self.time
	self.time = self.time + delta

	if math.floor(previousTime) < math.floor(self.time) then
		self:poke('hit', AttackPoke({ damage = self.leaks * 2 }))
	end

	local position = self:getBehavior(PositionBehavior)
	if position then
		position.position = Vector(
			position.position.x,
			math.sin(self.time * math.pi / 2) * 0.5 - 1.5 * (1 - self:getCurrentHealth() / self:getMaxHealth()),
			position.position.z)
	end
end

return ShipMapPeep
