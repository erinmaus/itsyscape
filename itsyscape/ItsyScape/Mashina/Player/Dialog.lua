--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/Dialog.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local Dialog = B.Node("Dialog")
Dialog.PEEP = B.Reference()
Dialog.PLAYER = B.Reference()
Dialog.NAMED_ACTION = B.Reference()
Dialog.MAIN = B.Reference()
Dialog.OPENED = B.Local()

function Dialog:update(mashina, state, executor)
	local game = mashina:getDirector():getGameInstance()
	local gameDB = mashina:getDirector():getGameDB()

	local player = state[self.PLAYER]
	if not player then
		return B.Status.Failure
	end

	local name = state[self.NAMED_ACTION]
	local opened = state[self.OPENED]

	local peep = state[self.PEEP] or mashina

	if not opened then
		local function _try(resource)
			if name then
				local namedAction = gameDB:getRecord("NamedPeepAction", {
					Name = name,
					Peep = resource
				})

				if not namedAction then
					return false
				end

				local action = Utility.getAction(game, namedAction:get("Action"), false, false)
				if not action then
					Log.warn("Couldn't get named peep action '%s' for peep '%s'!", name, peep:getName())
					return false
				end

				Utility.UI.openInterface(player, "DialogBox", true, action.instance, peep)
				return true
			else
				local actions = Utility.getActions(game, resource, "world")

				for _, action in ipairs(actions) do
					if action.instance:is("talk") or action.instance:is("yell") then
						Utility.UI.openInterface(player, "DialogBox", true, action.instance, peep, state[self.MAIN])
						return true
					end
				end

				return false
			end
		end

		local resource = Utility.Peep.getMapResource(peep)
		local mapObject = Utility.Peep.getMapObject(peep)

		if (mapObject and _try(mapObject)) or (resource and _try(resource)) then
			Utility.Peep.face(peep, player)
			Utility.Peep.face(player, peep)

			state[self.OPENED] = true

			return B.Status.Working
		end

		return B.Status.Failure
	end

	if opened then
		if Utility.UI.isOpen(player, "DialogBox") then
			return B.Status.Working
		else
			state[self.OPENED] = nil
			return B.Status.Success
		end
	end
end

return Dialog
