--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/DragonEat.lua
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
local CacheRef = require "ItsyScape.Game.CacheRef"
local Actor = require "ItsyScape.Game.Model.Actor"
local Projectile = require "ItsyScape.Graphics.Projectile"

local Eat = Class(Projectile)
Eat.CHOMP_TIME_SECONDS = 30 / 24
Eat.DURATION = 5
Eat.MOUTH_OFFSET = Vector(0, -1.5, 4)

function Eat:getDuration()
	return self.DURATION
end

function Eat:load()
	Projectile.load(self)

	self:playAnimation(self:getSource(), "Dragon_Eat", "x-dragon-eat", 1000)
	self.chompTime = 0
	self.chomped = false
end

function Eat:poof()
	Projectile.poof(self)

	self:stopAnimation(self:getDestination(), "x-dragon-eat")
end

function Eat:update(elapsed)
	Projectile.update(self, elapsed)

	self.chompTime = self.chompTime + elapsed
	if self.chompTime > self.CHOMP_TIME_SECONDS then
		if not self.chomped then
			self:playAnimation(self:getDestination(), "Human_Run_Crazy_1", "x-dragon-eat", 1000)
		end

		local destination = self:getDestination()
		local source = self:getSource()
		if Class.isCompatibleType(destination, Actor) and
		   Class.isCompatibleType(source, Actor)
		then
			local destinationView = self:getGameView():getView(destination)
			local sourceView = self:getGameView():getView(source)

			local _, _, layer = destination:getTile()
			local map = self:getGameView():getMapSceneNode(layer)
			local position = sourceView:getBoneWorldPosition("head", self.MOUTH_OFFSET)

			local transform = map:getTransform():getGlobalDeltaTransform(_APP:getFrameDelta())
			local mapPosition = position:inverseTransform(transform)

			destinationView:move(mapPosition, layer, not self.chomped)
		end

		self.chomped = true
	end
end

return Eat
