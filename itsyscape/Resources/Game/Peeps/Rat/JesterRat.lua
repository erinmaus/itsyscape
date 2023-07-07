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
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
--local BaseRat = require "Resources.Game.Peeps.Rat.BaseRat"
local BaseRat = require "ItsyScape.Peep.Peeps.Creep"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"

local JesterRat = Class(BaseRat)

JesterRat.MINIGAME_ODD_ONE_OUT = 'ODD_ONE_OUT'

JesterRat.ODD_ONE_OUT_NUM_PRESENTS = 4
JesterRat.ODD_ONE_OUT_MIN_RADIUS   = 8
JesterRat.ODD_ONE_OUT_MAX_RADIUS   = 4
JesterRat.ODD_ONE_OUT_ELEVATION    = 8

function JesterRat:new(resource, name, ...)
	BaseRat.new(self, resource, name or 'JesterRat', ...)
end

function JesterRat:onMinigame(minigame)
	if minigame == JesterRat.MINIGAME_ODD_ONE_OUT then
		self:prepareOddOneOut()
	end
end

function JesterRat:prepareOddOneOut(minigame)
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
			local projectile
			if seeds[i] == seed1 then
				projectile = "ConfettiSplosion"

				if player then
					player:poke('heal', {
						zealous = true,
						hitPoints = 50
					})
				end
			else
				projectile = "BoomBombSplosion"

				if player then
					player:poke('hit', AttackPoke {
						aggressor = self,
						damage = 20
					})
				end
			end

			if not sploded then
				sploded = true
				for j = 1, #presents do
					if j ~= i then
						presents[j]:poke('pick', nil)
						Utility.Peep.poof(presents[j])
					end
				end
			end

			local stage = p:getDirector():getGameInstance():getStage()
			return stage:fireProjectile(projectile, Vector.ZERO, Utility.Peep.getAbsolutePosition(p), Utility.Peep.getLayer(p))
		end)
	end

	Utility.Peep.talk(self, "Odd one out or you're in for a surprise!", nil, 5)
end

return JesterRat
