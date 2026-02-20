--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Skilling.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local json = require "json"
local Utility = require "ItsyScape.Game.Utility"
local Curve = require "ItsyScape.Game.Curve"

local Skilling = {}

Skilling.ACTION_COMMAND_MAPPINGS = {}
Skilling.ACTION_COMMAND_MAPPINGS_BY_ID = {}

function Skilling.validateActionCommandMapping(mapping)
	if not mapping.actionType or type(mapping.actionType) ~= "string" or mapping.actionType == "" then
		return false
	end

	return true
end

function Skilling.compareActionCommandMapping(a, b)
	if not (a.mapObjects and b.mapObjects) and (a.mapObjects or b.mapObjects) then
		if a.mapObjects then
			return true
		end

		if b.mapObjects then
			return false
		end
	end

	local aOutputCount = a.outputs and #a.outputs or 0
	local bOutputCount = b.outputs and #b.outputs or 0

	if aOutputCount ~= bOutputCount and (aOutputCount > 0 or bOutputCount > 0) then
		if aOutputCount > bOutputCount then
			return true
		end

		if aOutputCount < bOutputCount then
			return false
		end
	end

	local aInputCount = a.inputs and #a.inputs or 0
	local bInputCount = b.inputs and #b.inputs or 0

	if aInputCount ~= bInputCount and (aInputCount > 0 or bInputCount > 0) then
		if aInputCount > bInputCount then
			return true
		end

		if aInputCount < bInputCount then
			return false
		end
	end

	local aRequirementCount = a.requirements and #a.requirements or 0
	local bRequirementCount = b.requirements and #b.requirements or 0

	if aRequirementCount ~= bRequirementCount and (aRequirementCount > 0 or bRequirementCount > 0) then
		if aRequirementCount > bRequirementCount then
			return true
		end

		if aRequirementCount < bRequirementCount then
			return false
		end
	end

	return a.id < b.id
end

function Skilling.getActionCommandMappings()
	local id = 0
	if #Skilling.ACTION_COMMAND_MAPPINGS == 0 then
		local folder = "Resources/Game/ActionCommands/Mappings"
		for _, item in ipairs(love.filesystem.getDirectoryItems(folder)) do
			local filename = string.format("%s/%s", folder, item)
			local mappings = json.decode(love.filesystem.read(filename))

			for _, mapping in ipairs(mappings) do
				if Skilling.validateActionCommandMapping(mapping) then
					id = id + 1
					mapping.id = id

					Skilling.ACTION_COMMAND_MAPPINGS_BY_ID[id] = mapping
					table.insert(Skilling.ACTION_COMMAND_MAPPINGS, mapping)
				else
					Log.warn("Couldn't validate action command mapping: %s", Log.dump(mapping))
				end
			end
		end

		table.sort(Skilling.ACTION_COMMAND_MAPPINGS, Skilling.compareActionCommandMapping)
		Log.info("Loaded and processed '%s' action command mappings.", #Skilling.ACTION_COMMAND_MAPPINGS)
	end

	return Skilling.ACTION_COMMAND_MAPPINGS
end

Skilling.ACTION_COMMAND_CACHE = {}

function Skilling._actionCommandMappingConstraintMatch(mappingConstraint, actionConstraint)
	if not (mappingConstraint.resource and mappingConstraint.resource == actionConstraint.resource) then
		return false
	end

	if not (mappingConstraint.resourceType and mappingConstraint.resourceType == actionConstraint.type) then
		return false
	end

	local count
	if mappingConstraint.level then
		count = Curve.XP_CURVE:compute(mappingConstraint.level)
	else
		count = mappingConstraint.count
	end

	if count and count ~= math.max(actionConstraint.count, 1) then
		return false
	end

	local minCount
	if mappingConstraint.minLevel then
		minCount = Curve.XP_CURVE:compute(mappingConstraint.minLevel)
	end
	minCount = (minCount or mappingConstraint.minCount) and math.min(minCount or 0, mappingConstraint.minCount or 0)

	local maxCount
	if mappingConstraint.maxLevel then
		maxCount = Curve.XP_CURVE:compute(mappingConstraint.maxLevel)
	end
	maxCount = (maxCount or mappingConstraint.maxCount) and math.max(maxCount or 0, mappingConstraint.maxCount or 0)

	if (minCount and minCount > math.max(actionConstraint.count, 1)) or (maxCount and maxCount < math.max(actionConstraint.count, 1)) then
		return false
	end

	return true
end

function Skilling._actionCommandMappingConstraintsMatch(mappingConstraints, actionConstraints)
	if not mappingConstraints then
		return true
	end

	for _, mappingConstraint in ipairs(mappingConstraints) do
		local isMatch = false

		for _, actionConstraint in ipairs(actionConstraints) do
			if Skilling._actionCommandMappingConstraintMatch(mappingConstraint, actionConstraint) then
				isMatch = true
				break
			end
		end

		if not isMatch then
			return false
		end
	end

	return true
end

function Skilling._getActionCommandMappingsForResource(resource, actions, director, mappings, result)
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()

	for _, action in ipairs(actions) do
		local constraints = Utility.getActionConstraints(game, action.instance:getAction())

		for _, mapping in ipairs(mappings) do
			local isMatch = false

			if mapping.mapObjects then
				for _, mapObject in ipairs(mapping.mapObjects) do
					local mapObjectMap = mapObject.map
					local mapObjectName = mapObject.name

					if mapObjectMap and mapObjectName then
						local mapResource = gameDB:getResource(mapObjectMap, "Map")

						local mapObjectRecord = mapResource and (gameDB:getRecord("MapObjectReference", {
							Name = mapObjectName,
							Map = mapResource
						}) or gameDB:getRecord("MapObjectLocation", {
							Name = mapObjectName,
							Map = mapResource
						}))

						local mapObjectResourceID = mapObjectRecord and mapObjectRecord:get("Resource").id.value
						if mapObjectResourceID and mapObjectResourceID == resource.id.value then
							isMatch = true
							break
						end
					end
				end
			end

			if (mapping.requirements or mapping.inputs or mapping.outputs) and
			   Skilling._actionCommandMappingConstraintsMatch(mapping.requirements, constraints.requirements) and
			   Skilling._actionCommandMappingConstraintsMatch(mapping.inputs, constraints.inputs) and
			   Skilling._actionCommandMappingConstraintsMatch(mapping.outputs, constraints.outputs)
			then
				isMatch = true
			end

			if isMatch then
				table.insert(result, mapping)
			end
		end
	end

	return result
end

function Skilling.getActionCommands(peep, director)
	director = director or peep:getDirector()
	local game = director:getGameInstance()

	local mapObject = Utility.Peep.getMapObject(peep)
	local mapObjectActions = mapObject and Utility.getActions(game, mapObject)
	local resource = Utility.Peep.getResource(peep)
	local resourceActions = resource and Utility.getActions(game, resource)

	local mapObjectMappings = mapObject and Skilling.ACTION_COMMAND_CACHE[mapObject.id.value] or nil
	local resourceMappings = resource and Skilling.ACTION_COMMAND_CACHE[resource.id.value] or nil

	if mapObjectMappings ~= nil or resourceMappings ~= nil then
		return (mapObjectMappings or nil) or (resourceMappings or nil)
	end

	local mappings = Skilling.getActionCommandMappings()

	local mapObjectMappings = {}
	if mapObject then
		if mapObjectActions then
			Skilling._getActionCommandMappingsForResource(mapObject, mapObjectActions, director, mappings, mapObjectMappings)
		end

		if resourceActions then
			Skilling._getActionCommandMappingsForResource(mapObject, resourceActions, director, mappings, mapObjectMappings)
		end
	end

	local resourceMappings = {}
	if resourceMappings then
		if mapObjectActions then
			Skilling._getActionCommandMappingsForResource(resource, mapObjectActions, director, mappings, resourceMappings)
		end

		if resourceActions then
			Skilling._getActionCommandMappingsForResource(resource, resourceActions, director, mappings, resourceMappings)
		end

		if #mapObjectMappings > 0 then
			for _, mapping in ipairs(resourceMappings) do
				table.insert(mapObjectMappings, mapping)
			end
		end
	end

	if #mapObjectMappings > 0 then
		Skilling.ACTION_COMMAND_CACHE[mapObject.id.value] = mapObjectMappings
		return mapObjectMappings
	elseif mapObject then
		Skilling.ACTION_COMMAND_CACHE[mapObject.id.value] = false
	end

	if #resourceMappings > 0 then
		Skilling.ACTION_COMMAND_CACHE[resource.id.value] = resourceMappings
		return resourceMappings
	elseif resource then
		Skilling.ACTION_COMMAND_CACHE[resource.id.value] = false
	end

	return nil
end

function Skilling.getActionCommandType(peep, actionInstance)
	local actionCommands = Skilling.getActionCommands(peep)
	if not actionCommands then
		return nil
	end

	for _, actionCommand in ipairs(actionCommands) do
		if actionInstance:is(actionCommand.actionType) then
			local TypeName = string.format("Resources.Game.ActionCommands.%s", actionCommand.actionCommand)
			local s, r = xpcall(require, debug.traceback, TypeName)
			if not s then
				Log.error("Couldn't load action command '%s' (%s): %s", TypeName, actionCommand.actionCommand, r)
			end

			return r, actionCommand
		end
	end

	return nil
end

return Skilling
