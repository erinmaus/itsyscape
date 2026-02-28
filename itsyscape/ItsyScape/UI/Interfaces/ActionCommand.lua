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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Config = require "ItsyScape.Game.Config"
local ActorView = require "ItsyScape.Graphics.ActorView"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local CloseButton = require "ItsyScape.UI.CloseButton"
local Drawable = require "ItsyScape.UI.Drawable"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Glyph = require "ItsyScape.UI.Glyph"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local InputScheme = require "ItsyScape.UI.InputScheme"
local Interface = require "ItsyScape.UI.Interface"
local KeyboardSink = require "ItsyScape.UI.KeyboardSink"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Particles = require "ItsyScape.UI.Particles"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"

local ActionCommand = Class(Interface)
ActionCommand.DROP_SHADOW = 4
ActionCommand.CANVAS_SIZE = 540

ActionCommand.ROOT_PANEL_STYLE = {
	image = "Resources/Game/UI/Buttons/DialogButton-Default.png"
}

ActionCommand.ROOT_PADDING = Theme.DEFAULT_OUTER_PADDING * 3

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
	local _, screenHeight = itsyrealm.graphics.getScaledMode()
	local scale = screenHeight / ActionCommand.CANVAS_SIZE

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
	local _, screenHeight = itsyrealm.graphics.getScaledMode()
	local scale = screenHeight / ActionCommand.CANVAS_SIZE

	local valueColor = Color(unpack(self.t.color))

	love.graphics.setLineWidth(self.t.lineWidth)

	local x, y = -self.t.lineWidth / 2, -self.t.lineWidth / 2

	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.rectangle(
		self.t.fillMode,
		x + ActionCommand.DROP_SHADOW, y + ActionCommand.DROP_SHADOW,
		self.t.width * scale,
		self.t.height * scale,
		self.t.radius)

	love.graphics.setColor(valueColor:get())
	itsyrealm.graphics.rectangle(
		self.t.fillMode,
		x, y,
		self.t.width * scale,
		self.t.height * scale,
		self.t.radius)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

ActionCommand.Particles = Class(Particles)

function ActionCommand.Particles:new(particles)
	Particles.new(self)

	particles = particles or {}
	if particles.texture then
		self:setTexture(particles.texture)
	end

	local quads
	if particles.quads then
		quads = {}
		for _, quad in ipairs(particles.quads) do
			table.insert(quads, love.graphics.newQuad(unpack(quad)))
		end
	end

	if particles.properties then
		local properties = {}
		for k, v in pairs(particles.properties) do
			properties[k] = v
		end
		properties.Quads = quads

		self:updateParticleSystemProperties(properties)
	end

	if particles.emit then
		self:emit(unpack(particles.emit))
	end

	self.time = 0
	self.duration = particles.duration or math.huge

	self.fadeIn = not not particles.fadeIn
	self.fadeOut = not not particles.fadeOut
	self.fadeDuration = particles.fadeDuration or 0
end

do
	local tintColor = Color()
	function ActionCommand.Particles:update(delta)
		Particles.update(self, delta)

		self.time = self.time + delta

		local alpha = 1
		if self.fadeIn then
			if self.time < self.fadeDuration then
				alpha = self.time / self.fadeDuration
			end
		end

		if self.fadeOut then
			local remaining = self.duration - self.fadeDuration
			if remaining > 0 and remaining < self.fadeDuration then
				alpha = 1 - math.clamp(remaining / self.fadeDuration)
			end
		end

		tintColor:from(1, 1, 1, alpha)
		self:setTintColor(tintColor)

		if self.time > self.duration then
			local parent = self:getParent()
			if parent then
				parent:removeChild(self)
			end
		end
	end
end

function ActionCommand:new(...)
	Interface.new(self, ...)

	self:setData(KeyboardSink, KeyboardSink())

	self.root = ActionCommand.Root()
	self:addChild(self.root)

	self:setData(GamepadSink, GamepadSink({
		isBlockingCamera = false
	}))

	self.root.onMouseMove:register(self.mouseMoveOverRoot, self)
	self.root.onMousePress:register(self.mousePressOverRoot, self)
	self.root.onMouseRelease:register(self.mouseReleaseOverRoot, self)

	self.closeToolTip = GamepadToolTip()
	self.closeToolTip:setControl("openRibbon")
	self.closeToolTip:setText("Close")
	self.closeToolTip:setRowSize(math.huge, Theme.calculateInnerSize(GamepadToolTip.PADDING, CloseButton.DEFAULT_SIZE))

	self.closeButton = CloseButton()
	self.closeButton.onClick:register(self._onClose, self)

	self.panel = Panel()
	self.panel:setStyle(self.ROOT_PANEL_STYLE, PanelStyle)
	self.root:addChild(self.panel)

	self.sceneSnippets = {}
	self.glyphs = {}
	self.particles = {}
end

function ActionCommand:_onClose(_, index)
	if index == 1 then
		self:sendPoke("close", nil, {})
	end
end

function ActionCommand:getOverflow()
	return true
end

function ActionCommand:_getParentSceneSnippet(widget)
	local current = widget
	while current do
		for _, child in current:iterate() do
			if Class.isCompatibleType(child, SceneSnippet) then
				return child
			end
		end

		current = widget:getParent()
	end

	return nil
end

do
	local worldPosition = Vector()
	local screenPosition = Vector()

	function ActionCommand:_getTargetOffset(parent, t)
		if not (t.targetType and t.targetID) then
			return 0, 0
		end

		local sceneSnippet = self:_getParentSceneSnippet(parent)
		if not (sceneSnippet and sceneSnippet:getCamera()) then
			return 0, 0
		end

		local gameView = self:getView():getGameView()

		local object
		if t.targetType == "actor" then
			object = gameView:getActorByID(t.targetID)
		elseif t.targetType == "prop" then
			object = gameView:getPropByID(t.targetID)
		else
			return 0, 0
		end

		local view = gameView:getView(object)
		if not view then
			return 0, 0
		end

		local node
		if Class.isCompatibleType(view, ActorView) then
			node = view:getSceneNode()
		elseif Class.isCompatibleType(view, PropView) then
			node = view:getRoot()
		end

		if not node then
			return 0, 0
		end

		local transform = node:getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
		worldPosition:from(0):transform(transform, worldPosition)

		sceneSnippet:getCamera():project(worldPosition, screenPosition)
		return screenPosition.x, screenPosition.y
	end
end

function ActionCommand:_build(parent, t, o, delta)
	local _, screenHeight = itsyrealm.graphics.getScaledMode()
	local scale = screenHeight / self.CANVAS_SIZE

	local widget
	if t.type == "bar" then
		widget = ActionCommand.Bar(t, o, delta)
	elseif t.type == "button" then
		widget = GamepadToolTip()
		widget:setHasBackground(false)
		widget:setRowSize(math.huge, math.lerp(o.height, t.height, delta) * scale)

		if t.standard and t.standard.button then
			widget:setButtonID(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, t.standard.button)
			widget:setMessage(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, t.standard.label)
		end

		if t.gamepad and t.gamepad.button then
			widget:setButtonID(GamepadToolTip.INPUT_SCHEME_GAMEPAD, t.gamepad.button)
			widget:setMessage(GamepadToolTip.INPUT_SCHEME_GAMEPAD, t.gamepad.label)
		end

		if t.mobile and t.mobile.button then
			widget:setButtonID(GamepadToolTip.INPUT_SCHEME_TOUCH, t.mobile.button)
			widget:setMessage(GamepadToolTip.INPUT_SCHEME_TOUCH, t.mobile.label)
		end

		if t.control then
			widget:setControl(t.control)
		end
	elseif t.type == "component" then
		widget = ActionCommand.Common(t, o, delta)
	elseif t.type == "icon" then
		widget = Icon()
		widget:setIcon(t.icon)
		widget:setSize(
			math.lerp(o.width, t.width, delta) * scale,
			math.lerp(o.height, t.height, delta) * scale)
	elseif t.type == "item" then
		widget = ItemIcon()
		widget:setItemID(t.item)
		widget:setItemCount(t.count)
		widget:setSize(
			math.lerp(o.width, t.width, delta) * scale,
			math.lerp(o.height, t.height, delta) * scale)
	elseif t.type == "rectangle" then
		widget = ActionCommand.Rectangle(t, o, delta)
	elseif t.type == "glyph" then
		widget = self.glyphs[t.id] or Glyph()
		widget:updateTime(t.time)
		widget:setGlyph(t.glyph)
		widget:setAlpha(math.lerp(o.alpha, t.alpha, delta))
		widget:setGlyphColor(Color(unpack(o.glyphColor)):lerp(Color(unpack(t.glyphColor)), delta))
		widget:setGlowColor(Color(unpack(o.glowColor)):lerp(Color(unpack(t.glowColor)), delta))
		widget:setOutlineColor(Color(unpack(o.outlineColor)):lerp(Color(unpack(t.outlineColor)), delta))
		widget:setSize(
			math.lerp(o.width, t.width, delta) * scale,
			math.lerp(o.height, t.height, delta) * scale)
	elseif t.type == "peep" then
		widget = self.sceneSnippets[t.id] or SceneSnippet()

		if not widget:getCamera() then
			widget:setCamera(ThirdPersonCamera())
		end

		local gameView = self:getView():getGameView()

		local object
		if t.peepType == "actor" then
			object = gameView:getActorByID(t.peepID)
		elseif t.peepType == "prop" then
			object = gameView:getPropByID(t.peepID)
		end

		local parentNode = SceneNode()
		local ambientLight = AmbientLightSceneNode()
		ambientLight:setAmbience(1)
		ambientLight:setParent(parentNode)

		widget:setParentNode(parentNode)
		widget:setRoot(parentNode)
		widget:setSize(
			math.lerp(o.width, t.width, delta) * scale,
			math.lerp(o.height, t.height, delta) * scale)

		self.sceneSnippets[t.id] = widget
	elseif t.type == "map" then
		widget = self.sceneSnippets[t.id]
		if not widget then
			widget = SceneSnippet()

			local child = Panel()
			child:setStyle(Theme.SCENE_BORDER_PANEL_STYLE, PanelStyle)
			widget:addChild(child)
		end

		widget:setIsChildRenderer(false)

		if not widget:getCamera() then
			widget:setCamera(ThirdPersonCamera())
		end

		if not widget:getParentNode() then
			widget:setParentNode(widget:getRoot())
		end

		widget:setSize(
			math.lerp(o.width, t.width, delta) * scale,
			math.lerp(o.height, t.height, delta) * scale)

		local borderChild = widget:getChildAt(1)
		if borderChild then
			borderChild:setSize(widget:getSize())
		end

		local gameView = self:getView():getGameView()
		Theme.setSceneSnippetMap(widget, widget:getCamera(), gameView, t.mapLayer, nil, 2.5)

		local horizontalRotation = math.lerpAngle(o.horizontalRotation, t.horizontalRotation, delta)
		local verticalRotation = math.lerpAngle(o.verticalRotation, t.verticalRotation, delta)

		widget:getCamera():setHorizontalRotation(horizontalRotation)
		widget:getCamera():setVerticalRotation(verticalRotation)
		widget:getCamera():setRotation(Quaternion.IDENTITY)

		local distance = math.lerp(o.distance, t.distance, delta)
		local position = Vector(
			math.lerp(o.offsetX, t.offsetX, delta),
			math.lerp(o.offsetY, t.offsetY, delta) + widget:getCamera():getPosition().y,
			math.lerp(o.offsetZ, t.offsetZ, delta))

		widget:getCamera():setPosition(position)
		widget:getCamera():setDistance(distance)

		self.sceneSnippets[t.id] = widget
	end

	local ox, oy = self:_getTargetOffset(parent, t)

	local p = ActionCommand.Wrapper()
	p:setPosition(
		math.lerp(o.x, t.x, delta) * scale + ox,
		math.lerp(o.y, t.y, delta) * scale + oy)
	p:setSize(
		math.lerp(o.width, t.width, delta) * scale,
		math.lerp(o.height, t.height, delta) * scale)

	if widget then
		p:addChild(widget)
	end

	if parent then
		parent:addChild(p)
	end

	for i, child in ipairs(t.children) do
		local otherChild = o.children[i]
		if otherChild and child.id == otherChild.id then
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
		width = self.root:getSize() / 2,
		height = Theme.DEFAULT_BUTTON_SIZE,
		currentValue = state.resource.progress,
		maximumValue = 100,
		ratio = state.resource.progress / 100,
		backgroundColor = { progressColor:get() },
		foregroundColor = { remainderColor:get() },
	}
	self.progressBar = ActionCommand.Bar(t, t, 1)
	self.progressBar:setPosition(
		x + (self.root:getSize() - self.root:getSize() / 2) / 2,
		y + self.ROOT_PADDING)
	self:addChild(self.progressBar)
end

function ActionCommand:_addMessageToolTip()
	if self.hintToolTip and self.hintToolTip:getParent() == self then
		self:removeChild(self.hintToolTip)
	end

	local state = self:getState()
	if not state.message then
		return
	end

	local rootX, rootY = self.root:getPosition()
	local rootWidth, rootHeight = self.root:getSize()
	local _, panelY = self.panel:getPosition()
	local panelWidth, panelHeight = self.panel:getSize()

	self.hintToolTip = self.hintToolTip or GamepadToolTip()
	self:addChild(self.hintToolTip)

	self.hintToolTip:setButtonID(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, "none")
	self.hintToolTip:setButtonID(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "none")
	self.hintToolTip:setButtonID(GamepadToolTip.INPUT_SCHEME_TOUCH, "none")

	self.hintToolTip:setRowSize(rootWidth, 32)
	self.hintToolTip:setID("ActionCommand-Hint")

	local currentMessage = self:T(state.message)
	self.hintToolTip:setText(self:T(state.message))

	local hintWidth, hintHeight = self.hintToolTip:getSize()
	self.hintToolTip:setPosition(
		rootX + (rootWidth - hintWidth) / 2,
		rootY + rootHeight - Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, hintHeight))
end

function ActionCommand:attach()
	Interface.attach(self)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		inputProvider:setFocusedWidget(self.root, "open")
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
	for i = #self.particles, 1, -1 do
		local particle = self.particles[i]

		if particle.new or particle.widget:getParent() then
			self.actionCommandRoot:addChild(particle.widget)
			particle.new = false
		else
			table.remove(self.particles, i)
		end
	end

	self.root:setSize(self.actionCommandRoot:getSize())

	self:performLayout()
end

function ActionCommand:restoreFocus()
	self:focusChild(self.root)
end

function ActionCommand:performLayout()
	Interface.performLayout(self)

	local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()
	local rootWidth, rootHeight = self.root:getSize()

	self.root:setPosition(
		(screenWidth - rootWidth) / 2,
		(screenHeight - rootHeight) / 2)

	self:_addProgressBar()

	local rootX, rootY = self.root:getPosition() 
	self.panel:setSize(
		Theme.calculateSizeWithPadding(self.ROOT_PADDING, rootWidth),
		Theme.calculateSizeWithPadding(self.ROOT_PADDING, rootHeight))
	self.panel:setPosition(-self.ROOT_PADDING, -self.ROOT_PADDING)

	local _, progressBarY = self.progressBar:getPosition()
	local progressBarWidth = self.progressBar:getSize()
	self.closeButton:setPosition(
		rootX + rootWidth - CloseButton.DEFAULT_SIZE - self.ROOT_PADDING,
		progressBarY)
	self:addChild(self.closeButton)

	local closeButtonX, closeButtonY = self.closeButton:getPosition()
	self.closeToolTip:setPosition(
		rootX + rootWidth + self.ROOT_PADDING,
		closeButtonY)
	self:addChild(self.closeToolTip)

	self:_addMessageToolTip()
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

function ActionCommand:gamepadDirection(directionX, directionY)
	Interface.gamepadDirection(self, directionX, directionY)

	if directionX < 0 then
		self:sendPoke("key", nil, { controller = "gamepad", type = "down", value = "left" })
		self:sendPoke("key", nil, { controller = "gamepad", type = "up", value = "left" })
	elseif directionX > 0 then
		self:sendPoke("key", nil, { controller = "gamepad", type = "down", value = "right" })
		self:sendPoke("key", nil, { controller = "gamepad", type = "up", value = "right" })
	end

	if directionY < 0 then
		self:sendPoke("key", nil, { controller = "gamepad", type = "down", value = "up" })
		self:sendPoke("key", nil, { controller = "gamepad", type = "up", value = "up" })
	elseif directionY > 0 then
		self:sendPoke("key", nil, { controller = "gamepad", type = "down", value = "down" })
		self:sendPoke("key", nil, { controller = "gamepad", type = "up", value = "down" })
	end
end

function ActionCommand:mousePressOverRoot(_, x, y, button)
	self:focusChild(self.root)
	self:sendPoke("button", nil, { controller = "mouse", type = "down", value = button })
end

function ActionCommand:mouseReleaseOverRoot(_, x, y, button)
	self:focusChild(self.root)
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

function ActionCommand:keyDown(key, scan, isRepeat)
	Interface.keyDown(self, key, scan, isRepeat)

	if not isRepeat then
		self:sendPoke("key", nil, { controller = "keyboard", type = "down", value = scan })
	end
end

function ActionCommand:keyUp(key, scan, ...)
	Interface.keyUp(self, key, scan, ...)

	self:sendPoke("key", nil, { controller = "keyboard", type = "up", value = scan })
end

function ActionCommand:controlDown(control)
	Interface.controlDown(self, control)

	self:sendPoke("control", nil, { type = "down", value = control:getName() })
end

function ActionCommand:controlUp(control)
	Interface.controlUp(self, control)

	if control:is("openRibbon") then
		self:sendPoke("close", nil, {})
	else
		self:sendPoke("control", nil, { type = "up", value = control:getName() })
	end
end

function ActionCommand:showParticles(particles, x, y, z)
	local _, screenHeight = itsyrealm.graphics.getScaledMode()
	local scale = screenHeight / self.CANVAS_SIZE

	x = (x or 0) * scale
	y = (y or 0) * scale

	local widget = ActionCommand.Particles(particles)
	widget:setPosition(x, y)
	widget:setZDepth(z or 1)

	if self.actionCommandRoot then
		self.actionCommandRoot:addChild(widget)
	end

	table.insert(self.particles, { widget = widget, new = true })
end

return ActionCommand
