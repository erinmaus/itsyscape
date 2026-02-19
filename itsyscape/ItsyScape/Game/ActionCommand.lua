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
local Config = require "ItsyScape.Game.Config"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local InputScheme = require "ItsyScape.UI.InputScheme"

local ActionCommand = Class()
ActionCommand.CANVAS_SIZE = 540

ActionCommand.Bar = require "ItsyScape.Game.ActionCommands.Bar"
ActionCommand.Button = require "ItsyScape.Game.ActionCommands.Button"
ActionCommand.Component = require "ItsyScape.Game.ActionCommands.Component"
ActionCommand.Icon = require "ItsyScape.Game.ActionCommands.Icon"
ActionCommand.Item = require "ItsyScape.Game.ActionCommands.Item"
ActionCommand.Rectangle = require "ItsyScape.Game.ActionCommands.Rectangle"
ActionCommand.Glyph = require "ItsyScape.Game.ActionCommands.Glyph"
ActionCommand.Peep = require "ItsyScape.Game.ActionCommands.Peep"
ActionCommand.Map = require "ItsyScape.Game.ActionCommands.Map"

function ActionCommand:new(action, peep, target, t)
	self.action = action
	self.peep = peep
	self.target = target
	self.root = self.Component()

	self.onHit = Callback()

	self.lastInputScheme = "mouse"
	self.keyboardXDirection = 0
	self.keyboardYDirection = 0
	self.gamepadXDirection = 0
	self.gamepadYDirection = 0

	self.tool = false

	if t then
		if t.tool then
			self:setTool(t.tool)
		end
	end
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

function ActionCommand:getDirector()
	return self.peep:getDirector()
end

function ActionCommand:getGame()
	return self.peep:getDirector():getGameInstance()
end

function ActionCommand:setTool(tool)
	self.tool = tool
end

function ActionCommand:getTool()
	return self.tool
end

function ActionCommand:getToolResource()
	return self.tool and self.tool:getID() or "Null", "Item"
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

function ActionCommand:newMap(map, callback)
	local peepMapScript = Utility.Peep.getMapScript(self.peep)
	local peepInstance = Utility.Peep.getInstance(self.peep)
	local player = Utility.Peep.getPlayerModel(self.peep)

	do
		local mapScript = peepInstance:getMapScriptByMapFilename(map, player)
		if mapScript then
			if mapScript:getLayer() > 1 then
				callback(Utility.Peep.getLayer(mapScript), mapScript)
			else
				mapScript:listen("postLoad", function() callback(Utility.Peep.getLayer(mapScript), mapScript) end)
			end

			return Utility.Peep.getLayer(mapScript), mapScript
		end
	end

	local layer, mapScript = Utility.Map.spawnMap(peepMapScript, map, Vector(0, 1000, 0), {
		isInstancedToPlayer = true,
		player = player
	})

	Utility.Peep.disable(mapScript)
	mapScript:listen("postLoad", function() callback(Utility.Peep.getLayer(mapScript), mapScript) end)

	return layer, mapScript
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

function ActionCommand:_setLastInputScheme(controller)
	if controller == "mouse" or controller == "keyboard" then
		self.lastInputScheme = InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD
	elseif controller == "gamepad" then
		self.lastInputScheme = InputScheme.INPUT_SCHEME_GAMEPAD
	end
end

function ActionCommand:getCurrentInputScheme()
	return self.lastInputScheme
end

function ActionCommand:getInputDirection()
	local x, y = 0, 0
	if self.lastInputScheme == InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD then
		x, y = self.keyboardXDirection, self.keyboardYDirection
	elseif self.lastInputScheme == InputScheme.INPUT_SCHEME_GAMEPAD then
		x, y = self.gamepadXDirection, self.gamepadYDirection
	end

	x = math.clamp(x, -1, 1)
	y = math.clamp(y, -1, 1)

	local length = math.sqrt((x ^ 2) + (y ^ 2))
	if length > 0 then
		x = x / length
		y = y / length
	end

	return x, y
end

function ActionCommand:onXAxis(controller, x)
	self:_setLastInputScheme(controller)

	if controller == "gamepad" then
		local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity") or 0
		if math.abs(value) > axisSensitivity then
			self.gamepadXDirection = value
		else
			self.gamepadXDirection = 0
		end
	end
end

function ActionCommand:onYAxis(controller, y)
	self:_setLastInputScheme(controller)

	if controller == "gamepad" then
		local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity") or 0
		if math.abs(value) > axisSensitivity then
			self.gamepadYDirection = value
		else
			self.gamepadYDirection = 0
		end
	end
end

function ActionCommand:onButtonDown(controller, button)
	self:_setLastInputScheme(controller)
end

function ActionCommand:onButtonUp(controller, button)
	self:_setLastInputScheme(controller)
end

function ActionCommand:onKeyDown(controller, key)
	self:_setLastInputScheme(controller)

	local leftScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveLeft")
	local rightScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveRight")
	local upScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveUp")
	local downScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveDown")

	if key == leftScan then
		self.keyboardXDirection = self.keyboardXDirection - 1
	elseif key == rightScan then
		self.keyboardXDirection = self.keyboardXDirection + 1
	elseif key == upScan then
		self.keyboardYDirection = self.keyboardYDirection - 1
	elseif key == downScan then
		self.keyboardYDirection = self.keyboardYDirection + 1
	end
end

function ActionCommand:onKeyUp(controller, key)
	self:_setLastInputScheme(controller)

	local leftScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveLeft")
	local rightScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveRight")
	local upScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveUp")
	local downScan = Config.get("Input", "KEYBIND", "type", "world", "name", "keyboardMoveDown")

	if key == leftScan then
		self.keyboardXDirection = self.keyboardXDirection + 1
	elseif key == rightScan then
		self.keyboardXDirection = self.keyboardXDirection - 1
	elseif key == upScan then
		self.keyboardYDirection = self.keyboardYDirection + 1
	elseif key == downScan then
		self.keyboardYDirection = self.keyboardYDirection - 1
	end
end

function ActionCommand:onControlUp(value)
	-- Nothing.
end

function ActionCommand:onControlDown(value)
	-- Nothing.
end

function ActionCommand:update(delta)
	-- Nothing.
end

function ActionCommand:close()
	-- Nothing.s
end

return ActionCommand
