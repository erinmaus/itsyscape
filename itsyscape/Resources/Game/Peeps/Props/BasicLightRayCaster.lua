--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicLightRayCaster.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local LightRaySourceBehavior = require "ItsyScape.Peep.Behaviors.LightRaySourceBehavior"

local BasicLightRayCaster = Class(Prop)

function BasicLightRayCaster:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1.5, 1.5, 1.5)

	self:addPoke('rotate')

	self:addBehavior(LightRaySourceBehavior)
end

function BasicLightRayCaster:getPropState()
	local state = { rays = {} }

	local light = self:getBehavior(LightRaySourceBehavior)
	if light then
		if #light.paths > 0 then
			for _, path in ipairs(light.paths) do
				local results = {}
				for _, node in path:iterate() do
					local result = {
						a = { node:getInputRay().origin:get() },
						b = { node:getOutputRay().origin:get() },
						direction = { node:getOutputRay().origin:get() },
						id = node:getMirror():getTally()
					}

					table.insert(results, result)
				end

				table.insert(state.rays, results)
			end
		else
			for _, ray in ipairs(light.rays) do
				local results = {}

				local transformedRay
				do
					local transformedOrigin = ray.origin + Utility.Peep.getAbsolutePosition(self)
					local transformedDirection = ray.direction

					local rotation = self:getBehavior(RotationBehavior)
					if rotation then
						local transform = love.math.newTransform()
						transform:applyQuaternion(rotation.rotation:get())
						transformedDirection = Vector(transform:transformPoint(transformedDirection:get()))
					end

					transformedRay = Ray(transformedOrigin, transformedDirection)
				end

				table.insert(results, {
					a = { transformedRay.origin:get() },
					b = { transformedRay:project(100):get() },
					direction = { transformedRay.direction:get() },
					id = 0
				})

				table.insert(state.rays, results)
			end
		end
	end

	return state
end

return BasicLightRayCaster
