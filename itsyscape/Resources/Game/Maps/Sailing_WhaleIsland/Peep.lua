--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_WhaleIsland/Peep.lua
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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local FollowerCortex = require "ItsyScape.Peep.Cortexes.FollowerCortex"

local WhaleIsland = Class(Map)
WhaleIsland.MIN_LIGHTNING_PERIOD = 2
WhaleIsland.MAX_LIGHTNING_PERIOD = 4
WhaleIsland.LIGHTNING_TIME = 0.75
WhaleIsland.MAX_AMBIENCE = 3

function WhaleIsland:new(resource, name, ...)
	Map.new(self, resource, name or 'WhaleIsland', ...)

	self:addPoke('killBeachedWhale')
end

function WhaleIsland:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local beachedShip = Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_Ship")

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Sailing_WhaleIsland_HeavyRain', 'Rain', {
		wind = { 15, 0, 0 },
		heaviness = 1
	})

	self.lightning = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Light_Lightning"))[1]
	self.lightningTime = 0
	self:zap()

	self:pushPoke('killBeachedWhale')
end

function WhaleIsland:onKillBeachedWhale()
	local beachedWhale = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("BeachedWhale"))[1]

	if beachedWhale then
		beachedWhale:poke('die')

		local actor = beachedWhale:getBehavior(ActorReferenceBehavior)
		actor = actor and actor.actor
		if actor then
			Log.info("Playing death animation for beached whale.")
			actor:playAnimation(
				'combat',
				1000,
				beachedWhale:getResource("animation-die", "ItsyScape.Graphics.AnimationResource"),
				true,
				1000)
		else
			Log.warn("Couldn't get beached whale actor.")
		end

		local movement = beachedWhale:getBehavior(MovementBehavior)
		if movement then
			movement.float = 0
		end
	else
		Log.warn("Couldn't get beached whale.")
	end
end

function WhaleIsland:onPlayerEnter(player)
	self:trySpawnLyra(player)
end

function WhaleIsland:trySpawnLyra(player)
	local playerPeep = player:getActor():getPeep()

	local isInQuest = not playerPeep:getState():has("KeyItem", "SuperSupperSaboteur_MadeCandle")
	if not isInQuest then
		Log.info("Player '%s' has finished step in Super Supper Saboteur, don't care about spawning Lyra and Oliver.")
		return
	end

	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local gameDB = self:getDirector():getGameDB()
	local lyraResource, oliverResource = gameDB:getResource("Lyra", "Peep"), gameDB:getResource("Oliver", "Peep")
	if not lyraResource or not oliverResource then
		Log.warn(
			"Couldn't get resource in Whale Island (Lyra = %s, Oliver = %s).",
			Log.boolean(lyraResource),
			Log.boolean(oliverResource))
		return
	end

	local followerCortex = self:getDirector():getCortex(FollowerCortex)
	local lyraPeep, oliverPeep
	for peep in followerCortex:iterateFollowers(player) do
		local resource = Utility.Peep.getResource(peep)
		if resource then
			if resource.id.value == lyraResource.id.value then
				lyraPeep = peep
			end

			if resource.id.value == oliverResource.id.value then
				oliverPeep = peep
			end
		end
	end

	if lyraPeep and oliverPeep then
		Log.info("Lyra and Oliver are following player '%s', not respawning.", player:getActor():getName())
	elseif not lyraPeep or not oliverPeep then
		if not lyraPeep and not oliverPeep then
			Log.info("Lyra and Oliver are not following player '%s, spawning.", player:getActor():getName())
		else
			Log.warn("Just one of either Lyra or Oliver is following player '%s'!", player:getActor():getName())
		end

		if not lyraPeep then
			local lyraActor = Utility.spawnMapObjectAtPosition(self, "Lyra", Utility.Peep.getPosition(playerPeep):get())

			local _, instance = lyraActor:getPeep():addBehavior(InstancedBehavior)
			instance.playerID = player:getID()

			local _, follower = lyraActor:getPeep():addBehavior(FollowerBehavior)
			follower.playerID = player:getID()
			follower.followAcrossMaps = true

			Utility.Peep.setMashinaState(lyraActor:getPeep(), 'follow')
		end

		if not oliverPeep then
			local oliverActor = Utility.spawnMapObjectAtPosition(self, "Oliver", Utility.Peep.getPosition(playerPeep):get())

			local _, instance = oliverActor:getPeep():addBehavior(InstancedBehavior)
			instance.playerID = player:getID()

			local _, follower = oliverActor:getPeep():addBehavior(FollowerBehavior)
			follower.playerID = player:getID()
			follower.followAcrossMaps = true

			Utility.Peep.setMashinaState(oliverActor:getPeep(), 'follow')
		end
	end
end

function WhaleIsland:zap()
	self.wait = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function WhaleIsland:boom()
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

function WhaleIsland:update(director, game)
	Map.update(self, director, game)

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

return WhaleIsland
