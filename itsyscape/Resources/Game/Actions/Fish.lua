--------------------------------------------------------------------------------
-- Resources/Game/Makes/Fish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Equipment = require "ItsyScape.Game.Equipment"
local GatherResourceCommand = require "ItsyScape.Game.GatherResourceCommand"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local Map = require "ItsyScape.World.Map"
local Make = require "Resources.Game.Actions.Make"

local Fish = Class(Make)
Fish.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Fish.TARGET_MAX_DISTANCE = 9
Fish.MAX_SEARCH_DISTANCE_BUFFER = 1.5
Fish.TARGET_ANCHOR_STEPS = 4
Fish.FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true,
	['item-drop-excess'] = true
}

function Fish:getTileAnchors(prop, player)
	local layer = Utility.Peep.getLayer(player)
	local playerAbsolutePosition = Utility.Peep.getAbsolutePosition(player)
	local playerRelativePosition = Utility.Peep.getPosition(player)
	local xzPlayerRelativePosition = Vector(playerRelativePosition.x, 0, playerRelativePosition.z)
	local map = Utility.Peep.getMap(player)

	local fishAbsolutePosition = Utility.Peep.getAbsolutePosition(prop)
	local xzFishAbsolutePosition = Vector(fishAbsolutePosition.x, 0, fishAbsolutePosition.z)
	local fishRelativePosition = Utility.Map.absolutePositionToRelativePosition(self:getDirector(), layer, fishAbsolutePosition)
	local xzFishRelativePosition = Vector(fishRelativePosition.x, 0, fishRelativePosition.z)

	local _, fishI, fishJ = map:getTileAt(fishRelativePosition.x, fishRelativePosition.z)	local _, playerI, playerJ = map:getTileAt(playerRelativePosition.x, playerRelativePosition.z)

	local ray = Ray(
		xzFishRelativePosition,
		xzFishRelativePosition:direction(xzPlayerRelativePosition))

	local currentShoot
	local function iterateFromFishToPlayer(_, previousI, previousJ, differenceI, differenceJ)
		local canMoveUp = map:canMove(previousI, previousJ, differenceI, differenceJ, Map.SHOOT_FROM_BELOW_TO_ABOVE)
		local canMoveDown = map:canMove(previousI, previousJ, differenceI, differenceJ, Map.SHOOT_FROM_ABOVE_TO_BELOW)

		local nextShoot
		if canMoveUp and canMoveDown then
			nextShoot = Map.SHOOT_BIDRECTIONAL
		elseif canMoveUp then
			nextShoot = Map.SHOOT_FROM_BELOW_TO_ABOVE
		elseif canMoveDown then
			nextShoot = Map.SHOOT_FROM_ABOVE_TO_BELOW
		else
			return false
		end

		if currentShoot and nextShoot ~= Map.SHOOT_BIDRECTIONAL and nextShoot ~= currentShoot then
			return false
		end

		if nextShoot ~= Map.SHOOT_BIDRECTIONAL then
			currentShoot = nextShoot
		end

		return true
	end

	local stopI, stopJ
	local function iterateFromPlayerToFish(_, previousI, previousJ, differenceI, differenceJ)
		stopI = previousI + differenceI
		stopJ = previousJ + differenceJ

		return map:canMove(previousI, previousJ, differenceI, differenceJ, false)
	end

	local positions = {}
	table.insert(positions, xzPlayerRelativePosition)
	for i = 1, self.TARGET_ANCHOR_STEPS do
		local delta = (i - 1) / self.TARGET_ANCHOR_STEPS
		local angle = delta * math.pi * 2
		local ray = Ray(xzFishRelativePosition, Quaternion.fromAxisAngle(Vector.UNIT_Y, angle):transformVector(Vector(1, 0, 0)))
		table.insert(positions, ray:project(self.TARGET_MAX_DISTANCE))
	end

	local anchors = {}
	for i, position in ipairs(positions) do
		local _, currentI, currentJ = map:getTileAt(position.x, position.z)

		currentShoot = nil
		local canMoveFromFishToPlayer = map:lineOfSightPassable(fishI, fishJ, currentI, currentJ, nil, iterateFromFishToPlayer, true)
		if canMoveFromFishToPlayer then
			local _, stopI, stopJ = map:lineOfSightPassable(currentI, currentJ, fishI, fishJ, false, nil, true)
			local absoluteStopPosition = Utility.Map.getAbsoluteTilePosition(self:getDirector(), stopI, stopJ, layer)
			local xzAbsoluteStopPosition = Vector(absoluteStopPosition.x, 0, absoluteStopPosition.z)

			if xzAbsoluteStopPosition:distance(xzFishAbsolutePosition) < self.TARGET_MAX_DISTANCE then
				local relativeStopPosition = map:getTileCenter(stopI, stopJ)
				local xzRelativeStopPosition = Vector(relativeStopPosition.x, 0, relativeStopPosition.z)

				table.insert(anchors, { relativeStopPosition, xzRelativeStopPosition:distance(xzPlayerRelativePosition) })
			end
		end
	end

	table.sort(anchors, function(a, b)
		local _, aDistance = unpack(a)
		local _, bDistance = unpack(b)

		return aDistance < bDistance
	end)

	local maxSearchDistance = xzFishRelativePosition:distance(xzPlayerRelativePosition) * 2 + self.MAX_SEARCH_DISTANCE_BUFFER

	local result = {}
	for _, anchor in ipairs(anchors) do
		local position, distance = unpack(anchor)
		table.insert(result, { position, layer, maxSearchDistance })
	end

	local n = #result
	for i = 1, n do
		local position, layer = unpack(result[i])
		table.insert(result, { position, layer })
	end

	if #result > 0 then
		return true, result
	end

	return false
end

function Fish:perform(state, player, prop)
	return self:gather(state, player, prop, "fishing-rod", "fishing")
end

function Fish:getFailureReason(state, player)
	local reason = Make.getFailureReason(self, state, player)

	if not self:requiresSpecificTool("fishing-rod") then
		table.insert(reason.requirements, {
			type = "Item",
			resource = "WimpyFishingRod",
			name = "Fishing rod (any kind you can equip)",
			count = 1
		})
	end

	return reason
end

return Fish
