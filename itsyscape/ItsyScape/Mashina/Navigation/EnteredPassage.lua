--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/EnteredPassage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local EnteredPassage = B.Node("EnteredPassage")
EnteredPassage.PEEP = B.Reference()
EnteredPassage.PASSAGE = B.Reference()
EnteredPassage.PREVIOUS_PASSAGE = B.Local()

function EnteredPassage:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local position = Utility.Peep.getPosition(peep)
	local mapResource = Utility.Peep.getMapResource(peep)

	local gameDB = peep:getDirector():getGameDB()
	local passages = gameDB:getRecords("MapObjectRectanglePassage", {
		Map = mapResource
	})

	local passage
	for i = 1, #passages do
		local x1, z1 = passages[i]:get("X1"), passages[i]:get("Z1")
		local x2, z2 = passages[i]:get("X2"), passages[i]:get("Z2")
		if position.x >= x1 and position.x <= x2 and
		   position.z >= z1 and position.z <= z2
		then
			passage = passages[i]
			break
		end
	end

	local currentPassageName
	if passage then
		local mapObject = gameDB:getRecord("MapObjectReference", {
			Map = mapResource,
			Resource = passage:get("Resource")
		})

		if mapObject then
			currentPassageName = mapObject:get("Name")
		end
	end

	currentPassageName = currentPassageName or false
	local previousPassageName = state[self.PREVIOUS_PASSAGE] or false

	state[self.PREVIOUS_PASSAGE] = currentPassageName

	if currentPassageName ~= previousPassageName and currentPassageName ~= false then
		state[self.PASSAGE] = currentPassageName
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return EnteredPassage
