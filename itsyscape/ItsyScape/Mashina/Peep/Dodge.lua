--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Dodge.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"

local Dodge = B.Node("Dodge")
Dodge.TARGET = B.Reference()
Dodge.MAX_DISTANCE = B.Reference()
Dodge.DODGE_DEFAULT = B.Reference()
Dodge.DODGE_TOWARDS = B.Reference()
Dodge.DODGE_BACKWARDS = B.Reference()
Dodge.DODGE_LEFT_RIGHT = B.Reference()

function Dodge:update(mashina, state, executor)
	local target = state[self.TARGET]
	if not target then
		return B.Status.Failure
	end

	local maxDistance = state[self.MAX_DISTANCE] or math.huge

	local weapon = Utility.Peep.getEquippedWeapon(mashina, true) or Weapon.UNARMED
	local mashinaPosition = Utility.Peep.getPosition(mashina)
	local mashinaPositionXZ = mashinaPosition * Vector.PLANE_XZ

	local targetPosition
	if Class.isCompatibleType(target, Peep) then
		targetPosition = Utility.Peep.getRelativePosition(mashina, target)
	elseif Class.isCompatibleType(target, Vector) then
		targetPosition = target
	else
		return B.Status.Failure
	end
	local targetPositionXZ = targetPosition * Vector.PLANE_XZ

	local success = false
	if state[self.DODGE_DEFAULT] then
		success = Utility.Combat.dodge(mashina, target)
	elseif state[self.DODGE_TOWARDS] then
		success = Utility.Combat.dodge(mashina, targetPosition)
	elseif state[self.DODGE_BACKWARDS] then
		local direction = -mashinaPositionXZ:direction(targetPositionXZ)
		local distance = math.min(weapon:getDodgeRange(peep, target), maxDistance)

		success = Utility.Combat.dodge(mashina, mashinaPosition + direction * distance)
	elseif state[self.DODGE_LEFT_RIGHT] then
		local towardsDirection = mashinaPositionXZ:direction(targetPositionXZ)
		local distance = math.min(weapon:getDodgeRange(peep, target), maxDistance)

		local leftDirection = Vector(towardsDirection.y, -towardsDirection.x)
		local leftPosition = distance * leftDirection + mashinaPosition
		local rightDirection = -leftDirection
		local rightPosition = distance * rightDirection + mashinaPosition

		local isLeftPassable, leftRealPosition = Utility.Map.isPassable(mashina, leftPosition)
		local isRightPassable, rightRealPosition = Utility.Map.isPassable(mashina, rightPosition)

		local position
		if isLeftPassable and isRightPassable then
			local positions = { leftPosition, rightPosition }
			position = positions[love.math.random(#positions)]
		elseif isLeftPassable then
			position = leftPosition
		elseif isRightPassable then
			position = rightPosition
		else
			local leftDistance = leftRealPosition:distance(targetPositionXZ)
			local rightDistance = rightRealPosition:distance(targetPositionXZ)

			if leftDistance > rightDistance then
				position = leftRealPosition
			elseif rightDistance > leftDistance then
				position = rightRealPosition
			else
				local positions = { leftRealPosition, rightRealPosition }
				position = positions[love.math.random(#positions)]
			end
		end

		success = Utility.Combat.dodge(mashina, position)
	end

	if not success then
		return B.Status.Failure
	end

	return B.Status.Success
end

return Dodge
