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
local Config = require "ItsyScape.Game.Config"
local Weapon = require "ItsyScape.Game.Weapon"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Drawable = require "ItsyScape.UI.Drawable"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local RichTextLabel = require "ItsyScape.UI.RichTextLabel"
local RichTextLabelStyle = require "ItsyScape.UI.RichTextLabelStyle"
local SpiralLayout = require "ItsyScape.UI.SpiralLayout"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local BaseCombatHUD = require "ItsyScape.UI.Interfaces.BaseCombatHUD"
local GamepadCirclePanel = require "ItsyScape.UI.Interfaces.Components.GamepadCirclePanel"
local PendingPowerIcon = require "ItsyScape.UI.Interfaces.Components.PendingPowerIcon"
local RechargingPowerBar = require "ItsyScape.UI.Interfaces.Components.RechargingPowerBar"

local GamepadCombatHUD = Class(BaseCombatHUD)

GamepadCombatHUD.StandardInterfaceContainer = Class(Widget)

function GamepadCombatHUD.StandardInterfaceContainer:getOverflow()
	return true
end

GamepadCombatHUD.SPIRAL_OFFSET             = 32
GamepadCombatHUD.SPIRAL_OUTER_RADIUS       = 192
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
GamepadCombatHUD.CIRCLE_PANEL_ACTIVE_COLOR   = Color.fromHexString("00ff00", 0.5)
GamepadCombatHUD.ICON_ENABLED_COLOR          = Color.fromHexString("ffffff")
GamepadCombatHUD.ICON_DISABLED_COLOR         = Color.fromHexString("333333")

GamepadCombatHUD.STANDARD_INTERFACE_TITLE_WIDTH = 96
GamepadCombatHUD.STANDARD_INTERFACE_TITLE_HEIGHT = 48

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
	textFontSize = 16,

	headerFont = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	headerFontSize = 22
}

GamepadCombatHUD.SPIRAL_INNER_PANEL_BUTTON_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Regular.ttf",
	fontSize = 32,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

GamepadCombatHUD.RITE_TIER_NAMES = {
	"I",
	"II",
	"III",
	"IV"
}

GamepadCombatHUD.STANCE_DESCRIPTIONS = {
	[Weapon.STANCE_CONTROLLED] = {
		title = "Controlled",
		description = {
			"Go with the flow and respond to any situation.",
			"Both rites of malice and bulwark are at your disposal.",
			"Earn $ATTACK_SKILL XP for slain foes."
		}
	},
	[Weapon.STANCE_AGGRESSIVE] = {
		title = "Aggressive",
		description = {
			"Tap into your fury and increase your damage.",
			"Only rites of malice can be invoked.",
			"Earn $STRENGTH_SKILL XP for slain foes."
		}
	},
	[Weapon.STANCE_DEFENSIVE] = {
		title = "Defensive",
		description = {
			"Focus on dodging your foe to decrease damage taken.",
			"Only rites of bulwark can be invoked.",
			"Earn $DEFENSE_SKILL XP for slain foes."
		}
	}
}

GamepadCombatHUD.STANCE_SKILL_XP = {
	[Weapon.STYLE_MAGIC] = {
		ATTACK_SKILL = "Magic",
		STRENGTH_SKILL = "Wisdom",
		DEFENSE_SKILL = "Defense"
	},
	[Weapon.STYLE_ARCHERY] = {
		ATTACK_SKILL = "Archery",
		STRENGTH_SKILL = "Dexterity",
		DEFENSE_SKILL = "Defense"
	},
	[Weapon.STYLE_MELEE] = {
		ATTACK_SKILL = "Attack",
		STRENGTH_SKILL = "Strength",
		DEFENSE_SKILL = "Defense"
	}
}

function GamepadCombatHUD:new(...)
	self.thingiesAngles = {}
	self.thingiesStack = {}
	self.thingiesProperties = {}

	BaseCombatHUD.new(self, ...)

	self:setData(GamepadSink, GamepadSink())

	self:_initCommon()
end

function GamepadCombatHUD:restoreFocus()
	if not self:getIsShowing() then
		return false
	end

	self:focusChild(self:getMenu())
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
			panel:setData("currentColor", Color(self.CIRCLE_PANEL_ACTIVE_COLOR:get()))
			panel:setOutlineColor(self.CIRCLE_PANEL_ACTIVE_COLOR)
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

function GamepadCombatHUD:_newBackIcon()
	local icon = Icon()
	icon:setIcon("Resources/Game/UI/Icons/Controllers/PlayStation/button_b.png")
	icon:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	return icon
end

function GamepadCombatHUD:_newMenuActionIcon()
	local icon = Icon()
	icon:setIcon("Resources/Game/UI/Icons/Controllers/PlayStation/button_x.png")
	icon:setSize(self.DEFAULT_ICON_SIZE, self.DEFAULT_ICON_SIZE)
	return icon
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
		self:focusChild(thingiesWidget)
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

		self:focusChild(menu, "select")

		if self.thingiesAngles[self.FEATURE_MENU] then
			menu:setCurrentAngle(self.thingiesAngles[self.FEATURE_MENU])
		end

		self:layoutSpiralMenu(menu)
		self:updateStandardThingiesInterface(menu)
	end
end

function GamepadCombatHUD:clear()
	while #self.thingiesStack > 0 do
		self:back()
	end
end

function GamepadCombatHUD:back()
	if #self.thingiesStack == 0 then
		return false
	end

	local top = table.remove(self.thingiesStack)
	if top == self.FEATURE_MENU then
		self:hide()
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

function GamepadCombatHUD:toggle(open)
	open = open == nil and not self:getIsShowing() or open

	if not open and self:getIsShowing() then
		self:clear()
		self:hide()
	elseif open and not self:getIsShowing() then
		self:show()
	end
end

function GamepadCombatHUD:flee()
	local didFlee = BaseCombatHUD.flee(self)

	if didFlee and self:getIsShowing() then
		self:toggle()
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
	self:updateStandardThingiesInterface(spiralMenu)

	self:focusChild(spiralMenu, "select")
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

function GamepadCombatHUD:addSpiralMenuRichTextLabel(menu)
	local size = math.sqrt(2) * self.SPIRAL_INNER_PANEL_RADIUS - self.PADDING * 2
	local padding = math.floor(self.SPIRAL_INNER_PANEL_RADIUS - size / 2 + self.PADDING)

	local label = RichTextLabel()
	label:setSize(size, size)
	label:setPosition(padding, padding)
	label:setStyle(RichTextLabelStyle(self.SPIRAL_INNER_PANEL_LABEL_STYLE, self:getView():getResources()))

	local innerPanel = menu:getInnerPanel()
	innerPanel:setData("label", label)
	innerPanel:addChild(label)
end

function GamepadCombatHUD:addStandardThingiesInterface(menu, getDataCallback)
	local shadowLabel = RichTextLabel()
	shadowLabel:setStyle(RichTextLabelStyle(self.SPIRAL_INNER_PANEL_LABEL_STYLE, self:getView():getResources()))
	shadowLabel:setSize(self.STANDARD_INTERFACE_TITLE_WIDTH, 0)
	shadowLabel:setWrapContents(true)
	shadowLabel:setPosition(-self.STANDARD_INTERFACE_TITLE_WIDTH + 2, -self.STANDARD_INTERFACE_TITLE_HEIGHT + 2)

	local label = RichTextLabel()
	label:setStyle(RichTextLabelStyle(self.SPIRAL_INNER_PANEL_LABEL_STYLE, self:getView():getResources()))
	label:setSize(self.STANDARD_INTERFACE_TITLE_WIDTH, 0)
	label:setWrapContents(true)
	label:setPosition(-self.STANDARD_INTERFACE_TITLE_WIDTH, -self.STANDARD_INTERFACE_TITLE_HEIGHT)

	local icon = Icon()
	icon:setSize(self.STANDARD_INTERFACE_TITLE_HEIGHT, self.STANDARD_INTERFACE_TITLE_HEIGHT)
	icon:setPosition(
		-self.STANDARD_INTERFACE_TITLE_WIDTH - self.STANDARD_INTERFACE_TITLE_HEIGHT - self.PADDING,
		-self.STANDARD_INTERFACE_TITLE_HEIGHT - (self.STANDARD_INTERFACE_TITLE_HEIGHT / 2 - self.SPIRAL_INNER_PANEL_LABEL_STYLE.headerFontSize))

	local backToolTip = GamepadToolTip()
	backToolTip:setHasBackground(false)
	backToolTip:setButtonID(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "b")
	backToolTip:setText("Back")
	backToolTip:setPosition(self.SPIRAL_OUTER_RADIUS + self.DEFAULT_ICON_SIZE * 2, -self.STANDARD_INTERFACE_TITLE_HEIGHT)

	local menuActionToolTip = GamepadToolTip()
	menuActionToolTip:setHasBackground(false)
	menuActionToolTip:setButtonID(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "x")
	menuActionToolTip:setPosition(self.SPIRAL_OUTER_RADIUS + self.DEFAULT_ICON_SIZE * 2 + self.STANDARD_INTERFACE_TITLE_HEIGHT, self.PADDING)

	local container = GamepadCombatHUD.StandardInterfaceContainer()
	container:addChild(shadowLabel)
	container:addChild(label)
	container:addChild(icon)
	container:addChild(backToolTip)
	container:setData("shadowLabel", shadowLabel)
	container:setData("label", label)
	container:setData("icon", icon)
	container:setData("menuActionToolTip", menuActionToolTip)
	container:setData("getDataCallback", getDataCallback)

	local innerPanel = menu:getInnerPanel()
	innerPanel:setData("standardInterface", container)
	innerPanel:addChild(container)
end

function GamepadCombatHUD:updateStandardThingiesInterface(menu)
	local innerPanel = menu:getInnerPanel()
	local container = innerPanel:getData("standardInterface")
	if not container then
		return
	end

	local getDataCallback = container:getData("getDataCallback")
	if not getDataCallback then
		return
	end

	local data = getDataCallback(self, menu:getData("name"), menu)
	if not data then
		return
	end

	local icon = container:getData("icon")
	icon:setIcon(data.icon)

	local shadowLabel = container:getData("shadowLabel")
	shadowLabel:setText({
		{ t = "header", color = { 0, 0, 0, 1 }, data.titleText or "" },
		{ t = "text", color = { 0, 0, 0, 1 }, data.subtitleText or "" }
	})

	local label = container:getData("label")
	label:setText({
		{ t = "header", data.titleText or "" },
		{ t = "text", data.subtitleText or "" }
	})

	local menuActionToolTip = container:getData("menuActionToolTip")
	if data.menuActionText then
		menuActionToolTip:setText(data.menuActionText)

		if menuActionToolTip:getParent() ~= container then
			container:addChild(menuActionToolTip)
		end
	else
		if menuActionToolTip:getParent() == container then
			container:removeChild(menuActionToolTip)
		end
	end
end

function GamepadCombatHUD:newSpiralMenu(name)
	local spiralMenu = SpiralLayout()
	spiralMenu:setSize(
		self.SPIRAL_OUTER_RADIUS * 2 + self.SELECTED_BUTTON_SIZE,
		self.SPIRAL_OUTER_RADIUS * 2 + self.SELECTED_BUTTON_SIZE)
	spiralMenu:setData("name", name)
	spiralMenu:setRadius(self.SPIRAL_INNER_RADIUS, self.SPIRAL_OUTER_RADIUS)
	spiralMenu:setData(GamepadSink, GamepadSink({ isBlockingCamera = false }))

	local circlePanel = GamepadCirclePanel()
	circlePanel:enable()

	spiralMenu:getInnerPanel():setSize(
		self.SPIRAL_INNER_PANEL_RADIUS * 2,
		self.SPIRAL_INNER_PANEL_RADIUS * 2)
	spiralMenu:getInnerPanel():setPosition(
		-self.SPIRAL_OUTER_RADIUS / 2,
		-self.SPIRAL_OUTER_RADIUS / 2)
	spiralMenu:getInnerPanel():addChild(circlePanel)

	spiralMenu.onGamepadRelease:register(self.onSpiralMenuGamepadButtonRelease, self, name)

	return spiralMenu
end

function GamepadCombatHUD:finishSpiralMenu(name, spiralMenu)
	local numRemaining = spiralMenu:getNumRemainingOptions()

	for i = 1, numRemaining do
		local button = self:newSpiralButton()
		button:setData("isDisabled", true)

		local panel = button:getData("panel")
		panel:setOutlineColor(self.CIRCLE_PANEL_DISABLED_COLOR)

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

		local additionalDescription
		if name == self.THINGIES_DEFENSIVE_POWERS and not self:isEnabled(name) then
			additionalDescription = { t = "text", color = { 1, 0, 0, 1 }, "Your current stance prohibits rites of bulwark." }
		elseif name == self.THINGIES_OFFENSIVE_POWERS and not self:isEnabled(name) then
			additionalDescription = { t = "text", color = { 1, 0, 0, 1 }, "Your current stance prohibits rites of malice." }
		end

		local color
		if not self:isEnabled(name) then
			color = Color(0.5)
		else
			color = Color(1)
		end

		local label = innerPanel:getData("label")
		label:setText({
			{ t = "header", color = { color:get() }, self:getThingiesName(name) },
			{ t = "text", color = { color:get() }, self:getThingiesDescription(name) },
			additionalDescription
		})
	end
end

function GamepadCombatHUD:_updateMenuInterface()
	local result = {
		titleText = "Ring",
		icon = "Resources/Game/UI/Icons/Logo.png"
	}

	return result
end

function GamepadCombatHUD:newMenu()
	local menu = self:newSpiralMenu("main")
	menu:getInnerPanel():setID("GamepadCombatHUD-Menu")
	menu.onChildVisible:register(self._onMenuOptionVisible, self)
	menu.onChildSelected:register(self._onMenuOptionSelected, self)

	self:addSpiralMenuRichTextLabel(menu)
	self:addStandardThingiesInterface(menu, self._updateMenuInterface)

	return menu
end

function GamepadCombatHUD:newMenuButton(_, name)
	local button = self:newSpiralButton()
	button:setData("name", name)

	local icon = button:getData("icon")
	if name == self.THINGIES_FLEE then
		icon:setIcon("Resources/Game/UI/Icons/Concepts/Flee.png")
	elseif name == self.THINGIES_FOOD then
		icon:setIcon("Resources/Game/UI/Icons/Skills/Constitution.png")
	elseif name == self.THINGIES_PRAYERS then
		icon:setIcon("Resources/Game/UI/Icons/Skills/Faith.png")
	elseif name == self.THINGIES_EQUIPMENT then
		icon:setIcon("Resources/Game/UI/Icons/Common/Equipment.png")
	end

	return button
end

function GamepadCombatHUD:finishMenu(menu)
	menu:setNumVisibleOptions(menu:getNumOptions())
end

function GamepadCombatHUD:updateMenuButton(name, button)
	local icon = button:getData("icon")
	local panel = button:getData("panel")

	local isEnabled = self:isEnabled(name)

	if isEnabled or panel:getData("enabled") then
		button:unsetData("isDisabled")
		icon:setColor(self.ICON_ENABLED_COLOR)
		panel:setOutlineColor(panel:getData("currentColor") or self.CIRCLE_PANEL_ENABLED_COLOR)
	else
		button:setData("isDisabled", true)
		icon:setColor(self.ICON_DISABLED_COLOR)
		panel:setOutlineColor(self.CIRCLE_PANEL_DISABLED_COLOR)
	end
end

function GamepadCombatHUD:newPowerButton()
	local button = self:newSpiralButton()

	local rechargeBar = RechargingPowerBar()
	button:setData("recharge", rechargeBar)

	return button
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

	local rechargeBar = button:getData("recharge")
	rechargeBar:updateRecharge(powerState.pending, powerState.zeal)

	local buttonWidth, buttonHeight = button:getSize()
	rechargeBar:setPosition(self.PADDING, buttonHeight - 8 - self.PADDING)
	rechargeBar:setSize(buttonWidth - self.PADDING * 2, 8)

	if rechargeBar:getParent() ~= button then
		button:addChild(rechargeBar)
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

function GamepadCombatHUD:_onPowerSelected(menu, current)
	if not current then
		return
	end

	local index = menu:getFocusedOptionIndex()

	local stateKey
	do
		local name = menu:getData("name")
		if name == self.THINGIES_OFFENSIVE_POWERS then
			stateKey = "offensive"
		elseif name == self.THINGIES_DEFENSIVE_POWERS then
			stateKey = "defensive"
		end
	end

	local state = self:getState()
	local powersState = state.powers[stateKey]
	if not powersState then
		return
	end

	local innerPanel = menu:getInnerPanel()
	local label = innerPanel:getData("label")

	local powerState = powersState[index]
	if not powerState then
		label:setText({
			{ t = "header", color = { 0.4, 0.4, 0.4, 1.0 }, "Nothing" },
			{ t = "text", color = { 0.4, 0.4, 0.4, 1.0 }, "Unlock more rites as you level up and explore!" }
		})
	else
		local tier = powerState.tier
		local zeal = powerState.zeal
		local name = powerState.name
		local description = powerState.description

		local colorName = string.format("ui.combat.zeal.tier%dFire", tier)
		local color = Color.fromHexString(Config.get("Config", "COLOR", "color", colorName)):shiftHSL(0, 0, 0.2)

		label:setText({
			{ t = "header", powerState.name },
			{ t = "text", color = { color:get() }, string.format("A tier %s rite. Consumes %d%% zeal.", self.RITE_TIER_NAMES[tier] or tier, zeal * 100) },
			unpack(description)
		})
	end
end

function GamepadCombatHUD:_updatePowersThingiesInterface(name)
	local result = { titleText = self:getThingiesName(name) }

	if name == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS then
		result.icon = "Resources/Game/UI/Icons/Concepts/Powers.png"
	elseif name == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS then
		result.icon = "Resources/Game/UI/Icons/Skills/Defense.png"
	end

	return result
end

function GamepadCombatHUD:newPowerThingies(name, powersState)
	local powersSpiral = self:newSpiralMenu(name)
	powersSpiral.onChildVisible:register(self._onPowerVisible, self)
	powersSpiral.onChildSelected:register(self._onPowerSelected, self)

	self:addSpiralMenuRichTextLabel(powersSpiral)
	self:addStandardThingiesInterface(powersSpiral, self._updatePowersThingiesInterface)

	return powersSpiral
end

function GamepadCombatHUD:finishPowerThingies(name, thingiesWidget)
	self:finishSpiralMenu(name, thingiesWidget)
end

function GamepadCombatHUD:_onFoodVisible(_, child, delta)
	self:layoutSpiralButton(child, delta)
end

function GamepadCombatHUD:_onFoodSelected(menu, current)
	if not current then
		return
	end

	local index = menu:getFocusedOptionIndex()

	local state = self:getState()
	local foodState = state.food[index]

	local innerPanel = menu:getInnerPanel()
	local label = innerPanel:getData("label")

	if not foodState then
		label:setText({
			{ t = "header", color = { 0.4, 0.4, 0.4, 1.0 }, "Nothing" },
			{ t = "text", color = { 0.4, 0.4, 0.4, 1.0 }, "Gather and cook more food!" }
		})
	else
		local healColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.health.hitpoints")):shiftHSL(0, 0, 0.2)
		local damageColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.health.damage")):shiftHSL(0, 0, 0.2)

		local text, color 
		if foodState.health == 0 then
			text = "Heals 0 hitpoints."
			color = damageColor
		elseif foodState.health < 0 then
			text = string.format("Damages %d hitpoints.", math.abs(foodState.health))
			color = damageColor
		else
			text = string.format("Heals %d hitpoints.", foodState.health)
			color = healColor
		end

		label:setText({
			{ t = "header", foodState.name },
			{ t = "text", color = { color:get() }, text },
			foodState.description
		})
	end
end

function GamepadCombatHUD:_updateFoodThingiesInterface(name)
	local result = {
		titleText = self:getThingiesName(name),
		icon = "Resources/Game/UI/Icons/Skills/Constitution.png"
	}

	return result
end

function GamepadCombatHUD:newFoodThingies(name)
	local foodSpiral = self:newSpiralMenu(name)
	foodSpiral.onChildVisible:register(self._onFoodVisible, self)
	foodSpiral.onChildSelected:register(self._onFoodSelected, self)

	self:addSpiralMenuRichTextLabel(foodSpiral)
	self:addStandardThingiesInterface(foodSpiral, self._updateFoodThingiesInterface)

	return foodSpiral
end

function GamepadCombatHUD:newFoodButton(foodState)
	local button = self:newSpiralButton()

	local itemIcon = ItemIcon()
	button:addChild(itemIcon)

	button:removeChild(button:getData("icon"))
	button:setData("icon", itemIcon)

	return button
end

function GamepadCombatHUD:updateFoodButton(button, foodState)
	local icon = button:getData("icon")
	icon:setItemID(foodState.id)
	icon:setItemCount(foodState.count)
end

function GamepadCombatHUD:finishFoodThingies(name, spiralMenu)
	self:finishSpiralMenu(name, spiralMenu)
end

function GamepadCombatHUD:getStanceInfo(style, stance)
	if not style or not stance then
		return "???", {}
	end

	local input = self.STANCE_DESCRIPTIONS[stance]
	if not input then
		return "???", {}
	end

	local skills = self.STANCE_SKILL_XP[style]
	if not skills then
		return "???", {}
	end

	local description = {}
	for i = 1, #input.description do
		local d = input.description[i]:gsub("%$([^%s]+)", skills)
		table.insert(description, d)
	end

	return input.title, description
end

function GamepadCombatHUD:_onStanceVisible(_, child, delta)
	self:layoutSpiralButton(child, delta)
end

function GamepadCombatHUD:_onStanceSelected(menu, current)
	if not current then
		return
	end

	local index = menu:getFocusedOptionIndex()

	local state = self:getState()
	local stance = current:getData("stance")

	local innerPanel = menu:getInnerPanel()
	local label = innerPanel:getData("label")

	local currentStyle = self:getState().style

	local title, description = self:getStanceInfo(currentStyle, stance)

	if not stance then
		label:setText({
			{ t = "header", color = { 0.4, 0.4, 0.4, 1.0 }, "Nothing" },
			{ t = "text", color = { 0.4, 0.4, 0.4, 1.0 }, "Maybe there will be more stances in the future..." }
		})
	else
		label:setText({
			{ t = "header", title },
			unpack(description)
		})
	end
end

function GamepadCombatHUD:_updateStanceThingiesInterface(name)
	local result = {
		titleText = self:getThingiesName(name),
		icon = "Resources/Game/UI/Icons/Common/Stance.png"
	}

	return result
end

function GamepadCombatHUD:newStanceThingies(name)
	local stanceSpiral = self:newSpiralMenu(name)
	stanceSpiral.onChildVisible:register(self._onStanceVisible, self)
	stanceSpiral.onChildSelected:register(self._onStanceSelected, self)

	self:addSpiralMenuRichTextLabel(stanceSpiral)
	self:addStandardThingiesInterface(stanceSpiral, self._updateStanceThingiesInterface)

	return stanceSpiral
end

function GamepadCombatHUD:newStanceButton(foodState)
	return self:newSpiralButton()
end

function GamepadCombatHUD:updateStanceButton(button, stance, combatStyle, isActive)
	button:setData("stance", stance)

	local icon = button:getData("icon")
	icon:setIcon((self.COMBAT_STANCE_ICONS[combatStyle] or self.COMBAT_STANCE_ICONS[Weapon.STYLE_MELEE])[stance])

	local panel = button:getData("panel")
	if isActive then
		panel:setOutlineColor(self.CIRCLE_PANEL_ACTIVE_COLOR)
		panel:setData("enabled", true)
		panel:enable()
	else
		panel:unsetData("enabled")
		panel:setOutlineColor(self.CIRCLE_PANEL_ENABLED_COLOR)

		if not button:getIsFocused() then
			panel:disable()
		end
	end
end

function GamepadCombatHUD:finishStanceThingies(name, spiralMenu)
	self:finishSpiralMenu(name, spiralMenu)
end

function GamepadCombatHUD:refreshThingies()
	BaseCombatHUD.refreshThingies(self)

	if #self.thingiesStack >= 1 then
		local current = self.thingiesStack[#self.thingiesStack]
		if current == self.FEATURE_MENU then
			self:openMenu()
			self:focusChild(self:getMenu())
		else
			self:openThingies(current)
		end
	end
end

function GamepadCombatHUD:update(delta)
	BaseCombatHUD.update(self, delta)
end

return GamepadCombatHUD
