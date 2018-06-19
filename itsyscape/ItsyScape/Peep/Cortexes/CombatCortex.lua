--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/CombatCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TilePathNode = require "ItsyScape.World.TilePathNode"

local CombatCortex = Class(Cortex)

function CombatCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(CombatTargetBehavior)
	self:require(MovementBehavior)
	self:require(PositionBehavior)

	self.walking = {}
end

function CombatCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.walking[peep] = nil
end

function CombatCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local itemManager = self:getDirector():getItemManager()

	for peep in self:iterate() do
		local position = peep:getBehavior(PositionBehavior)

		local weaponRange
		local equippedWeapon = Utility.Peep.getEquippedItem(
			peep,
			Equipment.PLAYER_SLOT_RIGHT_HAND)
		if not equippedWeapon then
			weaponRange = 1
		else
			local logic = itemManager:getLogic(equippedWeapon:getID())
			if logic:isCompatibleType(Weapon) then
				weaponRange = logic:getAttackRange(peep)
			else
				weaponRange = 1
			end
		end

		local target = peep:getBehavior(CombatTargetBehavior).actor
		if target then
			target = target:getPeep()

			local targetPosition = target:getBehavior(PositionBehavior)
			if targetPosition and targetPosition.layer == position.layer then
				local map = game:getStage():getMap(targetPosition.layer or 1)
				if map then
					local selfI, selfJ = map:toTile(
						position.position.x,
						position.position.z)
					local targetI, targetJ = map:toTile(
						targetPosition.position.x,
						targetPosition.position.z)

					local differenceI = math.abs(selfI - targetI)
					local differenceJ = math.abs(selfJ - targetJ)
					local distanceToTarget = differenceI + differenceJ
					if distanceToTarget > weaponRange then
						local tile = self.walking[peep]
						if not tile or tile.i ~= targetI or tile.j ~= targetJ then
							if not Utility.Peep.walk(peep, targetI, targetJ, targetPosition.layer or 1, true) then
								Log.info(
									"Peep %s (%d) couldn't reach target Peep %s (%d); abandoning.",
									peep:getName(), peep:getTally(),
									target:getName(), target:getTally())
								peep:removeBehavior(CombatTargetBehavior)
							end

							self.walking[peep] = { i = targetI, j = targetJ }
						end
					else
						if self.walking[peep] then
							if peep:getCommandQueue():clear() then
								self.walking[peep] = nil

								peep:addBehavior(TargetTileBehavior)
								local targetTile = peep:getBehavior(TargetTileBehavior)
								targetTile.pathNode = TilePathNode(selfI, selfJ, position.layer or 1)
							end
						end

						local canAttack
						do
							local cooldown = peep:getBehavior(AttackCooldownBehavior)
							if cooldown then
								local cooldownFinishTicks = cooldown.cooldown + cooldown.ticks * game:getDelta()
								canAttack = cooldownFinishTicks < game:getCurrentTick() * game:getDelta()
							else
								canAttack = true
							end
						end
						do
							local combat = target:getBehavior(CombatStatusBehavior)
							if combat and combat.currentHitpoints == 0 then
								peep:removeBehavior(CombatTargetBehavior)
								canAttack = false
							end
						end

						if canAttack then
							local weapon = Utility.Peep.getEquippedItem(
								peep,
								Equipment.PLAYER_SLOT_RIGHT_HAND)
							if weapon then
								local logic = itemManager:getLogic(weapon:getID())
								if logic:isCompatibleType(Weapon) then
									logic:perform(peep, target)
								end
							end
						end
					end
				end
			end
		end
	end
end -- oh my god

return CombatCortex
