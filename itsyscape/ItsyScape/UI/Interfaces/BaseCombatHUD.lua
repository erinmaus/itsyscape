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
	self.playerInfo:setZDepth(1)

	self.targetInfo = CombatTarget("right", self:getView():getResources())
	self.targetInfo:setZDepth(0.5)

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

function BaseCombatHUD:show()
	self.isShowing = true
end

function BaseCombatHUD:hide()
	self.isShowing = false
end

function BaseCombatHUD:isShowing()
	return self.isShowing
end

function BaseCombatHUD:update(delta)
	Interface.update(self, delta)

	local showPlayer = self.isShowing
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
