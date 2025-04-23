--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicCannonPath.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local ICannon = require "ItsyScape.Game.Skills.ICannon"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local CannonPath = Class(PassableProp)

function CannonPath:new(...)
	PassableProp.new(self, ...)
	self:addPoke("aim")
end

function CannonPath:onAim(peep, cannon)
	self.targetPeep = peep
	self.targetCannon = cannon

	self.currentRotation = false
	self.currentPosition = false
end

function CannonPath:getTargetPeep()
	return self.targetPeep
end

function CannonPath:getTargetCannon()
	return self.targetCannon
end

function CannonPath:update(director, game)
	PassableProp.update(self, director, game)

	if not (self.targetPeep and self.targetCannon) then
		return
	end

	local position = Utility.Peep.getPosition(self.targetCannon)
	local rotation = self.targetCannon:getCannonDirection()

	if (not self.currentRotation or self.currentRotation ~= rotation) or
	   (not self.currentPosition or self.currentPosition ~= position)
	then
		local properties = Sailing.Cannon.getCannonballPathProperties(self.targetPeep, self.targetCannon)
		local cannonballPath, cannonballPathDuration = Sailing.Cannon.buildCannonballPath(self.targetCannon, properties)

		local path = {}
		for i = 1, #cannonballPath - 1 do
			local a = cannonballPath[i].position
			local b = (cannonballPath[i + 1] or cannonballPath[i]).position

			table.insert(path, { a = { a:get() }, b = { b:get() } })
		end

		local hit
		local instance = Utility.Peep.getInstance(self)
		for _, layer in instance:iterateLayers() do
			for _, node in ipairs(cannonballPath) do
				local position = node.position
				local mapScript = instance:getMapScriptByLayer(layer)
				local map = Utility.Peep.getMap(mapScript)

				local transform = Utility.Peep.getMapTransform(mapScript)
				local relativePosition = position:inverseTransform(transform)
				if relativePosition.x >= 0 and relativePosition.x <= map:getWidth() * map:getCellSize() and
				   relativePosition.z >= 0 and relativePosition.z <= map:getHeight() * map:getCellSize()
				then
					local y = map:getInterpolatedHeight(relativePosition.x, relativePosition.z)

					if relativePosition.y <= y then
						hit = Vector(relativePosition.x, y, relativePosition.z)
						break
					end
				end
			end

			if hit then
				break
			end
		end

		self.currentPropState = {
			path = path,
			hit = hit and { hit:get() }
		}

		self.currentRotation = rotation
		self.currentPosition = position
	end
end

function CannonPath:getPropState()
	return self.currentPropState or { path = {} }
end

return CannonPath
