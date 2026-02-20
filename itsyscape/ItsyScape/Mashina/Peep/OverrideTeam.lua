--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/OverrideTeam.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local Probe = require "ItsyScape.Peep.Probe"
local TeamBehavior = require "ItsyScape.Peep.Behaviors.TeamBehavior"
local TeamsBehavior = require "ItsyScape.Peep.Behaviors.TeamsBehavior"

local OverrideTeam = B.Node("OverrideTeam")
OverrideTeam.PEEP = B.Reference()
OverrideTeam.CHARACTER = B.Reference()
OverrideTeam.IS_NEUTRAL = B.Reference()
OverrideTeam.IS_ALLY = B.Reference()
OverrideTeam.IS_ENEMY = B.Reference()

function OverrideTeam:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local character = state[self.CHARACTER]

	local characterResource
	if Class.isCompatibleType(character, Peep) then
		characterResource = Utility.Peep.getCharacter(character)
	else
		local gameDB = peep:getDirector():getGameDB()
		characterResource = gameDB:getResource(character, "Character")
	end

	if not characterResource then
		return B.Status.Failure
	end

	local _, team = peep:addBehavior(TeamBehavior)

	if state[self.IS_ALLY] then
		team.override[characterResource.name] = TeamsBehavior.ALLY
	elseif state[self.IS_ENEMY] then
		team.override[characterResource.name] = TeamsBehavior.ENEMY
		print(">>> characterResource", characterResource.name, "is now enemy")
	elseif state[self.IS_NEUTRAL] then
		team.override[characterResource.name] = TeamsBehavior.NEUTRAL
	else
		team.override[characterResource.name] = nil
	end

	return B.Status.Success
end

return OverrideTeam
