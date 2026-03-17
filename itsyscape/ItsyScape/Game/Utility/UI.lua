--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/UI.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Instance = require "ItsyScape.Game.LocalModel.Instance"

local UI = {}
UI.Groups = {
	WORLD = {
		"Ribbon",
		"Chat",
		"GamepadRibbon",
		"GamepadCombatHUD",
		"QuestProgressNotification"
	}
}

function UI.openGroup(peep, group)
	if type(group) == "string" then
		if not UI.Groups[group] then
			Log.error("Built-in UI group '%s' not found; cannot open for peep '%s'.", group, peep:getName())
			return
		end

		group = UI.Groups[group]
	end

	for i = 1, #group do
		local interfaceID = group[i]

		if not UI.isOpen(peep, interfaceID) then
			UI.openInterface(peep, interfaceID, false)
		end
	end
end

function UI.closeAll(peep, id, exceptions)
	local e = { ["ConfigWindow"] = true }
	if exceptions then
		for _, exception in ipairs(exceptions) do
			e[exception] = true
		end
	end

	local ui = peep:getDirector():getGameInstance():getUI()

	local interfaces = {}
	for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep) do
		if not id or id == interfaceID then
			table.insert(interfaces, { id = interfaceID, index = interfaceIndex })
		end
	end

	for i = 1, #interfaces do
		if not e[interfaces[i].id] then
			ui:close(interfaces[i].id, interfaces[i].index)
		end
	end
end

function UI.broadcast(ui, peep, interfaceID, ...)
	if interfaceID then
		for interfaceIndex in ui:getInterfacesForPeep(peep, interfaceID) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	else
		for interfaceID, interfaceIndex in ui:getInterfacesForPeep(peep) do
			ui:poke(interfaceID, interfaceIndex, ...)
		end
	end
end

function UI.openInterface(peep, interfaceID, blocking, ...)
	if Class.isCompatibleType(peep, Instance) then
		local results = {}
		for _, player in peep:iteratePlayers() do
			local playerPeep = player:getActor() and player:getActor():getPeep()
			if playerPeep then
				table.insert(results, {
					UI.openInterface(playerPeep, interfaceID, blocking, ...)
				})
			end
		end
		return results
	else
		local ui = peep:getDirector():getGameInstance():getUI()
		if blocking then
			local _, n, controller = ui:openBlockingInterface(peep, interfaceID, ...)
			return n ~= nil, n, controller
		else
			local _, n, controller = ui:open(peep, interfaceID, ...)
			return n ~= nil, n, controller
		end
	end
end

function UI.isOpen(peep, interfaceID, interfaceIndex)
	local ui = peep:getDirector():getGameInstance():getUI()

	for index in ui:getInterfacesForPeep(peep, interfaceID) do
		if index == interfaceIndex or not interfaceIndex then
			return true, index
		end
	end

	return false
end

function UI.getOpenInterface(peep, interfaceID, interfaceIndex)
	if not interfaceIndex then
		local isOpen, i = UI.isOpen(peep, interfaceID)
		if not isOpen then
			return nil
		end

		interfaceIndex = i
	end

	local ui = peep:getDirector():getGameInstance():getUI()
	return ui:get(interfaceID, interfaceIndex)
end

function UI.tutorial(target, tips, done, state)
	state = state or {}

	local index = 0
	local function after()
		index = index + 1
		if index <= #tips then
			if Class.isCallable(tips[index].init) then
				tips[index].init(target, index)
			end

			local id = tips[index].id
			if Class.isCallable(id) then
				id = id(target, state)
			end

			local message = tips[index].message
			if Class.isCallable(message) then
				message = message(target, state)
			end

			local position = tips[index].position
			if Class.isCallable(position) then
				position = position(target, state)
			end

			local style = tips[index].style
			if Class.isCallable(style) then
				style = style(target, state)
			end

			UI.openInterface(
				target,
				"TutorialHint",
				false,
				id,
				message,
				tips[index].open(target, state),
				{ position = position, style = style },
				after)
		else
			if done then
				done()
			end
		end
	end

	after()
end

function UI.notifyFailure(peep, message)
	local director = peep:getDirector()
	if not director then
		return
	end

	local gameDB = director:getGameDB()
	if type(message) == "string" then
		local resource = gameDB:getResource(message, "KeyItem")
		if resource then
			message = resource
		end
	end

	local requirement
	if type(message) == "string" then
		requirement = {
			type = "KeyItem",
			resource = "_MESSAGE",
			name = "Message",
			description = message,
			count = 1
		}
	else
		local name = Utility.getName(message, gameDB) or ("*" .. message.name)
		local description = Utility.getDescription(message, gameDB, nil, 1)

		requirement = {
			type = "KeyItem",
			resource = message.name,
			name = name,
			description = description,
			count = 1
		}
	end

	local constraints = {
		requirements = { requirement },
		inputs = {},
		outputs = {}
	}

	UI.openInterface(peep, "Notification", false, constraints)
end

return UI
