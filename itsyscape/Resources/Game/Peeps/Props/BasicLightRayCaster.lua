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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
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
		for _, path in ipairs(light.paths) do
			local results = {}
			for _, node in path:iterate() do
				local result = {
					a = { node:getInputRay().origin:get() },
					b = { node:getOutputRay().origin:get() },
					id = node:getMirror():getTally()
				}

				table.insert(results, result)
			end

			table.insert(state.rays, results)
		end
	end

	return state
end

return BasicLightRayCaster
