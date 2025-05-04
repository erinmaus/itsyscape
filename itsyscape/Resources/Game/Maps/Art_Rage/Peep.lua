--------------------------------------------------------------------------------
-- Resources/Game/Maps/Art_Rage/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local MapScript = require "ItsyScape.Peep.Peeps.Map"

local Art = Class(MapScript)
Art.MIN_LIGHTNING_PERIOD = 4
Art.MAX_LIGHTNING_PERIOD = 5

function Art:new(resource, name, ...)
	MapScript.new(self, resource, name or "Art_Rage", ...)
end

function Art:onLoad(...)
	MapScript.onLoad(self, ...)

	Utility.Map.spawnMap(self, "Test123_Storm", Vector.ZERO, { isLayer = true })
end

function Art:onZap()
	self.lightningTime = love.math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function Art:onBoom()
	local director = self:getDirector()
	local map = director:getMap(self:getLayer())
	if not map then
		return
	end

	local i = love.math.random(28, 34)
	local j = love.math.random(28, 34)

	local position = Utility.Map.getAbsoluteTilePosition(director, i, j, self:getLayer())

	local stage = director:getGameInstance():getStage()
	--stage:fireProjectile("StormLightning", Vector.ZERO, position, self:getLayer())
	--stage:fireProjectile("CannonSplosion", Vector.ZERO, position, self:getLayer())
end

function Art:update(...)
	MapScript.update(self, ...)

	self.lightningTime = (self.lightningTime or 0) - self:getDirector():getGameInstance():getDelta()
	if self.lightningTime < 0 then
		self:onZap()
		self:onBoom()
	end
end

return Art
