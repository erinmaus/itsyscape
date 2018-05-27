--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/ActionConstraint.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"

-- Base level class for an ActionConstraint.
local ActionConstraint = Class(Pokeable)

-- Constructs a new ActionConstraint.
--
-- 't' is passed on to ActionConstraint.poke, if provided.
--
-- Derived ActionConstraints (Input, Output, or Requirement) are provided as
-- arguments to Action.poke.
function ActionConstraint:new(t)
	Pokeable.new(self)

	self.resource = false
	self.count = 1

	if t then
		self:poke(t)
	end
end

-- Defines the constraint.
--
-- 't' can contain:
--  - Resource (GameDB.Commands.Resource): The resource bound to the constraint.
--  - Count (number): The quantity of the resource bound to the constraint.
--
-- For example, an ActionConstraint for a mining level requirement of 10 would
-- have a "Mining" skill as Resource and however much XP level 10 is for Count.
function ActionConstraint:poke(t)
	t = t or {}

	self.resource = t.Resource or self.resource
	self.count = t.Count or self.count
end

-- Connecting the Constraint is handled by the top level Action.
function ActionConstraint:instantiate(brochure)
	return true
end

return ActionConstraint
