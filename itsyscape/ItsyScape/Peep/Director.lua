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
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Peep = require "ItsyScape.Peep.Peep"

local CortexDebugStats = Class(DebugStats)
function CortexDebugStats:process(cortex, ...)
	cortex:update(...)
end

local PeepDebugStats = Class(DebugStats)
function PeepDebugStats:process(peep, ...)
	peep:update(...)
end

-- Director type.
--
-- A director is a collection of Peeps and Cortexes. Whenever a Peep is added or
-- modified, the Director informs the Cortexes so they can properly filter the
-- Peep.
local Director = Class()

Director.READY_TIME_MS = 100

function Director:new(gameDB)
	self.gameDB = gameDB
	self.peeps = {}
	self.keys = {}
	self.cortexes = {}
	self.pendingPeeps = {}
	self.newPeeps = {}
	self.oldPeeps = {}
	self._previewPeep = function(peep, behavior)
		self.pendingPeeps[peep] = true
	end
	self.pendingReady = {}

	self.maps = {}
	self.peepsByLayer = {}

	self.cortexDebugStats = CortexDebugStats()
	self.peepDebugStats = PeepDebugStats()
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

function Director:getCortex(cortexType)
	for _, cortex in ipairs(self.cortexes) do
		if cortex:isCompatibleType(cortexType) then
			return cortex
		end
	end
end

-- Moves a Peep.
function Director:movePeep(peep, newKey)
	local currentKey = self.keys[peep]
	local oldLayer = self.peepsByLayer[currentKey]

	if oldLayer then
		for i, p in ipairs(oldLayer) do
			if peep == p then
				table.remove(oldLayer, i)
				break
			end
		end
	end

	self.keys[peep] = newKey
	local newLayer = self.peepsByLayer[newKey]
	if not newLayer then
		newLayer = {}
		self.peepsByLayer[newKey] = newLayer
	end

	table.insert(newLayer, peep)

	for _, cortex in ipairs(self.cortexes) do
		cortex:previewPeep(peep)
	end

	peep:move(self, newKey)
end


-- Adds a Peep of the provided type to the Director.
--
-- If no type is provided, just adds a plain 'ol Peep.
function Director:addPeep(key, peepType, ...)
	peepType = peepType or Peep

	local peep = peepType(...)
	peep.onBehaviorAdded:register(self._previewPeep)
	peep.onBehaviorRemoved:register(self._previewPeep)

	table.insert(self.newPeeps, { peep = peep, key = key })
	self.pendingPeeps[peep] = true

	return peep
end

function Director:assignPeep(peep, key)
	peep:assign(self, key)
end

-- Removes a Peep instance from the Director.
--
-- Returns true if the Peep was removed, false otherwise. If the Peep does not
-- belong to the Director, for example, it cannot be removed.
function Director:removePeep(peep)
	if self.keys[peep] then
		peep.onBehaviorAdded:unregister(self._previewPeep)
		peep.onBehaviorRemoved:unregister(self._previewPeep)

		peep:poke('reaper')

		self.oldPeeps[peep] = true
		self.pendingPeeps[peep] = nil
	end
end

function Director:removeLayer(key)
	local layer = self.peepsByLayer[key]
	if layer then
		for _, peep in ipairs(layer) do
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

	local before = love.timer.getTime()
	for _, peep in ipairs(peeps) do
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
	local after = love.timer.getTime()

	-- Log.info(
	-- 	"Took %.02f ms to probe %d peeps on layer %s with %d filters.",
	-- 	(after - before) * 1000,
	-- 	#peeps,
	-- 	select(1, ...),
	-- 	args.n)

	return result
end

function Director:broadcast(t, event, ...)
	if type(t) == 'string' then
		t = self.peepsByLayer[t] or {}
	else
		t = t or self.peeps
	end

	for _, peep in ipairs(t) do
		peep:poke(event, ...)
	end
end

-- Updates the Director.
--
-- First updates Peeps.
--
-- Then each Cortex, in the order they were added, is updated.
function Director:update(delta)
	for peep in pairs(self.oldPeeps) do
		for _, cortex in ipairs(self.cortexes) do
			cortex:removePeep(peep)
		end
	end

	for _, p in ipairs(self.newPeeps) do
		local peep = p.peep
		local key = p.key

		table.insert(self.peeps, peep)
		self.keys[peep] = key
		self.pendingReady[peep] = true
	end
	table.clear(self.newPeeps)

	local beforeCortexPreview = love.timer.getTime()
	for peep in pairs(self.pendingPeeps) do
		if not self.pendingReady[peep] then
			for _, cortex in ipairs(self.cortexes) do
				cortex:previewPeep(peep)
			end

			self.pendingPeeps[peep] = nil
		end
	end
	local afterCortexPreview = love.timer.getTime()

	local totalReadyTime = 0
	for _, peep in ipairs(self.peeps) do
		if self.pendingReady[peep] then
			if totalReadyTime < self.READY_TIME_MS then
				local beforeTime = love.timer.getTime()
				do
					local key = self.keys[peep]

					self:assignPeep(peep, key)

					local layer = self.peepsByLayer[key]
					if not layer then
						layer = {}
						self.peepsByLayer[key] = layer
					end

					peep:preUpdate(self, self:getGameInstance())

					table.insert(layer, peep)
				end
				local afterTime = love.timer.getTime()

				totalReadyTime = totalReadyTime + (afterTime - beforeTime) * 1000
				self.pendingReady[peep] = nil
			end
		elseif not self.oldPeeps[peep] then
			peep:preUpdate(self, self:getGameInstance())
		end
	end

	local beforeCortexUpdate = love.timer.getTime()
	for _, cortex in pairs(self.cortexes) do
		self.cortexDebugStats:measure(cortex, delta)
	end
	local afterCortexUpdate = love.timer.getTime()

	local beforePeepUpdate = love.timer.getTime()
	for _, peep in ipairs(self.peeps) do
		if not self.pendingReady[peep] and not self.oldPeeps[peep] then
			self.peepDebugStats:measure(peep, self, self:getGameInstance())
		end
	end
	local afterPeepUpdate = love.timer.getTime()

	for peep in pairs(self.oldPeeps) do
		for _, cortex in ipairs(self.cortexes) do
			cortex:removePeep(peep)
		end

		local key = self.keys[peep]
		local layer = self.peepsByLayer[key]
		if layer then
			for i, p in ipairs(layer) do
				if peep == p then
					table.remove(layer, i)
					break
				end
			end

			if #layer == 0 then
				self.peepsByLayer[key] = nil
			end
		end

		self.keys[peep] = nil

		peep:poof()
	end

	for i = #self.peeps, 1, -1 do
		if self.oldPeeps[self.peeps[i]] then
			table.remove(self.peeps, i)
		end
	end

	table.clear(self.oldPeeps)
end

function Director:quit()
	if _DEBUG then
		self.cortexDebugStats:dumpStatsToCSV("Cortex")
		self.peepDebugStats:dumpStatsToCSV("Peep")
	end
end

return Director
