--------------------------------------------------------------------------------
-- Resources/Game/Peeps/ViziersRock/RatKingJesterPresent.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local NVoronoiPointsBuffer = require "nbunny.world.voronoipointsbuffer"
local NVoronoiDiagram = require "nbunny.world.voronoidiagram"

local RatKingJesterPresent = Class(Prop)
RatKingJesterPresent.RELAX_ITERATIONS = 20
RatKingJesterPresent.SHIFT = 12
RatKingJesterPresent.COLORS = {
	"ffcc00",
	"c83737",
	"bcd35f",
	"80e5ff",
	"bc5fd3",
}
RatKingJesterPresent.MAX_SHAPE_TYPE_INDEX = 4
RatKingJesterPresent.OFFSETS = {
	{ 32, 32 },
	{ 32, 96 },
	{ 96, 32 },
	{ 96, 96 }
}
RatKingJesterPresent.SIZE = 128

function RatKingJesterPresent:new(...)
	Prop.new(self, ...)

	self:addPoke('presentify')
	self:addPoke('pick')
	self:addPoke('land')

	self.landed = false
end

function RatKingJesterPresent:onFinalize(...)
	Prop.onFinalize(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3)

	if not self.propState then
		self:poke('presentify')
	end
end

function RatKingJesterPresent:onPresentify(seed)
	seed = seed or love.math.random(0, 2 ^ 32 - 1)
	local rng = love.math.newRandomGenerator(seed)

	local c = {}
	for i = 1, #self.COLORS do
		c[i] = self.COLORS[i]
	end

	local ribbonColor = table.remove(c, rng:random(#c))
	local paperColor = table.remove(c, rng:random(#c))
	local shapeColor = table.remove(c, rng:random(#c))

	self.propState = {
		ribbonColor = { Color.fromHexString(ribbonColor):get() },
		paperColor = { Color.fromHexString(paperColor):get() },
		shapes = {}
	}

	local numShapes = #self.OFFSETS
	for i = 1, numShapes do
		local shapeIndex = rng:random(1, self.MAX_SHAPE_TYPE_INDEX)
		local x, y = unpack(self.OFFSETS[i])

		x = x + rng:random(-self.SHIFT, self.SHIFT)
		y = y + rng:random(-self.SHIFT, self.SHIFT)

		local shapeState = {
			index = shapeIndex,
			rotation = rng:random() * math.pi * 2,
			x = x / self.SIZE,
			y = y / self.SIZE,
			color = { Color.fromHexString(shapeColor):get() },
		}

		table.insert(self.propState.shapes, shapeState)
	end
end

function RatKingJesterPresent:spawnOrPoofTile(tile, i, j, mode)
	-- Nothing.
end

function RatKingJesterPresent:getPropState()
	return self.propState or {}
end

function RatKingJesterPresent:update(...)
	Prop.update(self, ...)

	local position = Utility.Peep.getPosition(self)
	local i, j = Utility.Peep.getTile(self)
	local map = Utility.Peep.getMap(self)

	if map then
		local minY = map:getInterpolatedHeight(position.x, position.z)
		local gravity = self:getDirector():getGameInstance():getStage():getGravity()
		local currentY = position.y + gravity.y * self:getDirector():getGameInstance():getDelta()
		local y = math.max(currentY, minY)

		if currentY > minY then
			self.landed = false
		elseif currentY <= minY then
			if not self.landed then
				self.landed = true
				self:poke('land')
			end
		end

		Utility.Peep.setPosition(self, Vector(position.x, y, position.z))
	end 
end

return RatKingJesterPresent
