--------------------------------------------------------------------------------
-- ItsyScape/Peep/Probe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local ShipCrewMemberBehavior = require "ItsyScape.Peep.Behaviors.ShipCrewMemberBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local Mapp = require "ItsyScape.GameDB.Mapp"

local Probe = {}

function Probe.bind(...)
	return Function(...)
end

local _none = function()
	return false
end

function Probe.none()
	return _none
end

local _any = function()
	return true
end

function Probe.any()
	return _any
end

local _distance = function(position, distance, other)
	local otherPosition = Utility.Peep.getAbsolutePosition(other) * Vector.PLANE_XZ
	local otherDistance = (position - otherPosition):getLength()
	return otherDistance <= distance
end

function Probe.distance(p, distance)
	local position
	if Class.isCompatibleType(p, Vector) then
		position = p
	else
		position = Utility.Peep.getAbsolutePosition(p)
	end

	position = position * Vector.PLANE_XZ

	return Function(_distance, position, distance)
end


local _near = function(peep, distance, other)
	local s, t = Utility.Peep.getTile(peep)
	local i, j = Utility.Peep.getTile(other)
	local u = math.abs(s - i)
	local v = math.abs(t - j)
	local difference = u + v
	return difference <= distance
end

function Probe.near(peep, distance)
	return Function(_near, peep, distance)
end

local _resource = function(resourceType, resourceName, peep)
	local resource = Utility.Peep.getResource(peep)
	if resource then
		if type(resourceType) == 'string' then
			local gameDB = peep:getDirector():getGameDB()
			
			local t = gameDB:getBrochure():getResourceTypeFromResource(resource)
			return t.name:lower() == resourceType:lower() and
			       resourceName:lower() == resource.name:lower()
		else
			return resource.id.value == resourceType.id.value
		end
	end

	return false
end

function Probe.resource(resourceType, resourceName)
	return Function(_resource, resourceType, resourceName)
end

local _mapObject = function(obj, peep)
	local mapObject = Utility.Peep.getMapObject(peep)
	if mapObject then
		return mapObject.id.value == obj.id.value
	end

	return false
end

function Probe.mapObject(obj)
	return Function(_mapObject, obj)
end

local _namedMapObject = function(name, peep)
	local gameDB = peep:getDirector():getGameDB()
	local resource = Utility.Peep.getMapObject(peep)
	if resource then
		local location = gameDB:getRecord("MapObjectLocation", { Resource = resource })
		local reference = gameDB:getRecord("MapObjectReference", { Resource = resource })

		if (location and location:get("Name") == name) or
		   (reference and reference:get("Name") == name)
		then
			return true
		end
	end

	return false
end

function Probe.namedMapObject(name)
	return Function(_namedMapObject, name)
end

local _instance = function(player, any, peep)
	local instance = peep:getBehavior(InstancedBehavior)
	if not instance and any then
		return true
	end

	return instance and instance.playerID == player:getID()
end

function Probe.instance(player, any)
	return Function(_instance, player, any)
end

local _player = function(peep)
	return peep:hasBehavior(PlayerBehavior)
end

function Probe.player()
	return _player
end

local _follower = function(player, peep)
	local follower = peep:getBehavior(FollowerBehavior)
	return follower and follower.playerID == player:getID()
end

function Probe.follower(player)
	return Function(_follower, player, peep)
end

local _crew = function(ship, peep)
	local crew = peep:getBehavior(ShipCrewMemberBehavior)
	return crew and crew.ship == ship
end

function Probe.crew(ship)
	return Function(_crew, ship)
end

local _mapObjectGroup = function(name, peep)
	local gameDB = peep:getDirector():getGameDB()
	local mapObject = Utility.Peep.getMapObject(peep)
	if mapObject then
		local record = gameDB:getRecord("MapObjectGroup", {
			MapObject = mapObject,
			MapObjectGroup = name,
			Map = Utility.Peep.getMapResource(peep)
		})

		if record then
			return true
		end
	end

	return false
end

function Probe.mapObjectGroup(name)
	return Function(_mapObjectGroup, name)
end

local _attackable = function(peep)
	return Utility.Peep.isAttackable(peep)
end

function Probe.attackable()
	return _attackable
end

local _actionOutput = function(actionType, outputName, outputType, peep)
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

function Probe.actionOutput(actionType, outputName, outputType)
	return Function(_actionOutput, actionType, outputName, outputType)
end

local _layer = function(layer, peep)
	local position = peep:getBehavior(PositionBehavior)
	return position and position.layer == layer
end

function Probe.layer(layer)
	return Function(_layer, layer)
end

local _component = function(ComponentType, peep)
	return peep:hasBehavior(ComponentType)
end

function Probe.component(ComponentType)
	return Function(_component, ComponentType)
end

return Probe
