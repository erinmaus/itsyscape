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
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local ToolTip = require "ItsyScape.UI.ToolTip"

local ProCombatStatusHUD = Class(Interface)
ProCombatStatusHUD.EFFECT_SIZE = 48
ProCombatStatusHUD.EFFECT_PADDING = 4
ProCombatStatusHUD.SCREEN_PADDING = 32
ProCombatStatusHUD.NUM_EFFECTS_PER_ROW = 4
ProCombatStatusHUD.TARGET_OFFSET_X = 256
ProCombatStatusHUD.TARGET_OFFSET_Y = 128
ProCombatStatusHUD.MAX_POSITIONING_ITERATIONS = 10

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

	love.graphics.setColor(Color.fromHexString("ffcc00", 1):get())
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

function ProCombatStatusHUD:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.targetWidgets = {}
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
		actorPosition.y = camera:getHeight() - actorPosition.y
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
end

return ProCombatStatusHUD
