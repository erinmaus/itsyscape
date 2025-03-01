--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/BaseCombatHUD.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"
local Widget = require "ItsyScape.UI.Widget"
local Particles = require "ItsyScape.UI.Particles"
local CombatTarget = require "ItsyScape.UI.Interfaces.Components.CombatTarget"

local BaseCombatHUD = Class(Interface)
BaseCombatHUD.PADDING = 8

BaseCombatHUD.THINGIES_STANCE           = "stance"
BaseCombatHUD.THINGIES_OFFENSIVE_POWERS = "offense"
BaseCombatHUD.THINGIES_DEFENSIVE_POWERS = "defense"
BaseCombatHUD.THINGIES_FOOD             = "food"
BaseCombatHUD.THINGIES_PRAYERS          = "prayers"
BaseCombatHUD.THINGIES_SPELLS           = "spells"
BaseCombatHUD.THINGIES_EQUIPMENT        = "equipment"
BaseCombatHUD.THINGIES_FLEE             = "flee"
BaseCombatHUD.FEATURE_HITPOINTS         = "hitpoints"
BaseCombatHUD.FEATURE_ZEAL              = "zeal"
BaseCombatHUD.FEATURE_EFFECTS           = "effects"

BaseCombatHUD.MENU_BUTTONS = {
	BaseCombatHUD.THINGIES_STANCE,
	BaseCombatHUD.THINGIES_OFFENSIVE_POWERS,
	BaseCombatHUD.THINGIES_DEFENSIVE_POWERS,
	BaseCombatHUD.THINGIES_FOOD,
	BaseCombatHUD.THINGIES_PRAYERS,
	BaseCombatHUD.THINGIES_SPELLS,
	BaseCombatHUD.THINGIES_EQUIPMENT,
	BaseCombatHUD.THINGIES_FLEE
}

function BaseCombatHUD:new(...)
	Interface.new(self, ...)

	self.playerInfo = CombatTarget("left", self:getView():getResources())
	self.playerInfo:setZDepth(1)

	self.targetInfo = CombatTarget("right", self:getView():getResources())
	self.targetInfo:setZDepth(0.5)

	self.thingies = {}
	self.thingiesButtons = {}
	self.openedThingies = {}

	self:performLayout()
end

function BaseCombatHUD:isEnabled(name)
	local state = self:getState()
	local config = state.config
	return not config or not config.disabled or config.disabled[name] == nil
end

function BaseCombatHUD:hasThingies(name)
	return self.thingies[name] ~= nil
end

function BaseCombatHUD:isThingiesOpen(name)
	return self.openedThingies[name] == true
end

function BaseCombatHUD:getThingiesWidget(name)
	return self.thingies[name] and self.thingies[name].widget
end

function BaseCombatHUD:getThingiesButton(name)
	return self.thingiesButtons[name]
end

function BaseCombatHUD:openThingies(name, targetWidget)
	if not self:hasThingies(name) then
		return false
	end

	if not self:isThingiesOpen() then
		self.openedThingies[name] = true
		return true
	end

	return false
end

function BaseCombatHUD:closeThingies(name)
	if not self:isThingiesOpen(name) then
		return
	end

	local thingies = self.thingies[name]
	if not thingies then
		return false
	end

	if not thingies.widget:getParent() then
		return false
	end

	thingies.widget:getParent():removeChild(thingies.widget)
	self.openedThingies[name] = nil

	return true
end

function BaseCombatHUD:focusThingies(name)
	if self:isThingiesOpen(name) then
		local thingiesWidget = self:getThingiesWidget()
		self:focus(thingiesWidget, "select")
	end
end

function BaseCombatHUD:selectThingies(name, target)
	target = target or self:getThingiesButton(name)

	if self:isThingiesOpen(name) then
		self:closeThingies(name)
	else
		self:openThingies(name, target)
	end

	return self:isThingiesOpen(name)
end

function BaseCombatHUD:registerThingies(name)
	-- Nothing.
end

function BaseCombatHUD:unregisterThingies(name)
	-- Nothing.
end

function BaseCombatHUD:_unregisterThingies(name)
	self:unregisterThingies(name)
	self:closeThingies(name)
	self.thingies[name] = nil
end

function BaseCombatHUD:_registerThingies(name, thingies)
	self.thingies[name] = thingies
	self:registerThingies(name)

	if self:isThingiesOpen(name) then
		self.openedThingies[name] = nil
		self:openThingies(name, self:getThingiesButton(name))
	end
end

function BaseCombatHUD:newMenu()
	return Class.ABSTRACT()
end

function BaseCombatHUD:newMenuButton(name)
	return Class.ABSTRACT()
end

function BaseCombatHUD:_newMenuButton(menu, name)
	local button = self:newMenuButton(menu, name)
	button:setID(string.format("BaseCombatHUD-%s", name))

	menu:addChild(button)
	self.thingiesButtons[name] = button

	button.onClick:register(self.selectThingies, self, name)
end

function BaseCombatHUD:_createMenu()
	local menu = self:newMenu()

	for i, name in ipairs(self.MENU_BUTTONS) do
		self:_newMenuButton(menu, name)
	end

	self.menu = menu
end

function BaseCombatHUD:newPowerButton(powerState)
	return Class.ABSTRACT()
end

function BaseCombatHUD:updatePowerButton(button, powerState, isPending)
	Class.ABSTRACT()
end

function BaseCombatHUD:newPowerThingies(name, powersState)
	return Class.ABSTRACT()
end

function BaseCombatHUD:_initPowersThingies(name, powersState)
	self:_unregisterThingies(name)

	local stateKey
	if name == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS then
		stateKey = "offensive"
	elseif name == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS then
		stateKey = "defensive"
	else
		return
	end

	local state = self:getState()
	local powersState = state.powers[stateKey]
	local pendingPowerID = state.powers.pendingID

	local powersThingie = { buttons = {} }
	powersThingie.widget = self:newPowerThingies(name, powersState)

	for i, powerState in ipairs(powersState) do
		local button = self:newPowerButton(powerState)
		button.onClick:register(self.onActivateDefensivePower, self, i)

		powersThingie.widget:addChild(button)
		table.insert(powersThingie.buttons, button)
	end

	self:_registerThingies(name, powersThingie)
end

function BaseCombatHUD:_updatePowersThingies(name)
	local stateKey
	if name == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS then
		stateKey = "offensive"
	elseif name == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS then
		stateKey = "defensive"
	else
		return
	end

	local state = self:getState()
	local powersState = state.powers[stateKey]
	local pendingPowerID = state.powers.pendingID

	for i, powerState in ipairs(powersState) do
		local button = self.defensivePowersButtons[i]
		if button then
			self:updatePowerButton(button, powerState, powerState.id == pendingID)
			button:setID(string.format("BaseCombatHUD-Power-%s", powerState.id))
		end
	end
end

function BaseCombatHUD:updateThingies()
	self:_updatePowersThingies(BaseCombatHUD.THINGIES_OFFENSIVE_POWERS)
	self:_updatePowersThingies(BaseCombatHUD.THINGIES_DEFENSIVE_POWERS)
end

function BaseCombatHUD:refreshThingies()
	self:_initPowersThingies(BaseCombatHUD.THINGIES_OFFENSIVE_POWERS)
	self:_initPowersThingies(BaseCombatHUD.THINGIES_DEFENSIVE_POWERS)

	self:performLayout()
end

function BaseCombatHUD:getOverflow()
	return true
end

function BaseCombatHUD:performLayout()
	Interface.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()

	local playerWidth = self.playerInfo:getRowSize()
	self.playerInfo:setPosition(w / 2 - playerWidth - self.PADDING / 2, 0)

	local targetWidth = self.playerInfo:getRowSize()
	self.targetInfo:setPosition(w / 2 + self.PADDING / 2, 0)

	self.isShowing = false
end

function BaseCombatHUD:_toggleInfo(enabled, info)
	if enabled and not info:getParent() then
		self:addChild(info)
	elseif not enabled and info:getParent() then
		info:getParent():removeChild(info)
	end
end

function BaseCombatHUD:togglePlayerInfo(enabled)
	self:_toggleInfo(enabled, self.playerInfo)
end

function BaseCombatHUD:toggleTargetInfo(enabled)
	self:_toggleInfo(enabled, self.targetInfo)
end

function BaseCombatHUD:getMenu()
	return self.menu
end

function BaseCombatHUD:openMenu()
	if not self.menu then
		self:_createMenu()
	end

	if self.menu:getParent() == self then
		return false
	end

	self:addChild(self.menu)
	return true
end

function BaseCombatHUD:closeMenu()
	if not self.menu then
		return false
	end

	if self.menu:getParent() ~= self then
		return false
	end

	self:removeChild(self.menu)
	return true
end

function BaseCombatHUD:show()
	if not self.isShowing then
		self:openMenu()
	end

	self.isShowing = true
end

function BaseCombatHUD:hide()
	if self.isShowing then
		self:closeMenu()
	end

	self.isShowing = false
end

function BaseCombatHUD:getIsShowing()
	return self.isShowing
end

function BaseCombatHUD:update(delta)
	Interface.update(self, delta)

	local showPlayer = self:getIsShowing()
	local showTarget = false

	local state = self:getState()
	if #state.combatants > 1 then
		showPlayer = true

		local playerState = state.player
		self.playerInfo:updateTarget(playerState)

		for _, combatantState in ipairs(state.combatants) do
			if combatantState.actorID == playerState.targetID then
				showTarget = true
				self.targetInfo:updateTarget(combatantState)
				break
			end
		end
	end

	self:togglePlayerInfo(showPlayer)
	self:toggleTargetInfo(showTarget)
end

return BaseCombatHUD
