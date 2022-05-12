--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Skeleton.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Resource = require "ItsyScape.Graphics.Resource"
local NSkeletonBone = require "nbunny.optimaus.skeletonbone"
local NSkeletonResourceInstance = require "nbunny.optimaus.skeletonresourceinstance"

local Skeleton = Class()
Skeleton.Bone = Class()
function Skeleton.Bone:new(bone, skeleton)
	self._bone = bone
	self.skeleton = skeleton
end

function Skeleton.Bone:getHandle()
	return self._bone
end

function Skeleton.Bone:getName(name)
	return self:getHandle():getName()
end

function Skeleton.Bone:getIndex()
	return self:getHandle():getIndex() + 1
end

function Skeleton.Bone:getParent()
	local index = self:getHandle():getParentIndex()
	if index >= 0 then
		return self.skeleton:getBoneByIndex(index + 1)
	end

	return nil
end

function Skeleton.Bone:getParentIndex()
	return self:getHandle():getParentIndex() + 1
end

function Skeleton.Bone:getParentName()
	return self:getHandle():getParentName()
end

function Skeleton.Bone:getInverseBindPose()
	return self:getHandle():getInverseBindPose()
end

function Skeleton:new(d, handle)
	self.bones = {}
	self.bonesByName = {}
	self.rootBone = false
	self._handle = handle or NSkeletonResourceInstance()

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	end
end

function Skeleton:getHandle()
	return self._handle
end

function Skeleton:addBone(name, parent, inverseBindPose)
	local boneHandle = self:getHandle():addBone(name, parent, inverseBindPose)
	local bone = Skeleton.Bone(boneHandle, self)
	self.bones[bone:getIndex()] = bone

	return bone
end

function Skeleton:getBoneIndex(name)
	return self:getHandle():getBoneIndex(name) + 1
end

function Skeleton:getBoneByIndex(index)
	return self.bones[index]
end

function Skeleton:getBoneByName(name)
	return self.bones[self:getHandle():getBoneByName(name):getIndex() + 1]
end

function Skeleton:getNumBones()
	return self:getHandle():getNumBones()
end

function Skeleton:iterate()
	local index = 0
	return function()
		index = index + 1
		if index > self:getHandle():getNumBones() then
			return nil, nil
		end

		return index, self:getBoneByIndex(index)
	end
end

function Skeleton:loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

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
		local transform = love.math.newTransform()
		transform:setMatrix('row', unpack(boneDefinition.inverseBindPose))

		local bone
		if parentBoneDefinition then
			bone = self:addBone(boneDefinition.name, parentBoneDefinition.name, transform)
		else
			bone = self:addBone(boneDefinition.name, nil, transform)
		end

		for i = 1, #boneDefinition.children do
			addBone(boneDefinition.children[i], boneDefinition)
		end
	end
	addBone(root)

	for i = 1, self:getNumBones() do
		local bone = self:getBoneByIndex(i)
		assert(bone:getParentIndex() < bone:getIndex())
	end
end

-- Constants.
Skeleton.EMPTY = Skeleton()

return Skeleton
