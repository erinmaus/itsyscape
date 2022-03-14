--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Common/Jellyfish/MagmaJellyfishRock.lua
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
local Weapon = require "ItsyScape.Game.Weapon"
local Peep = require "ItsyScape.Peep.Peep"
local Probe = require "ItsyScape.Peep.Probe"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local MagmaJellyfishRock = Class(Peep)
MagmaJellyfishRock.RADIUS = 3
MagmaJellyfishRock.DURATION = 0.6

function MagmaJellyfishRock:new(resource, ...)
	Peep.new(self, ...)

	self:addBehavior(PositionBehavior)
end

function MagmaJellyfishRock:onSpawnedByPeep(e)
	self.peep = e.peep

	local weapon = Utility.Peep.getEquippedWeapon(self.peep, true)
	self.duration = MagmaJellyfishRock.DURATION

	Log.info("Spawned by '%s'.", self.peep:getName())
end

function MagmaJellyfishRock:explode()
	local director = self:getDirector()
	local stage = self:getDirector():getGameInstance():getStage()
	local position = Utility.Peep.getAbsolutePosition(self)
	local hits = director:probe(self:getLayerName(), Probe.attackable(), function(peep)
		local difference = (Utility.Peep.getAbsolutePosition(peep) - position):getLength()
		return difference < MagmaJellyfishRock.RADIUS
	end)

	for i = 1, #hits do
		Weapon.perform(
			Utility.Peep.getEquippedWeapon(self.peep, true),
			self.peep,
			hits[i])
		stage:fireProjectile("MagmaJellyfishSplosion", self.peep, hits[i])
		Log.info('Magma jellyfish attack sploded on %s.', hits[i]:getName())
	end
end

function MagmaJellyfishRock:update(director, game)
	Peep.update(self, director, game)

	if self.duration then
		self.duration = self.duration - game:getDelta()
		if self.duration <= 0 then
			self:explode()
			Utility.Peep.poof(self)
		end
	end
end

return MagmaJellyfishRock
