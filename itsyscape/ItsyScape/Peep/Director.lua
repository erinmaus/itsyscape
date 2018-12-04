--------------------------------------------------------------------------------
-- ItsyScape/Peep/Director.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Peep = require "ItsyScape.Peep.Peep"

-- Director type.
--
-- A director is a collection of Peeps and Cortexes. Whenever a Peep is added or
-- modified, the Director informs the Cortexes so they can properly filter the
-- Peep.
local Director = Class()

function Director:new(gameDB)
	self.gameDB = gameDB
	self.peeps = {}
	self.cortexes = {}
	self.pendingPeeps = {}
	self.newPeeps = {}
	self.oldPeeps = {}
	self._previewPeep = function(peep, behavior)
		self.pendingPeeps[peep] = true
	end

	self.maps = {}
	self.peepsByLayer = {}

	self.pendingAssignment = {}
end

-- Gets the GameDB.
function Director:getGameDB()
	return self.gameDB
end

-- Sets the map for the specified layer.
function Director:setMap(layer, map)
	self.maps[layer] = map
end

-- Gets the map for the specified layer.
function Director:getMap(layer)
	return self.maps[layer]
end

-- Gets the game instance (i.e., ItsyScape.Game.Model.Game).
--
-- If not implemented, returns nil.
function Director:getGameInstance()
	return nil
end

-- Adds a Cortex of the provided type to the Director.
function Director:addCortex(cortexType, ...)
	local cortex = cortexType(...)
	cortex:attach(self)

	table.insert(self.cortexes, cortex)
	return cortex
end

-- Removes a Cortex instance from the Director.
--
-- Returns true if the Cortex was removed, false otherwise. If the Cortex does
-- not belong to the Director, for example, it cannot be removed.
function Director:removeCortex(cortex)
	for index, c in ipairs(self.cortexes) do
		if c == cortex then
			cortex:detach()
			table.remove(self.cortexes, index)

			return true
		end
	end

	return false
end

-- Moves a Peep.
function Director:movePeep(peep, key)
	local p = self.peeps[peep]
	if p then
		self.peepsByLayer[p.key][peep] = nil
		p.key = key
	end

	if key then
		local layer = self.peepsByLayer[key]
		if not layer then
			layer = {}
			self.peepsByLayer[key] = layer
		end

		layer[peep] = true
	end

	peep:move(self, key)
end


-- Adds a Peep of the provided type to the Director.
--
-- If no type is provided, just adds a plain 'ol Peep.
function Director:addPeep(key, peepType, ...)
	peepType = peepType or Peep

	local peep = peepType(...)
	peep.onBehaviorAdded:register(self._previewPeep)
	peep.onBehaviorRemoved:register(self._previewPeep)

	self.newPeeps[peep] = { key = key }
	self.pendingPeeps[peep] = true

	local layer = self.peepsByLayer[key]
	if not layer then
		layer = {}
		self.peepsByLayer[key] = layer
	end

	layer[peep] = true

	self.pendingAssignment[peep] = key

	return peep
end

function Director:assignPeep(peep)
	if not self.pendingAssignment[peep] then
		Log.error("Peep not pending assignment.")
	end

	peep:assign(self, self.pendingAssignment[peep])
	self.pendingAssignment[peep] = nil
end

-- Removes a Peep instance from the Director.
--
-- Returns true if the Peep was removed, false otherwise. If the Peep does not
-- belong to the Director, for example, it cannot be removed.
function Director:removePeep(peep)
	if self.peeps[peep] then
		peep.onBehaviorAdded:unregister(self._previewPeep)
		peep.onBehaviorRemoved:unregister(self._previewPeep)

		self.oldPeeps[peep] = true
	end
end

function Director:removeLayer(key)
	local layer = self.peepsByLayer[key]
	if layer then
		for peep in pairs(layer) do
			self:removePeep(peep)
		end
	end
end

function Director:probe(...)
	local peeps
	do
		local key = select(1, ...)
		if type(key) == 'string' then
			peeps = self.peepsByLayer[key] or {}
		else
			peeps = self.peeps
		end
	end


	local args = { n = select('#', ...), ... }

	local result = {}
	for peep in pairs(peeps) do
		local match = true
		for i = 1, args.n do
			local func = args[i]
			if func and type(func) ~= 'string' and not func(peep) then
				match = false
				break
			end
		end

		if match then
			table.insert(result, peep)
		end
	end

	return result
end

function Director:broadcast(t, event, ...)
	if type(t) == 'string' then
		t = self.peepsByLayer[t] or {}
	else
		t = t or self.peeps
	end

	for i = 1, #t do
		t[i]:poke(event, ...)
	end
end

-- Updates the Director.
--
-- First updates Peeps.
--
-- Then each Cortex, in the order they were added, is updated.
function Director:update(delta)
	for peep, info in pairs(self.newPeeps) do
		self:assignPeep(peep)

		self.peeps[peep] = info
	end
	self.newPeeps = {}

	for peep in pairs(self.oldPeeps) do
		for _, cortex in ipairs(self.cortexes) do
			cortex:removePeep(peep)
		end

		local key = self.peeps[peep].key
		local layer = self.peepsByLayer[key]
		if layer then
			layer[peep] = nil

			if not next(layer)  then
				self.peepsByLayer[key] = nil
			end
		end

		peep:poof()

		self.peeps[peep] = nil
	end
	self.oldPeeps = {}

	for peep in pairs(self.peeps) do
		peep:update(self, self:getGameInstance())
	end

	for _, cortex in ipairs(self.cortexes) do
		for peep in pairs(self.pendingPeeps) do
			cortex:previewPeep(peep)
		end
	end
	self.pendingPeeps = {}

	for _, cortex in pairs(self.cortexes) do
		cortex:update(delta)
	end
end

return Director
