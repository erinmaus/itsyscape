--------------------------------------------------------------------------------
-- Resources/Game/Effects/Tutorial_SillyClick/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local Effect = require "ItsyScape.Peep.Effect"

local SillyClick = Class(Effect)
SillyClick.INTERVAL = 1
SillyClick.NUM_CLICKS = 3

function SillyClick:new(activator)
	Effect.new(self)

	self.n = 0
	self.lastActionTime = love.timer.getTime()
	self._onActionTried = function(e)
		local actionID = e and e.actionID

		print(">>> actionTried", actionID)

		local currentTime = love.timer.getTime()
		local previousTime = self.lastActionTime

		if not self.currentAction or (action and self.currentActionID ~= actionID) then
			self.currentAction = action

			if currentTime - previousTime < self.INTERVAL then
				self.n = self.n + 1
			else
				self.n = 0
			end
		elseif self.currentAction and action and self.currentActionID == actionID then
			if currentTime - previousTime < self.INTERVAL then
				self.n = self.n + 1
			end
		end

		if self.n >= self.NUM_CLICKS and self:getPeep() then
			if not Utility.UI.isOpen(self:getPeep(), "SillyClick") then
				Utility.UI.openInterface(self:getPeep(), "SillyClick")
			end

			self.n = 0
		end

		self.lastActionTime = currentTime
	end

	self._onMove = function(peep)
		peep:removeEffect(self)
	end
end

function SillyClick:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function SillyClick:sizzle()
	self:getPeep():silence("actionTried", self._onActionTried)
	self:getPeep():silence("move", self._onMove)

	Effect.sizzle(self)
end

function SillyClick:enchant(peep)
	Effect.enchant(self, peep)

	self:getPeep():listen("actionTried", self._onActionTried)
	self:getPeep():listen("move", self._onMove)
end

function SillyClick:update(delta)
	Effect.update(self, delta)

	local currentTime = love.timer.getTime()
	if currentTime - self.lastActionTime >= self.INTERVAL then
		self.n = math.max(self.n - 1, 0)
		self.lastActionTime = currentTime
	end
end

return SillyClick
