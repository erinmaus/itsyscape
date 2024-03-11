--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/GetNearestOffset.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"

local GetNearestOffset = B.Node("GetNearestOffset")
GetNearestOffset.TARGET = B.Reference()
GetNearestOffset.OFFSETS = B.Reference()
GetNearestOffset.RESULT = B.Reference()
GetNearestOffset.RESULTS = B.Reference()

function GetNearestOffset:update(mashina, state, executor)
	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep

	local target = state[self.TARGET]
	local offsets = state[self.OFFSETS] or {}

	local results = {}
	for _, offset in ipairs(offsets) do
		local p, o = Sailing.getShipTarget(ship, target, offset)

		if p and o then
			local po
			if Class.isCompatibleType(o, Ray) then
				po = p + o.origin
			else
				po = p + o
			end

			table.insert(results, {
				offset = offset,
				position = po,

			})
		end
	end

	local selfPosition = Utility.Peep.getPosition(ship or mashina) + (ship and Sailing.getShipBow(ship) or Vector.ZERO)
	table.sort(results, function(a, b)
		local aDistance = (selfPosition - a.position):getLengthSquared()
		local bDistance = (selfPosition - b.position):getLengthSquared()

		return aDistance < bDistance
	end)

	for i, offset in ipairs(results) do
		results[i] = offset.offset
	end

	state[self.RESULT] = results[1]
	state[self.RESULTS] = results

	if #results > 0 then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return GetNearestOffset
