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

function LocalUI:isOpen(interfaceID, index)
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

function LocalUI:getInterfacesForPeep(peep, interfaceID)
	if interfaceID then
		local interfaces = self.interfaces[interfaceID]
		if not interfaces then
			return function() return nil, nil end
		end

		local currentIndex, current

		return function()
			currentIndex, current = next(interfaces.v, currentIndex)
			while currentIndex and interfaces.v[currentIndex]:getPeep() ~= peep do
				currentIndex, current = next(interfaces, currentIndex)
			end

			return currentIndex, current
		end
	else
		local interfaceID, interfaces
		local currentIndex, current
		return function()
			if not interfaceID then
				interfaceID, interfaces = next(self.interfaces, nil)
			end

			while interfaces do
				currentIndex, current = next(interfaces.v, currentIndex)
				while currentIndex and interfaces.v[currentIndex]:getPeep() ~= peep do
					currentIndex, current = next(interfaces.v, currentIndex)
				end

				if not current then
					interfaceID, interfaces = next(self.interfaces, interfaceID)
				else
					return interfaceID, currentIndex, current
				end
			end

			return nil
		end
	end
end

function LocalUI:get(interfaceID, index)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		return interfaces.v[index]
	end

	return nil
end

function LocalUI:open(peep, interfaceID, ...)
	local i = self.interfaces[interfaceID] or { n = 0, v = {} }
	i.n = i.n + 1

	local ControllerTypeName = string.format(
		"ItsyScape.UI.Interfaces.%sController",
		interfaceID)
	local ControllerType = require(ControllerTypeName)
	local controller = ControllerType(
		peep,
		self.game:getDirector(),
		...)
	controller:open()
	i.v[i.n] = controller

	self.interfaces[interfaceID] = i
	self.controllers[controller] = { id = interfaceID, index = i.n }

	self.onOpen(interfaceID, i.n)

	return interfaceID, i.n, controller
end

function LocalUI:openBlockingInterface(peep, interfaceID, ...)
	if self.blockingInterface then
		self:interrupt()
	end

	local id, n, controller = self:open(peep, interfaceID, ...)
	self.blockingInterface = {
		id = id,
		index = n
	}

	return id, n, controller
end

function LocalUI:interrupt()
	if self.blockingInterface then
		self:close(self.blockingInterface.id, self.blockingInterface.index)
	end

	self.blockingInterface = nil
end

function LocalUI:close(interfaceID, index)
	if not self.interfaces[interfaceID] then
		return false
	end

	local controller = self.interfaces[interfaceID].v[index]
	if not controller then
		return false
	end

	if self.blockingInterface then
		if self.blockingInterface.id == interfaceID and
		   self.blockingInterface.index == index
		then
			self.blockingInterface = false
		end
	end

	controller:close()
	self.interfaces[interfaceID].v[index] = nil
	self.controllers[controller] = nil

	self.onClose(interfaceID, index)
end

function LocalUI:closeInstance(instance)
	local c = self.controllers[instance]
	if c then
		self:close(c.id, c.index)
	end
end

function LocalUI:update(delta)
	for id, interfaces in pairs(self.interfaces) do
		for n, interface in pairs(interfaces.v) do
			interface:update(delta)
		end
	end
end

return LocalUI
