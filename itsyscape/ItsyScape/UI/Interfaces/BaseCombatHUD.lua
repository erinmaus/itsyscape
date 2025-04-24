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
local Weapon = require "ItsyScape.Game.Weapon"
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

BaseCombatHUD.FEATURE_MENU              = "menu"
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

BaseCombatHUD.THINGIES_DESCRIPTIONS = {
	[BaseCombatHUD.THINGIES_STANCE] = {
		name = "Stance",
		description = "Affects the damage you give and take and what rites you can use."
	},
	[BaseCombatHUD.THINGIES_OFFENSIVE_POWERS] = {
		name = "Rites of Malice",
		description = "Special attacks that deal damage and have other effects."
	},
	[BaseCombatHUD.THINGIES_DEFENSIVE_POWERS] = {
		name = "Rites of Bulwark",
		description = "Special maneuvers that reduce damage and have other effects."
	},
	[BaseCombatHUD.THINGIES_FOOD] = {
		name = "Healing",
		description = "Food and other items that heal."
	},
	[BaseCombatHUD.THINGIES_PRAYERS] = {
		name = "Prayers",
		description = "Buffs powered by Faith."
	},
	[BaseCombatHUD.THINGIES_SPELLS] = {
		name = "Spells",
		description = "Alternative attacks for magic weapons."
	},
	[BaseCombatHUD.THINGIES_EQUIPMENT] = {
		name = "Equipment",
		description = "Quickly change equipment."
	},
	[BaseCombatHUD.THINGIES_FLEE] = {
		name = "Yield",
		description = "Yield to your foe. Stops attacking."
	}
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
	self.isShowing = false

	self.currentPendingPowerType = false
	self.currentPendingPowerID = false
	self.currentCombatStyle = false
	self.currentStance = false
	self.currentSpellID = false

	self.pendingSprites = {}

	self.wasRefreshed = false

	self:performLayout()

	self.onClose:register(self.flushSprites, self)
end

function BaseCombatHUD:flushSprites()
	for _, pendingActorInfo in pairs(self.pendingSprites) do
		if pendingActorInfo.powerSprite then
			pendingActorInfo.powerSprite:finish()
		end

		if pendingActorInfo.attackSprite then
			pendingActorInfo.attackSprite:finish()
		end
	end
end

function BaseCombatHUD:onSelectPendingPower(powerType, pendingPowerID)
	-- Nothing.
end

function BaseCombatHUD:onClearPendingPower(powerType, pendingPowerID)
	-- Nothing.
end

function BaseCombatHUD:onSwitchCombatStyle(oldCombatStyle, newCombatStyle)
	-- Nothing.
end

function BaseCombatHUD:onSwitchStance(oldStance, newStance)
	-- Nothing.
end

function BaseCombatHUD:onSwitchSpell(oldSpell, newSpell)
	-- Nothing.
end

function BaseCombatHUD:activateDefensivePower(index)
	self:sendPoke("activateDefensivePower", nil, {
		index = index
	})
end

function BaseCombatHUD:activateOffensivePower(index)
	self:sendPoke("activateOffensivePower", nil, {
		index = index
	})
end

function BaseCombatHUD:_getPowerType(powerID)
	local state = self:getState()

	for _, powerState in ipairs(state.powers.offensive) do
		if powerState.id == powerID then
			return BaseCombatHUD.THINGIES_OFFENSIVE_POWERS
		end
	end

	for _, powerState in ipairs(state.powers.defensive) do
		if powerState.id == powerID then
			return BaseCombatHUD.THINGIES_DEFENSIVE_POWERS
		end
	end

	return nil
end

function BaseCombatHUD:resetEvents()
	self.currentPendingPowerType = false
	self.currentPendingPowerID = false
	self.currentCombatStyle = false
	self.currentStance = false
	self.currentSpellID = false

	self:onClearPendingPower(BaseCombatHUD.THINGIES_OFFENSIVE_POWERS, false)
	self:onClearPendingPower(BaseCombatHUD.THINGIES_DEFENSIVE_POWERS, false)

	self:updateEvents()
end

function BaseCombatHUD:updateEvents()
	local state = self:getState()

	local activespellID = state.activeSpellID or false
	if state.activeSpellID ~= self.currentSpellID then
		self:onSwitchSpell(self.currentSpellID, state.activeSpellID)
		self.currentSpellID = state.activeSpellID
	end

	local powerID = state.powers.pendingID or false
	if state.powers.pendingID ~= self.currentPendingPowerID then
		local newPowerType = state.powers.pendingID and self:_getPowerType(state.powers.pendingID)

		if self.currentPendingPowerID then
			self:onClearPendingPower(self.currentPendingPowerType, self.currentPendingPowerID)
		end

		if powerID then
			self:onSelectPendingPower(newPowerType, powerID)
		end

		self.currentPendingPowerID = powerID
		self.currentPendingPowerType = newPowerType or false
	end

	local style = state.style or false
	if style ~= self.currentCombatStyle then
		self:onSwitchCombatStyle(self.currentCombatStyle, style)
		self.currentCombatStyle = style
	end

	local stance = state.stance or false
	if stance ~= self.currentCombatStance then
		self:onSwitchStance(self.currentCombatStance, stance)
		self.currentCombatStance = stance
	end
end

function BaseCombatHUD:isEnabled(name)
	local state = self:getState()
	local config = state.config
	local isEnabled = not config or not config.disabled or config.disabled[name] == nil

	if name == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS and state.stance == Weapon.STANCE_AGGRESSIVE then
		return false 
	end

	if name == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS and state.stance == Weapon.STANCE_DEFENSIVE then
		return false
	end

	return isEnabled
end

function BaseCombatHUD:hasThingies(name)
	return self.thingies[name] ~= nil
end

function BaseCombatHUD:isThingiesOpen(name)
	return self.openedThingies[name] == true
end

function BaseCombatHUD:_getThingies(name)
	return self.thingies[name]
end

function BaseCombatHUD:getThingiesName(name)
	local thingies = self.THINGIES_DESCRIPTIONS[name]
	return thingies and thingies.name or "???"
end

function BaseCombatHUD:getThingiesDescription(name)
	local thingies = self.THINGIES_DESCRIPTIONS[name]
	return thingies and thingies.description or "???"
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
		self:sendPoke("openThingies", nil, { name = name })
		return true
	end

	return false
end

function BaseCombatHUD:closeThingies(name)
	if not self:isThingiesOpen(name) then
		return false
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
	self:sendPoke("closeThingies", nil, { name = name })

	return true
end

function BaseCombatHUD:focusThingies(name)
	if self:isThingiesOpen(name) then
		local thingiesWidget = self:getThingiesWidget()
		self:focus(thingiesWidget, "select")
	end
end

function BaseCombatHUD:flee()
	local player = self:getView():getGame():getPlayer()
	if player:getIsEngaged() then
		player:flee()
		return true
	end

	return false
end

function BaseCombatHUD:selectThingies(name, target)
	if name == BaseCombatHUD.THINGIES_FLEE then	
		return self:flee()
	end

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

function BaseCombatHUD:finishMenu(menu)
	Class.ABSTRACT()
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

	self:finishMenu(menu)

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

function BaseCombatHUD:finishPowerThingies(name, thingiesWidget)
	Class.ABSTRACT()
end

function BaseCombatHUD:_getPowersStateKey(name)
	if name == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS then
		return "offensive"
	elseif name == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS then
		return "defensive"
	end

	return nil
end

function BaseCombatHUD:_initPowersThingies(name, powersState)
	self:_unregisterThingies(name)

	local stateKey = self:_getPowersStateKey(name)
	local callback
	if name == BaseCombatHUD.THINGIES_OFFENSIVE_POWERS then
		callback = self.activateOffensivePower
	elseif name == BaseCombatHUD.THINGIES_DEFENSIVE_POWERS then
		callback = self.activateDefensivePower
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
		button.onClick:register(callback, self, i)

		powersThingie.widget:addChild(button)
		table.insert(powersThingie.buttons, button)
	end

	self:finishPowerThingies(name, powersThingie.widget)
	self:_registerThingies(name, powersThingie)
end

function BaseCombatHUD:_updatePowersThingies(name)
	local stateKey = self:_getPowersStateKey(name)

	local state = self:getState()
	local powersState = state.powers[stateKey]
	local pendingPowerID = state.powers.pendingID
	local buttons = self:_getThingies(name).buttons

	for i, powerState in ipairs(powersState) do
		local button = buttons[i]
		if button then
			self:updatePowerButton(button, powerState, powerState.id == pendingPowerID)
			button:setID(string.format("BaseCombatHUD-Power-%s", powerState.id))
		end
	end
end

function BaseCombatHUD:newFoodThingies(name, foodState)
	return Class.ABSTRACT()
end

function BaseCombatHUD:newFoodButton(foodState)
	return Class.ABSTRACT()
end

function BaseCombatHUD:updateFoodButton(foodState, button)
	Class.ABSTRACT()
end

function BaseCombatHUD:finishFoodThingies(name, thingiesWidget)
	Class.ABSTRACT()
end

function BaseCombatHUD:eat(index)
	local state = self:getState()

	local foodState = state.food[index]
	if not foodState then
		return
	end

	local minKey = math.huge
	for _, key in ipairs(foodState.keys) do
		minKey = math.min(key, minKey)
	end

	if minKey < math.huge then
		self:sendPoke("eat", nil, {
			key = minKey
		})
	end
end

function BaseCombatHUD:_initFoodThingies()
	self:_unregisterThingies(BaseCombatHUD.THINGIES_FOOD)

	local state = self:getState()
	local foodState = state.food

	local foodThingie = { buttons = {} }
	foodThingie.widget = self:newFoodThingies(BaseCombatHUD.THINGIES_FOOD, foodState)

	for i, foodState in ipairs(foodState) do
		local button = self:newFoodButton(foodState)
		button.onClick:register(self.eat, self, i)

		foodThingie.widget:addChild(button)
		table.insert(foodThingie.buttons, button)
	end

	self:finishFoodThingies(BaseCombatHUD.THINGIES_FOOD, foodThingie.widget)
	self:_registerThingies(BaseCombatHUD.THINGIES_FOOD, foodThingie)
end

function BaseCombatHUD:_updateFoodThingies()
	local state = self:getState()
	local foodState = state.food
	local buttons = self:_getThingies(BaseCombatHUD.THINGIES_FOOD).buttons

	for i, food in ipairs(foodState) do
		local button = buttons[i]
		if button then
			self:updateFoodButton(button, food)
			button:setID(string.format("BaseCombatHUD-Food-%s", food.id))
		end
	end
end

function BaseCombatHUD:newStanceThingies(name)
	return Class.ABSTRACT()
end

function BaseCombatHUD:newStanceButton()
	return Class.ABSTRACT()
end

function BaseCombatHUD:updateStanceButton(button, stance, combatStyle, isActive)
	Class.ABSTRACT()
end

function BaseCombatHUD:finishStanceThingies(name, thingiesWidget)
	Class.ABSTRACT()
end

local STANCES = {
	Weapon.STANCE_CONTROLLED,
	Weapon.STANCE_AGGRESSIVE,
	Weapon.STANCE_DEFENSIVE,
}

local STANCE_IDS = {
	[Weapon.STANCE_CONTROLLED] = "Controlled",
	[Weapon.STANCE_AGGRESSIVE] = "Aggressive",
	[Weapon.STANCE_DEFENSIVE] = "Defensive",
}

function BaseCombatHUD:changeStance(stance)
	self:sendPoke("changeStance", nil, {
		stance = stance
	})
end

function BaseCombatHUD:_initStanceThingies()
	self:_unregisterThingies(BaseCombatHUD.THINGIES_STANCE)

	local state = self:getState()

	local stanceThingie = { buttons = {} }
	stanceThingie.widget = self:newStanceThingies(BaseCombatHUD.THINGIES_STANCE, stanceState)

	for i, stance in ipairs(STANCES) do
		local button = self:newStanceButton(stanceState)
		button.onClick:register(self.changeStance, self, stance)

		stanceThingie.widget:addChild(button)
		table.insert(stanceThingie.buttons, button)
	end

	self:finishStanceThingies(BaseCombatHUD.THINGIES_STANCE, stanceThingie.widget)
	self:_registerThingies(BaseCombatHUD.THINGIES_STANCE, stanceThingie)
end

function BaseCombatHUD:_updateStanceThingies()
	local state = self:getState()
	local currentStyle = state.style
	local currentStance = state.stance

	local buttons = self:_getThingies(BaseCombatHUD.THINGIES_STANCE).buttons

	for i, stance in ipairs(STANCES) do
		local button = buttons[i]
		if button then
			self:updateStanceButton(button, stance, currentStyle, currentStance == stance)
			button:setID(string.format("BaseCombatHUD-Stance-%s", STANCE_IDS[stance] or stance))
		end
	end
end

function BaseCombatHUD:updateThingies()
	if not self.wasRefreshed then
		return
	end

	self:_updatePowersThingies(BaseCombatHUD.THINGIES_OFFENSIVE_POWERS)
	self:_updatePowersThingies(BaseCombatHUD.THINGIES_DEFENSIVE_POWERS)
	self:_updateFoodThingies()
	self:_updateStanceThingies()
end

function BaseCombatHUD:refresh()
	self.wasRefreshed = true
	self:refreshThingies()
end

function BaseCombatHUD:refreshThingies()
	self:_initPowersThingies(BaseCombatHUD.THINGIES_OFFENSIVE_POWERS)
	self:_initPowersThingies(BaseCombatHUD.THINGIES_DEFENSIVE_POWERS)
	self:_initFoodThingies()
	self:_initStanceThingies()

	self:resetEvents()
	self:performLayout()

	self:updateThingies()
end

function BaseCombatHUD:getOverflow()
	return true
end

function BaseCombatHUD:performLayout()
	Interface.performLayout(self)

	local w, h = itsyrealm.graphics.getScaledMode()

	local playerWidth = self.playerInfo:getRowSize()
	local _, playerHeight = self.playerInfo:getSize()
	self.playerInfo:setPosition(w / 2 - playerWidth - self.PADDING / 2, 0)

	local targetWidth = self.playerInfo:getRowSize()
	local _, targetHeight = self.targetInfo:getSize()
	self.targetInfo:setPosition(w / 2 + self.PADDING / 2, 0)
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

	local zealOrb = self.playerInfo:getZealOrb()
	if zealOrb then
		zealOrb:setID("BaseCombatHUD-ZealOrb-Player")
	end

	local healthBar = self.playerInfo:getHealthBar()
	if healthBar then
		healthBar:setID("BaseCombatHUD-HealthBar-Player")
	end
end

function BaseCombatHUD:toggleTargetInfo(enabled)
	self:_toggleInfo(enabled, self.targetInfo)

	local zealOrb = self.playerInfo:getZealOrb()
	if zealOrb then
		zealOrb:setID("BaseCombatHUD-ZealOrb-Target")
	end

	local healthBar = self.playerInfo:getHealthBar()
	if healthBar then
		healthBar:setID("BaseCombatHUD-HealthBar-Target")
	end
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

	for name, button in pairs(self.thingiesButtons) do
		self:updateMenuButton(name, button)
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
	if self.isShowing then
		return false
	end

	self:openMenu()
	self.isShowing = true

	self:sendPoke("show", nil, {})

	return true
end

function BaseCombatHUD:hide()
	if not self.isShowing then
		return false
	end

	self:closeMenu()
	self.isShowing = false

	self:sendPoke("hide", nil, {})

	return true
end

function BaseCombatHUD:getIsShowing()
	return self.isShowing
end

function BaseCombatHUD:toggle(openOrClose)
	Class.ABSTRACT()
end

function BaseCombatHUD:updateTurnOrder()
	local gameView = self:getView():getGameView()

	local state = self:getState()
	local playerActorID = state.player.actorID
	local turns = state.turns

	local actors = {}
	for _, turn in ipairs(turns) do
		for _, t in ipairs(turn) do
			local actorInfo = actors[t.id]
			if not actorInfo then
				actorInfo = {
					turns = 1,
					id = t.id,
					name = t.name,
					time = t.time,
					duration = t.duration,
					interval = t.duration,
					power = t.power
				}

				actors[t.id] = actorInfo
			elseif not actorInfo.power then
				actorInfo.turns = actorInfo.turns + 1
				actorInfo.duration = actorInfo.duration + t.duration
				actorInfo.power = t.power
			end
		end
	end

	for id, actorInfo in pairs(actors) do
		local actorView = gameView:getActor(gameView:getActorByID(id))
		if actorView then
			local pendingActorInfo = self.pendingSprites[id]

			if pendingActorInfo and pendingActorInfo.power and actorInfo.power and pendingActorInfo.power.id ~= actorInfo.power.id then
				if pendingActorInfo.powerSprite then
					pendingActorInfo.powerSprite:reset()
				end
			end

			if not pendingActorInfo then
				actorInfo.attackSprite = gameView:getSpriteManager():add(
					"PendingAttack",
					actorView:getSceneNode(),
					Vector(0, 2, 0))
			else
				actorInfo.powerSprite = pendingActorInfo.powerSprite
				actorInfo.attackSprite = pendingActorInfo.attackSprite
			end

			if actorInfo.power and not actorInfo.powerSprite and id ~= playerActorID then				
				actorInfo.powerSprite = gameView:getSpriteManager():add(
					"PendingPower",
					actorView:getSceneNode(),
					Vector(0, 2, 0))
			elseif not actorInfo.power and actorInfo.powerSprite then
				actorInfo.powerSprite:finish()
				actorInfo.powerSprite = nil
			end

			actorInfo.attackSprite:updateDuration(actorInfo.time, actorInfo.interval)
			if actorInfo.powerSprite then
				actorInfo.powerSprite:updateDuration(actorInfo.turns, actorInfo.time, actorInfo.interval)
			end

			self.pendingSprites[id] = actorInfo
		end
	end

	for id, actorInfo in pairs(self.pendingSprites) do
		if not actors[id] then
			if actorInfo.powerSprite then
				actorInfo.powerSprite:finish()
			end

			actorInfo.attackSprite:finish()

			self.pendingSprites[id] = nil
		end
	end
end

function BaseCombatHUD:tick()
	Interface.tick(self)

	self:updateTurnOrder()
end

function BaseCombatHUD:_updateDebug()
	local isDebugKeydown = love.keyboard.isDown("f7")
	if self.wasDebugKeydown ~= isDebugKeydown and isDebugKeydown then
		Log.info("Combat state: %s", Log.dump(self:getState()))
	end

	self.wasDebugKeydown = isDebugKeydown
end

function BaseCombatHUD:update(delta)
	Interface.update(self, delta)

	if not self.menu then
		self:_createMenu()
	end

	self:updateEvents()

	local showPlayer = self:getIsShowing()
	local showTarget = false

	local state = self:getState()
	local playerState = state.player

	if #state.combatants > 1 then
		showPlayer = true

		self.playerInfo:updateTarget(playerState)
		for _, combatantState in ipairs(state.combatants) do
			if combatantState.actorID == playerState.targetID then
				showTarget = true
				self.targetInfo:updateTarget(combatantState)
				break
			end
		end
	end

	if _DEBUG then
		self:_updateDebug()
	end

	self:togglePlayerInfo(showPlayer)
	self:toggleTargetInfo(showTarget)

	self:updateThingies()
end

return BaseCombatHUD
