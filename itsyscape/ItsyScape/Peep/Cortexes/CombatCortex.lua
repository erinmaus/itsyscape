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
local Vector = require "ItsyScape.Common.Math.Vector"
local AttackCommand = require "ItsyScape.Game.AttackCommand"
local CombatPower = require "ItsyScape.Game.CombatPower"
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
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local WeaponBehavior = require "ItsyScape.Peep.Behaviors.WeaponBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"
local TilePathNode = require "ItsyScape.World.TilePathNode"

local CombatCortex = Class(Cortex)
CombatCortex.QUEUE = {}
CombatCortex.PLAYER_DISENGAGE_DURATION = 2
CombatCortex.PLAYER_RETRY_MIN_DURATION = 0.25
CombatCortex.PLAYER_RETRY_MAX_DURATION = 1.00
CombatCortex.PLAYER_MOVING_COOLDOWN = 0.25

function CombatCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(CombatStatusBehavior)
	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(SizeBehavior)

	self.walking = {}
	self.strafing = {}
	self.pendingResume = {}
	self.pendingPlayers = {}
	self.defaultWeapon = Weapon()
end

function CombatCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.walking[peep] = nil
	self.strafing[peep] = nil
	self.pendingResume[peep] = nil
	self.pendingPlayers[peep] = nil
end

function CombatCortex:resetPeep(peep)
	peep:removeBehavior(CombatTargetBehavior)
	peep:getCommandQueue(CombatCortex.QUEUE):clear()
end

function CombatCortex:stopAttacking(peep, target)
	if self:hasPeep(peep) then
		if target then
			local actor = target:getBehavior(ActorReferenceBehavior)
			actor = actor and actor.actor

			local peepTarget = peep:getBehavior(CombatTargetBehavior)
			peepTarget = peepTarget and peepTarget.actor
			if not (peepTarget == actor or self.pendingResume[peep] == target) then
				return false
			end
		end

		self:resetPeep(peep)

		self.pendingResume[peep] = nil
		self.pendingPlayers[peep] = nil

		return true
	end

	return false
end

function CombatCortex:resume(peep, target)
	if peep:wasPoofed() or target:wasPoofed() then
		return
	end

	local actor = target:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
		local s, b = peep:addBehavior(CombatTargetBehavior)
		if s and not b.actor then
			b.actor = actor
		end

		local status = target:getBehavior(CombatStatusBehavior)
		if status.currentHitpoints > 0 then
			peep:getCommandQueue():push(AttackCommand())
		end
	end
end

function CombatCortex:usePower(peep, target, logic)
	local game = self:getDirector():getGameInstance()

	local power = peep:getBehavior(PendingPowerBehavior)
	if power then
		power = power.power
	end

	local coolDowns = peep:getBehavior(PowerCoolDownBehavior)
	if not coolDowns then
		peep:addBehavior(PowerCoolDownBehavior)
		coolDowns = peep:getBehavior(PowerCoolDownBehavior)
	end

	local logicOverride
	if power and power:isCompatibleType(CombatPower) then
		local canUseAbility = true

		local id = power:getResource().id.value
		local time = love.timer.getTime()
		if coolDowns.powers[id] then
			canUseAbility = time > coolDowns.powers[id]
		end

		if canUseAbility then
			canUseAbility = power:perform(peep, target)
		end

		if canUseAbility then
			power:activate(peep, target)

			if not power:getIsQuick() and logic and logic:isCompatibleType(Weapon) then
				logic:applyCooldown(peep, target)
			end

			logicOverride = power:getXWeapon(peep)

			coolDowns.powers[id] = time + power:getCoolDown(peep)

			local actor = peep:getBehavior(ActorReferenceBehavior)
			if actor and actor.actor then
				actor.actor:flash("Power", 0.5, power:getResource().name, power:getName())
			end
		end

		peep:removeBehavior(PendingPowerBehavior)

		return true, logicOverride
	end

	return false, logic
end

function CombatCortex:update(delta)
	local currentGlobalTime = love.timer.getTime()

	local game = self:getDirector():getGameInstance()
	local itemManager = self:getDirector():getItemManager()

	for peep, target in pairs(self.pendingResume) do
		self:resume(peep, target)
		self.pendingResume[peep] = nil
	end

	for peep in self:iterate() do
		local isMoving = peep:hasBehavior(MovementBehavior) and peep:getBehavior(MovementBehavior).velocity:getLength() > 0.1
		local position = peep:getBehavior(PositionBehavior)

		local weaponRange
		local equippedWeapon =
			Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_RIGHT_HAND) or
			Utility.Peep.getEquippedItem(peep, Equipment.PLAYER_SLOT_TWO_HANDED)
		if not equippedWeapon then
			weaponRange = 1
		end
		
		local logic
		if not equippedWeapon then
			local weapon = peep:getBehavior(WeaponBehavior)
			if weapon and weapon.weapon then
				logic = weapon.weapon
				weaponRange = logic:getAttackRange(peep)
			end
		else
			logic = itemManager:getLogic(equippedWeapon:getID())
			if logic and logic:isCompatibleType(Weapon) then
				weaponRange = logic:getAttackRange(peep)
			else
				weaponRange = 1
			end
		end

		local target = peep:getBehavior(CombatTargetBehavior)
		if target then
			target = target.actor and target.actor:getPeep()

			if target:hasBehavior(DisabledBehavior) then
				target = nil
			end
		end

		do
			for effect in peep:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
				weaponRange = effect:applyToSelfWeaponRange(peep, weaponRange)
			end

			if target then
				for effect in target:getEffects(require "ItsyScape.Peep.Effects.CombatEffect") do
					weaponRange = effect:applyToTargetWeaponRange(target, weaponRange)
				end
			end
		end

		if target then
			local targetInstance = Utility.Peep.getInstance(target)
			local peepInstance = Utility.Peep.getInstance(peep)

			if targetInstance ~= peepInstance then
				Log.info(
					"Target '%s' is in instance '%s' (%d), while peep '%s' is in instance %s (%s); dis-engaging.",
					target:getName(), (targetInstance and targetInstance:getFilename()) or "<invalid", (targetInstance and targetInstance:getID()) or -1,
					peep:getName(), (peepInstance and peepInstance:getFilename()) or "<invalid", (peepInstance and peepInstance:getID()) or -1)

				self.pendingPlayers[peep] = nil
				self.walking[peep] = nil
				self.strafing[peep] = nil

				self:resetPeep(peep)

				target = nil
			end
		end

		do
			local cooldown = peep:getBehavior(AttackCooldownBehavior)
			if cooldown then
				cooldown.cooldown = math.max((cooldown.cooldown or 0) - delta, 0)
			end
		end

		local attacked = false

		if target then
			local targetPosition = target:getBehavior(PositionBehavior)
			if targetPosition then
				local map = game:getDirector():getMap(position.layer or 1)
				if map then
					weaponRange = weaponRange * map:getCellSize()

					local selfI, selfJ = map:toTile(
						position.position.x,
						position.position.z)

					local targetI, targetJ
					if targetPosition.layer == position.layer then
						targetI, targetJ = map:toTile(
							targetPosition.position.x,
							targetPosition.position.z)
					else
						local targetAbsolutePosition = Utility.Peep.getAbsolutePosition(target)
						local peepParentTransform = Utility.Peep.getParentTransform(peep)

						local targetRelativePosition
						if peepParentTransform then
							local tx, ty, tz = peepParentTransform:inverseTransformPoint(targetAbsolutePosition:get())
							targetRelativePosition = Vector(tx, ty, tz)
						else
							targetRelativePosition = targetAbsolutePosition
						end

						local _
						_, _, targetI, targetJ = map:toTile(
							targetRelativePosition.x,
							targetRelativePosition.z)
					end

					local selfRadius, targetRadius
					do
						local peepSize = peep:getBehavior(SizeBehavior).size
						local peepScale = Utility.Peep.getScale(peep)
						peepSize = math.max(peepSize.x * peepScale.x, peepSize.z * peepScale.z)
						selfRadius = math.max(peepSize - 1, 0)

						local targetSize = target:getBehavior(SizeBehavior).size
						local targetScale = Utility.Peep.getScale(target)
						targetSize = math.max(targetSize.x * peepScale.x, targetSize.z * targetScale.z)
						targetRadius = math.max(targetSize - 1, 0)
					end
					
					local combat = peep:getBehavior(CombatStatusBehavior)
					local movement = peep:getBehavior(MovementBehavior)

					local distanceToTarget = ((Utility.Peep.getAbsolutePosition(peep) - Utility.Peep.getAbsolutePosition(target)) * Vector.PLANE_XZ):getLength()
					local desiredDistance = math.max(weaponRange + targetRadius + selfRadius - 1, 1)

					if distanceToTarget - selfRadius - targetRadius > (((combat and combat.maxChaseDistance) or 0) + weaponRange) then
						peep:getCommandQueue(CombatCortex.QUEUE):clear()
						peep:removeBehavior(CombatTargetBehavior)
						peep:poke('targetFled', { target = target, distance = distanceToTarget })
					elseif distanceToTarget > desiredDistance or (not movement.noClip and not map:lineOfSightPassable(selfI, selfJ, targetI, targetJ, true, peep:hasBehavior(PlayerBehavior) and _DEBUG == 'plus')) then
						local tile = self.walking[peep]
						if (not tile or tile.i ~= targetI or tile.j ~= targetJ) and targetPosition.layer == position.layer then
							local walk = Utility.Peep.getWalk(peep, targetI, targetJ, targetPosition.layer or 1, math.huge, { asCloseAsPossible = true })

							if not walk then
								Log.info(
									"Peep %s (%d) couldn't reach target peep %s (%d); abandoning.",
									peep:getName(), peep:getTally(),
									target:getName(), target:getTally())
								peep:removeBehavior(CombatTargetBehavior)
								peep:poke('targetFled', { target = target, distance = distanceToTarget })
							elseif (not peep:hasBehavior(TargetTileBehavior) or self.walking[peep]) then
								local hasTarget = peep:hasBehavior(TargetTileBehavior)
								local isWalking = true

								local function isPending()
									local s, t = Utility.Peep.getTile(target)
									local u, v = Utility.Peep.getTile(peep)
									local isSameTile = s == targetI and t == targetJ

									local peepPosition = Utility.Peep.getPosition(peep)
									local targetPosition = Utility.Peep.getPosition(target)
									local distance = ((peepPosition - targetPosition) * Vector.PLANE_XZ):getLength()
									local isTooFar = distance > desiredDistance
									local isLineOfSightBlocked = not map:lineOfSightPassable(u, v, s, t, true)

									return isSameTile and (isTooFar or isLineOfSightBlocked)
								end

								walk.onCanceled:register(function()
									isWalking = false
									self.walking[peep] = nil

									if not isPending() then
										self.pendingResume[peep] = target
									end
								end)
								local callback = CallbackCommand(self.resume, self, peep, target)
								local c = CompositeCommand(function()
									return isPending() and isWalking
								end, walk, callback)

								local executeWalk = false

								local isPlayer = peep:hasBehavior(PlayerBehavior)
								if isPlayer and not self.walking[peep] then
									local currentPlayerTime = self.pendingPlayers[peep]
									if not currentPlayerTime and isMoving then
										self.pendingPlayers[peep] = { idleTime = currentGlobalTime, movingTime = 0, totalTime = 0 }
									elseif not isMoving then
										executeWalk = true
									elseif currentPlayerTime and
									       (currentGlobalTime - currentPlayerTime.idleTime) > CombatCortex.PLAYER_RETRY_MIN_DURATION and
										   (currentGlobalTime - currentPlayerTime.idleTime) < CombatCortex.PLAYER_RETRY_MAX_DURATION
									then
										Log.info(
											"Player '%s' stopped moving; trying to re-engage with foe '%s'.",
											peep:getName(),
											target:getName())

										self.pendingPlayers[peep] = nil

										executeWalk = true
									end
								else
									executeWalk = true
								end

								if executeWalk then
									peep:getCommandQueue(CombatCortex.QUEUE):interrupt(c)

									if isPlayer then
										local _, playerTarget = peep:addBehavior(CombatTargetBehavior)
										local targetActor = target:hasBehavior(ActorReferenceBehavior) and target:getBehavior(ActorReferenceBehavior).actor

										if playerTarget and targetActor then
											playerTarget.actor = targetActor
										end
									end

									self.walking[peep] = { i = targetI, j = targetJ }
								end

								if hasTarget then
									peep:addBehavior(TargetTileBehavior)
								end
							end

						end
					else
						if self.walking[peep] then
							self.walking[peep] = nil

							peep:getCommandQueue(CombatCortex.QUEUE):clear()
							peep:removeBehavior(TargetTileBehavior)
						elseif not self.strafing[peep] then
							local targetIsPlayer = target:hasBehavior(PlayerBehavior)
							local selfIsPlayer = peep:hasBehavior(PlayerBehavior)
							if not selfIsPlayer then
								if distanceToTarget <= targetRadius and not self.strafing[target] then
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

						if peep:hasBehavior(PlayerBehavior) and self.pendingPlayers[peep] then
							local currentPlayerTime = self.pendingPlayers[peep]
							Log.info(
								"Player '%s' reached target in %0.2f second(s); resuming attack.",
								peep:getName(),
								currentPlayerTime.totalTime)

							self.pendingPlayers[peep] = nil
						end

						local canAttack
						do
							local cooldown = peep:getBehavior(AttackCooldownBehavior)
							if cooldown then
								canAttack = (cooldown.cooldown or 0) <= 0
							else
								canAttack = true
							end
						end
						do
							local targetCombat = target:getBehavior(CombatStatusBehavior)
							if targetCombat and targetCombat.currentHitpoints == 0 then
								peep:removeBehavior(CombatTargetBehavior)
								target:getCommandQueue(CombatCortex.QUEUE):clear()
								canAttack = false
							end
						end

						logic = logic or self.defaultWeapon
						if canAttack then
							local _
							_, logic = self:usePower(peep, target, logic)

							if logic and logic:isCompatibleType(Weapon) then
								local success = logic:perform(peep, target)

								if success then
									local projectile = logic:getProjectile(peep)
									if projectile then
										local stage = game:getStage()
										stage:fireProjectile(projectile, peep, target)
									end

									attacked = true
								end
							end
						else
							local power = peep:getBehavior(PendingPowerBehavior)
							if power then
								power = power.power

								if power:getIsInstant() then
									attacked = self:usePower(peep, target, logic)
								end
							end
						end
					end

					do
						if not movement.targetFacing then
							if selfI > targetI then
								movement.facing = MovementBehavior.FACING_LEFT
							elseif selfI < targetI then
								movement.facing = MovementBehavior.FACING_RIGHT
							end
						end
					end
				end
			end
		else
			local success

			local power = peep:getBehavior(PendingPowerBehavior)
			if power then
				power = power.power

				if not power:getRequiresTarget() then
					success = self:usePower(peep, nil, logic)
					attacked = success
				end
			end

			if not success then
				local isWalking = self.walking[peep]
				local isStrafing = self.strafing[peep]

				if not isWalking and not isStrafing then
					self:resetPeep(peep)
				end
			end
		end

		if not attacked then
			local power = peep:getBehavior(PendingPowerBehavior)
			if power then
				power = power.power

				if not power:getRequiresTarget() then
					success = self:usePower(peep, nil, logic)
					attacked = success
				end
			end
		end
	end

	for player, currentPlayerTime in pairs(self.pendingPlayers) do
		currentPlayerTime.totalTime = currentPlayerTime.totalTime + delta

		local isMoving = player:hasBehavior(MovementBehavior) and player:getBehavior(MovementBehavior).velocity:getLength() > 0.1
		if isMoving then
			currentPlayerTime.movingTime = 0
		else
			currentPlayerTime.movingTime = currentPlayerTime.movingTime + delta
		end

		local isExpired = currentGlobalTime - currentPlayerTime.idleTime > CombatCortex.PLAYER_DISENGAGE_DURATION
		local isStill = currentPlayerTime.movingTime > CombatCortex.PLAYER_MOVING_COOLDOWN
		if isExpired and not isMoving and isStill then
			Log.info(
				"Player hasn't been attacking for over %0.2f seconds and stopped moving for %0.2f seconds; dis-engaging.",
				currentGlobalTime - currentPlayerTime.idleTime,
				currentPlayerTime.movingTime)

			self:resetPeep(player)
			self.pendingPlayers[player] = nil
		end
	end
end -- oh my god

return CombatCortex
