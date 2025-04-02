--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/StandardTurnOrder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Drawable = require "ItsyScape.UI.Drawable"
local Widget = require "ItsyScape.UI.Widget"
local Particles = require "ItsyScape.UI.Particles"
local StandardBarLabel = require "ItsyScape.UI.Interfaces.Components.StandardBarLabel"
local patchy = require "patchy"

local StandardTurnOrder = Class(Drawable)
StandardTurnOrder.FONT_SIZE = 22
StandardTurnOrder.COMPLETED_TURN_TRANSITION_TIME_SECONDS = 0.2
StandardTurnOrder.TEXT_PADDING = 22
StandardTurnOrder.DEFAULT_NUM_SECONDS = 10

function StandardTurnOrder:new()
	Drawable.new(self)

	self.previousTurnOrder = false
	self.currentTurnOrder = false
	self.completedTurn = false
	self.completedTurnDelta = self.COMPLETED_TURN_TRANSITION_TIME_SECONDS
	self.numSeconds = self.DEFAULT_NUM_SECONDS
	self.radiusSpeed = math.pi / 4
	self.radiusFudge = 6
	self.radius = 8
	self.innerRadiusThickness = 3
	self.outerRadiusThickness = 2

	self:setIsSelfClickThrough(true)
end

function StandardTurnOrder:setNumSeconds(value)
	self.numSeconds = value or self
end

function StandardTurnOrder:resetTurnOrder()
	self.previousTurnOrder = false
	self.currentTurnOrder = false
	self.completedTurn = false
	self.completedTurnDelta = self.COMPLETED_TURN_TRANSITION_TIME_SECONDS
	self.previousTime = false
	self.currentTime = false
end

function StandardTurnOrder:updateTurnOrder(turnOrder)
	self.previousTime = self.currentTime
	self.currentTime = love.timer.getTime()

	self.previousTurnOrder = self.currentTurnOrder
	self.currentTurnOrder = {}

	for _, turns in ipairs(turnOrder) do
		local c = {}
		for _, t in ipairs(turns) do
			table.insert(c, {
				id = t.id,
				name = t.name,
				time = t.time,
				tickTime = t.tickTime,
				duration = t.duration
			})
		end
		table.insert(self.currentTurnOrder, c)
	end

	if self.previousTurnOrder and #self.previousTurnOrder > 1 and #self.currentTurnOrder > 1 then
		if #self.currentTurnOrder[1] >= 1 and #self.previousTurnOrder[1] >= 1 then
			if self.currentTurnOrder[1][1].id ~= self.previousTurnOrder[1][1].id or self.currentTurnOrder[1][1].time > self.previousTurnOrder[1][1].time then
				self.completedTurn = self.previousTurnOrder[1]
				self.completedTurnDelta = 0
			end
		end
	end
end

function StandardTurnOrder:loadAssets(resources)
	self.playerTurnImage = self.playerTurnImage or resources:load(patchy.load, "Resources/Game/UI/Panels/PlayerTurnOrder.png")
	self.targetTurnImage = self.targetTurnImage or resources:load(patchy.load, "Resources/Game/UI/Panels/TargetTurnOrder.png")
	self.turnOrderProgressImage = self.turnOrderProgressImage or resources:load(patchy.load, "Resources/Game/UI/Panels/TurnOrderProgressBar.png")
	self.font = self.font or resources:load(
		love.graphics.newFont,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		self.FONT_SIZE)
end

function StandardTurnOrder:drawTurn(currentTurn, previousTurn, w, h, delta)
	local game = _APP and _APP:getGame()
	local playerActor = game and game:getPlayer() and game:getPlayer():getActor()
	local playerActorID = playerActor and playerActor:getID()

	local nextTurnIndicatorWidth = self.radiusFudge + self.innerRadiusThickness + self.outerRadiusThickness

	for i, t in ipairs(currentTurn) do
		local otherT = previousTurn and previousTurn[i]

		local time
		if otherT and t.id == otherT.id then
			time = math.lerp(otherT.time, t.time, delta)
		else
			time = t.time
		end

		if time <= 1 then
			local delta = time / self.numSeconds

			local alpha
			if time < 0 then
				alpha = 1 - math.clamp(math.abs(time) / 0.5)
			else
				alpha = 1 - (math.max(time - 0.5, 0) / 0.5)
			end
			alpha = Tween.sineEaseInOut(alpha)

			local mu = Tween.expEaseInOut(math.min(time / 0.5, 1))

			local x = delta * w

			local animatedDecorationColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.animatedDecoration"), alpha)
			local fudge = self.radiusFudge * mu

			love.graphics.setColor(0, 0, 0, alpha)

			local shadowLineThickness = math.max(self.outerRadiusThickness / 2, 2)
			love.graphics.setLineWidth(shadowLineThickness)
			itsyrealm.graphics.line(
				x - fudge + self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				shadowLineThickness / 2,
				x - fudge + self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				h + shadowLineThickness / 2)
			itsyrealm.graphics.line(
				x - fudge - self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				h + shadowLineThickness / 2,
				x - fudge + self.outerRadiusThickness,
				h + shadowLineThickness / 2)
			itsyrealm.graphics.line(
				x + fudge + self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				shadowLineThickness / 2,
				x + fudge + self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				h + shadowLineThickness / 2)
			itsyrealm.graphics.line(
				x + fudge - self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				h + shadowLineThickness / 2,
				x + fudge + self.outerRadiusThickness,
				h + shadowLineThickness / 2)

			love.graphics.setLineWidth(self.innerRadiusThickness)
			itsyrealm.graphics.line(
				x + self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				shadowLineThickness / 2,
				x + self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				h + shadowLineThickness / 2)
			itsyrealm.graphics.line(
				x - self.outerRadiusThickness / 2 + shadowLineThickness / 2,
				h + shadowLineThickness / 2,
				x + self.outerRadiusThickness,
				h + shadowLineThickness / 2)

			love.graphics.setColor(animatedDecorationColor:get())

			love.graphics.setLineWidth(self.outerRadiusThickness)
			itsyrealm.graphics.line(x - fudge + 1, 1, x - fudge + 1, h + 1)
			itsyrealm.graphics.line(x + fudge + 1, 1, x + fudge + 1, h + 1)

			love.graphics.setLineWidth(self.innerRadiusThickness)
			itsyrealm.graphics.line(x + 1, 1, x + 1, h + 1)

			love.graphics.setColor(1, 1, 1, 1)
		end
	end

	for i, t in ipairs(currentTurn) do
		local otherT = previousTurn and previousTurn[i]

		local time
		if otherT and t.id == otherT.id then
			time = math.lerp(otherT.time, t.time, delta)
		else
			time = t.time
		end

		local a
		if time < 0 then
			a = 1 - math.clamp(math.abs(time) / self.COMPLETED_TURN_TRANSITION_TIME_SECONDS)
		elseif time > (self.numSeconds - self.COMPLETED_TURN_TRANSITION_TIME_SECONDS) then
			a = 1 - math.clamp(time - (self.numSeconds - self.COMPLETED_TURN_TRANSITION_TIME_SECONDS) / self.COMPLETED_TURN_TRANSITION_TIME_SECONDS)
		else
			a = 1
		end
		a = Tween.sineEaseInOut(a)

		if time <= self.numSeconds then
			local delta = time / self.numSeconds
			local x = delta * w

			local y
			if t.id == playerActorID then
				y = height * 0.25
			else
				y = height * 0.75
			end

			local labelWidth = self.font:getWidth(t.name)
			local labelHeight = self.font:getHeight()

			local labelX, labelY = x + nextTurnIndicatorWidth, y - (labelHeight / 2)

			labelX = math.floor(labelX)
			labelY = math.floor(labelY)

			local plainTextColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.bar.text"), a)
			local textShadowColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.bar.textShadow"), a)
			local attackColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.animatedDecoration"), a)

			local textColor
			if time < t.duration then
				textColor = plainTextColor:lerp(attackColor, 1 - (time / math.max(t.duration - 0.2, 0.2)))
			else
				textColor = plainTextColor
			end

			love.graphics.setColor(textShadowColor:get())
			itsyrealm.graphics.print(t.name, labelX + 2, labelY + 2)

			love.graphics.setColor(textColor:get())
			itsyrealm.graphics.print(t.name, labelX, labelY)
		end
	end

	love.graphics.setColor(1, 1, 1, 1)
end

function StandardTurnOrder:update(delta)
	Drawable.update(self, delta)

	if self.completedTurn then
		for _, t in ipairs(self.completedTurn) do
			t.time = t.time - delta
		end
	end
end


function StandardTurnOrder:draw(resources, state)
	local oldFont = love.graphics.getFont()
	local animatedDecorationColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.animatedDecoration"))
	self:loadAssets(resources)

	love.graphics.setFont(self.font)

	if not self.currentTurnOrder then
		return
	end

	local targetTickDelta = _APP and _APP:getTargetTickDelta() or (1 / 10)
	local currentTime = love.timer.getTime()
	local timeDifference = (self.currentTime or currentTime) - (self.previousTime or self.currentTime or currentTime)

	local timeDelta
	if timeDifference > 0 then
		timeDelta = (currentTime - (self.currentTime or currentTime)) / targetTickDelta
	else
		timeDelta = 1
	end

	local width, height = self:getSize()
	local offset = math.sin(currentTime * self.radiusSpeed) * self.radiusFudge
	local x = self.outerRadiusThickness * 2

	love.graphics.setLineWidth(offset + self.outerRadiusThickness)
	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.line(x + 2, 2, x + 2, height + 2)
	love.graphics.setColor(animatedDecorationColor:get())
	itsyrealm.graphics.line(x, 0, x, height)

	love.graphics.setLineStyle("rough")
	if self.completedTurn then
		self:drawTurn(self.completedTurn, nil, width, height, 1)
	end

	local actorIDs = {}
	for i, turn in ipairs(self.currentTurnOrder) do
		local alpha = 1
		if i == #self.currentTurnOrder then
			alpha = delta
		end

		local inProgress = false
		for _, t in ipairs(turn) do
			if not actorIDs[t.id] then
				inProgress = true
				actorIDs[t.id] = true
			end
		end

		self:drawTurn(turn, self.previousTurnOrder and self.previousTurnOrder[i], width, height, timeDelta)
	end

	love.graphics.setFont(oldFont)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
	love.graphics.setLineStyle("smooth")
end

return StandardTurnOrder
