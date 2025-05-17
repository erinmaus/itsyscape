--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CutsceneTransition.lua
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
local ResourceManager = require "ItsyScape.Graphics.ResourceManager"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"

local CutsceneTransition = Class(Interface)
CutsceneTransition.FADE_DURATION_SECONDS = 0.5
CutsceneTransition.DELAY_AFTER_MOVE_SECONDS = 1
CutsceneTransition.PADDING = 16

CutsceneTransition.Spinner = Class(Drawable)

function CutsceneTransition.Spinner:new(icon)
	Drawable.new(self)

	self.icon = icon
	self.startTime = love.timer.getTime()
	self.alpha = 0

	self:setSize(icon:getWidth() / 2, icon:getHeight() / 2)
end

function CutsceneTransition.Spinner:setAlpha(alpha)
	self.alpha = alpha
end

function CutsceneTransition.Spinner:draw()
	local time = love.timer.getTime() - self.startTime

	love.graphics.setColor(1, 1, 1, self.alpha)
	itsyrealm.graphics.draw(self.icon, 0, 0, math.pi * 2 * time, 0.5, 0.5, self.icon:getWidth() / 2, self.icon:getHeight() / 2)
end

function CutsceneTransition:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h, _, _, paddingX, paddingY = love.graphics.getScaledMode()

	local panel = Panel()
	local panelStyle = PanelStyle({
		color = { 0, 0, 0, 0 },
		radius = 0
	}, ui:getResources())
	panel:setSize(w + paddingX * 2, h + paddingY * 2)
	panel:setPosition(-paddingX, -paddingY)
	panel:setStyle(panelStyle)
	self:addChild(panel)

	local icon = ui:getResources():load(love.graphics.newImage, "Resources/Game/UI/CutsceneSpinner.png")
	self.spinningIcon = CutsceneTransition.Spinner(icon)
	self.spinningIcon:setSize(icon:getWidth(), icon:getHeight())
	self.spinningIcon:setPosition(
		w - icon:getWidth() / 2 - CutsceneTransition.PADDING,
		h - icon:getHeight() / 2 - CutsceneTransition.PADDING)
	self:addChild(self.spinningIcon)

	self.panelStyle = panelStyle

	self:setZDepth(5000)

	local game = self:getView():getGame()
	local player = game:getPlayer()

	self._onPlayerMove = function() self:onPlayerMove() end
	player.onMove:register(self._onPlayerMove, self)

	self.onClose:register(function()
		player.onMove:unregister(self._onPlayerMove)

		local num = 0
		for _ in self:getView():getInterfaces("CutsceneTransition") do
			num = num + 1
		end

		if num <= 1 then
			self:getView():getGameView():getResourceManager():setFrameDuration()
			self:getView():getGameView():getResourceManager():setMaxTimeForSyncResource()
		end
	end)

	self:getView():getGameView():getResourceManager():setFrameDuration(ResourceManager.LOADING_FRAME_DURATION)
	self:getView():getGameView():getResourceManager():setMaxTimeForSyncResource(ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE_LOADING)

	self.didPlayerMove = false
	self.isCheckingQueue = false
	self.wasQueueEmpty = false
	self.isFadingOut = false
	self.time = 0
	self.totalTime = 0
end

function CutsceneTransition:getOverflow()
	return true
end

function CutsceneTransition:onPlayerMove()
	self.didPlayerMove = true
	self.time = 0
end

function CutsceneTransition:update(delta)
	Interface.update(self, delta)

	local minDuration = self:getState().minDuration or 0

	self.time = self.time + delta
	self.totalTime = self.totalTime + delta
	local delta = math.min(self.time / CutsceneTransition.FADE_DURATION_SECONDS, 1)

	if self.didPlayerMove then
		if self.isFadingOut then
			if self.time > CutsceneTransition.FADE_DURATION_SECONDS then
				delta = 0
				self:sendPoke("close", nil, {})
			else
				if delta > 0.5 then
					delta = 1 - ((delta - 0.5) / 0.5)
				else
					delta = 1
				end
			end
		elseif self.isWaitingOnEvent then
			if self.didEventFire then
				Log.info("Took %0.2f ms to load.", self.time * 1000)

				self.time = 0
				self.isWaitingOnEvent = false
			end

			delta = 1
		elseif self.wasQueueEmpty then
			delta = 1

			if self.totalTime > (minDuration - CutsceneTransition.FADE_DURATION_SECONDS) then
				self.time = 0
				self.isFadingOut = true
				
				self:sendPoke("close", nil, {})
			end
		elseif self.isCheckingQueue then
			local gameView = self:getView():getGameView()
			local resources = self:getView():getGameView():getResourceManager()
			self.wasQueueEmpty = self.wasQueueEmpty or not (resources:getIsPending() or gameView:getIsHeavyResourcePending())

			if self.wasQueueEmpty then
				resources:queueEvent(function()
					self.didEventFire = true
				end)

				self.isWaitingOnEvent = true
			end

			delta = 1
		else
			if self.time > CutsceneTransition.DELAY_AFTER_MOVE_SECONDS then
				self.isCheckingQueue = true
			end

			delta = 1
		end
	else
		if self.time > self.DELAY_AFTER_MOVE_SECONDS then
			self.didPlayerMove = true
		end
	end

	self.panelStyle.color[4] = delta
	self.spinningIcon:setAlpha(delta)
end

return CutsceneTransition
