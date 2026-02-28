--------------------------------------------------------------------------------
-- Resources/Game/ActionCommands/Mine1.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ActionCommand = require "ItsyScape.Game.ActionCommand"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local InputScheme = require "ItsyScape.UI.InputScheme"

local Mine1 = Class(ActionCommand)

Mine1.MIN_STUN_INTERVAL_SECONDS   = 0.25
Mine1.MAX_STUN_INTERVAL_SECONDS   = 0.5

Mine1.REROLL_INTERVAL_SECONDS = 3

Mine1.ROTATION_INTERVAL = 0.5

Mine1.MAP = "Skilling_Mining1"
Mine1.ROCK_OVERRIDE = false

Mine1.MIN_ACTIONS = 0
Mine1.MAX_ACTIONS = 0

Mine1.GAMEPAD_BUTTONS = {
	"a",
	"b",
	"x",
	"y",
	"up",
	"left",
	"right",
	"down"
}

Mine1.GAMEPAD_BUTTON_ICONS = {
	["up"] = "stick_l_up",
	["left"] = "stick_l_left",
	["right"] = "stick_l_right",
	["down"] = "stick_l_down"
}

Mine1.KEYBOARD_BUTTONS = {
	"w",
	"a",
	"s",
	"d",
	"up",
	"left",
	"right",
	"down"
}

function Mine1:new(...)
	ActionCommand.new(self, ...)

	self:getRoot():setSize(540, 400)

	self.map = ActionCommand.Map()
	self.map:setSize(540, 400)
	self.map:setDistance(15)
	self:addChild(self.map)

	self.mainContainer = ActionCommand.Component()
	self.mainContainer:setPosition(-24, -24)
	self.mainContainer:setSize(48, 48)
	self.map:addChild(self.mainContainer)

	self.toolIcon = ActionCommand.Item()
	self.toolIcon:setSize(48, 48)
	self.toolIcon:setItem(self:getToolResource())
	self.mainContainer:addChild(self.toolIcon)

	self.innerRectangle = ActionCommand.Rectangle()
	self.innerRectangle:setLineWidth(2)
	self.innerRectangle:setRadius(4)
	self.mainContainer:addChild(self.innerRectangle)

	self.outerRectangle = ActionCommand.Rectangle()
	self.outerRectangle:setSize(48, 48)
	self.outerRectangle:setLineWidth(4)
	self.outerRectangle:setRadius(4)
	self.mainContainer:addChild(self.outerRectangle)

	self.mainButton = ActionCommand.Button()
	self.mainButton:setStandardButton("keyboard_arrows")
	self.mainButton:setGamepadButton("stick_l")
	self.mainButton:setPosition(0, 56)
	self.mainButton:setSize(48, 48)
	self.mainContainer:addChild(self.mainButton)

	self.buttons = { { container = self.mainContainer, rectangles = { self.innerRectangle, self.outerRectangle }, button = self.mainButton } }
	for i = 2, self.MAX_ACTIONS do
		local container = ActionCommand.Component()
		container:setSize(48, 48)

		local rectangle = ActionCommand.Rectangle()
		rectangle:setSize(48, 48)
		rectangle:setLineWidth(4)
		rectangle:setRadius(4)
		container:addChild(rectangle)

		local icon = ActionCommand.Icon()
		icon:setSize(48, 48)
		icon:setIcon("Resources/Game/ActionCommands/Mine/Explosion.png")
		container:addChild(icon)

		local button = ActionCommand.Button()
		button:setSize(48, 48)
		button:setPosition(0, 56)
		container:addChild(button)

		table.insert(self.buttons, { container = container, rectangles = { rectangle }, button = button })
	end

	self.mapLayer, self.mapScript = self:newMap(self.MAP, function(mapLayer, mapScript)
		self.map:setMap(mapScript)

		local rockProp = Utility.spawnPropAtAnchor(mapScript, self.ROCK_OVERRIDE or Utility.Peep.getResource(self:getTarget()), "Anchor_Spawn")
		self.rock = rockProp and rockProp:getPeep()
	end)

	self.stunTimer = 0
	self.rollTimer = 0

	self.rotateTimer = 0
	self.previousAngle = 0
	self.currentAngle = 0

	self.activeButtons = {}
	self:rollButtons()
end

function Mine1:close()
	ActionCommand.close(self)

	if self.rock then
		Utility.Peep.poof(self.rock)
	end
end

function Mine1:rotateCamera()
	local delta = math.clamp(self.rotateTimer / self.ROTATION_INTERVAL)
	self.previousAngle = math.lerp(self.previousAngle, self.currentAngle, delta)
	self.currentAngle = self.currentAngle + math.pi / 2

	self.rotateTimer = 0
end

function Mine1:rollButtons()
	for _, button in ipairs(self.buttons) do
		local parent = button.container:getParent()
		if parent then
			parent:removeChild(button.container)
		end
	end

	local numActions = love.math.random(self.MIN_ACTIONS, self.MAX_ACTIONS)
	local numButtons = numActions + 1

	local allGamepadButtons = { unpack(self.GAMEPAD_BUTTONS) }
	local allKeyboardButtons = { unpack(self.KEYBOARD_BUTTONS) }

	local positions = {}
	for i = 1, 4 do
		for j = 2, 3 do
			table.insert(positions, {
				(i - 1) * (540 / 4),
				(j - 1) * (400 / 4)
			})
		end
	end

	table.clear(self.activeButtons)
	for i = 1, numButtons do
		local button = self.buttons[i]

		local gamepadButton = table.remove(allGamepadButtons, love.math.random(#allGamepadButtons))
		local keyboardButton = table.remove(allKeyboardButtons, love.math.random(#allKeyboardButtons))

		button.button:setStandardButton(keyboardButton)
		button.button:setGamepadButton(self.GAMEPAD_BUTTON_ICONS[gamepadButton] or gamepadButton)

		local x, y = unpack(table.remove(positions, love.math.random(#positions)))

		button.container:setPosition(x, y)
		button.container:refresh()

		self:addChild(button.container)

		table.insert(self.activeButtons, {
			container = button.container,
			gamepad = gamepadButton,
			keyboard = keyboardButton
		})
	end
	self.numClearedButtons = 0
	self.targetNumClearedButtons = numButtons - 1

	self.rollTimer = self.REROLL_INTERVAL_SECONDS

	self:rotateCamera()
end

function Mine1:onButtonDown(controller, button)
	ActionCommand.onButtonDown(self, InputScheme.INPUT_SCHEME_GAMEPAD, button)
	self:tryButtons(controller, button)
end

function Mine1:onKeyDown(controller, button)
	self:tryButtons(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD, button)
end

function Mine1:onDirectionChanged(currentX, currentY)
	local button1, button2
	if currentX < 0 then
		button1 = "left"
	elseif currentX > 0 then
		button1 = "right"
	end

	if currentY < 0 then
		button2 = "up"
	elseif currentY > 0 then
		button2 = "down"
	end

	self:tryButtons(self:getCurrentInputScheme(), button1, button2)
end

function Mine1:tryButtons(controller, ...)
	if not self.isActive then
		return false
	end

	for i = 1, select("#", ...) do
		local button = select(i, ...)

		if self:_tryButton(1, controller, button) then
			self:hit(true)
			return true
		end
	end

	for i = 2, #self.activeButtons do
		for i = 1, select("#", ...) do
			local button = select(i, ...)

			if self:_tryButton(i, controller, button) then
				self:hit(false)
				return true
			end
		end
	end

	if select("#", ...) > 0 then
		self:hit(false)
		return true
	end

	return false
end


function Mine1:_tryButton(index, controller, button)
	local b = self.activeButtons[index]
	if controller == InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD then
		if b.keyboard == button then
			return true
		end
	elseif controller == InputScheme.INPUT_SCHEME_GAMEPAD then
		if b.gamepad == button then
			return true
		end
	end

	return false
end

function Mine1:hit(success)
	self.rock:poke("mine", { peep = self:getPeep(), tool = self:getTool() })

	if not success then
		self.isActive = false
		self.stunTimer = math.lerp(self.MIN_STUN_INTERVAL_SECONDS, self.MAX_STUN_INTERVAL_SECONDS, love.math.random())
		self:onHit(-love.math.random())
		return
	end

	local fromColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.gamepadZap.from"))
	local fr, fg, fb = fromColor:get()
	local toColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.gamepadZap.to"))
	local tr, tg, tb = toColor:get()

	local x, y = self.mainContainer:getPosition()
	local w, h = self.mainContainer:getSize()

	self:onParticles({
		properties = {
			EmissionArea = { "ellipse", 64, 64, math.rad(360), true },
			ParticleLifetime = { 0.4, 0.6 },
			Sizes = { 0.25, 1.25, 0.25 },
			Speed = { 96, 128 },
			Rotation = { math.rad(0), math.rad(360) },
			LinearAcceleration = { 0, -32, 0, -32 },
			SizeVariation = { 0.5 },
			Colors = {
				{ fr, fg, fb, 0 },
				{ fr, fg, fb, 1 },
				{ tr, tg, tb, 1 },
				{ tr, tg, tb, 0 }
			},
			Offset = {
				32, 32
			}
		},

		texture = "Resources/Game/UI/Particles/Combat/Zap.png",
		quads = {
			{ 0, 0, 64, 64, 128, 128 },
			{ 64, 0, 64, 64, 128, 128 },
			{ 0, 64, 64, 64, 128, 128 },
			{ 64, 64, 64, 64, 128, 128 },
		},

		emit = { 20, 35 },

		duration = 0.5
	}, x + w / 2, y + h / 2)

	self:onHit(love.math.random())

	self:rollButtons()
end

function Mine1:updateButtonColors()
	local goColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.resource.hit"))
	local readyColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.resource.ready"))
	local disabledColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "world.resource.disabled"))

	if not self.isActive then 
		for _, button in ipairs(self.buttons) do
			for _, rectangle in ipairs(button.rectangles) do
				rectangle:setColor(disabledColor)
			end
		end

		return
	end

	for _, rectangle in ipairs(self.buttons[1].rectangles) do
		rectangle:setColor(goColor)
	end

	for i = 2, #self.buttons do
		for _, rectangle in ipairs(self.buttons[i].rectangles) do
			rectangle:setColor(readyColor)
		end
	end
end

function Mine1:getMapWidget()
	return self.map
end

function Mine1:updateMapCamera()
	if not self.rock then
		return
	end

	local rockPosition = Utility.Peep.getPosition(self.rock)
	self.map:setOffset(rockPosition)

	local delta = math.clamp(self.rotateTimer / self.ROTATION_INTERVAL)
	local rotation = math.lerp(self.previousAngle, self.currentAngle, delta)
	self.map:setVerticalRotation(rotation)
end

function Mine1:getMessage()
	return "ui.actionCommand.mine.hitButton"
end

function Mine1:update(delta)
	ActionCommand.update(self, delta)

	local s = math.sin(love.timer.getTime() * math.pi / 4) * 4 + 64

	self.innerRectangle:setSize(s, s)
	self.innerRectangle:setPosition(
		((self.outerRectangle:getSize() + 4) - (s + 4)) / 2,
		((self.outerRectangle:getSize() + 4) - (s + 4)) / 2)

	self.stunTimer = math.max(self.stunTimer - delta, 0)
	self.rollTimer = math.max(self.rollTimer - delta, 0)
	self.rotateTimer = math.min(self.rotateTimer + delta, self.ROTATION_INTERVAL)

	if self.rollTimer == 0 and self.isActive then
		self:rollButtons()
	end

	if self.stunTimer == 0 and not self.isActive then
		self.isActive = true
	end

	self:updateButtonColors(delta)
	self:updateMapCamera()
end

return Mine1
