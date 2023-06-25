--------------------------------------------------------------------------------
-- Resources/Game/Maps/ViziersRock_Sewers_Floor1/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local Common = require "Resources.Game.Peeps.ViziersRock.SewersCommon"

local Sewers = Class(Map)

function Sewers:new(resource, name, ...)
	Map.new(self, resource, name or 'ViziersRock_Sewers_Floor1', ...)

	self:addBehavior(BossStatsBehavior)
end

function Sewers:onLoad(...)
	Map.onLoad(self, ...)

	if not Common.hasValveBeenOpenedOrClosed(self, Common.MARK_CIRCLE) then
		Common.closeValve(self, Common.MARK_CIRCLE)
	end

	self:initRatKingFight()
end

function Sewers:initRatKingFight()
	local ratKing = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("RatKing"))[1]

	if not ratKing then
		Log.warn("No Rat King, can't initialize fight.")
		return
	end

	ratKing:listen('receiveAttack', Utility.Peep.Attackable.bossReceiveAttack)
	ratKing:listen('die', self.onRatKingDie, self)
	ratKing:listen('eat', self.onRatKingEat, self)

	self.ratKingStrengthStat = BossStat({
		icon = 'Resources/Game/UI/Icons/Concepts/Rage.png',
		text = "Rat King's rage",
		label = "+0 strength levels",
		current = 0,
		isValue = true
	})

	local stats = self:getBehavior(BossStatsBehavior)
	table.insert(stats.stats, self.ratKingStrengthStat)
end

function Sewers:onRatKingDie(ratKing, poke)
	local position = Utility.Peep.getPosition(ratKing)
	local otherRatKing = Utility.spawnMapObjectAtPosition(self, "RatKingUnleashed", position.x, position.y, position.z, 0)
	if otherRatKing then
		local otherRatKingPeep = otherRatKing:getPeep()

		otherRatKingPeep:listen('ready', function(p)
			local animation = p:getResource(
				"animation-spawn",
				"ItsyScape.Graphics.AnimationResource")

			if animation then
				otherRatKingPeep:playAnimation('spawn', 2000, animation)

				Utility.UI.openInterface(
					Utility.Peep.getInstance(self),
					"BossHUD",
					false,
					p)

				Utility.Peep.attack(p, poke:getAggressor())
			end
		end)

		otherRatKingPeep:listen('receiveAttack', Utility.Peep.Attackable.bossReceiveAttack)
	end
end

function Sewers:onRatKingEat(ratKing, p)
	local target = p.target
	if not target then
		return
	end

	local status = target:getBehavior(CombatStatusBehavior)
	local damage = status.damage[ratKing]
	local relativeDamage = damage / status.maximumHitpoints

	current = self.ratKingStrengthStat:get().current + relativeDamage

	self.ratKingStrengthStat:set({
		current = current,
		label = string.format("+%d strength levels", math.floor(current * 10))
	})
end

function Sewers:update(...)
	Map.update(self, ...)

	Common.updateValve(self, "Valve_SquareTriangle", Common.MARK_TRIANGLE, Common.MARK_SQUARE)
	Common.updateDoor(self, "Door_TrialValveWest_Triangle", Common.MARK_TRIANGLE)
	Common.updateDoor(self, "Door_TrialValveSouth_Square", Common.MARK_SQUARE)
end

return Sewers
