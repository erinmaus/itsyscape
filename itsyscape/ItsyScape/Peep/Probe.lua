--------------------------------------------------------------------------------
-- ItsyScape/Peep/Probe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local Mapp = require "ItsyScape.GameDB.Mapp"

local Probe = {}

function Probe.none()
	return function(peep)
		return false
	end
end

function Probe.near(peep, distance)
	local position = peep:getBehavior(PositionBehavior)
	if not position then
		return Probe.none()
	else
		return function(other)
			local p = other:getBehavior(PositionBehavior)
			if p and position.layer == p.layer then
				local dx = position.position.x - p.position.x
				local dz = position.position.z - p.position.z
				local difference = math.sqrt(dx ^ 2 + dz ^ 2)
				if difference < distance then
					return true
				end
			end

			return false
		end
	end
end

function Probe.resource(resourceType, resourceName)
	return function(peep)
		if peep.getGameDBResource then
			local resource = peep:getGameDBResource()
			if resource then
				local gameDB = peep:getDirector():getGameDB()
				
				local resourceType = gameDB:getBrochure():getResourceTypeFromResource(resource)
				return resourceType.name:lower() == resourceType:lower() and
				       resourceName:lower() == resource.name:lower()
			end

			return false
		end
	end
end

function Probe.actionOutput(actionType, outputName, outputType)
	return function(peep)
		if peep.getGameDBResource then
			local resource = peep:getGameDBResource()
			if resource then
				local gameDB = peep:getDirector():getGameDB()
				local brochure = gameDB:getBrochure()
				
				for action in brochure:findActionsByResource(resource) do
					local a = brochure:getActionDefinitionFromAction(action)
					if a.name:lower() == actionType:lower() then
						for output in brochure:getOutputs(action) do
							local outputResource = brochure:getConstraintResource(output)
							local outputResourceType = brochure:getResourceTypeFromResource(outputResource)
							if outputResourceType.name:lower() == outputType:lower() and
							   outputResource.name:lower() == outputName:lower()
							then
								return true
							end
						end
					end
				end
			end

			return false
		end
	end
end

return Probe
