--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Rat/JesterRat.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"
local BaseRat = require "Resources.Game.Peeps.Rat.BaseRat"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"

local JesterRat = Class(BaseRat)

JesterRat.MINIGAME_ODD_ONE_OUT = 'odd-one-out'
JesterRat.MINIGAME_AVOID       = 'avoid'

JesterRat.MINIGAMES = {
	JesterRat.MINIGAME_ODD_ONE_OUT,
	JesterRat.MINIGAME_AVOID
}

JesterRat.ODD_ONE_OUT_NUM_PRESENTS    = 4
JesterRat.ODD_ONE_OUT_MIN_RADIUS      = 8
JesterRat.ODD_ONE_OUT_MAX_RADIUS      = 4
JesterRat.ODD_ONE_OUT_ELEVATION       = 8
JesterRat.ODD_ONE_OUT_SPLOSION_RADIUS = 4

JesterRat.AVOID_ELEVATION             = 8
JesterRat.AVOID_SPLOSION_RADIUS       = 4

function JesterRat:new(resource, name, ...)
	BaseRat.new(self, resource, name or 'JesterRat', ...)

	self:addPoke('startMinigame')
	self:addPoke('stopMinigame')
	self:addPoke('despawn')
	self:addPoke('dropPresent')
end

function JesterRat:ready(director, game)
	BaseRat.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if not actor then
		return
	end

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/JesterRat.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)
	local hat = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Rat/RatJesterHat.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, 0, hat)

	Utility.Peep.equipXWeapon(self, "RatKingsJester_Splosion")
end

function JesterRat:onStartMinigame(minigame)
	Log.info("Jester Rat is trying to start minigame '%s'...", minigame)

	if minigame == JesterRat.MINIGAME_ODD_ONE_OUT then
		self:prepareOddOneOut()
	elseif minigame == JesterRat.MINIGAME_AVOID then
		self:prepareAvoid()
	end

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = minigame
	end
end

function JesterRat:onStopMinigame(minigame)
	if minigame == JesterRat.MINIGAME_ODD_ONE_OUT then
		self:finishOddOneOut()
	end

	local mashina = self:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = 'poof'
	end
end

function JesterRat:performAttack(peeps)
	local weapon = Utility.Peep.getEquippedWeapon(self, true)
	if not weapon then
		print(">>> no weapon")
		return
	end

	print(">>> #", #peeps)

	for i = 1, #peeps do
		weapon:perform(self, peeps[i])
	end
end

function JesterRat:performHeal(peeps)
	for i = 1, #peeps do
		peeps[i]:poke('heal', {
			zealous = true,
			hitPoints = 20
		})
	end
end

function JesterRat:prepareOddOneOut()
	local seed1 = love.math.random(0, 2 ^ 32 - 1)
	local seed2 = love.math.random(0, 2 ^ 32 - 1)

	local seeds = { seed1, seed2, seed2, seed2 }
	local offset = love.math.random() * math.pi * 2

	local map = Utility.Peep.getMap(self)
	if not map then
		return
	end

	local position = Utility.Peep.getPosition(self)

	local presents = {}
	for i = 1, #seeds do
		local angle = offset + (i / JesterRat.ODD_ONE_OUT_NUM_PRESENTS) * math.pi * 2

		-- First, XZ plane.
		local x = math.cos(angle) * love.math.random(JesterRat.ODD_ONE_OUT_MIN_RADIUS, JesterRat.ODD_ONE_OUT_MAX_RADIUS) + position.x
		local z = math.sin(angle) * love.math.random(JesterRat.ODD_ONE_OUT_MIN_RADIUS, JesterRat.ODD_ONE_OUT_MAX_RADIUS) + position.z

		-- Then Y axis.
		local y = map:getInterpolatedHeight(x, z) + JesterRat.ODD_ONE_OUT_ELEVATION

		-- Spawn Jester present.
		local prop = Utility.spawnPropAtPosition(self, "ViziersRock_Sewers_RatKingJesterPresent_Openable", x, y, z, 0)
		if prop then
			table.insert(presents, prop:getPeep())
		end
	end

	local sploded = false
	for i = 1, #presents do
		presents[i]:listen('finalize', function(p)
			p:poke('presentify', seeds[i])
		end)

		presents[i]:listen('pick', function(p, player)
			local hits = Utility.Peep.getPeepsInRadius(
				p,
				JesterRat.ODD_ONE_OUT_SPLOSION_RADIUS,
				Probe.attackable())

			local projectile
			if seeds[i] == seed1 then
				projectile = "ConfettiSplosion"
				self:performHeal(hits)
			else
				projectile = "BoomBombSplosion"
				self:performAttack(hits)
			end

			if not sploded then
				sploded = true
				for j = 1, #presents do
					if j ~= i then
						presents[j]:poke('pick', nil)
						Utility.Peep.poof(presents[j])
					end
				end

				self:poke('stopMinigame', JesterRat.MINIGAME_ODD_ONE_OUT)
			end

			local stage = p:getDirector():getGameInstance():getStage()
			stage:fireProjectile(projectile, Vector.ZERO, Utility.Peep.getAbsolutePosition(p), Utility.Peep.getLayer(p))
		end)
	end

	Utility.Peep.talk(self, "Sure hope your deduction skills are better than your combat skills, villian!", nil, 5)
end

function JesterRat:prepareAvoid()
	Utility.Peep.talk(self, "Tee-hee-hee! Here's some presents for you!", nil, 5)
end

function JesterRat:finishOddOneOut()
	local hits = self:getDirector():probe(
		self:getLayerName(),
		Probe.resource("Prop", "ViziersRock_Sewers_RatKingJesterPresent_Openable"))
	local hit = hits[1]

	if hit then
		hit:poke('pick', nil)
		Utility.Peep.poof(hit)
	end
end

function JesterRat:onDespawn()
	local stage = self:getDirector():getGameInstance():getStage()
	stage:fireProjectile(
		"ConfettiSplosion",
		Vector.ZERO,
		Utility.Peep.getAbsolutePosition(self), Utility.Peep.getLayer(self))

	Utility.Peep.poof(self)
end

function JesterRat:onDropPresent()
	local instance = Utility.Peep.getInstance(self)

	for _, player in instance:iteratePlayers() do
		local playerPeep = player:getActor():getPeep()
		local position = Utility.Peep.getPosition(playerPeep)

		position = position + Vector(0, JesterRat.AVOID_ELEVATION, 0)

		local prop = Utility.spawnPropAtPosition(self, "ViziersRock_Sewers_RatKingJesterPresent", position.x, position.y, position.z, 0)
		if prop then
			local propPeep = prop:getPeep()

			propPeep:listen('finalize', function(p)
				local stage = self:getDirector():getGameInstance():getStage()
				stage:fireProjectile(
					"ConfettiSplosion",
					Vector.ZERO,
					p)
			end)

			propPeep:listen('land', function(p)
				local hits = Utility.Peep.getPeepsInRadius(
					p,
					JesterRat.AVOID_SPLOSION_RADIUS,
					Probe.attackable())

				self:performAttack(hits)

				local stage = p:getDirector():getGameInstance():getStage()
				stage:fireProjectile("BoomBombSplosion", Vector.ZERO, Utility.Peep.getAbsolutePosition(p), Utility.Peep.getLayer(p))

				Utility.Peep.poof(p)
			end)
		end
	end
end

return JesterRat
