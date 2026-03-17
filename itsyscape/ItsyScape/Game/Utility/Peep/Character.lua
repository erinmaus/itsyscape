--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Character.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local CharacterBehavior = require "ItsyScape.Peep.Behaviors.CharacterBehavior"
local TeamBehavior = require "ItsyScape.Peep.Behaviors.TeamBehavior"

local Character = {}

local function _tryMakeCharacter(peep, resource)
	if not resource then
		return false
	end

	local gameDB = peep:getDirector():getGameDB()
	local character = gameDB:getRecord("PeepCharacter", {
		Peep = resource
	})

	if character then
		local _, c = peep:addBehavior(CharacterBehavior)
		c.character = character:get("Character")

		return true
	end

	return false
end

function Character:onFinalize()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if not (_tryMakeCharacter(self, mapObject) or _tryMakeCharacter(self, resource)) then
		return
	end

	local character = Utility.Peep.getCharacter(self)
	local teamRecords = character and self:getDirector():getGameDB():getRecords("CharacterTeam", {
		Character = character
	})

	if not teamRecords then
		return
	end

	local _, teams = self:addBehavior(TeamBehavior)
	for _, teamRecord in ipairs(teamRecords) do
		local team = teamRecord:get("Team").name

		local hasTeam = false
		for _, otherTeam in ipairs(teams.teams) do
			if otherTeam == team then
				hasTeam = true
				break
			end
		end

		if not hasTeam then
			Log.info("Peep '%s' (character = '%s') is on team '%s'.", self:getName(), character.name, team)
			table.insert(teams.teams, team)
		end
	end
end

return Character
