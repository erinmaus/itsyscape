--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/FireCannons.lua
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
local Vector = require "ItsyScape.Common.Math.Vector"
local Probe = require "ItsyScape.Peep.Probe"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"
local ShipCrewMemberBehavior = require "ItsyScape.Peep.Behaviors.ShipCrewMemberBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"

local FireCannons = B.Node("FireCannons")
FireCannons.TARGET = B.Reference()
FireCannons.DIRECTION = B.Reference()
FireCannons.ALWAYS = B.Reference()
FireCannons.HITS = B.Reference()

local function probeCannons(ship, targetPosition, targetNormal, direction, always)
	local director = ship:getDirector()
	local gameDB = director:getGameDB()

	local _, movement = ship:addBehavior(ShipMovementBehavior)
	local selfPosition = Utility.Peep.getPosition(ship)
	local selfForward = movement.rotation:transformVector(movement.steerDirectionNormal) + selfPosition

	local hits = director:probe(
		ship:getLayerName(),
		Probe.layer(ship:getLayer()),
		function(peep)
			local isCannon
			do
				local resource = Utility.Peep.getResource(peep)
				if resource then
					local cannonRecord = gameDB:getRecord("Cannon", {
						Resource = resource
					})

					if cannonRecord then
						isCannon = true
					else
						isCannon = false
					end
				end
			end

			return isCannon
		end)

	local cannons = {}
	for i = 1, #hits do
		local hit = hits[i]
		local resource = Utility.Peep.getResource(hit)
		cannons[i] = gameDB:getRecord("Cannon", {
			Resource = resource
		})
	end

	local positions = {}
	for i = 1, #hits do
		local map = Utility.Peep.getMapScript(hits[i])
		local mapTransform = Utility.Peep.getMapTransform(map)
		local position = Utility.Peep.getPosition(hits[i])
		positions[i] = Vector(mapTransform:transformPoint(position:get()))
	end

	local canFire = {}
	local distances = {}
	for i = 1, #hits do
		local isCloseEnough, shipSide
		if targetPosition and targetNormal then
			local origin = targetPosition * Vector.PLANE_XZ
			local v = (positions[i] * Vector.PLANE_XZ) - origin
			local d = v:dot(targetNormal)
			local p = targetPosition + d * targetNormal

			local distance = (positions[i] * Vector.PLANE_XZ - p):getLength()
			isCloseEnough = distance <= cannons[i]:get("Range")
			shipSide = Sailing.getDirection(ship, targetPosition)
		elseif targetPosition then
			local distance = ((positions[i] - targetPosition) * Vector.PLANE_XZ):getLength()
			isCloseEnough = distance <= cannons[i]:get("Range")
			shipSide = Sailing.getDirection(ship, targetPosition)
		elseif direction then
			isCloseEnough = true
			shipSide = targetPosition
		end

		local cannonSide = Sailing.getDirection(ship, positions[i])
		local isSameSide = cannonSide == shipSide

		canFire[i] = (isCloseEnough or always) and isSameSide
		distances[i] = distance
	end

	local actions = {}
	for i = 1, #hits do
		actions[i] = false

		local resource = Utility.Peep.getResource(hits[i])
		local peepActions = Utility.getActions(ship:getDirector():getGameInstance(), resource, 'world')
		for j = 1, #peepActions do
			if peepActions[j].instance:is('fire') then
				actions[i] = peepActions[j].instance
				break
			end
		end
	end

	local result = {}
	for i = 1, #hits do
		result[i] = {
			peep = hits[i],
			cannon = cannons[i],
			position = positions[i],
			canFire = canFire[i],
			distance = distances[i],
			action = actions[i]
		}
	end

	return result
end

local function fireCannons(ship, fireProbe)
	local director = ship:getDirector()
	local crew = director:probe(ship:getLayerName(), Probe.layer(ship:getLayer()), Probe.crew(ship))

	local hits = 0
	for i = 1, #fireProbe do
		local details = fireProbe[i]

		if details.canFire then
			table.sort(crew, function(a, b)
				local aPosition = Utility.Peep.getAbsolutePosition(a)
				local bPosition = Utility.Peep.getAbsolutePosition(b)

				return (aPosition - details.position):getLengthSquared() < (bPosition - details.position):getLengthSquared()
			end)

			for index, crewMember in ipairs(crew) do
				local cannonReady = details.peep:canFire()

				local canFire = cannonReady
				if canFire then
					canFire = details.action:canPerform(crewMember:getState()) and
					          details.action:canTransfer(crewMember:getState())
				end

				if canFire and cannonReady then
					if details.action:perform(crewMember:getState(), crewMember, details.peep) then
						hits = hits + 1
						Log.info("BOOM! '%s' is gonna fire a cannon!", crewMember:getName())

						table.remove(crew, index)
						break
					end
				end
			end
		end
	end

	return hits
end

function FireCannons:update(mashina, state, executor)
	local director = mashina:getDirector()

	local target = state[self.TARGET]
	local direction = state[self.DIRECTION]
	local always = state[self.ALWAYS] or false

	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep
	if not ship then
		Log.warnOnce("Peep '%s' is not currently a captain of a ship!", mashina:getName())
		return B.Status.Failure
	end

	local position = Sailing.getShipTarget(ship, target)
	if not position and not direction then
		return B.Status.Failure
	end

	local normal = Sailing.getShipDirectionNormal(target)

	local cannonProbe = probeCannons(ship, position, normal, direction, always)
	local count = fireCannons(ship, cannonProbe)

	state[self.HITS] = count

	if count == 0 then
		print("NO SHOTS!")
		return B.Status.Failure
	else
		print("SHOTS", count)
		return B.Status.Success
	end
end

return FireCannons
