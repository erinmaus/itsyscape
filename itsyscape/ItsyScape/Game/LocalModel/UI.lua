--------------------------------------------------------------------------------
-- ItsyScape/Game/Model/UI.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local UI = require "ItsyScape.Game.Model.UI"

local LocalUI = Class(UI)

function LocalUI:new(game)
	UI.new(self)

	self.game = game
	self.interfaces = {}
	self.controllers = {}
end

function LocalUI:poke(interfaceID, index, actionID, actionIndex, e)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces.v[index]
		if interface then
			interface:poke(actionID, actionIndex, e)
		end
	end
end

function LocalUI:sendPoke(interface, actionID, actionIndex, e)
	local i = self.controllers[interface]
	if i then
		self.onPoke(i.id, i.index, actionID, actionIndex, e)
	end
end

function LocalUI:pull(interfaceID, index, actionID, actionIndex, e)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces.v[index]
		if interface then
			return interface:pull()
		end
	end

	return {}
end

function LocalUI:isOpen(interface, index)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		if index == nil then
			local n = next(interfaces.v, nil)
			return n ~= nil
		else
			local interface = interfaces.v[index]
			if interface then
				return true
			end
		end
	end

	return false
end

function LocalUI:getGame()
	return self.game
end

function LocalUI:open(interfaceID)
	local i = self.interfaces[interfaceID] or { n = 0, v = {} }
	i.n = i.n + 1

	local ControllerTypeName = string.format(
		"ItsyScape.UI.Interfaces.%sController",
		interfaceID)
	local ControllerType = require(ControllerTypeName)
	local controller = ControllerType(
		self.game:getPlayer():getActor():getPeep(),
		self.game:getDirector())
	controller:open()
	i.v[i.n] = controller

	self.interfaces[interfaceID] = i
	self.controllers[controller] = { id = interfaceID, index = i.n }

	self.onOpen(interfaceID, i.n)
end

function LocalUI:close(interfaceID, index)
	if not self.interfaces[interfaceID] then
		return false
	end

	local controller = self.interfaces[interfaceID][index]
	if not controller then
		return false
	end

	controller:close()
	self.interfaces[interfaceID][index] = nil
	self.controllers[controller] = nil

	self.onClose(interfaceID, index)
end

function LocalUI:update(delta)
	for _, interfaces in pairs(self.interfaces) do
		for _, interface in pairs(interfaces.v) do
			interface:update(delta)
		end
	end
end

return LocalUI
