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
local Weapon = require "ItsyScape.Game.Weapon"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local Icon = require "ItsyScape.UI.Icon"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local RichTextLabelStyle = require "ItsyScape.UI.RichTextLabelStyle"
local SpiralLayout = require "ItsyScape.UI.SpiralLayout"
local ToolTip = require "ItsyScape.UI.ToolTip"
local BaseCombatHUD = require "ItsyScape.UI.Interfaces.BaseCombatHUD"
local GamepadCirclePanel = require "ItsyScape.UI.Interfaces.Components.GamepadCirclePanel"
local PendingPowerIcon = require "ItsyScape.UI.Interfaces.Components.PendingPowerIcon"

local GamepadCombatHUD = Class(BaseCombatHUD)

GamepadCombatHUD.SPIRAL_OFFSET             = 32
GamepadCombatHUD.SPIRAL_OUTER_RADIUS       = 168
GamepadCombatHUD.SPIRAL_INNER_RADIUS       = 144
GamepadCombatHUD.SPIRAL_INNER_PANEL_RADIUS = 144

GamepadCombatHUD.SELECTED_BUTTON_SIZE = 68
GamepadCombatHUD.DEFAULT_BUTTON_SIZE  = 52
GamepadCombatHUD.MINIMUM_BUTTON_SIZE  = 28

GamepadCombatHUD.SELECTED_ICON_SIZE = 64
GamepadCombatHUD.DEFAULT_ICON_SIZE  = 48
GamepadCombatHUD.MINIMUM_ICON_SIZE  = 24
GamepadCombatHUD.ICON_OFFSET        = 2

GamepadCombatHUD.MIN_ICON_ALPHA     = 0.25
GamepadCombatHUD.MAX_ICON_ALPHA     = 1

GamepadCombatHUD.CIRCLE_PANEL_DISABLED_COLOR = Color.fromHexString("999999", 0.75)
GamepadCombatHUD.CIRCLE_PANEL_ENABLED_COLOR  = Color.fromHexString("ffcc00", 0.75)
GamepadCombatHUD.CIRCLE_PANEL_SPELL_COLOR    = Color.fromHexString("00ff00", 0.5)
GamepadCombatHUD.ICON_ENABLED_COLOR          = Color.fromHexString("ffffff")
GamepadCombatHUD.ICON_DISABLED_COLOR         = Color.fromHexString("333333")

GamepadCombatHUD.COMBAT_STYLE_ICONS = {
	[Weapon.STYLE_NONE] = "Resources/Game/Items/Null/Icon.png",
	[Weapon.STYLE_MAGIC] = "Resources/Game/UI/Icons/Skills/Magic.png",
	[Weapon.STYLE_ARCHERY] = "Resources/Game/UI/Icons/Skills/Archery.png",
	[Weapon.STYLE_MELEE] = "Resources/Game/UI/Icons/Skills/Attack.png",
	[Weapon.STYLE_SAILING] = "Resources/Game/UI/Icons/Skills/Sailing.png"
}

GamepadCombatHUD.COMBAT_STANCE_ICONS = {
	[Weapon.STYLE_MAGIC] = {
		[Weapon.STANCE_NONE] = "Resources/Game/Items/Null/Icon.png",
		[Weapon.STANCE_CONTROLLED] = "Resources/Game/UI/Icons/Skills/Magic.png",
		[Weapon.STANCE_AGGRESSIVE] = "Resources/Game/UI/Icons/Skills/Wisdom.png",
		[Weapon.STANCE_DEFENSIVE] = "Resources/Game/UI/Icons/Skills/Defense.png"
	},
	[Weapon.STYLE_ARCHERY] = {
		[Weapon.STANCE_NONE] = "Resources/Game/Items/Null/Icon.png",
		[Weapon.STANCE_CONTROLLED] = "Resources/Game/UI/Icons/Skills/Archery.png",
		[Weapon.STANCE_AGGRESSIVE] = "Resources/Game/UI/Icons/Skills/Dexterity.png",
		[Weapon.STANCE_DEFENSIVE] = "Resources/Game/UI/Icons/Skills/Defense.png"
	},
	[Weapon.STYLE_MELEE] = {
		[Weapon.STANCE_NONE] = "Resources/Game/Items/Null/Icon.png",
		[Weapon.STANCE_CONTROLLED] = "Resources/Game/UI/Icons/Skills/Attack.png",
		[Weapon.STANCE_AGGRESSIVE] = "Resources/Game/UI/Icons/Skills/Strength.png",
		[Weapon.STANCE_DEFENSIVE] = "Resources/Game/UI/Icons/Skills/Defense.png"
	},
	[Weapon.STYLE_SAILING] = {
		[Weapon.STANCE_NONE] = "Resources/Game/Items/Null/Icon.png",
		[Weapon.STANCE_CONTROLLED] = "Resources/Game/UI/Icons/Skills/Sailing.png",
		[Weapon.STANCE_AGGRESSIVE] = "Resources/Game/UI/Icons/Skills/Sailing.png",
		[Weapon.STANCE_DEFENSIVE] = "Resources/Game/UI/Icons/Skills/Sailing.png"
	}
}

GamepadCombatHUD.SPIRAL_INNER_PANEL_LABEL_STYLE = {
	textFont = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	textFontSize = 22,

	headerFont = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	headerFontSize = 26
}

function GamepadCombatHUD:new(...)
	self.thingiesAngles = {}
	self.thingiesStack = {}
	self.thingiesProperties = {}

	BaseCombatHUD.new(self, ...)

	local uiView = self:getView()
	local rootNode = uiView:getRoot()

	self._onGamepadRelease = function(_, joystick, button)
		local inputProvider = uiView:getInputProvider()

		if not inputProvider:isCurrentJoystick(joystick) then
			return
		end

		if inputProvider:getKeybind("gamepadOpenCombatRing") ~= button then
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

function GamepadCombatHUD:onSwitchCombatStyle(oldCombatStyle, newCombatStyle)
	BaseCombatHUD.onSwitchCombatStyle(self, oldCombatStyle, newCombatStyle)

	local button = self:getThingiesButton(BaseCombatHUD.THINGIES_STANCE)
	if not button then
		return
	end

	local icon = button:getData("icon")

	newCombatStyle = newCombatStyle or Weapon.STYLE_NONE

	local iconFilename = GamepadCombatHUD.COMBAT_STYLE_ICONS[newCombatStyle]
	iconFilename = iconFilename or GamepadCombatHUD.COMBAT_STYLE_ICONS[Weapon.STYLE_NONE]

	icon:setIcon(iconFilename or false)
end

function GamepadCombatHUD:onSelectPendingPower(powerType, pendingPowerID)
	BaseCombatHUD.onSelectPendingPower(self, powerType, pendingPowerID)

	local button = self:getThingiesButton(powerType)
	if not button then
		return
	end

	local icon = button:getData("icon")
	icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", pendingPowerID))

	button:addChild(self.pendingPowerMenuIcon)
	self.pendingPowerMenuIcon:setSize(icon:getSize())
end

function GamepadCombatHUD:onClearPendingPower(powerType, pendingPowerID)
	BaseCombatHUD.onClearPendingPower(self, powerType, pendingPowerID)

	local button = self:getThingiesButton(powerType)
	if not button then
		return
	end

	local icon = button:getData("icon")
	if powerType == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS then
		icon:setIcon("Resources/Game/UI/Icons/Concepts/Powers.png")
	elseif powerType == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS then
		icon:setIcon("Resources/Game/UI/Icons/Skills/Defense.png")
	end

	if self.pendingPowerMenuIcon:getParent() == button then
		button:removeChild(self.pendingPowerMenuIcon)
	end
end

function GamepadCombatHUD:onSwitchSpell(oldSpell, newSpell)
	BaseCombatHUD.onSwitchSpell(self, oldSpell, newSpell)

	local button = self:getThingiesButton(BaseCombatHUD.THINGIES_SPELLS)
	if not button then
		return
	end

	local icon = button:getData("icon")

	if newSpell then
		icon:setIcon(string.format("Resources/Game/Spells/%s/Icon.png", newSpell))

		local panel = button:getData("panel")
		if not panel:getData("enabled") then
			panel:setData("enabled", true)
			panel:setData("previousColor", panel:getData("currentColor") or Color(panel:getOutlineColor():get()))
			panel:setData("currentColor", Color(self.CIRCLE_PANEL_SPELL_COLOR:get()))
			panel:setOutlineColor(self.CIRCLE_PANEL_SPELL_COLOR)
			panel:enable()
		end
	else
		icon:setIcon(string.format("Resources/Game/Spells/FireBlast/Icon.png"))

		local panel = button:getData("panel")
		panel:setOutlineColor(panel:getData("previousColor") or self.CIRCLE_PANEL_ENABLED_COLOR)
		panel:unsetData("enabled")
		panel:unsetData("previousColor")
		panel:unsetData("currentColor")

		local menu = self:getMenu()
		if menu and menu:getCurrentOption() == button then
			panel:enable()
		else
			panel:disable()
		end
	end
end

function GamepadCombatHUD:_initCommon()
	self.iconGamepadPrimaryAction = Icon()
	self.iconGamepadPrimaryAction:setIcon("Resources/Game/UI/Icons/Controllers/PlayStation/button_a.png")
	self.iconGamepadPrimaryAction:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadPrimaryAction:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4),
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4))
	self.iconGamepadSecondaryAction = Icon()
	self.iconGamepadSecondaryAction:setIcon("Resources/Game/UI/Icons/Controllers/PlayStation/button_y.png")
	self.iconGamepadSecondaryAction:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadSecondaryAction:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4),
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4))
	self.iconGamepadBack = Icon()
	self.iconGamepadBack:setIcon("Resources/Game/UI/Icons/Controllers/PlayStation/button_b.png")
	self.iconGamepadBack:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadBack:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4),
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4))
	self.iconGamepadMenuAction = Icon()
	self.iconGamepadMenuAction:setIcon("Resources/Game/UI/Icons/Controllers/PlayStation/button_x.png")
	self.iconGamepadMenuAction:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	self.iconGamepadMenuAction:setPosition(
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4),
		self.SELECTED_BUTTON_SIZE - self.DEFAULT_ICON_SIZE * (3 / 4))

	self.pendingPowerIcon = PendingPowerIcon()
	self.pendingPowerIcon:setPosition(self.ICON_OFFSET, self.ICON_OFFSET)
	self.pendingPowerIcon:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)

	self.pendingPowerMenuIcon = PendingPowerIcon()
	self.pendingPowerMenuIcon:setPosition(self.ICON_OFFSET, self.ICON_OFFSET)
	self.pendingPowerMenuIcon:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
end

function GamepadCombatHUD:openThingies(name, targetWidget)
	local didOpen = BaseCombatHUD.openThingies(self, name, targetWidget)
	if didOpen then
		local thingiesWidget = self:getThingiesWidget(name)
		local angle = self.thingiesAngles[name]
		if angle then
			thingiesWidget:setCurrentAngle(angle)
		end

		self:addChild(thingiesWidget)
	end

	return didOpen
end

function GamepadCombatHUD:closeThingies(name)
	local didClose = BaseCombatHUD.closeThingies(self, name)
	if didClose then
		local menu = self:getThingiesWidget(name)
		self.thingiesAngles[name] = menu:getCurrentAngle()
	end
end

function GamepadCombatHUD:openMenu()
	local didOpen = BaseCombatHUD.openMenu(self)
	if didOpen then
		local menu = self:getMenu()

		self:focus(menu, "select")

		if self.thingiesAngles[self.FEATURE_MENU] then
			menu:setCurrentAngle(self.thingiesAngles[self.FEATURE_MENU])
		end

		self:layoutSpiralMenu(menu)
	end
end

function GamepadCombatHUD:clear()
	while #self.thingiesStack > 1 do
		self:back()
	end
end

function GamepadCombatHUD:back()
	if #self.thingiesStack == 0 then
		return false
	end

	local top = table.remove(self.thingiesStack)
	if top == self.FEATURE_MENU then
		self:closeMenu()
	else
		self:closeThingies(top)
	end

	if #self.thingiesStack >= 1 then
		local current = self.thingiesStack[#self.thingiesStack]
		if current == self.FEATURE_MENU then
			self:openMenu()
		else
			self:openThingies(current)
		end
	end

	return true
end

function GamepadCombatHUD:closeMenu()
	local didClose = BaseCombatHUD.closeMenu(self)

	if didClose then
		self.thingiesAngles[self.FEATURE_MENU] = self:getMenu():getCurrentAngle()
	end
end

function GamepadCombatHUD:show()
	local didShow = BaseCombatHUD.show(self)
	if didShow then
		table.insert(self.thingiesStack, self.FEATURE_MENU)
	end
end

function GamepadCombatHUD:toggleCombatRing()
	if self:getIsShowing() then
		self:clear()
		self:hide()
	else
		self:show()
	end
end

function GamepadCombatHUD:layoutSpiralMenu(spiralMenu)
	local width, height = itsyrealm.graphics.getScaledMode()

	local _, outerRadius = spiralMenu:getRadius()
	spiralMenu:setPosition(
		width / 2 + outerRadius / 2 + self.SPIRAL_OFFSET,
		height / 2 + outerRadius / 2 + self.SPIRAL_OFFSET)
end

function GamepadCombatHUD:openSpiralMenu(spiralMenu)
	self:layoutSpiralMenu(spiralMenu)

	self:focus(spiralMenu, "select")
end

function GamepadCombatHUD:selectThingies(name, target)
	local isOpen = BaseCombatHUD.selectThingies(self, name, target)
	if not isOpen then
		return
	end

	local top = self.thingiesStack[#self.thingiesStack]
	if top then
		if top == self.FEATURE_MENU then
			self:closeMenu()
		else
			self:closeThingies(top)
		end
	end

	table.insert(self.thingiesStack, name)

	local spiralMenu = self:getThingiesWidget(name)
	self:openSpiralMenu(spiralMenu)
end

function GamepadCombatHUD:performLayout()
	BaseCombatHUD.performLayout(self)

	local current = self.thingiesStack[#self.thingiesStack]
	if current == self.FEATURE_MENU then
		self:layoutSpiralMenu(self:getMenu())
	elseif current then
		self:layoutSpiralMenu(self:getThingiesWidget(current))
	end
end

function GamepadCombatHUD:onSpiralMenuGamepadButtonRelease(name, _, joystick, button)
	local inputProvider = self:getView():getInputProvider()

	if not inputProvider:isCurrentJoystick(joystick) then
		return
	end

	if inputProvider:getKeybind("gamepadBack") == button then
		self:back()
	end
end

function GamepadCombatHUD:newSpiralMenu(name)
	local spiralMenu = SpiralLayout()
	spiralMenu:setData("name", name)
	spiralMenu:setRadius(self.SPIRAL_INNER_RADIUS, self.SPIRAL_OUTER_RADIUS)

	local circlePanel = GamepadCirclePanel()
	circlePanel:enable()

	spiralMenu:getInnerPanel():setSize(
		self.SPIRAL_INNER_PANEL_RADIUS * 2,
		self.SPIRAL_INNER_PANEL_RADIUS * 2)
	spiralMenu:getInnerPanel():setPosition(
		-self.SPIRAL_INNER_PANEL_RADIUS,
		-self.SPIRAL_INNER_PANEL_RADIUS)
	spiralMenu:getInnerPanel():addChild(circlePanel)

	spiralMenu.onGamepadRelease:register(self.onSpiralMenuGamepadButtonRelease, self, name)

	return spiralMenu
end

function GamepadCombatHUD:finishSpiralMenu(name, spiralMenu)
	local numRemaining = spiralMenu:getNumRemainingOptions()

	for i = 1, numRemaining do
		local button = self:newSpiralButton()
		button:setData("isDisabled", true)

		spiralMenu:addChild(button)
	end
end

function GamepadCombatHUD:newSpiralButton()
	local button = Button()
	button:setStyle(ButtonStyle({}, self:getView():getResources()))

	local panel = GamepadCirclePanel()
	panel:setOutlineColor(self.CIRCLE_PANEL_ENABLED_COLOR)
	panel:setOutlineThickness(1, 3)
	panel:setRadius(5)
	button:addChild(panel)
	button:setData("panel", panel)

	local icon = Icon()
	button:addChild(icon)
	button:setData("icon", icon)

	return button
end

function GamepadCombatHUD:layoutSpiralButton(button, delta)
	delta = delta or button:getData("delta") or 1
	button:setData("delta", delta)

	local isDisabled = button:getData("isDisabled")

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

	local panel = button:getData("panel")
	if button:getIsFocused() then
		panel:enable()

		if self.iconGamepadPrimaryAction:getParent() ~= button and not isDisabled then
			button:addChild(self.iconGamepadPrimaryAction)
		end
	else
		panel:disable()

		if self.iconGamepadPrimaryAction:getParent() == button then
			button:removeChild(self.iconGamepadPrimaryAction)
		end
	end

	if panel:getData("enabled") then
		panel:enable()
	end

	button:setSize(buttonSize, buttonSize)

	local icon = button:getData("icon")
	icon:setSize(iconSize, iconSize)
	icon:setColor(Color(1, 1, 1, alpha))
end

function GamepadCombatHUD:focusSpiralButton(currentButton, previousButton)
	if currentButton then
		self:layoutSpiralButton(currentButton)
	end

	if previousButton then
		self:layoutSpiralButton(previousButton)
	end
end

function GamepadCombatHUD:_onMenuOptionVisible(_, button, delta)
	self:layoutSpiralButton(button, delta)

	if self.pendingPowerMenuIcon:getParent() == button then
		local icon = button:getData("icon")
		self.pendingPowerMenuIcon:setSize(icon:getSize())
	end
end

function GamepadCombatHUD:_onMenuOptionSelected(_, currentButton, previousButton)
	self:focusSpiralButton(currentButton, previousButton)

	if currentButton then
		local name = currentButton:getData("name")

		local menu = self:getMenu()
		local innerPanel = menu:getInnerPanel()

		local label = innerPanel:getData("label")
		label:setText({
			{ t = "header", self:getThingiesName(name) },
			self:getThingiesDescription(name)
		})
	end
end

function GamepadCombatHUD:newMenu()
	local menu = self:newSpiralMenu("main")
	menu.onChildVisible:register(self._onMenuOptionVisible, self)
	menu.onChildSelected:register(self._onMenuOptionSelected, self)

	local size = math.sqrt(2) * self.SPIRAL_INNER_PANEL_RADIUS - self.PADDING * 2
	local padding = math.floor(self.SPIRAL_INNER_PANEL_RADIUS - size / 2 + self.PADDING)

	local label = RichTextLabel()
	label:setSize(size, size)
	label:setPosition(padding, padding)
	label:setStyle(RichTextLabelStyle(self.SPIRAL_INNER_PANEL_LABEL_STYLE, self:getView():getResources()))

	local innerPanel = menu:getInnerPanel()
	innerPanel:setData("label", label)
	innerPanel:addChild(label)

	return menu
end

function GamepadCombatHUD:newMenuButton(_, name)
	local button = self:newSpiralButton()
	button:setData("name", name)

	return button
end

function GamepadCombatHUD:updateMenuButton(name, button)
	local icon = button:getData("icon")
	local panel = button:getData("panel")

	local isEnabled = self:isEnabled(name)
	if isEnabled or panel:getData("enabled") then
		icon:setColor(self.ICON_ENABLED_COLOR)
		panel:setOutlineColor(panel:getData("currentColor") or self.CIRCLE_PANEL_ENABLED_COLOR)
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
		self.pendingPowerIcon:setSize(icon:getSize())
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

function GamepadCombatHUD:finishPowerThingies(name, thingiesWidget)
	self:finishSpiralMenu(name, thingiesWidget)
end

function GamepadCombatHUD:update(delta)
	BaseCombatHUD.update(self, delta)
end

return GamepadCombatHUD
