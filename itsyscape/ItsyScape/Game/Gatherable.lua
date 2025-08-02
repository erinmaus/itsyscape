--------------------------------------------------------------------------------
-- ItsyScape/Game/Gatherable.lua
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
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SceneTemplate = require "ItsyScape.Graphics.SceneTemplate"

local Gatherable = Class()

Gatherable.Transform = Class()

function Gatherable.Transform:new(position, rotation, scale)
	self.position = position and Vector(position:get()) or Vector(0)
	self.rotation = rotation and Quaternion(rotation:get()) or Quaternion()
	self.scale = scale and Vector(scale:get()) or Vector(1)
end

function Gatherable.Transform.fromTransform(transform)
	local position, rotation = MathCommon.decomposeTransform(transform)
	return Gatherable.Transform(position, rotation, Vector.ONE)
end

function Gatherable.Transform:getPosition()
	return self.position
end

function Gatherable.Transform:getRotation()
	return self.rotation
end

function Gatherable.Transform:getScale()
	return self.scale
end

Gatherable.Model = Class()

function Gatherable.Model:new(gatherable, model, group, material)
	self.gatherable = gatherable
	self.model = model
	self.group = group
	self.material = material
	self.transform = transform or Gatherable.Transform()
end

function Gatherable.Model:getGatherable()
	return self.gatherable
end

function Gatherable.Model:getModelFilename()
	return self.model
end

function Gatherable.Model:getModelGroup()
	return self.group
end

function Gatherable.Model:getMaterialID()
	return self.material
end

function Gatherable.Model:getMaterial()
	return self.gatherable:getMaterial(self.material)
end

function Gatherable.Model:getMaterial()
	return self.material
end

function Gatherable.Model:getTransform()
	return self.transform
end

function Gatherable:new(game, resource)
	self.game = game
	self.resource = resource

	self.models = {}
	self.materials = {
		["Resources/Game/Items/ItemBagMaterial.lmaterial"] = DecorationMaterial("Resources/Game/Items/ItemBagMaterial.lmaterial"),
		["Resources/Game/Items/ItemBagStringMaterial.lmaterial"] = DecorationMaterial("Resources/Game/Items/ItemBagStringMaterial.lmaterial")
	}

	self:_buildModels()
end

function Gatherable:iterateModels()
	return ipairs(self.models)
end

function Gatherable:getNumModels()
	return #self.models
end

function Gatherable:getModelByIndex(index)
	return self.models[index]
end

function Gatherable:getMaterial(id)
	return self.materials[id]
end

function Gatherable:iterateMaterials()
	return pairs(self.materials)
end

local function _compareGatherableModelGroup(a, b)
	return a:getModelGroup() < b:getModelGroup()
end

function Gatherable:_buildModelsFromScenes(scenes)
	local results = {}

	for _, scene in ipairs(scenes) do
		local model = scene:get("ModelFilename")
		local material = DecorationMaterial(scene:get("MaterialFilename"))
		local sceneTemplate = SceneTemplate(scene:get("SceneFilename"))

		if not self.materials[material] then
			self.materials[material] = DecorationMaterial(material)
		end

		for name, node in sceneTemplate:iterate() do
			local transform = Gatherable.Transform.fromTransform(node:getGlobalTransform())
			local result = Gatherable.Model(self, model, node:getName(), material)
			table.insert(results, result)
		end
	end

	table.sort(results, _compareGatherableModelGroup)
	for _, result in ipairs(results) do
		table.insert(self.models, result)
	end
end

function Gatherable:_buildModelsFromModels(models)
	for _, model in ipairs(models) do
		local model = model:get("ModelFilename")
		local group = model:get("ModelGroup")
		local material = model:get("MaterialFilename")

		if not self.materials[material] then
			self.materials[material] = DecorationMaterial(material)
		end

		local result = Gatherable.Model(self, model, group, material)
		table.insert(self.models, result)
	end
end

function Gatherable:_buildModelsFromItem(item)
	local itemBag = Gatherable.Model(self, "Resources/Game/Items/ItemBag.lstatic", "bag", "Resources/Game/Items/ItemBagMaterial.lmaterial")
	local itemBagString = Gatherable.Model(self, "Resources/Game/Items/ItemBag.lstatic", "string", "Resources/Game/Items/ItemBagStringMaterial.lmaterial")

	local itemResource = item:get("Item")
	local itemBagIconMaterialFilename = string.format("Resources/Game/Items/ItemBagIconMaterial.lmaterial,%s", item.name)

	if not self.materials[itemBagIconMaterialFilename] then
		local baseMaterial = DecorationMaterial("Resources/Game/Items/ItemBagIconMaterial.lmaterial")

		local baseMaterialConfig = baseMaterial:serialize()
		baseMaterialConfig.texture = string.format("Resources/Game/Items/%s/Icon.png", itemResource.name)

		self.materials[itemBagIconMaterialFilename] = DecorationMaterial(baseMaterialConfig)
	end
end

function Gatherable:_buildModels()
	local query = { Resource = self.resource }
	local gameDB = self.game:getGameDB()

	local scenes = gameDB:getRecords("GatherableScene", query)
	self:_buildModelsFromScenes(scenes)

	local models = gameDB:getRecords("GatherableModel", query)
	self:_buildModelsFromModels(models)

	local item = gameDB:getRecords("GatherableModel", query)
	self:_buildModelsFromItems(item)
end

return Gatherable
