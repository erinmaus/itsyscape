--------------------------------------------------------------------------------
-- ItsyScape/GameDB/Commands/Action.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Pokeable = require "ItsyScape.GameDB.Commands.Pokeable"
local Input = require "ItsyScape.GameDB.Commands.Input"
local Output = require "ItsyScape.GameDB.Commands.Output"
local Requirement = require "ItsyScape.GameDB.Commands.Requirement"

-- Maps to a Mapp.Action.
local Action = Class(Pokeable)

-- Constructs a new Action with the given type.
function Action:new(type)
	Pokeable.new(self)

	self.type = type
	self.inputs = {}
	self.outputs = {}
	self.requirements = {}
end

-- Connects inputs, outputs, or requirements to the Action.
--
-- For each element in 't', the value must be either an Input, Output, or
-- Requirement. No other values are accepted.
--
-- The syntax is generally something like:
--
-- Game.Action.Smelt {
--   Requirement { Resource = Game.Resource.Skill "Smithing", Count = Game.Utility.xpForLevel(10) },
--   Input { Resource = Game.Resource.Item "FooOre", Count = 1 },
--   Output { Resource = Game.Resource.Item "FooBar", Count = 1 },
--   Output { Resource = Game.Resource.Skill "Smithing", Count = Game.Utility.xpForAction(10, Game.Utility.SKILL_MEDIUM_PRESTIGE) }
-- }
--
-- This would create an action that takes a FooOre and generates a FooBar,
-- requiring level 10 smithing, producing some relevant smithing XP.
function Action:poke(t)
	t = t or {}

	for i = 1, #t do
		if Class.isType(t[i], Input) then
			table.insert(self.inputs, t[i])
		elseif Class.isType(t[i], Output) then
			table.insert(self.outputs, t[i])
		elseif Class.isType(t[i], Requirement) then
			table.insert(self.requirements, t[i])
		else
			error("unrecognized parameter", 2)
		end
	end
end

-- Instantiates the Action, connecting all constraints (if any).
function Action:instantiate(brochure)
	if not self.instance then
		self.instance = brochure:createAction(self.type:instantiate(brochure))

		for i = 1, #self.inputs do
			local input = self.inputs[i]
			local resource = input:getResource():instantiate(brochure)

			brochure:connectInput(self.instance, resource, input:getCount())
		end

		for i = 1, #self.outputs do
			local output = self.outputs[i]
			local resource = output:getResource():instantiate(brochure)

			brochure:connectOutput(self.instance, resource, output:getCount())
		end

		for i = 1, #self.requirements do
			local requirement = self.requirements[i]
			local resource = requirement:getResource():instantiate(brochure)

			brochure:connectRequirement(self.instance, resource, requirement:getCount())
		end
	end

	return self.instance
end

return Action
