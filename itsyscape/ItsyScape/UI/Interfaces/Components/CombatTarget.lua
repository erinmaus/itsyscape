--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/CombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Utility = require "ItsyScape.Game.Utility"
local Variables = require "ItsyScape.Game.Variables"
local Drawable = require "ItsyScape.UI.Drawable"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Widget = require "ItsyScape.UI.Widget"
local StandardHealthBar = require "ItsyScape.UI.Interfaces.Components.StandardHealthBar"
local StandardZealOrb = require "ItsyScape.UI.Interfaces.Components.StandardZealOrb"
local Particles = require "ItsyScape.UI.Particles"

local CombatTarget = Class(Widget)
CombatTarget.ALIGN_LEFT = "left"
CombatTarget.ALIGN_RIGHT = "right"

function CombatTarget:new(align, resources)
	Widget.new(self)

	self.rowWidth = 400
	self.titleHeight = 48
	self.healthHeight = 32
	self.zealHeight = 96
	self.padding = 4
	self.align = align

	self.titleLabel = Label()
	self.titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
		fontSize = 24,
		textShadow = true,
		spaceLines = true,
		color = { 1, 1, 1, 1 }
	}, resources))
	self:addChild(self.titleLabel)

	self:setIsSelfClickThrough(true)
	self:setSize(
		self.rowWidth,
		self.titleHeight + math.max(self.healthHeight, self.zealHeight) + self.padding * 3)
end

function CombatTarget:getRowSize()
	return self.rowWidth, self.rowHeight
end

function CombatTarget:setRowSize(w, h)
	self.rowWidth = w or self.rowWidth
	self.rowHeight = h or self.rowHeight

	self:setSize(
		self.rowWidth,
		self.titleHeight + math.max(self.healthHeight, self.zealHeight) + self.padding * 3)

	self:performLayout()
end

function CombatTarget:getOverflow()
	return true
end

function CombatTarget:getHealthBar()
	return self.healthBar
end

function CombatTarget:getZealOrb()
	return self.zealOrb
end

function CombatTarget:performLayout()
	self.titleLabel:setPosition(0, 0)
	self.titleLabel:setSize(self.rowWidth, self.titleHeight)

	if self.healthBar then
		self.healthBar:setSize(self.rowWidth, self.healthHeight)
		self.healthBar:setPosition(0, self.titleHeight)
	end

	if self.zealOrb then
		self.zealOrb:setSize(self.zealHeight, self.zealHeight)

		if self.align == self.ALIGN_LEFT then
			self.zealOrb:setPosition(-self.zealHeight - self.padding, self.titleHeight)
		elseif self.align == self.ALIGN_RIGHT then
			self.zealOrb:setPosition(self.rowWidth + self.padding * 2, self.titleHeight)
		end
	end
end

function CombatTarget:updateTarget(targetInfo)
	local healthBarType = targetInfo.meta.healthBarTypeName and require(targetInfo.meta.healthBarTypeName) or StandardHealthBar
	if self.healthBarType ~= healthBarType then
		if self.healthBar then
			self:removeChild(self.healthBar)
		end

		self.healthBarType = healthBarType
		self.healthBar = healthBarType()
		self:addChild(self.healthBar)
	end

	local zealOrbType = targetInfo.meta.zealOrbTypeName and require(targetInfo.meta.zealOrbTypeName) or StandardZealOrb
	if self.zealOrbType ~= zealOrbType then
		if self.zealOrb then
			self:removeChild(self.zealOrb)
		end

		self.zealOrbType = zealOrbType
		self.zealOrb = zealOrbType()
		self:addChild(self.zealOrb)
	end

	self:performLayout()

	self.healthBar:updateHealth(targetInfo.stats.hitpoints.current, targetInfo.stats.hitpoints.max)
	self.zealOrb:updateZeal(targetInfo.stats.zeal.current, targetInfo.stats.zeal.max)
	self.zealOrb:updateZealTier(targetInfo.stats.zeal.tier)
	self.titleLabel:setText((targetInfo.name or ""):gsub(Utility.Text.INFINITY, "infinite"))
end

return CombatTarget
