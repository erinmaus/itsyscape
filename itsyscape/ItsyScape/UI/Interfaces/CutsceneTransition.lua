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
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Drawable = require "ItsyScape.UI.Drawable"

local CutsceneTransition = Class(Interface)
CutsceneTransition.FADE_DURATION_SECONDS = 0.5
CutsceneTransition.DELAY_AFTER_MOVE_SECONDS = 1

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

	self.panelStyle = panelStyle

	self:setZDepth(5000)

	local game = self:getView():getGame()
	local player = game:getPlayer()
	player.onMove:register(self.onPlayerMove, self)

	self.didPlayerMove = false
	self.isCheckingQueue = false
	self.wasQueueEmpty = false
	self.time = 0
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

	self.time = self.time + delta
	local delta = math.min(self.time / CutsceneTransition.FADE_DURATION_SECONDS, 1)

	if self.didPlayerMove then
		if self.wasQueueEmpty then
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
		elseif self.isCheckingQueue then
			local resources = self:getView():getGameView():getResourceManager()
			self.wasQueueEmpty = self.wasQueueEmpty or not resources:getIsPending()

			if self.wasQueueEmpty then
				self:sendPoke("close", nil, {})
				self.time = 0
			end

			delta = 1
		else
			if self.time > CutsceneTransition.DELAY_AFTER_MOVE_SECONDS then
				self.isCheckingQueue = true
			end

			delta = 1
		end
	end

	self.panelStyle.color[4] = delta
end

return CutsceneTransition
