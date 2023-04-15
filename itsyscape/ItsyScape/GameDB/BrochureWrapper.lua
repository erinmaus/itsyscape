--------------------------------------------------------------------------------
-- ItsyScape/GameDB/BrochureWrapper.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Meta = require "ItsyScape.GameDB.Commands.Meta"

local BrochureWrapper = Class()

function BrochureWrapper:new(brochure)
	self.brochure = brochure

	self.actionDefinitions = {}
	self.actions = {}
	self.resourceTypes = {}
	self.resources = {}
	self.constraints = {}
	self.queries = {}

	self:_pullActionDefinitions()
	self:_pullActions()
	self:_pullResourceTypes()
	self:_pullResources()
	self:_connect()
end

function BrochureWrapper:_pullActionDefinitions()
	for actionDefinition in self.brochure.actionDefinitions do
		self.actionDefinitions[actionDefinition.name] = {
			definition = actionDefinition,
			actions = {}
		}
	end
end

function BrochureWrapper:_pullActions()
	for action in self.brochure.actions do
		local actionDefinition = self.brochure:getActionDefinitionFromAction(action)

		local requirementConstraints = {}
		for requirement in self.brochure:getRequirements(action) do
			table.insert(requirementConstraints, requirement)

			local c = self.constraints[requirement.type] or {}
			c[requirement.id.value] = {
				constraint = requirement,
				action = action,
				resource = self.brochure:getConstraintResource(requirement)
			}

			self.constraints[requirement.type] = c
		end

		local inputConstraints = {}
		for input in self.brochure:getInputs(action) do
			table.insert(inputConstraints, input)

			local c = self.constraints[input.type] or {}
			c[input.id.value] = {
				constraint = input,
				action = action,
				resource = self.brochure:getConstraintResource(input)
			}
			self.constraints[input.type] = c
		end

		local outputConstraints = {}
		for output in self.brochure:getOutputs(action) do
			table.insert(outputConstraints, output)

			local c = self.constraints[output.type] or {}
			c[output.id.value] = {
				constraint = output,
				action = action,
				resource = self.brochure:getConstraintResource(output)
			}
			self.constraints[output.type] = c
		end

		self.actions[action.id.value] = {
			action = action,
			definition = actionDefinition,
			resources = {},
			requirementConstraints = requirementConstraints,
			inputConstraints = inputConstraints,
			outputConstraints = outputConstraints
		}

		table.insert(self.actionDefinitions[actionDefinition.name].actions, { action = action })
	end
end

function BrochureWrapper:_pullResourceTypes()
	for resourceType in self.brochure.resourceTypes do
		self.resourceTypes[resourceType.name] = {
			resourceType = resourceType,
			resources = {},
			resourcesByName = {}
		}
	end
end

function BrochureWrapper:_pullResources()
	for resource in self.brochure.resources do
		local resourceType = self.brochure:getResourceTypeFromResource(resource)

		self.resources[resource.id.value] = {
			resource = resource,
			resourceType = resourceType,
			actions = {}
		}

		table.insert(self.resourceTypes[resourceType.name].resources, { resource = resource })

		resourcesByName = self.resourceTypes[resourceType.name].resourcesByName[resource.name]
		if not resourcesByName then
			resourcesByName = {}
			self.resourceTypes[resourceType.name].resourcesByName[resource.name] = resourcesByName
		end

		table.insert(resourcesByName, { resource = resource })
	end
end

function BrochureWrapper:_connect()
	for _, r in pairs(self.actions) do
		for resource in self.brochure:findResourcesByAction(r.action) do
			table.insert(r.resources, { resource = resource })
		end
	end

	for _, r in pairs(self.resources) do
		for action in self.brochure:findActionsByResource(r.resource) do
			table.insert(r.actions, { action = action })
		end
	end
end

function BrochureWrapper:getInternalBrochure()
	return self.brochure
end

function BrochureWrapper:tryGetActionDefinition(id, definition)
	if type(id) == 'string' then
		local r = self.actionDefinitions[id]
		if r == nil then
			return false
		else
			definition.id = r.definition.id
			definition.name = r.definition.name
			return true
		end
	else
		return self.brochure:tryGetActionDefinition(id, definition)
	end
end

function BrochureWrapper:actionDefinitions()
	return coroutine.wrap(function()
		for _, d in pairs(self.actionDefinitions) do
			local i = Mapp.ActionDefinition()
			i.id = d.definition.id
			i.name = d.definition.name
			coroutine.yield(i)
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:tryGetAction(id, action)
	id = id.value

	local r = self.actions[id]
	if r then
		action.id = r.action.id
		return true
	end

	return false
end

function BrochureWrapper:getActionDefinitionFromAction(action)
	local definition = Mapp.ActionDefinition()
	local id = action.id.value

	local r = self.actions[id]
	if r then
		definition.id = r.definition.id
		definition.name = r.definition.name

		return definition
	else
		return nil
	end
end

function BrochureWrapper:actions()
	return coroutine.wrap(function()
		for _, a in pairs(self.actions) do
			local i = Mapp.Action()
			i.id = a.action.id
			coroutine.yield(i)
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:findActionsByDefinition(definition)
	return coroutine.wrap(function()
		local r = self.actionDefinitions[definition.name]
		if r then
			for _, a in ipairs(r.actions) do
				local i = Mapp.Action()
				i.id = a.action.id
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:findActionsByResource(resource)
	return coroutine.wrap(function()
		local r = self.resources[resource.id.value]

		if r then
			for _, a in pairs(r.actions) do
				local i = Mapp.Action()
				i.id = a.action.id
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:tryGetResourceType(id, resourceType)
	if type(id) == 'string' then
		local r = self.resourceTypes[id]
		if r == nil then
			return false
		else
			resourceType.id = r.resourceType.id
			resourceType.name = r.resourceType.name
			return true
		end
	else
		return self.brochure:tryGetActionDefinition(id, resourceType)
	end
end

function BrochureWrapper:getResourceTypeFromResource(resource)
	local resourceType = Mapp.ResourceType()
	local id = resource.id.value

	local r = self.resources[id]
	if r then
		resourceType.id = r.resourceType.id
		resourceType.name = r.resourceType.name

		return resourceType
	else
		return nil
	end
end

function BrochureWrapper:resourceTypes()
	return coroutine.wrap(function()
		for _, d in pairs(self.resourceTypes) do
			local i = Mapp.ResourceType()
			i.id = d.resourceType.id
			i.name = d.resourceType.name
			coroutine.yield(i)
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:tryGetResource(id, resource)
	id = id.value

	local r = self.resources[id]
	if r then
		resource.id = resource.id
		resource.name = resource.name
		resource.isSingleton = resource.isSingleton

		return true
	end

	return false
end

function BrochureWrapper:resources()
	return coroutine.wrap(function()
		for _, r in pairs(self.resources) do
			local i = Mapp.Resource()
			i.id = r.resource.id
			i.name = r.resource.name
			i.isSingleton = r.resource.isSingleton
			coroutine.yield(i)
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:findResourcesByAction(action)
	return coroutine.wrap(function()
		local r = self.actions[action.id.value]

		if r then
			for _, r in ipairs(r.resources) do
				local i = Mapp.Resource()
				i.id = r.resource.id
				i.name = r.resource.name
				i.isSingleton = r.resource.isSingleton
				coroutine.yield(i)
			end

			coroutine.yield(nil)
		end
	end)
end

function BrochureWrapper:findResourcesByType(resourceType)
	return coroutine.wrap(function()
		local r = self.resourceTypes[resourceType.name]
		if r then
			for _, j in ipairs(r.resources) do
				local i = Mapp.Resource()
				i.id = j.resource.id
				i.name = j.resource.name
				i.isSingleton = j.resource.isSingleton
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:findResourcesByNameAndType(name, resourceType)
	return coroutine.wrap(function()
		local r = self.resourceTypes[resourceType.name]
		if r then
			for _, j in ipairs(r.resourcesByName[name] or {}) do
				local i = Mapp.Resource()
				i.id = j.resource.id
				i.name = j.resource.name
				i.isSingleton = j.resource.isSingleton
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:getInputs(action)
	return coroutine.wrap(function()
		local r = self.actions[action.id.value]

		if r then
			for _, constraint in ipairs(r.inputConstraints) do
				local i = Mapp.Constraint()
				i.id = constraint.id
				i.type = constraint.type
				i.count = constraint.count
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:getOutputs(action)
	return coroutine.wrap(function()
		local r = self.actions[action.id.value]

		if r then
			for _, constraint in ipairs(r.outputConstraints) do
				local i = Mapp.Constraint()
				i.id = constraint.id
				i.type = constraint.type
				i.count = constraint.count
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:getRequirements(action)
	return coroutine.wrap(function()
		local r = self.actions[action.id.value]

		if r then
			for _, constraint in ipairs(r.requirementConstraints) do
				local i = Mapp.Constraint()
				i.id = constraint.id
				i.type = constraint.type
				i.count = constraint.count
				coroutine.yield(i)
			end
		end

		coroutine.yield(nil)
	end)
end

function BrochureWrapper:getConstraintResource(constraint)
	local resource = Mapp.Resource()

	local r = self.constraints[constraint.type][constraint.id.value]
	if r then
		resource.id = r.resource.id
		resource.name = r.resource.name
		resource.isSingleton = r.resource.isSingleton
	end

	return resource
end

function BrochureWrapper:getConstraintAction(constraint)
	local action = Mapp.Action()

	local r = self.constraints[constraint.type][constraint.id.value]
	if r then
		action.id = r.action.id
	end

	return action
end

function BrochureWrapper:select(definition, query, limit, prompt)
	local result

	if prompt then
		local queryKey = {}
		for k, v in pairs(prompt) do
			local index = definition:getIndex(k)
			local t = definition:getType(index)

			if t == Meta.TYPE_ACTION then
				table.insert(queryKey, string.format("%s@%d=%d", k, t, v.id.value))
			elseif t == Meta.TYPE_RESOURCE then
				table.insert(queryKey, string.format("%s@%d+%s=%s", k, t, self:getResourceTypeFromResource(v).name, v.name))
			elseif t == Meta.TYPE_REAL then
				-- We don't want floating point precision to screw things up.
				-- You shouldn't really query any number than an integer anyway.
				table.insert(queryKey, string.format("%s@%d=%d", k, t, v))
			else
				table.insert(queryKey, string.format("%s@%d=%s", k, t, tostring(v)))
			end
		end

		table.sort(queryKey)
		local key = string.format("%s$%s;#%s", definition.name, table.concat(queryKey, ";"), tostring(limit))

		result = self.queries[key]
		if not result then
			result = self.brochure:select(definition, query, limit)

			if next(result) then
				self.queries[key] = result
			end
		end
	end

	return result or self.brochure:select(definition, query, limit)
end

return BrochureWrapper
