--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/Swim.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipMovementCortex = require "ItsyScape.Peep.Cortexes.ShipMovementCortex"

local Swim = B.Node("Swim")
Swim.TARGET = B.Reference()
Swim.OFFSET = B.Reference()
Swim.DISTANCE = B.Reference()
Swim.FACE3D = B.Reference()
Swim.FACE2D = B.Reference()
Swim.PATH = B.Local()

function Swim:update(mashina, state, executor)
	local distance = state[self.DISTANCE] or 0
	local target = state[self.TARGET]
	local offset = state[self.OFFSET]
	local face3D = state[self.FACE3D]
	local face2D = state[self.FACE2D]
	--local path = state[self.PATH]

	local nodes = Sailing.Navigation.buildNodes(mashina, target, offset)
	local path = Sailing.Navigation.navigate(nodes)

	print(">>> path", Log.dump(path))

	-- if not path then
	-- 	local nodes, ships = Sailing.Navigation.buildNodes

	-- 	state[self.PATH] = { nodes = path
	-- end

	local movement = mashina:getBehavior(MovementBehavior)
	if not movement then
		return B.Status.Failure
	end

	local targetPosition = path[2]
	if not targetPosition then
		local _, _, t = Sailing.getShipTarget(mashina, target, offset)
		targetPosition = t
	end

	-- local otherPosition, otherOffset = Sailing.getShipTarget(mashina, target, offset)
	-- if not otherPosition then
	-- 	return B.Status.Failure
	-- end

	-- local targetPosition
	-- if Class.isCompatibleType(otherOffset, Ray) then
	-- 	targetPosition = otherPosition + otherOffset.origin
	-- elseif Class.isCompatibleType(otherOffset, Vector) then
	-- 	targetPosition = otherPosition + otherOffset
	-- else
	-- 	targetPosition = otherPosition
	-- end	
	-- targetPosition = targetPosition * Vector.PLANE_XZ

	local currentPosition = Utility.Peep.getPosition(mashina) * Vector.PLANE_XZ
	local distanceFromTarget = (targetPosition - currentPosition):getLength()
	local direction = (targetPosition - currentPosition):getNormal()

	local isClose = false
	if Class.isCompatibleType(otherOffset, Ray) then
		local ray = Ray(targetPosition, otherOffset.direction)
		local _, A = ray:closest(currentPosition)
		local isWithinTargetDistance = (A - targetPosition):getLength() < distance

		local size = Utility.Peep.getSize(mashina)
		local isWithinWidth = (A - currentPosition):getLength() < size.x / 2
		isClose = isWithinTargetDistance and isWithinWidth
	end

	-- local rayToTarget = Ray(currentPosition, (targetPosition - currentPosition):getNormal())
	-- local director = mashina:getDirector()
	-- local shipMovementCortex = director:getCortex(ShipMovementCortex)

	-- local hits = shipMovementCortex:projectRay(rayToTarget, mashina:getLayerName())
	-- table.sort(hits, function(a, b)
	-- 	local aDistance = (a.nearPoint - currentPosition):getLengthSquared()
	-- 	local bDistance = (b.nearPoint - currentPosition):getLengthSquared()

	-- 	return aDistance < bDistance
	-- end)

-- 	local collision = hits[1]
-- 	if collision then
-- 		local collisionShip = collision.peep

-- 		local collisionShipPosition = Utility.Peep.getPosition(collision.peep) * Vector.PLANE_XZ
-- 		--local shipMovement = collisionShip:getBehavior(ShipMovementBehavior)

-- 		local currentSize = Utility.Peep.getSize(mashina)
-- 		local currentRadius = math.max(currentSize.x, currentSize.z)

-- 		local cornerDistance = (collisionShipPosition - collision.nearPoint):getLength()
-- 		local cornerDirection = collisionShipPosition:direction(collision.nearPoint)

-- 		-- local collisionBow = Sailing.getShipBow(collisionShip, (shipMovement and shipMovement.length * 2))
-- 		-- local collisionStern = Sailing.getShipStern(collisionShip, (shipMovement and shipMovement.length * 2))
-- 		-- local collisionPort = Sailing.getShipPort(collisionShip, (shipMovement and shipMovement.beam * 2))
-- 		-- local collisionStarboard = Sailing.getShipStarboard(collisionShip, (shipMovement and shipMovement.beam * 2))

-- 		-- -- local collisionShipPosition = Utility.Peep.getPosition(collisionShip) * Vector.PLANE_XZ
-- 		-- -- local shipForwardNormal = Sailing.getShipDirectionNormal(collisionShip)
-- 		-- -- local shipToCurrentNormal = (collisionShipPosition - currentPosition):getNormal()

-- 		-- -- local corners
-- 		-- -- do
-- 		-- -- 	local dot = shipForwardNormal:dot(shipToCurrentNormal)
-- 		-- -- 	if math.abs(dot) > 0.8 then
-- 		-- -- 		print(">>> try left/right of ship")
-- 		-- -- 		corners = {
-- 		-- -- 			collisionPort,
-- 		-- -- 			collisionStarboard
-- 		-- -- 		}
-- 		-- -- 	else
-- 		-- -- 		print(">>> try back of ship")
-- 		-- -- 		corners = {
-- 		-- -- 			collisionStern
-- 		-- -- 		}
-- 		-- -- 	end
-- 		-- -- end

-- 		-- local isInFrontOrBehindOfShip
-- 		-- do
-- 		-- 	local shipForward = Sailing.getShipDirectionNormal(collisionShip)

-- 		-- 	local shipForwardRay = Ray(Sailing.getShipBow(collisionShip) * Vector.PLANE_XZ, shipForward)
-- 		-- 	local shipBackwardRay = Ray(Sailing.getShipStern(collisionShip) * Vector.PLANE_XZ, -shipForward)

-- 		-- 	local currentMin, currentMax = Utility.Peep.getBounds(mashina)
-- 		-- 	currentMin = Vector(currentMin.x, -1, currentMin.z)
-- 		-- 	currentMax = Vector(currentMax.x, 1, currentMax.z)

-- 		-- 	local currentTransform = Utility.Peep.getTransform(mashina)

-- 		-- 	local hitForward, a1 = shipForwardRay:hitBounds(currentMin, currentMax)
-- 		-- 	local hitBackward, a2 = shipBackwardRay:hitBounds(currentMin, currentMax)

-- 		-- 	if hitForward then
-- 		-- 		print(">>> forward")
-- 		-- 		print("", "p", a1:get())
-- 		-- 	end
-- 		-- 	if hitBackward then
-- 		-- 		print(">>> backward")
-- 		-- 		print("", "p", a2:get())
-- 		-- 	end

-- 		-- 	local dot = math.abs(shipForward:dot(collisionShipPosition:direction(currentPosition)))
-- 		-- 	if hitForward or hitBackward then print("", "dot", dot) end

-- 		-- 	isInFrontOrBehindOfShip = (hitForward or hitBackward) and dot > 0.8
-- 		-- end

-- 		-- local corners
-- 		-- if isInFrontOrBehindOfShip then
-- 		-- 	print(">>> is in front or behind ship")
-- 		-- 	corners = {
-- 		-- 		collisionPort,
-- 		-- 		collisionStarboard
-- 		-- 	}
-- 		-- else
-- 		-- 	print(">>> is to the side of the ship")
-- 		-- 	corners = {
-- 		-- 		collisionStern,
-- 		-- 		collisionBow
-- 		-- 	}
-- 		-- end

-- 		-- local closestCorner, closestDistance
-- 		-- for _, corner in ipairs(corners) do
-- 		-- 	corner = corner * Vector.PLANE_XZ

-- 		-- 	local distanceToTargetFromCorner = (corner - targetPosition):getLengthSquared()
-- 		-- 	if distanceToTargetFromCorner < (closestDistance or math.huge) then
-- 		-- 		print(">>> best", _, math.sqrt(distanceToTargetFromCorner))
-- 		-- 		closestCorner = corner
-- 		-- 		closestDistance = distanceToTargetFromCorner
-- 		-- 	else
-- 		-- 		print(">>> nope", _, math.sqrt(distanceToTargetFromCorner))
-- 		-- 	end

-- 		-- 	--print(">>>", _, "cornerToTargetRay", not not shipMovementCortex:projectRayAgainstShip(collisionShip, cornerToTargetRay))
-- 		-- 	--print(">>>", _, "currentToCornerRay", not not shipMovementCortex:projectRayAgainstShip(collisionShip, currentToCornerRay))

-- 		-- 	--local hasNoCollision = not (shipMovementCortex:projectRayAgainstShip(collisionShip, cornerToTargetRay) or shipMovementCortex:projectRayAgainstShip(collisionShip, currentToCornerRay))
-- 		-- 	-- local hasNoCollision = not shipMovementCortex:projectRayAgainstShip(cornerToTargetRay)
-- 		-- 	-- if hasNoCollision then
-- 		-- 	-- 	closestCorner = corner
-- 		-- 	-- 	break
-- 		-- 	-- end
-- 		-- end

-- 		-- local otherTargetPosition = closestCorner

-- 		-- local currentToCornerRay = Ray(currentPosition, -currentPosition:direction(closestCorner))
-- 		-- if shipMovementCortex:projectRayAgainstShip(collisionShip, currentToCornerRay) then
-- 		-- 	local cornerCurrentMidpoint = currentPosition:lerp(closestCorner, 0.5)
-- 		-- 	otherTargetPosition = cornerCurrentMidpoint
-- 		-- 	print(">>> ship is in way")
-- 		-- end

-- 		-- local cornerToTargetRay = Ray(closestCorner, (targetPosition - closestCorner):getNormal()) 
-- 		-- local currentToCornerRay = Ray(currentPosition, (currentPosition - closestCorner):getNormal())
-- 		-- if shipMovementCortex:projectRayAgainstShip(collisionShip, currentToCornerRay) then
-- 		-- 	local p1, p2 = shipMovementCortex:projectRayAgainstShip(collisionShip, currentToCornerRay)
-- 		-- 	print(">>> near", p1:get())
-- 		-- 	print(">>> far", p2:get())

-- 		-- 	--Utility.spawnPropAtPosition(mashina, "Null", p1:get())
-- 		-- 	--Utility.spawnPropAtPosition(mashina, "Null", p2:get())

-- 		-- 	print(">>> whoops, hit ship again!")
-- 		-- 	local cornerCurrentMidpoint = currentPosition:lerp(closestCorner, 0.5)
-- 		-- 	local shipDirectionToMidpoint = (collisionShipPosition - cornerCurrentMidpoint):getNormal()
-- 		-- 	otherTargetPosition = shipDirectionToMidpoint * math.max(shipMovement.beam, shipMovement.length) + collisionShipPosition
-- 		-- else
-- 		-- 	print(">>> free'n'clear!")
-- 		-- 	otherTargetPosition = closestCorner
-- 		-- end

-- --		if otherTargetPosition then
-- 			-- print(">>> avoiding", collisionShip:getName(), "curpos", targetPosition:get())
-- 			-- direction = (otherTargetPosition - currentPosition):getNormal()
-- 		 	-- print("", "newposition", otherTargetPosition:get())
-- 		-- else
-- 		-- 	print("NO CLOSEST CORNER!")
-- 		-- end

-- 		--Utility.Peep.setPosition(prop:getPeep(), otherTargetPosition + Vector(0, 32, 0))
-- 	else
-- 		--Utility.Peep.setPosition(prop:getPeep(), targetPosition + Vector(0, 32, 0))
-- 	end

	-- local rotationTarget = (collision and collision.peep) or target
	-- if Class.isCompatibleType(rotationTarget, Peep) then
	-- 	local shipMovement = rotationTarget:getBehavior(ShipMovementBehavior)

	-- 	if shipMovement and face3D and mashina:hasBehavior(RotationBehavior) then
	-- 		local rotation = shipMovement.rotation
	-- 		if face2D then
	-- 			local inverseRotation = -rotation
	-- 			local inverseTransformedDirection = inverseRotation:transformVector(direction)
	-- 			if inverseTransformedDirection.x < 0 then
	-- 				-- Rotation 180 to face left.
	-- 				-- Do nothing otherwise. Objects using 2D facing default to facing +X.
	-- 				rotation = rotation * Quaternion.Y_180
	-- 			end
	-- 		end

	-- 		Utility.Peep.setRotation(mashina, rotation)
	-- 	end
	-- end

	local direction = currentPosition:direction(targetPosition)

	if isClose or distanceFromTarget < distance then
		movement.isStopping = true
		--movement.acceleration = Vector(0)

		Utility.Peep.lookAt(mashina, target)

		return B.Status.Success
	else
		movement.isStopping = false
		--movement.acceleration = movement.acceleration + direction * movement.maxAcceleration
		movement.velocity = direction * movement.maxSpeed

		return B.Status.Working
	end
end

function Swim:deactivated(mashina, state)
	local prop = state[self.PROP]
	if prop then
		Utility.Peep.poof(prop:getPeep())
	end
end

return Swim
