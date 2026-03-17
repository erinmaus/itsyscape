--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/CthulhuGlare/Projectile.lua
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

local Glare = Class(Projectile)

Glare.DURATION = 1.0

Glare.OFFSETS = {
	Vector(3, 2.5, 5.5),
	Vector(-3, 2.5, 5.5),
}

Glare.COLORS = {
	Color.fromHexString("ff0000"),
	Color.fromHexString("ff6600")
}

Glare.ALPHA_MULTIPLIER = 1.75
Glare.NUM_BEAMS = 6

Glare.INNER_RADIUS = 3
Glare.OUTER_RADIUS = 8

function Glare:attach()
	Projectile.attach(self)
end

function Glare:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.beams = {}
	for _, offset in ipairs(self.OFFSETS) do
		for i = 1, self.NUM_BEAMS do
			local colorIndex = (i % #self.COLORS) + 1

			local beam = LightBeamSceneNode()
			beam:setParent(root)
			beam:setBeamSize(1)
			beam:getMaterial():setIsFullLit(true)
			beam:getMaterial():setIsZWriteDisabled(true)
			beam:getMaterial():setColor(self.COLORS[colorIndex])

			local x = (love.math.random() - 0.5) * 2
			local y = (love.math.random() - 0.5) * 2
			local z = love.math.random()

			local normal = Vector(x, y, z):getNormal()
			if normal:getLengthSquared() == 0 then
				normal = Vector(0, 0, -1):getNormal()
			end

			local p1 = normal * Vector(self.INNER_RADIUS) + offset
			local p2 = normal * Vector(self.OUTER_RADIUS) + offset

			local path = {
				{ a = { p1:get() }, b = { p1:get() } },
				{ a = { p2:get() }, b = { p2:get() } },
			}

			beam:buildSeamless(path)

			table.insert(self.beams, beam)
		end
	end

	self.currentPath = {}
end

function Glare:getDuration()
	return self.DURATION
end

function Glare:update(elapsed)
	Projectile.update(self, elapsed)

	local gameView = self:getGameView()

	local currentGlarePosition
	do
		local actorView = gameView:getActor(self:getSource())
		if actorView then
			currentGlarePosition = actorView:getBoneWorldPosition("head", Vector.ZERO)
		else
			currentGlarePosition = Vector.ZERO
		end
	end

	self:getRoot():getTransform():setLocalTranslation(currentGlarePosition)

	local delta = self:getDelta()
	local alpha = math.abs(math.sin(delta * math.pi)) * self.ALPHA_MULTIPLIER
	alpha = math.min(alpha, 1)

	for _, beam in ipairs(self.beams) do
		local color = beam:getMaterial():getColor()
		beam:getMaterial():setColor(Color(color.r, color.g, color.b, alpha))
	end

	self:ready()
end

return Glare
