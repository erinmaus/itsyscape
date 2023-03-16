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
	self.blockingInterface = {}
end

function LocalUI:poke(interfaceID, index, actionID, actionIndex, e)
	local interfaces = self.interfaces[interfaceID]
	if interfaces then
		local interface = interfaces.v[index]
		if interface then
			local success, error  = xpcall(interface.poke, debug.traceback, interface, actionID, actionIndex, e)
			if not success then
				Log.warn(
					"Could not run poke '%s' (index = %d) on interface '%s' (index = %d) for peep '%s': %s",
					actionID or "<none>", actionIndex or 0, interfaceID, index, interface:getPeep():getName(), error)
				Log.engine("Argument passed to poke: %s", Log.stringify(e))
			end
		end
	end
end

function LocalUI:sendPoke(interface, actionID, actionIndex, e)
	local i = self.controllers[interface]
	if i then
		self.onPoke(self, i.id, i.index, actionID, actionIndex, e)
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
				currentIndex, current = next(interfaces.v, currentIndex)
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

	self.onPush(self, interfaceID, i.n, controller:pull())
	self.onOpen(self, interfaceID, i.n, controller:getPlayer())

	return interfaceID, i.n, controller
end

function LocalUI:openBlockingInterface(peep, interfaceID, ...)
	if self.blockingInterface[peep] then
		self:interrupt(peep)
	end

	local id, n, controller = self:open(peep, interfaceID, ...)
	self.blockingInterface[peep] = {
		id = id,
		index = n
	}

	return id, n, controller
end

function LocalUI:interrupt(peep)
	local blockingInterface = self.blockingInterface[peep]
	if blockingInterface then
		self:close(blockingInterface.id, blockingInterface.index)
	end
end

function LocalUI:close(interfaceID, index)
	if not self.interfaces[interfaceID] then
		return false
	end

	local controller = self.interfaces[interfaceID].v[index]
	if not controller then
		return false
	end

	if self.blockingInterface[controller:getPeep()] then
		local blockingInterface = self.blockingInterface[controller:getPeep()]
		if blockingInterface.id == interfaceID and
		   blockingInterface.index == index
		then
			self.blockingInterface[controller:getPeep()] = nil
		end
	end

	self.onClose(self, interfaceID, index, controller:getPlayer())

	controller:close()
	self.interfaces[interfaceID].v[index] = nil
	self.controllers[controller] = nil
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
			self.onPush(self, id, n, interface:pull())
		end
	end
end

return LocalUI
