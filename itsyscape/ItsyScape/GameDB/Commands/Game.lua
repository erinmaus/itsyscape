--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ActionCategory = require "ItsyScape.GameDB.Commands.ActionCategory"
local MetaCategory = require "ItsyScape.GameDB.Commands.MetaCategory"
local ResourceCategory = require "ItsyScape.GameDB.Commands.ResourceCategory"

local Game = Class()
function Game.getGame()
	if not _G["_GAME"] then
		error("game not yet defined", 2)
	end

	assert(_G["_GAME"]:isType(Game))

	return _G["_GAME"]
end

-- Constructs a new Game.
--
-- A global, _GAME, is set corresponding to the new Game instance.
--
-- Furthermore, a global of 'name' is created, also corresponding to the Game
-- instance.
--
-- This should only be called in a sandbox.
--
-- It is an error to define multiple Games in a single script.
function Game:new(name)
	assert(_G["_GAME"] == nil, "game already defined")

	self.name = name
	self.actionTypes = {}
	self.resourceTypes = {}
	self.metaDefinitions = {}

	self.Meta = MetaCategory(self)
	self.Action = ActionCategory(self)
	self.Resource = ResourceCategory(self)
	self.Utility = {}

	_G["_GAME"] = self
	_G[name] = self
end

-- Gets the name of the game.
function Game:getName()
	return self.name
end

-- Gets the underlying record definitions.
function Game:getRecordDefinitions()
	local definitions = {}
	for name, meta in self.Meta:iterate() do
		definitions[name] = meta.definition.definition
	end

	return definitions
end

-- Instantiates the GameDB.
function Game:instantiate(brochure)
	for _, resources in self.Resource:iterate() do
		for _, resource in ipairs(resources) do
			resource:instantiate(brochure)
		end
	end

	for _, metas in self.Meta:iterate() do
		metas.definition:instantiate(brochure)

		for _, meta in ipairs(metas) do
			meta:instantiate(brochure)
		end 
	end

	for _, meta in self.Meta:iterate() do
		for _, m in ipairs(meta) do
			m:instantiate(brochure)
		end
	end

	return true
end

--------------------------------------------------------------------------------
-- These are internal methods. They add new fields to Meta, Action, and
-- Resource, among other possible background things.
--
-- They should never be called by the construction script. If they are, then it
-- is the Game object will be inconsistent which will likely result in errors or
-- a garbage GameDB.
--------------------------------------------------------------------------------

function Game:addActionType(actionType)
	if self.actionTypes[actionType:getName()] then
		error(string.format("action type '%s' already defined", actionType:getName()), 2)
	end

	self.actionTypes[actionType:getName()] = actionType
end

function Game:getActionType(name)
	if not self.actionTypes[name] then
		error(string.format("action type '%s' not defined", name), 2)
	end

	return self.actionTypes[name]
end

function Game:addResourceType(resourceType)
	if self.resourceTypes[resourceType:getName()] then
		error(string.format("resource type '%s' already defined", resourceType:getName()), 2)
	end

	self.resourceTypes[resourceType:getName()] = resourceType
end

function Game:getResourceType(name)
	if not self.resourceTypes[name] then
		error(string.format("resource type '%s' not defined", name), 2)
	end

	return self.resourceTypes[name]
end

function Game:addMeta(meta)
	self.Meta:add(meta)
end

return Game
