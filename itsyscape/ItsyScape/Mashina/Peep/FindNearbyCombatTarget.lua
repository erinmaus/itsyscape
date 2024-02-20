--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/FindNearbyCombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local FindNearbyCombatTarget = B.Node("FindNearbyCombatTarget")
FindNearbyCombatTarget.FILTER = B.Reference()
FindNearbyCombatTarget.FILTERS = B.Reference()
FindNearbyCombatTarget.DISTANCE = B.Reference()
FindNearbyCombatTarget.LINE_OF_SIGHT = B.Reference()
FindNearbyCombatTarget.INCLUDE_NPCS = B.Reference()
FindNearbyCombatTarget.INCLUDE_DEAD = B.Reference()
FindNearbyCombatTarget.COUNT = B.Reference()
FindNearbyCombatTarget.SAME_LAYER = B.Reference()
FindNearbyCombatTarget.RESULT = B.Reference()

local function probeIsAlive(includeDead, p)
	if includeDead then
		return true
	end

	return p:hasBehavior(CombatStatusBehavior) and not p:getBehavior(CombatStatusBehavior).dead
end

local function probeFilterNPCs(mashina, includeNPCs, p)
	if not includeNPCs then
		if p:hasBehavior(PlayerBehavior) and p ~= mashina then
			return true
		end
	else
		return p ~= mashina
	end
end

local function probeFilterLineOfSight(mashina, sameLayer, checkLineOfSight, p)
	if not checkLineOfSight then
		return true
	end

	if sameLayer and Utility.Peep.getLayer(mashina) ~= Utility.Peep.getLayer(p) then
		return false
	end

	local director = mashina:getDirector()

	local selfI, selfJ = Utility.Peep.getTile(mashina)
	local targetI, targetJ = Utility.Peep.getTile(p)

	local map = director:getMap(Utility.Peep.getLayer(mashina))
	local passable = map and map:lineOfSightPassable(selfI, selfJ, targetI, targetJ, true)

	return passable
end

local function probeCustomFilter(f, mashina, state, executor, p)
	return f(p, mashina, state, executor)
end

function FindNearbyCombatTarget:update(mashina, state, executor)
	local director = mashina:getDirector()

	local includeNPCs = state[self.INCLUDE_NPCS]
	local sameLayer = state[self.SAME_LAYER]
	sameLayer = sameLayer == nil and true or sameLayer

	local status = mashina:getBehavior(CombatStatusBehavior)
	local distance = math.min(state[self.DISTANCE] or math.huge, status and status.maxChaseDistance or math.huge)

	local weapon = Utility.Peep.getEquippedWeapon(mashina, true)
	if weapon and Class.isCompatibleType(weapon, Weapon) then
		distance = distance + weapon:getAttackRange(mashina)
	end

	local p = director:probe(
		mashina:getLayerName(),
		Probe.attackable(),
		Probe.distance(mashina, distance / 2),
		Probe.bind(probeIsAlive, state[self.INCLUDE_DEAD]),
		Probe.bind(probeFilterNPCs, mashina, includeNPCs),
		Probe.bind(probeFilterLineOfSight, mashina, sameLayer, state[self.LINE_OF_SIGHT]),
		Probe.bind(probeCustomFilter, state[self.FILTER] or Probe.any(), mashina, state, executor),
		unpack(state[self.FILTERS] or {}))

	if p and #p > 0 then
		table.sort(
			p,
			function(a, b)
				local p = Utility.Peep.getPosition(mashina)
				local aP = Utility.Peep.getPosition(a)
				local bP = Utility.Peep.getPosition(b)

				local aDistance = (aP - p):getLength()
				local bDistance = (bP - p):getLength()
				return aDistance < bDistance
			end)

		for i = 1, #p do
			if p[i] ~= mashina then
				state[self.RESULT] = p[i]
				state[self.COUNT] = #p
				return B.Status.Success
			end
		end
	end

	state[self.RESULT] = nil
	state[self.COUNT] = 0

	return B.Status.Failure
end

return FindNearbyCombatTarget
