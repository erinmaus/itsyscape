--------------------------------------------------------------------------------
-- Resources/Game/Peeps/PreTutorial/V2Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"

local Common = {}

function Common.listenForAction(playerPeep, action, target, firstMessage, otherMessage)
	local numTimesChopped = 0

	local SPAM_MESSAGE_THRESHOLD = 3

	local notifiedPlayer = false

	local function _performAction(_, e)
		if e.action:is(action) then
			if numTimesChopped == 0 then
				Utility.Peep.notify(playerPeep, firstMessage)
			end

			local target = playerPeep:getBehavior(CombatTargetBehavior)
			target = target and target.actor

			if previousTarget ~= target then
				previousTarget = target
				numTimesChopped = 1
			else
				numTimesChopped = numTimesChopped + 1
			end

			if numTimesChopped > SPAM_MESSAGE_THRESHOLD then
				numTimesChopped = 1

				Utility.Peep.notify(playerPeep, otherMessage, notifiedPlayer)
				notifiedPlayer = true
			end
		end

		if target then
			Utility.Peep.poof(target)
		end
	end

	local function _move()
		playerPeep:silence("actionPerformed", _performAction)
		playerPeep:silence("move", _move)
	end

	playerPeep:listen("actionPerformed", _performAction)
	playerPeep:listen("move", _move)
end

function Common.makeRosalindTalk(playerPeep, name)
	local director = playerPeep:getDirector()
	local game = director:getGame()
	local gameDB = director:getGameDB()

	local rosalind = director:probe(
		playerPeep:getLayerName(),
		Probe.resource("Peep", "IsabelleIsland_Rosalind"))[1]

	if not rosalind then
		return
	end

	local mapObjectResource = Utility.Peep.getMapObject(rosalind)
	if not mapObjectResource then
		return
	end

	local namedAction = gameDB:getRecord("NamedPeepAction", {
		Name = name,
		Peep = mapObjectResource
	})

	if not namedAction then
		return
	end

	local action = Utility.getAction(game, namedAction:get("Action"), false, false)
	if not action then
		return
	end

	Utility.UI.openInterface(player, "DialogBox", true, action.instance, mashina)
end

return Common
