--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/GamepadCombatHUD.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local Icon = require "ItsyScape.UI.Icon"
local SpiralLayout = require "ItsyScape.UI.SpiralLayout"
local ToolTip = require "ItsyScape.UI.ToolTip"
local BaseCombatHUD = require "ItsyScape.UI.Interfaces.BaseCombatHUD"
local GamepadCirclePanel = require "ItsyScape.UI.Interfaces.Components.GamepadCirclePanel"
local PendingPowerIcon = require "ItsyScape.UI.Interfaces.Components.PendingPowerIcon"

local GamepadCombatHUD = Class(BaseCombatHUD)

GamepadCombatHUD.SPIRAL_OFFSET             = 32
GamepadCombatHUD.SPIRAL_RADIUS             = 276
GamepadCombatHUD.SPIRAL_INNER_PANEL_RADIUS = 192

GamepadCombatHUD.SELECTED_BUTTON_SIZE = 68
GamepadCombatHUD.DEFAULT_BUTTON_SIZE  = 52
GamepadCombatHUD.MINIMUM_BUTTON_SIZE  = 28

GamepadCombatHUD.SELECTED_ICON_SIZE = 64
GamepadCombatHUD.DEFAULT_ICON_SIZE  = 48
GamepadCombatHUD.MINIMUM_ICON_SIZE  = 24
GamepadCombatHUD.ICON_OFFSET        = 2

GamepadCombatHUD.MIN_ICON_ALPHA     = 0.25
GamepadCombatHUD.MAX_ICON_ALPHA     = 1

GamepadCombatHUD.CIRCLE_PANEL_DISABLED_COLOR = Color.fromHexString("999999")
GamepadCombatHUD.CIRCLE_PANEL_ENABLED_COLOR  = Color.fromHexString("ffcc00")
GamepadCombatHUD.ICON_ENABLED_COLOR          = Color.fromHexString("ffffff")
GamepadCombatHUD.ICON_DISABLED_COLOR         = Color.fromHexString("333333")

function GamepadCombatHUD:new(...)
	BaseCombatHUD.new(self, ...)

	local uiView = self:getUIView()
	local rootNode = uiView:getRoot()

	self._onGamepadRelease = function(_, joystick, button)
		local inputProvider = uiView:getInputProvider()

		if not inputProvider:isCurrentJoystick(joystick) then
			return
		end

		if not inputProvider:getKeybind("gamepadOpenCombatRing") == button then
			return
		end

		self:toggleCombatRing()
	end
	rootNode.onGamepadRelease:register(self._onGamepadRelease)

	self.onClose:register(function()
		rootNode.onGamepadRelease:unregister(self._onGamepadRelease)
	end)

	self:_initCommon()
end

function GamepadCombatHUD:_initCommon()
	self.iconGamepadPrimaryAction = Icon()
	self.iconGamepadPrimaryAction:setIcon("Resources/Game/UI/Icons/Controllers/PlayerStation/button_a.png")
	self.iconGamepadPrimaryAction:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadPrimaryAction:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2,
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2)
	self.iconGamepadSecondaryAction = Icon()
	self.iconGamepadSecondaryAction:setIcon("Resources/Game/UI/Icons/Controllers/PlayerStation/button_y.png")
	self.iconGamepadSecondaryAction:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadSecondaryAction:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2,
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2)
	self.iconGamepadBack = Icon()
	self.iconGamepadBack:setIcon("Resources/Game/UI/Icons/Controllers/PlayerStation/button_b.png")
	self.iconGamepadBack:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadBack:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2,
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2)
	self.iconGamepadMenuAction = Icon()
	self.iconGamepadMenuAction:setIcon("Resources/Game/UI/Icons/Controllers/PlayerStation/button_x.png")
	self.iconGamepadMenuAction:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadMenuAction:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2,
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE / 2)

	self.pendingPowerIcon = PendingPowerIcon()
	self.pendingPowerIcon:setPosition(self.ICON_OFFSET, self.ICON_OFFSET)
	self.pendingPowerIcon:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)

	self.pendingPowerMenuIcon = PendingPowerIcon()
	self.pendingPowerMenuIcon:setPosition(self.ICON_OFFSET, self.ICON_OFFSET)
	self.pendingPowerMenuIcon:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
end

function GamepadCombatHUD:openMenu()
	local didOpen = BaseCombatHUD.openMenu(self)
	if didOpen then
		self:focus(self:getMenu(), "select")
	end
end

function GamepadCombatHUD:toggleCombatRing()
	if self:getIsShowing() then
		self:hide()
	else
		self:show()
	end
end

function GamepadCombatHUD:layoutSpiralMenu(spiralMenu)
	local width, height = itsyrealm.graphics.getScaledMode()

	local radius = spiralMenu:getRadius()
	spiralMenu:setPosition(
		width / 2 + radius + self.SPIRAL_OFFSET,
		height / 2 + radius + self.SPIRAL_OFFSET)
end

function GamepadCombatHUD:openSpiralMenu(spiralMenu)
	self:layoutSpiralMenu(spiralMenu)
	self.curentSpiralMenu = spiralMenu

	self:focus(spiralMenu, "select")
end

function GamepadCombatHUD:selectThingies(name, target)
	local isOpen = BaseCombatHUD.selectThingies(self, name, target)
	if not isOpen then
		return
	end

	local spiralMenu = self:getThingiesWidget(name)
	self:openSpiralMenu(spiralMenu)
end

function GamepadCombatHUD:performLayout()
	BaseCombatHUD.performLayout(self)

	if self.currentSpiralMenu then
		self:layoutSpiralMenu(self.currentSpiralMenu)
	end
end

function GamepadCombatHUD:newSpiralMenu(name)
	local spiralMenu = SpiralLayout()
	spiralMenu:setData("name", name)
	spiralMenu:setRadius(self.SPIRAL_RADIUS)

	local circlePanel = GamepadCirclePanel()
	circlePanel:enable()

	spiralMenu:getInnerPanel():setSize(
		self.SPIRAL_INNER_PANEL_RADIUS,
		self.SPIRAL_INNER_PANEL_RADIUS)
	spiralMenu:getInnerPanel():setPosition(
		-(self.SPIRAL_INNER_PANEL_RADIUS / 2),
		-(self.SPIRAL_INNER_PANEL_RADIUS / 2))
	spiralMenu:getInnerPanel():addChild(circlePanel)

	return spiralMenu
end

function GamepadCombatHUD:newSpiralButton()
	local button = Button()
	button:setStyle(ButtonStyle({}, self:getUIView():getResources()))

	local panel = GamepadCirclePanel()
	panel:setOutlineColor(self.CIRCLE_PANEL_ENABLED_COLOR)
	panel:setOutlineThickness(2, 4)
	panel:setRadius(2)
	button:addChild(panel)
	button:setData("panel", panel)

	local icon = Icon()
	button:addChild(icon)
	button:setData("icon", icon)

	return button
end

function GamepadCombatHUD:layoutSpiralButton(button, delta)
	local buttonSize, iconSize, alpha
	if button:getIsFocused() then
		alpha = 1
		buttonSize = math.lerp(self.MINIMUM_BUTTON_SIZE, self.SELECTED_BUTTON_SIZE, delta)
		iconSize = math.lerp(self.MINIMUM_ICON_SIZE, self.SELECTED_ICON_SIZE, delta)
	else
		alpha = 1
		buttonSize = math.lerp(self.MINIMUM_BUTTON_SIZE, self.DEFAULT_BUTTON_SIZE, delta)
		iconSize = math.lerp(self.MINIMUM_ICON_SIZE, self.DEFAULT_ICON_SIZE, delta)
	end

	if button:getIsFocused() then
		button:getData("panel"):enable()

		if self.iconGamepadPrimaryAction:getParent() ~= button then
			button:addChild(self.iconGamepadPrimaryAction)
		end
	else
		button:getData("panel"):disable()

		if self.iconGamepadPrimaryAction:getParent() == button then
			button:removeChild(self.iconGamepadPrimaryAction)
		end
	end

	button:setSize(buttonSize, buttonSize)

	local icon = button:getData("icon")
	icon:setSize(iconSize, iconSize)
	icon:setColor(Color(1, 1, 1, alpha))

	self:layoutSpiralButton(button)
end

function GamepadCombatHUD:newMenu()
	return self:newSpiralMenu("main")
end

function GamepadCombatHUD:newMenuButton(name)
	local button = self:newSpiralButton()
	button:setData("name", name)

	return button
end

function GamepadCombatHUD:updateMenuButton(name, button)
	local icon = button:getData("icon")
	local panel = button:getData("panel")

	local isEnabled = self:isEnabled(name)
	if isEnabled then
		icon:setColor(self.ICON_ENABLED_COLOR)
		panel:setOutlineColor(self.CIRCLE_PANEL_ENABLED_COLOR)
	else
		icon:setColor(self.ICON_DISABLED_COLOR)
		panel:setOutlineColor(self.CIRCLE_PANEL_DISABLED_COLOR)
	end
end

function GamepadCombatHUD:newPowerButton()
	return self:newSpiralButton()
end

function GamepadCombatHUD:updatePowerButton(button, powerState, isPending)
	button:setToolTip(ToolTip.Header(powerState.name), unpack(powerState.description))

	button:setData("powerID", powerState.id)

	local icon = button:getData("icon")
	icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", powerState.id))

	button:setData("isPending", isPending)
	if isPending then
		button:addChild(self.pendingPowerIcon)
	elseif self.pendingPowerIcon:getParent() == button then
		button:removeChild(self.pendingPowerIcon)
	end
end

function GamepadCombatHUD:layoutPowerButton(button, delta)
	self:layoutSpiralButton(button, delta)

	if button:getData("isPending") then
		local iconWidth, iconHeight = button:getData("icon"):getSize()
		self.pendingPowerIcon:setSize(iconWidth, iconHeight)
	end
end

function GamepadCombatHUD:_onPowerVisible(_, child, delta)
	self:layoutPowerButton(child, delta)
end

function GamepadCombatHUD:newPowerThingies(name, powersState)
	local powersSpiral = self:newSpiralMenu(name)
	powersSpiral.onChildVisible:register(self._onPowerVisible, self)
	return powersSpiral
end

return GamepadCombatHUD

