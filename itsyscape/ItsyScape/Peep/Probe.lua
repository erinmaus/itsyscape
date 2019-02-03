--------------------------------------------------------------------------------
-- ItsyScape/Peep/Probe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
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
			if p then
				local s, t = Utility.Peep.getTile(peep)
				local i, j = Utility.Peep.getTile(other)
				local u = math.abs(s - i)
				local v = math.abs(t - j)
				local difference = u + v
				if difference <= distance then
					return true
				end
			end

			return false
		end
	end
end

function Probe.resource(resourceType, resourceName)
	return function(peep)
		local resource = Utility.Peep.getResource(peep)
		if resource then
			if type(resourceType) == 'string' then
				local gameDB = peep:getDirector():getGameDB()
				
				local t = gameDB:getBrochure():getResourceTypeFromResource(resource)
				return t.name:lower() == resourceType:lower() and
				       resourceName:lower() == resource.name:lower()
			else
				return resource.id == resourceType.id
			end
		end

		return false
	end
end

function Probe.mapObject(obj)
	return function(peep)
		local mapObject = Utility.Peep.getMapObject(peep)
		if mapObject then
			return mapObject.id.value == obj.id.value
		end

		return false
	end
end

function Probe.namedMapObject(name)
	return function(peep)
		local gameDB = peep:getDirector():getGameDB()
		local resource = Utility.Peep.getMapObject(peep)
		if resource then
			local location = gameDB:getRecord("MapObjectLocation", { Resource = resource })
			if location and location:get("Name") == name then
				return true
			end
		end

		return false
	end
end

function Probe.attackable()
	return function(peep)
		return Utility.Peep.canAttack(peep)
	end
end

function Probe.actionOutput(actionType, outputName, outputType)
	return function(peep)
		local resource = Utility.Peep.getResource(peep)
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

return Probe
