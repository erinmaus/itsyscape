--------------------------------------------------------------------------------
-- Resources/Game/Props/BehemothMap/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local BehemothMap = Class(PropView)

function BehemothMap:getActorView()
	local state = self:getProp():getState()
	local actorID = state.actorID
	if not actorID then
		return nil
	end

	local actor = self:getGameView():getActorByID(actorID)
	if not actor then
		return nil
	end

	local actorView = self:getGameView():getActor(actor)
	if not actorView then
		return nil
	end

	return actorView
end

function BehemothMap:getMapSceneNode()
	local state = self:getProp():getState()
	local layer = state.layer
	if not layer then
		return nil
	end

	local mapSceneNode = self:getGameView():getMapSceneNode(layer)
	if not mapSceneNode then
		return nil
	end

	local mapOffset = Vector(state.i, 0, state.j)
	local mapTranslation = Vector(state.x, state.k, state.z)
	local mapRotation = Quaternion(unpack(state.rotation or {}))

	return mapSceneNode, mapOffset, mapTranslation, mapRotation, state.bone
end

function BehemothMap:update(delta)
	PropView.update(self, delta)

	local actorView = self:getActorView()
	if not actorView then
		return
	end

	local mapSceneNode, mapOffset, mapTranslation, mapRotation, bone = self:getMapSceneNode()

	local boneTransform = actorView:getLocalBoneTransform(bone)
	local actorTransform = actorView:getSceneNode():getTransform():getGlobalTransform()
	local inverseBindPose = actorView:getSkeleton():getBoneByName(bone):getInverseBindPose()

	local composedTransform = love.math.newTransform()
	composedTransform:apply(actorTransform)
	composedTransform:translate(mapOffset:get())
	composedTransform:translate(mapTranslation:get())
	composedTransform:apply(boneTransform)
	composedTransform:apply(inverseBindPose)
	composedTransform:applyQuaternion(mapRotation:get())
	composedTransform:translate((-mapOffset):get())
	composedTransform:rotate(1, 0, 0, math.pi / 2)

	local decomposedTranslation, decomposedRotation = MathCommon.decomposeTransform(composedTransform)

	mapSceneNode:getTransform():setLocalTranslation(decomposedTranslation)
	mapSceneNode:getTransform():setLocalRotation(decomposedRotation)
end

return BehemothMap
