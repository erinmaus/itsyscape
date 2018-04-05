--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Skeleton.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

local Skeleton = Class()
Skeleton.Bone = Class()
function Skeleton.Bone:new(name, parent)
	self.name = name
	self.parent = parent or false
	self.inverseBindPose = love.math.newTransform()
end

function Skeleton.Bone:getName(name)
	return self.name
end

function Skeleton.Bone:getParent()
	return self.parent
end

function Skeleton.Bone:getInverseBindPose()
	return self.inverseBindPose
end

function Skeleton.Bone:setInverseBindPose(...)
	self.inverseBindPose:setMatrix('row', ...)
end

function Skeleton:new(d)
	self.bones = {}
	self.bonesByName = {}
	self.rootBone = false

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	end
end

function Skeleton:addBone(name, parent)
	if self.bonesByName[name] then
		error(("bone %s already exists in skeleton"):format(name), 2)
	end

	local bone = Skeleton.Bone(name, parent)
	if not self.rootBone then
		self.rootBone = bone
	end

	self.bonesByName[name] = #self.bones + 1
	table.insert(self.bones, bone)

	return bone
end

function Skeleton:getBoneByIndex(index)
	return self.bones[index]
end

function Skeleton:getBoneIndex(name)
	return self.bonesByName[name]
end

function Skeleton:getBoneByName(name)
	local index = self.bonesByName[name]
	if index then
		return self.bones[index]
	else
		return nil
	end
end

function Skeleton:getNumBones()
	return #self.bones
end

function Skeleton:iterate()
	return ipairs(self.bones)
end

function Skeleton:loadFromFile(filename)
	local data = "return " .. love.filesystem.read(filename)
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})()

	self:loadFromTable(result)
end

function Skeleton:loadFromTable(t)
	local bones = {}
	local root

	for name, value in pairs(t) do
		local bone = {}
		bone.name = name
		bone.parent = value.parent
		bone.inverseBindPose = value.inverseBindPose
		bone.children = {}

		bones[name] = bone
		if not root and not bone.parent then
			root = bone
		end
	end

	if not root then
		error("no root bone", 2)
	end

	local function buildChildren(bone)
		for key, value in pairs(bones) do
			if value.parent == bone.name then
				local child = bones[key]
				table.insert(bone.children, child)

				buildChildren(child)
			end
		end
	end
	buildChildren(root)

	local function addBone(boneDefinition, parentBoneDefinition)

		local bone
		if parentBoneDefinition then
			bone = self:addBone(boneDefinition.name, parentBoneDefinition.name)
		else
			bone = self:addBone(boneDefinition.name)
		end

		bone:setInverseBindPose(unpack(boneDefinition.inverseBindPose))
		for i = 1, #boneDefinition.children do
			addBone(boneDefinition.children[i], boneDefinition, d)
		end
	end
	addBone(root)
end

return Skeleton
