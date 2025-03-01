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

function BaseCombatHUD:new(...)
	Interface.new(self, ...)

	self.playerInfo = CombatTarget("left", self:getView():getResources())
	self.targetInfo = CombatTarget("right", self:getView():getResources())

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
end

function BaseCombatHUD:update(delta)
	Interface.update(self, delta)

	local state = self:getState()
	if #state.combatants > 1 then
		local playerState = state.player
		self.playerInfo:updateTarget(playerState)

		for _, combatantState in ipairs(state.combatants) do
			if combatantState.actorID == playerState.targetID then
				self.targetInfo:updateTarget(combatantState)
				break
			end
		end

		if not self.playerInfo:getParent() then
			self:addChild(self.playerInfo)
		end

		if not self.targetInfo:getParent() then
			self:addChild(self.targetInfo)
		end
	else
		if self.playerInfo:getParent() then
			self:removeChild(self.playerInfo)
		end

		if self.targetInfo:getParent() then
			self:removeChild(self.targetInfo)
		end
	end
end

return BaseCombatHUD
