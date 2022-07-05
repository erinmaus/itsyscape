--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/ProCombatStatusHUD.lua
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
local Drawable = require "ItsyScape.UI.Drawable"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Button = require "ItsyScape.UI.Button"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local SpellIcon = require "ItsyScape.UI.SpellIcon"
local ToolTip = require "ItsyScape.UI.ToolTip"

local ProCombatStatusHUD = Class(Interface)
ProCombatStatusHUD.EFFECT_SIZE = 48
ProCombatStatusHUD.EFFECT_PADDING = 4
ProCombatStatusHUD.SCREEN_PADDING = 32
ProCombatStatusHUD.NUM_EFFECTS_PER_ROW = 4
ProCombatStatusHUD.TARGET_OFFSET_X = 256
ProCombatStatusHUD.TARGET_OFFSET_Y = 128
ProCombatStatusHUD.MAX_POSITIONING_ITERATIONS = 10
ProCombatStatusHUD.BUTTON_SIZE = 48
ProCombatStatusHUD.NUM_BUTTONS_PER_ROW = 4
ProCombatStatusHUD.BUTTON_PADDING = 8
ProCombatStatusHUD.THINGIES_WIDTH = (ProCombatStatusHUD.BUTTON_SIZE + ProCombatStatusHUD.BUTTON_PADDING) * ProCombatStatusHUD.NUM_BUTTONS_PER_ROW + ProCombatStatusHUD.BUTTON_PADDING
ProCombatStatusHUD.SPECIAL_COLOR = Color.fromHexString("ffcc00", 1)

ProCombatStatusHUD.THINGIES_OFFENSIVE_POWERS = 1
ProCombatStatusHUD.THINGIES_DEFENSIVE_POWERS = 2
ProCombatStatusHUD.THINGIES_SPELLS           = 3
ProCombatStatusHUD.THINGIES_PRAYERS          = 4

ProCombatStatusHUD.Target = Class(Drawable)
ProCombatStatusHUD.Target.WIDTH = (ProCombatStatusHUD.EFFECT_SIZE + ProCombatStatusHUD.EFFECT_PADDING) * ProCombatStatusHUD.NUM_EFFECTS_PER_ROW
ProCombatStatusHUD.Target.HEIGHT = 4
ProCombatStatusHUD.Target.STAT_HEIGHT = 18
ProCombatStatusHUD.Target.PSEUDO_WIDTH = 320
ProCombatStatusHUD.Target.PSEUDO_HEIGHT = 256

function ProCombatStatusHUD.Target:new(hud, actorID)
	Drawable.new(self)

	self.hud = hud
	self.actorID = actorID
	self.isDead = false

	self.effectsPanel = GridLayout()
	self.effectsPanel:setUniformSize(true, ProCombatStatusHUD.EFFECT_SIZE, ProCombatStatusHUD.EFFECT_SIZE)
	self.effectsPanel:setPadding(ProCombatStatusHUD.PADDING, ProCombatStatusHUD.PADDING)
	self.effectsPanel:setWrapContents(true)
	self.effectsPanel:setSize(ProCombatStatusHUD.Target.WIDTH, 0)
	self:addChild(self.effectsPanel)

	self.label = Label()
	self.label:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
		fontSize = 22,
		textShadow = true,
		color = { 1, 1, 1, 1 }
	}, self.hud:getView():getResources()))
	self.label:setPosition(0, (ProCombatStatusHUD.Target.HEIGHT + ProCombatStatusHUD.EFFECT_PADDING) + (ProCombatStatusHUD.Target.STAT_HEIGHT + ProCombatStatusHUD.EFFECT_PADDING) * 2)
	self:addChild(self.label)

	self.hitPoints = ProCombatStatusHUD.StatBar()
	self.hitPoints:setInColor(Color(0.44, 0.78, 0.21))
	self.hitPoints:setOutColor(Color(0.78, 0.21, 0.21))
	self.hitPoints:setPosition(0, ProCombatStatusHUD.Target.HEIGHT + ProCombatStatusHUD.EFFECT_PADDING)
	self.hitPoints:setSize(ProCombatStatusHUD.Target.WIDTH, ProCombatStatusHUD.Target.STAT_HEIGHT)
	self.hitPointsLabel = Label()
	self.hitPointsLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 16,
		textShadow = true,
		color = { 1, 1, 1, 1 }
	}, self.hud:getView():getResources()))
	self.hitPointsLabel:setPosition(ProCombatStatusHUD.EFFECT_PADDING, -ProCombatStatusHUD.EFFECT_PADDING)
	self.hitPoints:addChild(self.hitPointsLabel)
	self:addChild(self.hitPoints)

	self.prayerPoints = ProCombatStatusHUD.StatBar()
	self.prayerPoints:setInColor(Color(0.21, 0.67, 0.78))
	self.prayerPoints:setOutColor(Color(0.78, 0.21, 0.21))
	self.prayerPoints:setPosition(0, ProCombatStatusHUD.Target.HEIGHT + ProCombatStatusHUD.EFFECT_PADDING * 2 + ProCombatStatusHUD.Target.STAT_HEIGHT)
	self.prayerPoints:setSize(ProCombatStatusHUD.Target.WIDTH, ProCombatStatusHUD.Target.STAT_HEIGHT)
	self.prayerPointsLabel = Label()
	self.prayerPointsLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = 16,
		textShadow = true,
		color = { 1, 1, 1, 1 }
	}, self.hud:getView():getResources()))
	self.prayerPointsLabel:setPosition(ProCombatStatusHUD.EFFECT_PADDING, -ProCombatStatusHUD.EFFECT_PADDING)
	self.prayerPoints:addChild(self.prayerPointsLabel)
	self:addChild(self.prayerPoints)

	self.effectsPanel:setSize(ProCombatStatusHUD.Target.WIDTH, ProCombatStatusHUD.Target.HEIGHT)

	self.buttons = {}
end

function ProCombatStatusHUD.Target:getEffects()
	return self.effectsPanel
end

function ProCombatStatusHUD.Target:getOverflow()
	return true
end

function ProCombatStatusHUD.Target:getIsDead()
	return self.isDead
end

function ProCombatStatusHUD.Target:drawTarget(target)
	local x, y = self:getPosition()

	itsyrealm.graphics.translate(-x, -y)
	itsyrealm.graphics.rectangle(
		'fill',
		x, y,
		ProCombatStatusHUD.Target.WIDTH,
		ProCombatStatusHUD.Target.HEIGHT)
	itsyrealm.graphics.polygon(
		'fill',
		x + ProCombatStatusHUD.Target.WIDTH, y,
		x + ProCombatStatusHUD.Target.WIDTH, y + ProCombatStatusHUD.Target.HEIGHT,
		target.x, target.y)
	itsyrealm.graphics.translate(x, y)
end

function ProCombatStatusHUD.Target:getActorState(state)
	for i = 1, #state.combatants do
		if state.combatants[i].actorID == self.actorID then
			return state.combatants[i]
		end
	end

	return nil
end

function ProCombatStatusHUD.Target:draw(resources, state)
	local actorState = self:getActorState(state)

	self.isDead = actorState == nil
	if self.isDead then
		return
	end

	local actorPosition = self.hud:getActorPosition(self.actorID)
	if actorPosition.z < 0 or actorPosition.z > 1 then
		return
	end

	love.graphics.setColor(0, 0, 0, 0.5)
	itsyrealm.graphics.translate(1, 1)
	self:drawTarget(actorPosition)

	love.graphics.setColor(ProCombatStatusHUD.SPECIAL_COLOR:get())
	itsyrealm.graphics.translate(-1, -1)
	self:drawTarget(actorPosition)
end

function ProCombatStatusHUD.Target:update(...)
	Drawable.update(self, ...)

	local width, height = self.effectsPanel:getSize()
	self.effectsPanel:setPosition(
		ProCombatStatusHUD.EFFECT_PADDING,
		-(ProCombatStatusHUD.EFFECT_PADDING + height))

	local actor = self.hud:getView():getGameView():getActorByID(self.actorID)
	if actor then
		self.label:setText(actor:getName())

		local actorState = self:getActorState(self.hud:getState())
		if actorState then
			self.hitPointsLabel:setText(string.format("%d/%d", actorState.stats.hitpoints.current, actorState.stats.hitpoints.max))
			self.hitPoints:setCurrent(actorState.stats.hitpoints.current)
			self.hitPoints:setMax(actorState.stats.hitpoints.max)
			self.prayerPointsLabel:setText(string.format("%d/%d", actorState.stats.hitpoints.current, actorState.stats.prayer.max))
			self.prayerPoints:setCurrent(actorState.stats.prayer.current)
			self.prayerPoints:setMax(actorState.stats.prayer.max)
		end
	end
end

ProCombatStatusHUD.StatBar = Class(Drawable)
ProCombatStatusHUD.StatBar.BORDER_THICKNESS = 4
function ProCombatStatusHUD.StatBar:new()
	Drawable.new(self)

	self.current = 0
	self.max = 1
	self.inColor = Color(0, 1, 0, 1)
	self.outColor = Color(1, 0, 0, 1)
end

function ProCombatStatusHUD.StatBar:getCurrent()
	return self.current
end

function ProCombatStatusHUD.StatBar:setCurrent(value)
	self.current = value or self.current
end

function ProCombatStatusHUD.StatBar:getMax()
	return self.max
end

function ProCombatStatusHUD.StatBar:setMax(value)
	self.max = value or self.max
end

function ProCombatStatusHUD.StatBar:getInColor()
	return self.inColor
end

function ProCombatStatusHUD.StatBar:setInColor(value)
	self.inColor = value or self.inColor
end

function ProCombatStatusHUD.StatBar:getOutColor()
	return self.outColor
end

function ProCombatStatusHUD.StatBar:setOutColor(value)
	self.outColor = value or self.outColor
end

function ProCombatStatusHUD.StatBar:draw(resources, state)
	local w, h = self:getSize()
	local cornerRadius = math.min(w, h) / 4

	love.graphics.setColor(self.inColor:get())
	itsyrealm.graphics.rectangle('fill', 0, 0, w, h, cornerRadius)

	local outWidth = w * (1 - (self.current / self.max))
	if outWidth >= 1 then
		love.graphics.setColor(self.outColor:get())
		itsyrealm.graphics.rectangle('fill', w - outWidth, 0, outWidth, h, cornerRadius)
	end

	love.graphics.setLineWidth(self.BORDER_THICKNESS)
	love.graphics.setColor(0, 0, 0, 0.5)
	itsyrealm.graphics.rectangle('line', 0, 0, w, h, cornerRadius)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

ProCombatStatusHUD.EffectBorder = Class(Drawable)
ProCombatStatusHUD.EffectBorder.BORDER_THICKNESS = 1
function ProCombatStatusHUD.EffectBorder:new()
	Drawable.new(self)

	self.current = 0
	self.max = 1
	self.color = Color(1, 1, 1, 0)
end

function ProCombatStatusHUD.EffectBorder:getColor()
	return self.color
end

function ProCombatStatusHUD.EffectBorder:setColor(value)
	self.color = value or self.color
end

function ProCombatStatusHUD.EffectBorder:draw(resources, state)
	local w, h = self:getSize()

	love.graphics.setColor(self.color:get())
	love.graphics.setLineWidth(2)
	itsyrealm.graphics.rectangle('line', 0, 0, w, h)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

ProCombatStatusHUD.RadialMenu = Class(Drawable)
ProCombatStatusHUD.MIN_ZOOM = 10
ProCombatStatusHUD.MAX_ZOOM = 50
ProCombatStatusHUD.MIN_RADIUS = 96
ProCombatStatusHUD.MAX_RADIUS = 256

function ProCombatStatusHUD.RadialMenu:new(hud)
	Drawable.new(self)
	self.hud = hud

	self:updateRadius()
end

function ProCombatStatusHUD.RadialMenu:addChild(...)
	Drawable.addChild(self, ...)

	self:performLayout()
end

function ProCombatStatusHUD.RadialMenu:removeChild(...)
	Drawable.removeChild(self, ...)

	self:performLayout()
end

function ProCombatStatusHUD.RadialMenu:getOverflow()
	return true
end

function ProCombatStatusHUD.RadialMenu:draw()
	love.graphics.setLineWidth(ProCombatStatusHUD.Target.HEIGHT)

	local screenWidth, screenHeight = love.graphics.getScaledMode()
	love.graphics.setColor(ProCombatStatusHUD.SPECIAL_COLOR:get())
	itsyrealm.graphics.circle('line', screenWidth / 2, screenHeight / 2, self.radius)
end

function ProCombatStatusHUD.RadialMenu:updateRadius()
	local camera = self.hud:getView():getGameView():getRenderer():getCamera()
	local clampedZoom = math.max(math.min(camera:getDistance(), ProCombatStatusHUD.MAX_ZOOM), ProCombatStatusHUD.MIN_ZOOM)
	local zoomMultiplier = 1 - ((clampedZoom - ProCombatStatusHUD.MIN_ZOOM) / (ProCombatStatusHUD.MAX_ZOOM - ProCombatStatusHUD.MIN_ZOOM))

	local oldRadius = self.radius
	local newRadius = math.floor(zoomMultiplier * (ProCombatStatusHUD.MAX_RADIUS - ProCombatStatusHUD.MIN_RADIUS) + ProCombatStatusHUD.MIN_RADIUS)

	if oldRadius ~= newRadius then
		self.radius = newRadius
		self:performLayout()
	end
end

function ProCombatStatusHUD.RadialMenu:update(...)
	Drawable.update(self, ...)

	self:updateRadius()
end

function ProCombatStatusHUD.RadialMenu:performLayout()
	local numChildren = self:getNumChildren()
	if numChildren > 0 then
		local step = (math.pi * 2) / numChildren

		local current = 0
		for i = 1, numChildren do
			local child = self:getChildAt(i)
			local childWidth, childHeight = child:getSize()
			local screenWidth, screenHeight = love.graphics.getScaledMode()

			local x = screenWidth / 2 + math.cos(current) * self.radius - (childWidth / 2)
			local y = screenHeight / 2 + math.sin(current) * self.radius - (childHeight / 2)

			child:setPosition(x, y)

			current = current + step
		end
	end
end

ProCombatStatusHUD.Pending = Class(Drawable)
function ProCombatStatusHUD.Pending:draw(resources, state)
	local w, h = self:getSize()
	local time = love.timer.getTime() * math.pi * 2
	local startAngle = time
	local endAngle = startAngle + math.pi * 2 * (3 / 4)

	startAngle = startAngle % (math.pi * 2)
	endAngle = endAngle % (math.pi * 2)

	if startAngle > endAngle then
		startAngle = startAngle - math.pi * 2
	end

	love.graphics.setLineWidth(4)

	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.arc('line', 'open', w / 2 + 1, h / 2 + 1, math.min(w, h) / 4, startAngle, endAngle, 16)
	love.graphics.setColor(1, 1, 1, 1)
	itsyrealm.graphics.arc('line', 'open', w / 2, h / 2, math.min(w, h) / 4, startAngle, endAngle, 16)

	love.graphics.setLineWidth(1)
end

ProCombatStatusHUD.ThingiesLayout = Class(GridLayout)

function ProCombatStatusHUD.ThingiesLayout:getIsFocusable()
	return true
end

function ProCombatStatusHUD:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.targetWidgets = {}
	self.openThingies = {}
	self.thingies = {}

	self.radialMenu = ProCombatStatusHUD.RadialMenu(self)
	self.radialMenu:setZDepth(1000)
	self:prepareRadialMenu()
	self:addChild(self.radialMenu)

	self.subPending = ProCombatStatusHUD.Pending()
	self.subPending:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)
	self.mainPending = ProCombatStatusHUD.Pending()
	self.mainPending:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)
end

function ProCombatStatusHUD:isThingyOpen(type)
	return self.openThingies[type] ~= nil
end

function ProCombatStatusHUD:showThingies(type, buttons, target)
	if self.openThingies[type] then
		self:removeChild(self.openThingies[type])
		self.openThingies[type] = nil
		
		if not self.isRefreshing then
			return
		end
	end

	local thingies = ProCombatStatusHUD.ThingiesLayout()
	thingies:setUniformSize(true, ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)
	thingies:setPadding(ProCombatStatusHUD.BUTTON_PADDING, ProCombatStatusHUD.BUTTON_PADDING)
	thingies:setWrapContents(true)
	thingies:setSize(ProCombatStatusHUD.THINGIES_WIDTH, 0)

	for i = 1, #buttons do
		thingies:addChild(buttons[i])
	end

	local targetX, targetY = target:getAbsolutePosition()
	local targetWidth, targetHeight = target:getSize()
	local width, height = thingies:getSize()

	thingies:setPosition(
		targetX - (width / 2 - targetWidth / 2),
		targetY - height - ProCombatStatusHUD.BUTTON_PADDING)

	thingies:setZDepth(2000)

	self:addChild(thingies)

	self.openThingies[type] = thingies
end

function ProCombatStatusHUD:registerThingies(type, openFunc)
	self.thingies[type] = openFunc
end

function ProCombatStatusHUD:openRegisteredThingies(type)
	local openFunc = self.thingies[type]
	openFunc(self)
end

function ProCombatStatusHUD:createPowerButtons(powers, onClick)
	local buttons = {}
	for i = 1, #powers do
		local button = Button()

		local icon = Icon()
		icon:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)
		button:setData('icon', icon)
		button:addChild(icon)

		button.onClick:register(onClick, self, i)

		local coolDown = Label()
		coolDown:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/TinySansSerif/Regular.ttf",
			color = { 1, 1, 0, 1 },
			fontSize = 22,
			textShadow = true
		}, self:getView():getResources()))
		coolDown:setPosition(ProCombatStatusHUD.BUTTON_PADDING, ProCombatStatusHUD.BUTTON_SIZE - 22 - ProCombatStatusHUD.BUTTON_PADDING)
		button:setData('coolDown', coolDown)
		button:addChild(coolDown)

		table.insert(buttons, button)
	end

	return buttons
end

function ProCombatStatusHUD:addOffensivePowersButton()
	local offensivePowersButton = Button()
	offensivePowersButton:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)

	local offensivePowersButtonIcon = Icon()
	offensivePowersButtonIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", "Attack"))
	offensivePowersButton:addChild(offensivePowersButtonIcon)

	offensivePowersButton.onClick:register(self.onShowOffensivePowers, self)
	self:registerThingies(
		ProCombatStatusHUD.THINGIES_OFFENSIVE_POWERS,
		self.onShowOffensivePowers)

	self.radialMenu:addChild(offensivePowersButton)

	self:initOffensivePowers()
	self.offensivePowersButton = offensivePowersButton
end

function ProCombatStatusHUD:onActivateOffensivePower(index)
	self:sendPoke("activateOffensivePower", nil, {
		index = index
	})
end

function ProCombatStatusHUD:initOffensivePowers()
	local state = self:getState()
	local powers = state.powers.offensive

	self.offensivePowersButtons = self:createPowerButtons(powers, self.onActivateOffensivePower)
end

function ProCombatStatusHUD:onShowOffensivePowers(button)
	self:showThingies(
		ProCombatStatusHUD.THINGIES_OFFENSIVE_POWERS,
		self.offensivePowersButtons,
		button or self.offensivePowersButton)
end

function ProCombatStatusHUD:addDefensivePowersButton()
	local defensivePowersButton = Button()
	defensivePowersButton:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)

	local defensivePowersButtonIcon = Icon()
	defensivePowersButtonIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", "Defense"))
	defensivePowersButton:addChild(defensivePowersButtonIcon)
	self:registerThingies(
		ProCombatStatusHUD.THINGIES_DEFENSIVE_POWERS,
		self.onShowDefensivePowers)

	defensivePowersButton.onClick:register(self.onShowDefensivePowers, self)

	self.radialMenu:addChild(defensivePowersButton)

	self:initDefensivePowers()
	self.defensivePowersButton = defensivePowersButton
end

function ProCombatStatusHUD:onActivateDefensivePower(index)
	self:sendPoke("activateDefensivePower", nil, {
		index = index
	})
end

function ProCombatStatusHUD:initDefensivePowers()
	local state = self:getState()
	local powers = state.powers.defensive

	self.defensivePowersButtons = self:createPowerButtons(powers, self.onActivateDefensivePower)
end

function ProCombatStatusHUD:onShowDefensivePowers(button)
	self:showThingies(
		ProCombatStatusHUD.THINGIES_DEFENSIVE_POWERS,
		self.defensivePowersButtons,
		button or self.defensivePowersButtons)
end

function ProCombatStatusHUD:addSpellsButton()
	local spellsButton = Button()
	spellsButton:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)

	local spellsButtonIcon = SpellIcon()
	spellsButtonIcon:setSpellID("FireBlast")
	spellsButtonIcon:setSpellEnabled(true)
	spellsButtonIcon:setSpellActive(false)
	spellsButton:addChild(spellsButtonIcon)

	spellsButton.onClick:register(self.onShowSpells, self)
	self:registerThingies(
		ProCombatStatusHUD.THINGIES_SPELLS,
		self.onShowSpells)

	self.radialMenu:addChild(spellsButton)

	self:initSpells()
	self.spellsButton = spellsButton
end

function ProCombatStatusHUD:onActivateSpell(id)
	self:sendPoke("castSpell", nil, {
		id = id
	})
end

function ProCombatStatusHUD:initSpells()
	local state = self:getState()
	local spells = state.spells

	self.spellButtons = {}
	for i = 1, #spells do
		local spell = spells[i]

		local button = Button()
		button.onClick:register(self.onActivateSpell, self, spell.id)

		local icon = SpellIcon()
		icon:setSpellID(spell.id)
		icon:setSpellEnabled(true)
		icon:setSpellActive(spells[i].active)
		button:addChild(icon)

		local runes = {}
		for j = 1, #spell.items do
			local s = string.format("- %dx %s", spell.items[j].count, spell.items[j].name)
			table.insert(runes, ToolTip.Text(s))
		end

		if #runes == 0 then
			button:setToolTip(
				ToolTip.Header(spell.name),
				ToolTip.Text(spell.description),
				ToolTip.Text(string.format("Requires level %d Magic.", spell.level)))
		else
			button:setToolTip(
				ToolTip.Header(spell.name),
				ToolTip.Text(spell.description),
				ToolTip.Text(string.format("Requires level %d Magic and:", spell.level)),
				unpack(runes))
		end

		table.insert(self.spellButtons, button)
	end
end

function ProCombatStatusHUD:onShowSpells(button)
	self:showThingies(
		ProCombatStatusHUD.THINGIES_SPELLS,
		self.spellButtons,
		button or self.spellsButton)
end

function ProCombatStatusHUD:addPrayersButton()
	local prayersButton = Button()
	prayersButton:setSize(ProCombatStatusHUD.BUTTON_SIZE, ProCombatStatusHUD.BUTTON_SIZE)

	local prayersButtonIcon = Icon()
	prayersButtonIcon:setIcon("Resources/Game/UI/Icons/Skills/Faith.png")
	prayersButton:addChild(prayersButtonIcon)

	prayersButton.onClick:register(self.onShowPrayers, self)
	self:registerThingies(
		ProCombatStatusHUD.THINGIES_PRAYERS,
		self.onShowPrayers)

	self.radialMenu:addChild(prayersButton)

	self:initPrayers()
	self.prayersButton = prayersButton
end

function ProCombatStatusHUD:onActivatePrayer(id)
	self:sendPoke("pray", nil, {
		id = id
	})
end

function ProCombatStatusHUD:initPrayers()
	local state = self:getState()
	local prayers = state.prayers

	self.prayerButtons = {}
	for i = 1, #prayers do
		local prayer = prayers[i]

		local button = Button()
		button.onClick:register(self.onActivatePrayer, self, prayer.id)

		local icon = Icon()
		icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", prayer.id))
		button:addChild(icon)

		button:setToolTip(
			ToolTip.Header(prayer.name),
			ToolTip.Text(prayer.description))

		table.insert(self.prayerButtons, button)
	end
end

function ProCombatStatusHUD:onShowPrayers(button)
	self:showThingies(
		ProCombatStatusHUD.THINGIES_PRAYERS,
		self.prayerButtons,
		button or self.prayersButton)
end

function ProCombatStatusHUD:prepareRadialMenu()
	self:addOffensivePowersButton()
	self:addDefensivePowersButton()
	self:addSpellsButton()
	self:addPrayersButton()
end

function ProCombatStatusHUD:getOverflow()
	return true
end

function ProCombatStatusHUD:getActorPosition(actorID)
	local gameView = self:getView():getGameView()
	local actorView = gameView:getActor(gameView:getActorByID(actorID))

	if not actorView then
		return Vector.ZERO
	end

	local actorPosition
	do
		local headTransform = actorView:getLocalBoneTransform("head")
		local feetTransform = actorView:getSceneNode():getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
		local worldTransform = love.math.newTransform()
		worldTransform:apply(feetTransform)
		worldTransform:apply(headTransform)

		local camera = gameView:getRenderer():getCamera()
		local projectionTransform, viewTransform = camera:getTransforms()

		local completeTransform = love.math.newTransform()
		completeTransform:apply(projectionTransform)
		completeTransform:apply(viewTransform)
		completeTransform:apply(worldTransform)

		actorPosition = Vector(completeTransform:transformPoint(0, 0, 0))
		actorPosition = (actorPosition + Vector(1)) * Vector(0.5) * Vector(camera:getWidth(), camera:getHeight(), 1)
	end

	return actorPosition
end

function ProCombatStatusHUD:positionTarget(targetWidget, actorID)
	local playerActorID
	do
		local state = self:getState()
		if state.player then
			playerActorID = state.player.actorID
		else
			playerActorID = 0
		end
	end

	local actorPosition = self:getActorPosition(actorID)
	local playerPosition = self:getActorPosition(playerActorID)

	if actorPosition.x < playerPosition.x and actorID ~= playerActorID then
		actorPosition.x = actorPosition.x - ProCombatStatusHUD.TARGET_OFFSET_X
		actorPosition.y = actorPosition.y - ProCombatStatusHUD.TARGET_OFFSET_Y
	else
		actorPosition.x = actorPosition.x + ProCombatStatusHUD.TARGET_OFFSET_X
		actorPosition.y = actorPosition.y - ProCombatStatusHUD.TARGET_OFFSET_Y
	end

	local screenWidth, screenHeight = love.graphics.getScaledMode()
	local targetWidgetWidth, targetWidgetHeight = ProCombatStatusHUD.Target.PSEUDO_WIDTH, ProCombatStatusHUD.Target.PSEUDO_HEIGHT

	if actorPosition.x < ProCombatStatusHUD.SCREEN_PADDING then
		actorPosition.x = ProCombatStatusHUD.SCREEN_PADDING
	elseif actorPosition.x + targetWidgetWidth > screenWidth then
		actorPosition.x = screenWidth - targetWidgetWidth - ProCombatStatusHUD.SCREEN_PADDING
	end

	if actorPosition.y < ProCombatStatusHUD.SCREEN_PADDING then
		actorPosition.y = ProCombatStatusHUD.SCREEN_PADDING
	elseif actorPosition.y + targetWidgetHeight > screenHeight then
		actorPosition.y = screenHeight - targetWidgetHeight - ProCombatStatusHUD.SCREEN_PADDING
	end

	local isCollision = false
	local fudge = 1
	local iterations = ProCombatStatusHUD.MAX_POSITIONING_ITERATIONS
	repeat
		for _, otherTargetWidget in pairs(self.targetWidgets) do
			local otherTargetWidgetX, otherTargetWidgetY = otherTargetWidget:getPosition()
			local otherTargetWidgetWidth, otherTargetWidgetHeight = ProCombatStatusHUD.Target.PSEUDO_WIDTH, ProCombatStatusHUD.Target.PSEUDO_HEIGHT
			local isCollision = false
			if actorPosition.x < otherTargetWidgetX + otherTargetWidgetWidth and
			   actorPosition.x + targetWidgetWidth > otherTargetWidgetX and
			   actorPosition.y < otherTargetWidgetY + otherTargetWidgetHeight and
			   actorPosition.y + otherTargetWidgetHeight > otherTargetWidgetY
			then
				isCollision = true
			end

			if isCollision then
				local overlapX = otherTargetWidgetWidth - (actorPosition.x - otherTargetWidgetX)
				local overlapY = otherTargetWidgetHeight - (actorPosition.y - otherTargetWidgetY)

				if math.abs(overlapX) > math.abs(overlapY) then
					actorPosition.y = actorPosition.y + overlapY * fudge
				else
					actorPosition.x = actorPosition.x + overlapX * fudge
				end

				fudge = fudge * 1.1
			end
		end

		iterations = iterations - 1
	until not isCollision or iterations <= 0

	targetWidget:setPosition(actorPosition.x, actorPosition.y)
end

function ProCombatStatusHUD:addTarget(combatant)
	local targetWidget = ProCombatStatusHUD.Target(self, combatant.actorID)
	self.targetWidgets[combatant.actorID] = targetWidget

	self:positionTarget(targetWidget, combatant.actorID)
	self:addChild(targetWidget)
end

function ProCombatStatusHUD:updateTargetEffects(targetWidget, state)
	local effects = targetWidget:getEffects()
	for i = 1, #state.effects do
		local icon = effects:getChildAt(i)
		if not icon then
			icon = Icon()
			local label = Label()
			label:setPosition(
				ProCombatStatusHUD.EFFECT_PADDING,
				ProCombatStatusHUD.EFFECT_SIZE - 22 - ProCombatStatusHUD.EFFECT_PADDING)
			icon:setData('label', label)
			icon:addChild(icon:getData('label'))

			border = ProCombatStatusHUD.EffectBorder()
			border:setSize(
				ProCombatStatusHUD.EFFECT_SIZE,
				ProCombatStatusHUD.EFFECT_SIZE)
			icon:setData('border', border)
			icon:addChild(border)

			effects:addChild(icon)
		end

		icon:setIcon(string.format("Resources/Game/Effects/%s/Icon.png", state.effects[i].id))
		icon:setSize(ProCombatStatusHUD.EFFECT_SIZE, ProCombatStatusHUD.EFFECT_SIZE)

		local duration = state.effects[i].duration
		if duration ~= math.huge then
			local HOUR = 60 * 60
			local MINUTE = 60

			local time, suffix
			if duration > HOUR then
				time = math.floor(duration / HOUR)
				suffix = 'h'
			elseif duration > MINUTE then
				time = math.floor(duration / MINUTE)
				suffix = 'm'
			else
				time = math.floor(duration)
				suffix = 's'
			end

			local label = icon:getData('label')
			label:setText(string.format("%d%s", time, suffix))
			label:setStyle(LabelStyle({
				font = "Resources/Renderers/Widget/Common/TinySansSerif/Regular.ttf",
				fontSize = 22,
				textShadow = true
			}, self:getView():getResources()))
		else
			icon:getData('label'):setText("")
		end

		do
			if state.effects[i].buff then
				icon:getData('border'):setColor(Color(0, 1, 0, 1))
			elseif state.effects[i].debuff then
				icon:getData('border'):setColor(Color(1, 0, 0, 1))
			else
				icon:getData('border'):setColor(Color(1, 1, 1, 0))
			end
		end

		icon:setToolTip(
			ToolTip.Header(state.effects[i].name),
			ToolTip.Text(state.effects[i].description))
	end

	while effects:getNumChildren() > #state.effects do
		effects:removeChild(effects:getChildAt(effects:getNumChildren()))
	end
end

function ProCombatStatusHUD:updateTarget(targetWidget, state)
	self:updateTargetEffects(targetWidget, state)
end

function ProCombatStatusHUD:updatePowers(type, buttons, powers, pendingID, radialButton)
	local pendingIndex

	for i = 1, #powers do
		local power = powers[i]
		local button = buttons[i]

		local coolDown = button:getData('coolDown')
		local icon = button:getData('icon')

		icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", power.id))

		local description = {}
		for i = 1, #power.description do
			table.insert(description, ToolTip.Text(power.description[i]))
		end

		local toolTip = {
			ToolTip.Header(power.name),
			unpack(power.description)
		}

		button:setToolTip(unpack(toolTip))

		if power.coolDown then
			coolDown:setText(tostring(power.coolDown))
		else
			coolDown:setText("")
		end

		if pendingID == power.id then
			button:addChild(self.subPending)
			pendingIndex = i
		else
			button:removeChild(self.subPending)
		end
	end

	if pendingIndex and not self:isThingyOpen(type) and not radialButton:getData('pending') then
		local power = powers[pendingIndex]
		local icon = radialButton:getChildAt(1)
		icon:setData('previousIcon', icon:getIcon())
		icon:setIcon(string.format("Resources/Game/Powers/%s/Icon.png", power.id))

		icon:addChild(self.mainPending)

		radialButton:setData('pending', true)
	elseif (not pendingIndex or self:isThingyOpen(type)) and radialButton:getData('pending') then
		local icon = radialButton:getChildAt(1)
		icon:removeChild(self.mainPending)
		icon:setIcon(icon:getData('previousIcon'))

		radialButton:setData('pending', false)
	end
end

function ProCombatStatusHUD:updateSpells()
	local radialSpellsButtonIcon = self.spellsButton:getChildAt(1)
	local hasActiveSpell = false

	local spells = self:getState().spells
	for i = 1, #spells do
		local spell = spells[i]
		local button = self.spellButtons[i]

		if spell.active then
			button:getChildAt(1):setSpellActive(true)

			radialSpellsButtonIcon:setSpellID(spell.id)
			radialSpellsButtonIcon:setSpellActive(true)

			hasActiveSpell = true
		else
			button:getChildAt(1):setSpellActive(false)
		end
	end

	if not hasActiveSpell then
		radialSpellsButtonIcon:setSpellID("FireBlast")
		radialSpellsButtonIcon:setSpellActive(false)
	end
end

function ProCombatStatusHUD:refresh()
	self.isRefreshing = true

	self:initOffensivePowers()
	self:initDefensivePowers()
	self:initSpells()
	self:initPrayers()

	for thingyType in pairs(self.openThingies) do
		self:openRegisteredThingies(thingyType)
	end

	self.isRefreshing = false
end

function ProCombatStatusHUD:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	for i = 1, #state.combatants do
		local stateCombatant = state.combatants[i]
		local targetWidget = self.targetWidgets[stateCombatant.actorID]
		if not targetWidget then
			self:addTarget(stateCombatant)
			targetWidget = self.targetWidgets[stateCombatant.actorID]
		end

		self:updateTarget(targetWidget, stateCombatant)
	end

	for id, targetWidget in pairs(self.targetWidgets) do
		if targetWidget:getIsDead() then
			self.targetWidgets[id] = nil
			self:removeChild(targetWidget)
		end
	end

	self:updatePowers(
		ProCombatStatusHUD.THINGIES_OFFENSIVE_POWERS,
		self.offensivePowersButtons,
		state.powers.offensive,
		state.powers.pendingID,
		self.offensivePowersButton)
	self:updatePowers(
		ProCombatStatusHUD.THINGIES_DEFENSIVE_POWERS,
		self.defensivePowersButtons,
		state.powers.defensive,
		state.powers.pendingID,
		self.defensivePowersButton)
	self:updateSpells()

	if not self.offensivePowersButton:getData('pending') then
		local icon = self.offensivePowersButton:getChildAt(1)
		icon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", state.style))
	end

	local player = self:getView():getGame():getPlayer()
	--if player:getIsEngaged() and not self.radialMenu:getParent() then
	--	self:addChild(self.radialMenu)
	--elseif not player:getIsEngaged() and self.radialMenu:getParent() then
	--	self:removeChild(self.radialMenu)
	--end
end

return ProCombatStatusHUD
