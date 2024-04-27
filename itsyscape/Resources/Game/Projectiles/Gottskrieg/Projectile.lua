--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Gottskrieg/Projectile.lua
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

local Staff = Class(Projectile)
Staff.DURATION = 1.0
Staff.OFFSET_POSITION = Vector(0.75, 0, 0)
Staff.COLORS = {
	Color.fromHexString("ff0000"),
	Color.fromHexString("ff6600")
}
Staff.ALPHA_MULTIPLIER = 1.75
Staff.NUM_BEAMS = 10

Staff.INNER_RADIUS = 0.5
Staff.OUTER_RADIUS = 2

function Staff:attach()
	Projectile.attach(self)
end

function Staff:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.beams = {}
	for i = 1, Staff.NUM_BEAMS do
		local colorIndex = (i % #Staff.COLORS) + 1

		local beam = LightBeamSceneNode()
		beam:setParent(root)
		beam:setBeamSize(0.25)
		beam:getMaterial():setIsFullLit(true)
		beam:getMaterial():setIsZWriteDisabled(true)
		beam:getMaterial():setColor(Staff.COLORS[colorIndex])

		local x = (love.math.random() - 0.5) * 2
		local y = (love.math.random() - 0.5) * 2
		local z = (love.math.random() - 0.5) * 2

		local normal = Vector(x, y, z):getNormal()
		if normal:getLengthSquared() == 0 then
			normal = Vector(1, 0, 1):getNormal()
		end

		local p1 = normal * Vector(Staff.INNER_RADIUS)
		local p2 = normal * Vector(Staff.OUTER_RADIUS)

		local path = {
			{ a = { p1:get() }, b = { p1:get() } },
			{ a = { p2:get() }, b = { p2:get() } },
		}

		beam:buildSeamless(path)

		table.insert(self.beams, beam)
	end

	self.currentPath = {}
end

function Staff:getDuration()
	return Staff.DURATION
end

function Staff:update(elapsed)
	Projectile.update(self, elapsed)

	local gameView = self:getGameView()

	local currentStaffPosition
	do
		local actorView = gameView:getActor(self:getSource())
		if actorView then
			currentStaffPosition = actorView:getBoneWorldPosition("hand.r", self.OFFSET_POSITION)
		else
			currentStaffPosition = Vector.ZERO
		end
	end

	self:getRoot():getTransform():setLocalTranslation(currentStaffPosition)

	local delta = self:getDelta()
	local alpha = math.abs(math.sin(delta * math.pi)) * Staff.ALPHA_MULTIPLIER
	alpha = math.min(alpha, 1)

	for _, beam in ipairs(self.beams) do
		local color = beam:getMaterial():getColor()
		beam:getMaterial():setColor(Color(color.r, color.g, color.b, alpha))
	end

	self:ready()
end

return Staff
