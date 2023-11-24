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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"

local ShipMapPeep = Class(Map)
ShipMapPeep.SINK_TIME = 2.0
ShipMapPeep.SINK_DEPTH = 1
ShipMapPeep.BOB_MULTIPLIER = math.pi / 2

function ShipMapPeep:new(resource, name, ...)
	Map.new(self, resource, name or 'ShipMapPeep', ...)

	self:addBehavior(PositionBehavior)
	self:addBehavior(RotationBehavior)
	self.time = 0

	self:addBehavior(BossStatsBehavior)
	self:addBehavior(CombatStatusBehavior)

	self:addPoke('hit')
	self:addPoke('sink')
	self:addPoke('sunk')
	self:addPoke('beach')
	self:addPoke('rock')

	self:addPoke('leak')
	self.leaks = 0

	self.isSinking = false
	self.isSunk = false
	self.sinkTime = 0
	self.beached = false

	self:silence('playerEnter', Map.showPlayerMapInfo)
	self:listen('playerEnter', ShipMapPeep.showPlayerMapInfo)
end

function ShipMapPeep:showPlayerMapInfo(player)
	local args = self:getArguments() or {}
	local mapResourceName = args['map']
	if not mapResourceName then
		return
	end

	local mapResource = self:getDirector():getGameDB():getResource(mapResourceName, "Map")
	if not mapResource then
		return
	end

	Map.showPlayerMapInfo(self, player, mapResource)
end

function ShipMapPeep:getPrefix()
	return "Small"
end

function ShipMapPeep:getSuffix()
	return "Default"
end

function ShipMapPeep:getHealthStat()
	return self.healthStat
end

function ShipMapPeep:updateMaxHealth(newMaxHealth)
	if self.healthStat then
		local stat = self.healthStat:get()
		local difference = newMaxHealth - stat.current

		self.healthStat:set({
			current = difference + stat.current,
			max = newMaxHealth
		})
	end
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

function ShipMapPeep:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local game = self:getDirector():getGameInstance()
	local stage = game:getStage()

	local map = args['map']
	if map then
		Log.info('Ship map: %s.', map)
		local scriptLayer, script = stage:loadMapResource(
			stage:getPeepInstance(self), map, {
			ship = filename,
			instance = self
		})

		stage:loadMusic(layer, map)

		-- TODO: get this from the map
		local WATER_ELEVATION = 1.75

		if script then
			local baseMap = stage:getMap(scriptLayer)
			local selfMap = stage:getMap(self:getLayer())

			local x, z
			do
				local i, j = args['i'], args['j']
				if i and j then
					i = tonumber(i)
					j = tonumber(j)

					if i and j then
						i = i - selfMap:getWidth() / 2
						j = j - selfMap:getHeight() / 2

						local position = self:getBehavior(PositionBehavior)
						local map = stage:getMap(layer)
						position.position = map:getTileCenter(i, j)

						x = position.position.x
						z = position.position.z
					end
				end
			end

			x = (x or 0) + selfMap:getWidth() / 2 * selfMap:getCellSize()
			z = (z or 0) + selfMap:getHeight() / 2 * selfMap:getCellSize()

			local boatFoamPropName = string.format("resource://BoatFoam_%s_%s", self:getPrefix(), self:getSuffix())
			local _, boatFoamProp = stage:placeProp(boatFoamPropName, scriptLayer, self:getLayerName())
			if boatFoamProp then
				local peep = boatFoamProp:getPeep()
				peep:listen('finalize', function()
					local position = peep:getBehavior(PositionBehavior)
					if position then
						position.position = Vector(x, WATER_ELEVATION, z)
					end
				end)
				self.boatFoamProp = peep
			end

			local boatFoamTrailPropName = string.format("resource://BoatFoamTrail_%s_%s", self:getPrefix(), self:getSuffix())
			local _, boatFoamTrailProp = stage:placeProp(boatFoamTrailPropName, scriptLayer, self:getLayerName())
			if boatFoamTrailProp then
				local peep = boatFoamTrailProp:getPeep()
				peep:listen('finalize', function()
					local position = peep:getBehavior(PositionBehavior)
					if position then
						position.position = Vector(x, WATER_ELEVATION, z)
					end
				end)
				self.boatFoamTrailProp = peep
			end
		end

		self.previousMap = args['shore']
		self.previousMapAnchor = args['shoreAnchor']
	else
		Log.warn("No ship map.")
	end
end

function ShipMapPeep:onHit(p)
	local health = math.max(self:getCurrentHealth() - p:getDamage(), 0)
	if self.healthStat then
		self.healthStat.currentValue = health
	end

	if p:getWeaponType() ~= 'none' then
		self:_rock()
	end

	if health <= 0 then
		self:poke('sink')
		self.isSinking = true
	end
end

function ShipMapPeep:onRock()
	self:_rock()
end

function ShipMapPeep:_rock()
	local gameDB = self:getDirector():getGameDB()
	local effect = gameDB:getResource("X_ShipRock", "Effect")
	if effect then
		Utility.Peep.applyEffect(self, effect, true)
	end
end

function ShipMapPeep:onLeak(p)
	local leak = p.leak
	leak:listen('poof', function()
		self.leaks = self.leaks - 1
	end)

	self:_rock()

	self.leaks = self.leaks + 1
end

function ShipMapPeep:onBeach()
	self.beached = true
end

function ShipMapPeep:updateFoam()
	if not self.boatFoamProp or not self.boatFoamTrailProp then
		return
	end

	local map = self:getDirector():getMap(self:getLayer())
	if not map then
		return
	end

	local x, z
	do
		local position = self:getBehavior(PositionBehavior)
		x, z = position.position.x, position.position.z
	end

	local rotation = self:getBehavior(RotationBehavior)
	if rotation then
		local _, boatFoamPropScale = self.boatFoamProp:addBehavior(RotationBehavior)
		local _, boatFoamTrailPropScale = self.boatFoamTrailProp:addBehavior(RotationBehavior)
		local shipOffset = self:hasBehavior(MapOffsetBehavior) and self:getBehavior(MapOffsetBehavior)

		local offset
		if shipOffset and shipOffset.offset:getLength() > 0 then
			offset = Vector.ZERO
		else
			offset = Vector(
				map:getWidth() / 2 * map:getCellSize(),
				0,
				map:getHeight() / 2 * map:getCellSize())
		end
		offset = rotation.rotation:transformVector(offset)

		boatFoamPropScale.rotation = rotation.rotation
		boatFoamTrailPropScale.rotation = rotation.rotation

		x = x + offset.x
		z = z + offset.z
	else
		x = x + map:getWidth() / 2 * map:getCellSize()
		z = z + map:getHeight() / 2 * map:getCellSize()
	end

	do
		local _, boatFoamPropPosition = self.boatFoamProp:addBehavior(PositionBehavior)
		local _, boatFoamTrailPropPosition = self.boatFoamTrailProp:addBehavior(PositionBehavior)

		boatFoamPropPosition.position = Vector(x, boatFoamPropPosition.position.y, z)
		boatFoamTrailPropPosition.position = Vector(x, boatFoamTrailPropPosition.position.y, z)
	end

	local scale = self:getBehavior(ScaleBehavior)
	if scale then
		local _, boatFoamPropScale = self.boatFoamProp:addBehavior(ScaleBehavior)
		local _, boatFoamTrailPropScale = self.boatFoamTrailProp:addBehavior(ScaleBehavior)

		boatFoamPropScale.scale = scale.scale
		boatFoamTrailPropScale.scale = scale.scale
	end
end

function ShipMapPeep:update(director, game)
	Map.update(self, director, game)

	local delta = game:getDelta()

	local previousTime = self.time
	self.time = self.time + delta

	if math.floor(previousTime) < math.floor(self.time) then
		if self.leaks > 0 then
			self:poke('hit', AttackPoke({ damage = self.leaks * 2, damageType = 'leak' }))
		end
	end

	self:updateFoam()

	local position = self:getBehavior(PositionBehavior)
	local scale = self:getBehavior(ScaleBehavior)
	if position then
		local yScale
		if scale then
			yScale = scale.scale.y
		else
			yScale = 1
		end

		if self.beached then
			position.position = Vector(
				position.position.x,
				position.offset.y,
				position.position.z)
		else
			position.position = Vector(
				position.position.x,
				(math.sin(self.time * self.BOB_MULTIPLIER) * 0.5 - 1.5 * (1 - self:getCurrentHealth() / self:getMaxHealth())) * yScale,
				position.position.z) + (position.offset or Vector.ZERO)
			if self.isSinking then
				position.position.y = position.position.y - (self.sinkTime / self.SINK_TIME) * self.SINK_DEPTH
			end
		end
	end

	if self.isSinking then
		self.sinkTime = math.min(self.sinkTime + game:getDelta(), self.SINK_TIME)

		if self.sinkTime >= self.SINK_TIME then
			local previousMap = self.previousMap
			local previousMapAnchor = self.previousMapAnchor

			if not self.isSunk and previousMap and previousMapAnchor then
				local instance = Utility.Peep.getInstance(self)
				if instance:getPartyLeader() then
					game:getStage():movePeep(
						instance:getPartyLeader():getActor():getPeep(),
						previousMap,
						previousMapAnchor)
				end

				for _, player in instance:iteratePlayers() do
					if player ~= instance:getPartyLeader() then
						game:getStage():movePeep(
							player:getActor():getPeep(),
							previousMap,
							previousMapAnchor)
					end
				end
			end

			if not self.isSunk then
				self:poke('sunk')
				self.isSunk = true
			end
		end
	end
end

return ShipMapPeep
