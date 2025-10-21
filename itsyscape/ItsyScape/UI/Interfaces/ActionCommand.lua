--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/TutorialHint.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local Drawable = require "ItsyScape.UI.Drawable"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local Widget = require "ItsyScape.UI.Widget"

local ActionCommand = Class(Interface)
ActionCommand.DROP_SHADOW = 4

ActionCommand.Root = Class(Widget)
function ActionCommand.Root:getIsFocusable()
	return true
end

ActionCommand.Wrapper = Class(Widget)
function ActionCommand.Wrapper:getOverflow()
	return true
end

ActionCommand.Common = Class(Drawable)
function ActionCommand.Common:new(currentT, previousT, delta)
	Drawable.new(self)
	self:makeCurrentT(currentT, previousT, delta)

	self:setSize(self.t.width, self.t.height)
end

function ActionCommand.Common:makeCurrentT(currentT, previousT, delta)
	self.t = {}
	for k, v in pairs(currentT) do
		self.t[k] = v
	end

	self.t.x = math.lerp(previousT.x, currentT.x, delta)
	self.t.y = math.lerp(previousT.y, currentT.y, delta)
	self.t.width = math.lerp(previousT.width, currentT.width, delta)
	self.t.height = math.lerp(previousT.height, currentT.height, delta)
end

function ActionCommand.Common:getOverflow()
	return true
end

ActionCommand.Bar = Class(ActionCommand.Common)
function ActionCommand.Bar:makeCurrentT(currentT, previousT, delta)
	ActionCommand.Common.makeCurrentT(self, currentT, previousT, delta)

	self.t.foregroundColor = { Color(unpack(previousT.foregroundColor)):lerp(Color(unpack(currentT.foregroundColor)), delta):get() }
	self.t.backgroundColor = { Color(unpack(previousT.backgroundColor)):lerp(Color(unpack(currentT.backgroundColor)), delta):get() }
end

function ActionCommand.Bar:draw()
	local valueColor = Color(unpack(self.t.foregroundColor))
	local backgroundColor = Color(unpack(self.t.backgroundColor))

	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.rectangle(
		"fill",
		ActionCommand.DROP_SHADOW, ActionCommand.DROP_SHADOW,
		self.t.width,
		self.t.height,
		ActionCommand.DROP_SHADOW)

	love.graphics.setColor(backgroundColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, self.t.width, self.t.height, ActionCommand.DROP_SHADOW)

	local w = self.t.ratio * self.t.width
	if self.t.ratio > 0 then
		w = math.max(w, 1)

		love.graphics.setColor(valueColor:get())
		itsyrealm.graphics.rectangle(
			"fill",
			0,
			0,
			w,
			self.t.height,
			math.min(ActionCommand.DROP_SHADOW, w / 2))
	end

	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.setLineWidth(ActionCommand.DROP_SHADOW)
	itsyrealm.graphics.rectangle("line", 0, 0, self.t.width, self.t.height, ActionCommand.DROP_SHADOW)
	love.graphics.setLineWidth(1)

	love.graphics.setColor(1, 1, 1, 1)
end

ActionCommand.Rectangle = Class(ActionCommand.Common)
function ActionCommand.Rectangle:makeCurrentT(currentT, previousT, delta)
	ActionCommand.Common.makeCurrentT(self, currentT, previousT, delta)
	self.t.color = { Color(unpack(previousT.color)):lerp(Color(unpack(currentT.color)), delta):get() }
end

function ActionCommand.Rectangle:draw()
	local valueColor = Color(unpack(self.t.color))

	love.graphics.setLineWidth(self.t.lineWidth)

	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.rectangle(
		self.t.fillMode,
		ActionCommand.DROP_SHADOW, ActionCommand.DROP_SHADOW,
		self.t.width,
		self.t.height,
		self.t.radius)

	love.graphics.setColor(valueColor:get())
	itsyrealm.graphics.rectangle(
		self.t.fillMode,
		0, 0,
		self.t.width,
		self.t.height,
		self.t.radius)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

function ActionCommand:new(...)
	Interface.new(self, ...)

	self.root = ActionCommand.Root()
	self:addChild(self.root)

	self:setData(GamepadSink, GamepadSink({
		isBlockingCamera = false
	}))

	self.root.onMouseMove:register(self.mouseMoveOverRoot, self)
	self.root.onMousePress:register(self.mousePressOverRoot, self)
	self.root.onMouseRelease:register(self.mouseReleaseOverRoot, self)
end

function ActionCommand:getOverflow()
	return true
end

function ActionCommand:_build(parent, t, o, delta)
	local widget
	if t.type == "bar" then
		widget = ActionCommand.Bar(t, o, delta)
	elseif t.type == "button" then
		widget = GamepadToolTip()
		widget:setHasBackground(false)
		widget:setRowSize(math.huge, math.lerp(o.height, t.height, delta))

		if t.standard then
			widget:setButtonID(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, t.standard.button)
			widget:setMessage(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, t.standard.label)
		end

		if t.gamepad then
			widget:setButtonID(GamepadToolTip.INPUT_SCHEME_GAMEPAD, t.gamepad.button)
			widget:setMessage(GamepadToolTip.INPUT_SCHEME_GAMEPAD, t.gamepad.label)
		end

		if t.mobile then
			widget:setButtonID(GamepadToolTip.INPUT_SCHEME_TOUCH, t.mobile.button)
			widget:setMessage(GamepadToolTip.INPUT_SCHEME_TOUCH, t.mobile.label)
		end
	elseif t.type == "component" then
		widget = ActionCommand.Common(t, o, delta)
	elseif t.type == "icon" then
		widget = Icon()
		widget:setIcon(t.icon)
		widget:setSize(
			math.lerp(o.width, t.width, delta),
			math.lerp(o.height, t.height, delta))
	elseif t.type == "rectangle" then
		widget = ActionCommand.Rectangle(t, o, delta)
	end

	local p = ActionCommand.Wrapper()
	p:setPosition(
		math.lerp(o.x, t.x, delta),
		math.lerp(o.y, t.y, delta))
	p:setSize(
		math.lerp(o.width, t.width, delta),
		math.lerp(o.height, t.height, delta))

	if widget then
		p:addChild(widget)
	end

	if parent then
		parent:addChild(p)
	end

	for i, child in ipairs(t.children) do
		local otherChild = o.children[i]
		if child.id == otherChild.id then
			self:_build(p, child, otherChild, delta)
		else
			self:_build(p, child, child, delta)
		end
	end

	return p
end

function ActionCommand:_addProgressBar()
	if self.progressBar and self.progressBar:getParent() == self then
		self:removeChild(self.progressBar)
	end

	local state = self:getState()
	local prop = self:getView():getGameView():getPropByID(state.propID)
	if not prop then
		return
	end

	local progressColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.progress"), alpha)
	local remainderColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.remainder"), alpha)

	local x, y = self.root:getPosition()
	local state = prop:getState()
	local t = {
		x = 0,
		y = 0,
		width = self.root:getSize(),
		height = 32,
		currentValue = state.resource.progress,
		maximumValue = 100,
		ratio = state.resource.progress / 100,
		backgroundColor = { progressColor:get() },
		foregroundColor = { remainderColor:get() },
	}
	self.progressBar = ActionCommand.Bar(t, t, 1)
	self.progressBar:setPosition(x, y - 48)
	self:addChild(self.progressBar)
end

function ActionCommand:attach()
	Interface.attach(self)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		inputProvider:setFocusedWidget(self, "open")
	end
end

function ActionCommand:tick()
	Interface.tick(self)

	if self.actionCommandRoot and self.actionCommandRoot:getParent() == self.root then
		self.root:removeChild(self.actionCommandRoot)
	end

	local state = self:getState()
	local currentInterface = state.current
	local previousInterface = state.previous

	self.actionCommandRoot = self:_build(self.root, currentInterface, previousInterface, _APP:getFrameDelta())
	self.root:setSize(self.actionCommandRoot:getSize())

	self:performLayout()

	self:_addProgressBar()
end

function ActionCommand:performLayout()
	Interface.performLayout(self)

	local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()
	local rootWidth, rootHeight = self.root:getSize()

	self.root:setPosition(
		(screenWidth - rootWidth) / 2,
		(screenHeight - rootHeight) / 2)
end

function ActionCommand:mouseMoveOverRoot(_, x, y)
	local sx, sy = self.root:getAbsolutePosition()
	local w, h = self.root:getSize()
	x = (((x - sx) / w) - 0.5) * 2
	y = (((y - sy) / h) - 0.5) * 2

	self:sendPoke("axis", nil, { controller = "mouse", axis = "x", value = x })
	self:sendPoke("axis", nil, { controller = "mouse", axis = "y", value = y })
end

function ActionCommand:gamepadAxis(joystick, axis, value)
	Interface.gamepadAxis(self, joystick, axis, value)

	if axis == "leftx" then
		self:sendPoke("axis", nil, { controller = "gamepad", axis = "x", value = value })
	elseif axis == "lefty" then
		self:sendPoke("axis", nil, { controller = "gamepad", axis = "y", value = value })
	end
end

function ActionCommand:mousePressOverRoot(_, x, y, button)
	self:sendPoke("button", nil, { controller = "mouse", type = "down", value = button })
end

function ActionCommand:mouseReleaseOverRoot(_, x, y, button)
	self:sendPoke("button", nil, { controller = "mouse", type = "up", value = button })
end

function ActionCommand:gamepadPress(joystick, button)
	Interface.gamepadPress(self, joystick, button)
	self:sendPoke("button", nil, { controller = "gamepad", type = "down", value = button })
end

function ActionCommand:gamepadRelease(x, y, button)
	Interface.gamepadRelease(self, joystick, button)
	self:sendPoke("button", nil, { controller = "gamepad", type = "up", value = button })
end

return ActionCommand
