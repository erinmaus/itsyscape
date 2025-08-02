--------------------------------------------------------------------------------
-- ItsyScape/Game/GatherableInstance.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local GatherableInstance = Class()
GatherableInstance.CURRENT_ID = 1

function GatherableInstance:new(prop, action, gatherable, model, transform)
	self.id = GatherableInstance.CURRENT_ID
	GatherableInstance.CURRENT_ID = GatherableInstance.CURRENT_ID + 1

	self.prop = prop
	self.action = action
	self.gatherable = gatherable
	self.model = model or false
	self.transform = transform or false
	self.gathered = false
end

function GatherableInstance:getID()
	return self.id
end

function GatherableInstance:getProp()
	return self.prop
end

-- Is an instance of Action, not a Mapp Action
function GatherableInstance:getAction()
	return self.action
end

function GatherableInstance:getGatherable()
	return self.gatherableModel:getGatherable()
end

function GatherableInstance:getGatherableModel()
	return self.model
end

function GatherableInstance:getTransform()
	return self.transform
end

function GatherableInstance:getIsGathered()
	return self.gathered
end

function GatherableInstance:gather()
	if self.gathered then
		return false
	end

	self.gathered = true
	self.prop:poke("resourceGathered", {
		instance = self,
		gatherable = self.gatherable,
		action = self.action
	})

	return true
end

function GatherableInstance._serializeModel(instance, model)
	local transform = instance:getTransform() or model:getTransform()

	return {
		id = instance:getID(),
		gathered = instance:getIsGathered(),

		model = model:getModelFilename(),
		group = model:getModelGroup(),
		material = model:getMaterialID(),

		transform = {
			position = { transform:getPosition():get() },
			rotation = { transform:getRotation():get() },
			scale = { transform:getScale():get() }
		}
	}
end

function GatherableInstance.serialize(gatherableInstances)
	local results = {
		materials = {},
		gatherables = {}
	}

	for _, instance in ipairs(gatherableInstances) do
		local gatherable = instance:getGatherable()

		for materialName, materialInstance in gatherable:iterateMaterials() do
			if not results.materials[materialName] then
				results.materials[materialName] = materialInstance:serialize()
			end
		end

		if instance:getGatherableModel() then
			local result = GatherableInstance._serializeModel(instance, instance:getGatherableModel())
			table.insert(results.gatherables, result)
		else
			for _, model in instance:getGatherable():iterateModels() do
				local result = GatherableInstance._serializeModel(instance, model)
				table.insert(results.gatherables, result)
			end
		end
	end

	return results
end

return GatherableInstance
