--------------------------------------------------------------------------------
-- ItsyScape/Game/Probe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Ray = require "ItsyScape.Common.Math.Ray"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.World.Map"

local Probe = Class()
Probe.TESTS = {
	['walk'] = true,
	['loot'] = true,
	['actors'] = true,
	['props'] = true
}

function Probe:new(game, gameView, gameDB, ray, tests)
	self.onExamine = Callback()

	self.game = game
	self.gameView = gameView
	self.gameDB = gameDB
	self.ray = ray

	self.actions = {}
	self.isDirty = false

	self.probes = {}
	self.tests = tests

	self.tile = false
	self.layer = false
end

-- Returns an iterator over the actions.
--
-- The iterator returns a single table per step in the form:
--  * id: id of the action. For example, "Teleport-X" and "Teleport-Y" would
--        both be "Teleport".
--  * verb: the verb for the action. For a Teleport action, this would be
--          "Teleport-[Location]", for example.
--  * object: the object that action is being performed on. This can be false
--            if there is no object.
--  * callback: a function to perform the action.
--  * depth: the priority of the action. Lower value, higher priority in the
--           list.
--
--  For example:
--  {
--    id = "Teleport",
--    verb = "Teleport-Anywhere",
--    object = "Amulet of yendor",
--    callback = function() ... end,
--    depth = 0
--  }
function Probe:iterate()
	if self.isDirty then
		table.sort(self.actions, function(a, b) return a.depth < b.depth end)
		self.isDirty = false
	end

	local index = 1
	return function()
		local current = self.actions[index]
		if index <= #self.actions then
			index = index + 1
		end

		return current
	end
end

-- Collects actions from Probe.iterate into an array and returns it.
function Probe:toArray()
	local result = {}
	for action in self:iterate() do
		table.insert(result, action)
	end

	return result
end

-- Returns the number of actions in the probe.
function Probe:getCount()
	return #self.actions
end

-- Probes all actions that can be performed.
function Probe:all(callback)
	local layer
	do
		local i, j, k = self.game:getPlayer():getActor():getTile()
		layer = k
	end

	local ray = self.ray
	do
		local node = self.gameView:getMapSceneNode(layer)
		if node then
			local transform = node:getTransform():getGlobalDeltaTransform(0)
			local origin1 = Vector(transform:inverseTransformPoint(self.ray.origin:get()))
			local origin2 = Vector(transform:inverseTransformPoint((self.ray.origin + self.ray.direction):get()))
			local direction = origin2 - origin1

			ray = Ray(origin1, direction)
		end
	end

	local tests = self.tests or Probe.TESTS

	if tests['loot'] or tests['walk'] then
		self.game:getStage():testMap(layer, ray, function(result)
			self:getTile(result, layer)
			self:walk()
			self:loot()
			self:actors()
			self:props()

			if callback then
				callback()
			end
		end)
	else
		for test in pairs(tests) do
			if Probe.TESTS[test] then
				self[test](self)
			end
		end

		if callback then
			callback()
		end
	end
end

-- Returns the tile this probe hit as a tuple in the form (i, j, layer).
--
-- If no tile was hit, returns (nil, nil, nil).
function Probe:getTile(tiles, layer)
	if tiles then
		local function sortFunc(a, b)
			local i = a[Map.RAY_TEST_RESULT_POSITION]
			local j = b[Map.RAY_TEST_RESULT_POSITION]
			local s = Vector(love.graphics.project(i.x, i.y, i.z))
			local t = Vector(love.graphics.project(j.x, j.y, j.z))

			return s.z < t.z
		end

		table.sort(tiles, sortFunc)
		self.tile = tiles[1]
		self.layer = layer or 1
	end

	-- Gotta check again. No tile may have been found.
	if not self.tile then
		return nil, nil, nil
	end

	return self.tile[Map.RAY_TEST_RESULT_I],
	       self.tile[Map.RAY_TEST_RESULT_J],
	       self.layer,
	       self.tile[Map.RAY_TEST_RESULT_POSITION]
end

-- Adds a 'Walk here' action, if possible.
function Probe:walk()
	if self.probes['walk'] then
		return self.probes['walk']
	end

	local i, j, k, position = self:getTile()
	if i and j and k then
		local action = {
			id = "Walk",
			verb = "Walk",
			object = "here", -- lol
			description = "Walk to this location.",
			callback = function()
				self.game:getPlayer():walk(i, j, k)
			end,
			depth = position.z
		}

		table.insert(self.actions, action)

		self.probes['walk'] = 1
		self.isDirty = true
	end

	return self.probes['walk'] or 0
end

-- Adds all 'Take' actions, if possible.
function Probe:loot()
	if self.probes['loot'] then
		return self.probes['loot']
	end

	local i, j, k, position = self:getTile()
	if i and j and k and position then
		local items = self.game:getStage():getItemsAtTile(i, j, k)

		for _, item in pairs(items) do
			local name
			do
				-- TODO: [LANG]
				name = Utility.Item.getName(item.id, self.gameDB, "en-US")
				if not name then
					name = "*" .. item.id
				end
			end

			local object
			if item.count > 1 then
				if item.noted then
					object = string.format(
						"%s (%s, noted)",
						name,
						Utility.Item.getItemCountShorthand(item.count))
				else
					object = string.format(
						"%s (%s)",
						name,
						Utility.Item.getItemCountShorthand(item.count))
				end
			else
				object = name
			end

			local action = {
				id = "Take",
				verb = "Take",
				object = object,
				description = "Pick up item from the ground.",
				callback = function()
					self.game:getStage():takeItem(i, j, k, item.ref)
				end,
				depth = position.z - (i / #items) -- This ensures items remain stable.
			}

			table.insert(self.actions, action)
			self.isDirty = true
		end

		self.probes['loot'] = #items
	end

	return self.probes['loot'] or 0
end

-- Adds all actor actions, if possible.
function Probe:actors()
	if self.probes['actors'] then
		return self.probes['actors']
	end

	local count = 0
	for actor in self.game:getStage():iterateActors() do
		local min, max = actor:getBounds()
		do
			local _, _, layer = actor:getTile()
			local node = self.gameView:getMapSceneNode(layer)
			if node then
				local transform = node:getTransform():getGlobalDeltaTransform(0)
				min, max = Vector.transformBounds(min, max, transform)
			end
		end

		local s, p = self.ray:hitBounds(min, max)
		if s then
			local actions = actor:getActions('world')
			for i = 1, #actions do
				local action = {
					id = actions[i].id,
					verb = actions[i].verb,
					object = actor:getName(),
					description = actor:getDescription(),
					callback = function()
						actor:poke(actions[i].id, 'world')
					end,
					depth = -p.z + ((i / #actions) / 100)
				}

				table.insert(self.actions, action)
				self.isDirty = true
				count = count + 1
			end

			table.insert(self.actions, {
				id = "Examine",
				type = 'examine',
				verb = "Examine",
				object = actor:getName(),
				callback = function()
					self.onExamine(actor:getName(), actor:getDescription())
				end,
				depth = -p.z + (((#actions + 1) / #actions) / 100)
			})
		end
	end

	self.probes['actors'] = count
	return count
end

-- Adds all prop actions, if possible.
function Probe:props()
	if self.probes['props'] then
		return self.probes['props']
	end

	local count = 0
	for prop in self.game:getStage():iterateProps() do
		local min, max = prop:getBounds()
		do
			local _, layer = prop:getPosition()
			local node = self.gameView:getMapSceneNode(layer)
			if node then
				local transform = node:getTransform():getGlobalDeltaTransform(0)
				min, max = Vector.transformBounds(min, max, transform)
			end
		end

		local s, p = self.ray:hitBounds(min, max)
		if s then
			local actions = prop:getActions('world')
			for i = 1, #actions do
				local action = {
					id = actions[i].id,
					verb = actions[i].verb,
					object = prop:getName(),
					description = prop:getDescription(),
					callback = function()
						prop:poke(actions[i].id, 'world')
					end,
					depth = -p.z + ((i / #actions) / 100)
				}

				table.insert(self.actions, action)
				self.isDirty = true
				count = count + 1
			end

			table.insert(self.actions, {
				id = "Examine",
				type = 'examine',
				verb = "Examine",
				object = prop:getName(),
				callback = function()
					self.onExamine(prop:getName(), prop:getDescription())
				end,
				depth = -p.z + (((#actions + 1) / #actions) / 100)
			})
		end
	end

	self.probes['props'] = count
	return count
end

return Probe
