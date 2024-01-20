--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/TheEmptyKing_FullyRealized_Zweihander/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Color = require "ItsyScape.Graphics.Color"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"

local AncientZweihander = Class(Projectile)
AncientZweihander.DURATION = 2
AncientZweihander.OFFSET_POSITION = Vector(-4.15, -9, 0.1)
AncientZweihander.COLOR = Color.fromHexString("63396f")
AncientZweihander.DELTA_FADE_OUT = 0.75
AncientZweihander.DISTANCE = 0.5

function AncientZweihander:attach()
	Projectile.attach(self)
end

function AncientZweihander:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.trail = LightBeamSceneNode()
	self.trail:setParent(root)
	self.trail:setBeamSize(1)
	self.trail:getMaterial():setIsFullLit(true)
	self.trail:getMaterial():setIsZWriteDisabled(true)
	self.trail:getMaterial():setColor(self.COLOR)

	self.currentPath = {}
end

function AncientZweihander:getDuration()
	return AncientZweihander.DURATION
end

function AncientZweihander:update(elapsed)
	Projectile.update(self, elapsed)

	local gameView = self:getGameView()

	local currentSwordPosition
	do
		local actorView = gameView:getActor(self:getSource())
		if actorView then
			currentSwordPosition = actorView:getBoneWorldPosition("hand.r", self.OFFSET_POSITION)
		else
			currentSwordPosition = Vector.ZERO
		end
	end

	if self.previousSwordPosition then
		local distance = (self.previousSwordPosition - currentSwordPosition):getLength()
		if distance >= self.DISTANCE then
			table.insert(self.currentPath, {
				a = { self.previousSwordPosition:get() },
				b = { currentSwordPosition:get() },
			})

			self.previousSwordPosition = currentSwordPosition
		end
	else
		self.previousSwordPosition = currentSwordPosition
	end

	if #self.currentPath >= 1 then
		self.trail:buildSeamless(self.currentPath)
	end

	local alpha = self:getDelta()
	if alpha > self.DELTA_FADE_OUT then
		alpha = 1 - ((alpha - self.DELTA_FADE_OUT) / (1 - self.DELTA_FADE_OUT))
	else
		alpha = 1
	end

	self.trail:getMaterial():setColor(Color(self.COLOR.r, self.COLOR.g, self.COLOR.b, alpha))
end

return AncientZweihander
