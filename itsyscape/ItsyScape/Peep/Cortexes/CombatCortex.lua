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
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local Equipment = require "ItsyScape.Game.Equipment"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TilePathNode = require "ItsyScape.World.TilePathNode"

local CombatCortex = Class(Cortex)
CombatCortex.QUEUE = {}

function CombatCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(CombatTargetBehavior)
	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(SizeBehavior)

	self.walking = {}
	self.strafing = {}
	self.defaultWeapon = Weapon()
end

function CombatCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.walking[peep] = nil
	self.strafing[peep] = nil
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
			equippedWeapon = Utility.Peep.getEquippedItem(
				peep,
				Equipment.PLAYER_SLOT_TWO_HANDED)
			if not equippedWeapon then
				weaponRange = 1
			end
		end
		
		local logic
		if equippedWeapon then
			logic = itemManager:getLogic(equippedWeapon:getID())
			if logic:isCompatibleType(Weapon) then
				weaponRange = logic:getAttackRange(peep)
			else
				weaponRange = 1
			end
		end

		local target = peep:getBehavior(CombatTargetBehavior)
		if target then
			target = target.actor
		end

		if target and target:getPeep() then
			target = target:getPeep()

			local targetPosition = target:getBehavior(PositionBehavior)
			if targetPosition and targetPosition.layer == position.layer then
				local map = game:getDirector():getMap(targetPosition.layer or 1)
				if map then
					local selfI, selfJ = map:toTile(
						position.position.x,
						position.position.z)
					local targetI, targetJ = map:toTile(
						targetPosition.position.x,
						targetPosition.position.z)

					local selfRadius, targetRadius
					do
						local peepSize = peep:getBehavior(SizeBehavior).size.x
						selfRadius = math.max(math.floor(peepSize / map:getCellSize()) - 1, 0)
						local targetSize = target:getBehavior(SizeBehavior).size.x
						targetRadius = math.max(math.floor(targetSize / map:getCellSize()) - 1, 0)
					end
					
					local combat = peep:getBehavior(CombatStatusBehavior)

					local differenceI = math.abs(selfI - targetI)
					local differenceJ = math.abs(selfJ - targetJ)
					local distanceToTarget = math.floor(math.sqrt(differenceI ^ 2 + differenceJ ^ 2))

					if distanceToTarget - selfRadius > combat.maxChaseDistance + targetRadius then
						peep:getCommandQueue(CombatCortex.QUEUE):clear()
						peep:poke('targetFled', { target = target, distance = distanceToTarget })
					elseif distanceToTarget - selfRadius > weaponRange + targetRadius then
						local tile = self.walking[peep]
						if not tile or tile.i ~= targetI or tile.j ~= targetJ then
							local walk = Utility.Peep.getWalk(peep, targetI, targetJ, targetPosition.layer or 1, math.max(weaponRange - 1, 0), { asCloseAsPossible = false })

							if not walk then
								Log.info(
									"Peep %s (%d) couldn't reach target Peep %s (%d); abandoning.",
									peep:getName(), peep:getTally(),
									target:getName(), target:getTally())
								peep:removeBehavior(CombatTargetBehavior)
							else
								walk.onCanceled:register(function()
									if peep:hasBehavior(CombatTargetBehavior) and peep:hasBehavior(PlayerBehavior) then
										peep:removeBehavior(CombatTargetBehavior)
										peep:getCommandQueue(CombatCortex.QUEUE):clear()
									end
								end)

								peep:getCommandQueue(CombatCortex.QUEUE):interrupt(walk)
							end

							self.walking[peep] = { i = targetI, j = targetJ }
						end
					else
						if self.walking[peep] then
							self.walking[peep] = nil
							self.strafing[peep] = true

							peep:addBehavior(TargetTileBehavior)
							local targetTile = peep:getBehavior(TargetTileBehavior)
							targetTile.pathNode = TilePathNode(selfI, selfJ, position.layer or 1)
							targetTile.distance = 0.25
							targetTile.pathNode.onEnd:register(function()
								self.strafing[peep] = nil
							end)
						elseif not self.strafing[peep] then
							local targetIsPlayer = target:hasBehavior(PlayerBehavior)
							local selfIsPlayer = peep:hasBehavior(PlayerBehavior)
							if targetIsPlayer and not selfIsPlayer then
								if distanceToTarget <= selfRadius + targetRadius then
									local i, j
									if selfI > targetI then
										if map:canMove(selfI, selfJ, 1, 0) then
											self.strafing[peep] = true
											i = selfI + 1
											j = selfJ
										elseif map:canMove(selfI, selfJ, -1, 0) then
											self.strafing[peep] = true
											i = selfI - 1
											j = selfJ
										end
									else
										if map:canMove(selfI, selfJ, -1, 0) then
											self.strafing[peep] = true
											i = selfI - 1
											j = selfJ
										elseif map:canMove(selfI, selfJ, 1, 0) then
											self.strafing[peep] = true
											i = selfI + 1
											j = selfJ
										end
									end

									if not i and not j then
										if map:canMove(selfI, selfJ, 0, 1) then
											self.strafing[peep] = true
											i = selfI
											j = selfJ + 1
										elseif map:canMove(selfI, selfJ, 0, -1) then
											self.strafing[peep] = true
											i = selfI
											j = selfJ - 1
										end
									end

									if i and j then
										peep:addBehavior(TargetTileBehavior)
										local targetTile = peep:getBehavior(TargetTileBehavior)
										targetTile.pathNode = TilePathNode(i, j, position.layer or 1)
										targetTile.distance = 0.25
										targetTile.pathNode.onEnd:register(function()
											self.strafing[peep] = nil
										end)
									end
								end
							end
						elseif not peep:hasBehavior(TargetTileBehavior) then
							self.strafing[peep] = nil
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
							local targetCombat = target:getBehavior(CombatStatusBehavior)
							if targetCombat and targetCombat.currentHitpoints == 0 then
								peep:removeBehavior(CombatTargetBehavior)
								canAttack = false
							end
						end

						if canAttack then
							logic = logic or self.defaultWeapon
							if logic:isCompatibleType(Weapon) then
								logic:perform(peep, target)
							end
						end
					end

					do
						local movement = peep:getBehavior(MovementBehavior)
						if selfI > targetI then
							movement.facing = MovementBehavior.FACING_LEFT
						elseif selfI < targetI then
							movement.facing = MovementBehavior.FACING_RIGHT
						end
					end
				end
			end
		end
	end
end -- oh my god

return CombatCortex
