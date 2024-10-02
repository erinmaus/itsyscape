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
local Function = require "ItsyScape.Common.Function"
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

Probe.PROP_FILTERS = {
	['open'] = function(prop)
		return prop:getState().open
	end,

	['close'] = function()
		return true
	end,

	['light_prop'] = function(prop)
		return prop:getState().lit
	end,

	['snuff'] = function(prop)
		return not prop:getState().lit
	end
}

function Probe:new(game, gameView, gameDB)
	self.onExamine = Callback()

	self.game = game
	self.gameView = gameView
	self.gameDB = gameDB

	self.pendingActions = {}
	self.pendingActionsCount = 0
	self.actions = {}

	self.probes = {}

	self.tile = false
	self.layer = false

	self._sort = function(...)
		return self:sort(...)
	end
end

function Probe:sort(a, b)
	return a.depth < b.depth
end

function Probe:init(ray, tests, radius, layer)
	self.pendingActionsCount = 0

	self.ray = ray:keep()
	self.radius = radius or 0

	table.clear(self.actions)
	self.isDirty = false

	table.clear(self.probes)
	self.tests = tests

	self.tile = false
	self.layer = layer or false
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
		for i = 1, self.pendingActionsCount do
			table.insert(self.actions, self.pendingActions[i])
		end

		table.sort(self.actions, self._sort)

		self.isDirty = false
	end

	return ipairs(self.actions)
end

-- Collects actions from Probe.iterate into an array and returns it.
function Probe:toArray()
	self:iterate()
	return self.actions
end

-- Returns the number of actions in the probe.
function Probe:getCount()
	return self.pendingActionsCount
end

function Probe:addAction(id, verb, type, object, description, depth, callback, ...)
	self.pendingActionsCount = self.pendingActionsCount + 1
	local pendingAction = self.pendingActions[self.pendingActionsCount] or { n = self.pendingActionsCount, callback = Function() }

	pendingAction.id = id
	pendingAction.verb = verb
	pendingAction.type = type
	pendingAction.object = object
	pendingAction.description = description
	pendingAction.callback:rebind(callback, ...)
	pendingAction.depth = depth
	pendingAction.suppress = false

	self.pendingActions[self.pendingActionsCount] = pendingAction
	return pendingAction
end

function Probe:_all(callback, results)
	local tests = self.tests or Probe.TESTS

	self:getTile(results)
	for test in pairs(tests) do
		if Probe.TESTS[test] then
			self[test](self)
		end
	end

	if callback then
		callback()
	end
end

-- Probes all actions that can be performed.
function Probe:all(callback)
	self.gameView:testMap(nil, self.ray, Function(self._all, self, callback))
end

-- Returns the tile this probe hit as a tuple in the form (i, j, layer).
--
-- If no tile was hit, returns (nil, nil, nil).
function Probe:getTile(tiles)
	if tiles then
		local function sortFunc(a, b)
			local i = a[Map.RAY_TEST_RESULT_POSITION]
			local j = b[Map.RAY_TEST_RESULT_POSITION]

			local camera = self.gameView:getCamera()
			local s = camera:project(Vector(i.x, i.y, i.z))
			local t = camera:project(Vector(j.x, j.y, j.z))

			return s.z < t.z
		end
		table.sort(tiles, sortFunc)

		if self.layer then
			for i = 1, #tiles do
				if tiles[i].layer == layer then
					self.tile = tiles[i]
					self.layer = layer
					break
				end
			end
		else
			self.tile = tiles[1]
			if self.tile then
				self.layer = self.tile.layer or 1
			else
				self.layer = nil
			end
		end
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

function Probe:_walk(i, j, k)
	self.game:getPlayer():walk(i, j, k)
end

-- Adds a 'Walk here' action, if possible.
function Probe:walk()
	if self.probes['walk'] then
		return self.probes['walk']
	end

	local i, j, k, position = self:getTile()
	if i and j and k then
		self:addAction(
			"Walk",
			"Walk",
			"walk",
			"here", -- lol
			"Walk to this location.",
			position.z,
			self._walk, self, i, j, k)

		self.probes['walk'] = 1
		self.isDirty = true
	end

	return self.probes['walk'] or 0
end

function Probe:_take(i, j, k, item)
	self.game:getPlayer():takeItem(i, j, k, item.ref)
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
			item = item.item

			local name, description
			do
				-- TODO: [LANG]
				name = Utility.Item.getName(item.id, self.gameDB, "en-US")
				if not name then
					name = "*" .. item.id
				end

				description = Utility.Item.getDescription(item.id, self.gameDB, "en-US")
				if not description then
					description = "Pick up item from the ground."
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

			self:addAction(
				item.ref,
				"Take",
				"item",
				object,
				description,
				position.z - (i / #items),
				self._take, self, i, j, k, item)
			self.isDirty = true
		end

		self.probes['loot'] = #items
	end

	return self.probes['loot'] or 0
end

function Probe:_poke(id, target, scope)
	self.game:getPlayer():poke(id, target, scope)
end

-- Adds all actor actions, if possible.
function Probe:actors()
	if self.probes['actors'] then
		return self.probes['actors']
	end

	local count = 0
	for actor in self.game:getStage():iterateActors() do
		local transform
		local min, max = actor:getBounds()
		do
			local _, _, layer = actor:getTile()
			local node = self.gameView:getMapSceneNode(layer)
			if node then
				transform = node:getTransform():getGlobalDeltaTransform(0)
			end
		end

		local s, p = self.ray:hitBounds(min, max, transform, self.radius)
		if s then
			local actions = actor:getActions('world')
			for i = 1, #actions do
				self:addAction(
					actions[i].id,
					actions[i].verb,
					"actor",
					actor:getName(),
					actor:getDescription(),
					-p.z + ((i / #actions) / 100),
					self._poke, self, actions[i].id, actor, 'world')

				self.isDirty = true
				count = count + 1
			end

			self:addAction(
				"Examine",
				"Examine",
				'examine',
				actor:getName(),
				actor:getDescription(),
				-p.z + (((#actions + 1) / #actions) / 100),
				self.onExamine, actor:getName(), actor:getDescription())
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

	local player = self.game:getPlayer()
	if not player then
		return 0
	end

	local playerActor = player:getActor()
	if not playerActor then
		return
	end

	local _, _, playerLayer = playerActor:getTile()

	local count = 0
	for prop in self.game:getStage():iterateProps() do
		local transform
		local min, max = prop:getBounds()
		do
			local _, _, layer = prop:getTile()
			local node = self.gameView:getMapSceneNode(layer)
			if node then
				transform = node:getTransform():getGlobalDeltaTransform(0)
			end
		end

		local s, p = self.ray:hitBounds(min, max, transform, self.radius)
		if s then
			local actions = prop:getActions('world')
			for i = 1, #actions do
				local filter = Probe.PROP_FILTERS[actions[i].type:lower()]

				local isHidden = propLayer ~= playerLayer
				if filter then
					isHidden = isHidden or filter(prop)
				end

				local action = self:addAction(
					actions[i].id,
					actions[i].verb,
					"prop",
					prop:getName(),
					prop:getDescription(),
					-p.z + ((i / #actions) / 100),
					self._poke, self, actions[i].id, prop, 'world')
				action.suppress = not isHidden

				self.isDirty = true
				count = count + 1
			end

			self:addAction(
				"Examine",
				"Examine",
				'examine',
				prop:getName(),
				prop:getDescription(),
				-p.z + (((#actions + 1) / #actions) / 100),
				self.onExamine, prop:getName(), prop:getDescription())
		end
	end

	self.probes['props'] = count
	return count
end

return Probe
