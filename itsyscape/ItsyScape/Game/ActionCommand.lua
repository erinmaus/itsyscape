--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"

local ActionCommand = Class()

ActionCommand.Bar = require "ItsyScape.Game.ActionCommands.Bar"
ActionCommand.Button = require "ItsyScape.Game.ActionCommands.Button"
ActionCommand.Component = require "ItsyScape.Game.ActionCommands.Component"
ActionCommand.Icon = require "ItsyScape.Game.ActionCommands.Icon"
ActionCommand.Rectangle = require "ItsyScape.Game.ActionCommands.Rectangle"
ActionCommand.Glyph = require "ItsyScape.Game.ActionCommands.Glyph"
ActionCommand.Peep = require "ItsyScape.Game.ActionCommands.Peep"

function ActionCommand:new(action, peep, target)
	self.action = action
	self.peep = peep
	self.target = target
	self.root = self.Component()

	self.onHit = Callback()
end

function ActionCommand:getAction()
	return self.action
end

function ActionCommand:getPeep()
	return self.peep
end

function ActionCommand:getTarget()
	return self.target
end

function ActionCommand:onDamage(damage)
	-- Nothing.
end

function ActionCommand:getResource()
	local gameDB = self.action:getGameDB()
	local brochure = gameDB:getBrochure()

	local resource
	for r in brochure:findResourcesByAction(self.action:getAction()) do
		resource = r
		break
	end

	if resource then
		local resourceType = brochure:getResourceTypeFromResource(resource)
		return resource.name, resourceType.name
	end

	return "Null", "Item"
end

function ActionCommand:getOutputItem()
	local gameDB = self.action:getGameDB()
	local brochure = gameDB:getBrochure()

	for output in brochure:getOutputs(self.action:getAction()) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if resourceType.name == "Item" then
			return resource.name
		end
	end

	return "Null"
end

function ActionCommand:getRoot()
	return self.root
end

function ActionCommand:addChild(child)
	self.root:addChild(child)
end

function ActionCommand:removeChild(child)
	self.root:removeChild(child)
end

local function _serialize(c)
	local t = { children = {} }
	c:serialize(t)

	for _, child in c:iterate() do
		table.insert(t.children, _serialize(child))
	end

	return t
end

function ActionCommand:serialize()
	return _serialize(self.root)
end

function ActionCommand:onXAxis(controller, x)
	-- Nothing.
end

function ActionCommand:onYAxis(controller, y)
	-- Nothing.
end

function ActionCommand:onButtonDown(controller, button)
	-- Nothing.
end

function ActionCommand:onButtonUp(controller, button)
	-- Nothing.
end

function ActionCommand:onKeyDown(controller, key)
	-- Nothing.
end

function ActionCommand:onKeyUp(controller, key)
	-- Nothing.
end

function ActionCommand:update(delta)
	-- Nothing.
end

return ActionCommand
