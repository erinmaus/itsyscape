--------------------------------------------------------------------------------
-- Resources/Game/Props/Theodyssius_Head/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local PropView = require "ItsyScape.Graphics.PropView"

local Head = Class(PropView)

Head.MIN_MULTIPLIER  = 0.75
Head.MAX_MULTIPLIER  = 1.25
Head.BASE_MULTIPLIER = math.pi / 4

Head.MIN_SCALE = 0.8
Head.SCALE_WIDTH = 0.15

Head.MIN_ROTATION = math.rad(0)
Head.MAX_ROTATION = math.rad(5)

Head.BOB_MULTIPLIER = math.pi / 2
Head.BOB_WIDTH      = 1
Head.BOB_OFFSET = Vector(0, 12, 0)

Head.EXEMPT_BONES = {
	["lump8"] = true,
	["root"] = true
}

function Head:new(...)
	PropView.new(self, ...)

	self.bones = {}

	self._computeBoneTransforms = Callback.bind(self.computeBoneTransforms, self)
end

function Head:getBoneInfo(boneName)
	local info = self.bones[boneName]
	if not info then
		info = {
			scaleMultiplier = love.math.random() * (Head.MAX_MULTIPLIER - Head.MIN_MULTIPLIER) + Head.MIN_MULTIPLIER,
			scaleOffset = math.pi * 2 * love.math.random(),
			rotationXMultiplier = love.math.random() * (Head.MAX_MULTIPLIER - Head.MIN_MULTIPLIER) + Head.MIN_MULTIPLIER,
			rotationXOffset = math.pi * 2 * love.math.random(),
			rotationX = love.math.random() * (Head.MAX_ROTATION - Head.MIN_ROTATION) + Head.MIN_ROTATION,
			rotationYMultiplier = love.math.random() * (Head.MAX_MULTIPLIER - Head.MIN_MULTIPLIER) + Head.MIN_MULTIPLIER,
			rotationYOffset = math.pi * 2 * love.math.random(),
			rotationY = love.math.random() * (Head.MAX_ROTATION - Head.MIN_ROTATION) + Head.MIN_ROTATION,
			rotationZMultiplier = love.math.random() * (Head.MAX_MULTIPLIER - Head.MIN_MULTIPLIER) + Head.MIN_MULTIPLIER,
			rotationZOffset = math.pi * 2 * love.math.random(),
			rotationZ = love.math.random() * (Head.MAX_ROTATION - Head.MIN_ROTATION) + Head.MIN_ROTATION
		}

		self.bones[boneName] = info
	end

	return info
end

function Head:updateBone(transforms, animatable, boneIndex, boneInfo)
	local transform = love.math.newTransform()

	local currentTime = love.timer.getTime()

	local scale = math.abs(math.sin(currentTime * boneInfo.scaleMultiplier * Head.BASE_MULTIPLIER + boneInfo.scaleOffset)) * Head.SCALE_WIDTH + Head.MIN_SCALE
	transform:scale(scale, scale, scale)

	local angleZ = math.sin(currentTime * boneInfo.rotationZMultiplier * Head.BASE_MULTIPLIER + boneInfo.rotationZOffset) * boneInfo.rotationZ
	local rotationZ = Quaternion.fromAxisAngle(Vector(0, 0, 1), angleZ)

	local angleY = math.sin(currentTime * boneInfo.rotationYMultiplier * Head.BASE_MULTIPLIER + boneInfo.rotationYOffset) * boneInfo.rotationY
	local rotationY = Quaternion.fromAxisAngle(Vector(0, 0, 1), angleY)

	local angleX = math.sin(currentTime * boneInfo.rotationXMultiplier * Head.BASE_MULTIPLIER + boneInfo.rotationXOffset) * boneInfo.rotationX
	local rotationX = Quaternion.fromAxisAngle(Vector(0, 0, 1), angleX)

	local rotation = rotationZ * rotationY * rotationX
	transform:applyQuaternion(rotation:get())

	transforms:applyTransform(boneIndex, transform)
end

function Head:updateRoot(transforms, animatable)
	local transform = love.math.newTransform()
	do
		local translation = Vector.UNIT_Y * math.sin(love.timer.getTime() * Head.BOB_MULTIPLIER) * Head.BOB_WIDTH + Head.BOB_OFFSET
		transform:translate(translation:get())
	end

	local skeleton = animatable:getSkeleton()
	local rootIndex = skeleton:getBoneIndex("root") or 1
	transforms:applyTransform(rootIndex, transform)
end

function Head:computeBoneTransforms(_, transforms, animatable)
	local skeleton = animatable:getSkeleton()

	for boneIndex, bone in skeleton:iterate() do
		local name = bone:getName()
		local isExempt = Head.EXEMPT_BONES[name]
		if not isExempt then
			local boneInfo = self:getBoneInfo(name)
			self:updateBone(transforms, animatable, boneIndex, boneInfo)
		end
	end

	self:updateRoot(transforms, animatable)
end

function Head:tick()
	PropView.tick(self)

	local state = self:getProp():getState()

	local targetActorID = state.body
	if not targetActorID then
		return
	end

	local targetActor = self:getGameView():getActorByID(targetActorID)
	local targetActorView = targetActor and self:getGameView():getActor(targetActor)
	if not targetActorView then
		return
	end

	if self.currentActorView ~= targetActorView then
		if self.currentActorView then
			self.currentActorView.onPreComputeBoneTransforms:unregister(self._computeBoneTransforms)
		end

		self.currentActorView = targetActorView
		self.currentActorView.onPreComputeBoneTransforms:register(self._computeBoneTransforms)

		table.clear(self.bones)
	end
end

function Head:getIsStatic()
	return false
end

return Head
