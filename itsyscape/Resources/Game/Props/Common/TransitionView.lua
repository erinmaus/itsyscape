--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/TransitionView.lua
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
local PropView = require "ItsyScape.Graphics.PropView"

local TransitionView = Class(PropView)

TransitionView.TWEEN = Tween.bounceOut 
TransitionView.TIME = 2

function TransitionView:instantiateInactiveView(prop, gameView)
	return Class.ABSTRACT()
end

function TransitionView:instantiateActiveView(prop, gameView)
	return Class.ABSTRACT()
end

function TransitionView:getIsActive()
	return Class.ABSTRACT()
end

function TransitionView:updateActiveAlpha(propView, alpha)
	-- Nothing.
end

function TransitionView:updateInactiveAlpha(propView, alpha)
	-- Nothing.
end

function TransitionView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local prop = self:getProp()
	local gameView = self:getGameView()

	self.inactiveView = self:instantiateInactiveView(prop, gameView)
	self.inactiveView:load()

	self.activeView = self:instantiateActiveView(prop, gameView)
	self.activeView:load()

	resources:queueEvent(function()
		local isActive = self:getIsActive()

		self.isActive = isActive
		self.time = self.TIME

		self.inactiveView:getRoot():setParent(root)
		self.activeView:getRoot():setParent(root)
	end)
end

function TransitionView:tick()
	PropView.tick(self)

	self.inactiveView:tick()
	self.activeView:tick()

	local isActive = self:getIsActive()
	if self.time and self.isActive ~= isActive then
		self.isActive = isActive
		self.time = self.TIME - self.time
	end
end

function TransitionView:update(delta)
	PropView.update(self, delta)

	self.inactiveView:update(delta)
	self.activeView:update(delta)

	if self.time then
		self.time = math.min(self.time + delta, self.TIME)

		local delta = self.time / self.TIME
		local tweenedDelta = self.TWEEN(delta)

		local inactiveAlpha, activeAlpha
		if self.isActive then
			inactiveAlpha = 1 - tweenedDelta
			activeAlpha = tweenedDelta
		else
			inactiveAlpha = tweenedDelta
			activeAlpha = 1 - tweenedDelta
		end

		self:updateInactiveAlpha(self.inactiveView, inactiveAlpha)
		self:updateActiveAlpha(self.activeView, activeAlpha)
	end
end

return TransitionView
