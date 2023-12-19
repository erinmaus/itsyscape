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

	return mapSceneNode, Vector(state.i, 0, state.j), Vector(state.x, state.k, state.z), state.bone
end

function BehemothMap:decomposeTransform(transform)
	local m11, m21, m31, m41,
	      m12, m22, m32, m42,
	      m13, m23, m33, m43,
	      m14, m24, m34, m44 = transform:getMatrix()

	local t, q
	if m33 < 0 then
		if m11 > m22 then
			t = 1 + m11 - m22 - m33;
			q = Quaternion(t, m12 + m21, m31 + m13, m23 - m32);
		else
			t = 1 - m11 + m22 - m33;
			q = Quaternion(m12 + m21, t, m23 + m32, m31 - m13);
		end
	else
		if m11 < -m22 then
			t = 1 - m11 - m22 + m33;
			q = Quaternion(m31 + m13, m23 + m32, t, m12 - m21);
		else
			t = 1 + m11 + m22 + m33;
			q = Quaternion(m23 - m32, m31 - m13, m12 - m21, t);
		end
	end

	q.x = q.x * (0.5 / math.sqrt(t))
	q.y = q.y * (0.5 / math.sqrt(t))
	q.z = q.z * (0.5 / math.sqrt(t))
	q.w = q.w * (0.5 / math.sqrt(t))

	return Vector(m41, m42, m43), q
end

function BehemothMap:update(delta)
	PropView.update(self, delta)

	local actorView = self:getActorView()
	if not actorView then
		return
	end

	local mapSceneNode, mapOffset, mapTranslation, bone = self:getMapSceneNode()

	local boneTransform = actorView:getLocalBoneTransform(bone)
	local actorTransform = actorView:getSceneNode():getTransform():getGlobalTransform()

	local composedTransform = love.math.newTransform()
	composedTransform:apply(actorTransform)
	composedTransform:translate((mapOffset):get())
	composedTransform:translate(mapTranslation:get())
	composedTransform:apply(boneTransform)
	composedTransform:translate((-mapOffset):get())
	composedTransform:rotate(1, 0, 0, math.pi / 2)

	local x, y, z = boneTransform:transformPoint(0, 0, 0)
	print("b", math.floor(x * 10) / 10, math.floor(y * 10) / 10, math.floor(z * 10) / 10)

	local x, y, z = (Vector(composedTransform:transformPoint(0, 0, 0)) - Vector(actorTransform:transformPoint(0, 0, 0))):get()
	print("t", math.floor(x * 10) / 10, math.floor(y * 10) / 10, math.floor(z * 10) / 10)

	local decomposedTranslation, decomposedRotation = self:decomposeTransform(composedTransform)

	mapSceneNode:getTransform():setLocalTranslation(decomposedTranslation)
	mapSceneNode:getTransform():setLocalRotation(decomposedRotation)
end

return BehemothMap
