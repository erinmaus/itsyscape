--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/ChestView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local PropView = require "ItsyScape.Graphics.PropView"
local Resource = require "ItsyScape.Graphics.Resource"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local ChestView = Class(PropView)

ChestView.TOP_DESCRIPTION = {}
ChestView.BOTTOM_DESCRIPTION = {}

ChestView.PIVOT = Vector(0, 0.75, -0.5):keep()

ChestView.ANIMATION_DURATION_SECONDS = 0.5

ChestView.CLOSED_ROTATION = Quaternion.IDENTITY
ChestView.OPENED_ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_X, math.rad(-45))

local ANIMATION_OPEN = "open"
local ANIMATION_CLOSE = "close"

function ChestView:getTopDescription()
	return self.TOP_DESCRIPTION
end

function ChestView:getBottomDescription()
	return self.BOTTOM_DESCRIPTION
end

function ChestView:_loadDescription(root, description)
	local resources = self:getResources()

	for _, d in ipairs(description) do
		local mesh
		resources:queue(
			StaticMeshResource,
			d.mesh,
			function(m)
				mesh = m
			end)

		local material
		resources:queueEvent(function()
			if Class.isCompatibleType(d.material, DecorationMaterial) then
				material = d.material
			elseif type(d.material) == "string" then
				local m = Resource.readLua(material)
				material = DecorationMaterial(m)
			else
				material = DecorationMaterial(d.material or {})
			end
		end)

		resources:queueEvent(function()
			local decoration = DecorationSceneNode()
			decoration:fromGroup(mesh:getResource(), d.group)
			material:apply(decoration, self:getResources())

			decoration:setParent(root)
		end)
	end
end

function ChestView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.topNode = SceneNode()
	self.topNode:getTransform():setLocalOffset(self.PIVOT)
	self:_loadDescription(self.topNode, self:getTopDescription())

	self.bottomNode = SceneNode()
	self:_loadDescription(self.bottomNode, self:getBottomDescription())

	resources:queueEvent(function()
		self.topNode:setParent(root)
		self.bottomNode:setParent(root)
	end)

	local state = self:getProp():getState()
	if state.isOpen then
		self.currentAnimation = ANIMATION_OPEN
	else
		self.currentAnimation = ANIMATION_CLOSE
	end
	self.currentTime = 0
	self.isOpen = state.isOpen
end

function ChestView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.isOpen ~= self.isOpen then
		if state.isOpen then
			self.currentAnimation = ANIMATION_OPEN
		else
			self.currentAnimation = ANIMATION_CLOSE
		end
		self.currentTime = self.ANIMATION_DURATION_SECONDS - (self.currentTime or 0)
		self.isOpen = state.isOpen
	end
end

function ChestView:update(delta)
	PropView.update(self, delta)

	self.currentTime = math.max((self.currentTime or 0) - delta, 0)
	local delta = self.currentTime / self.ANIMATION_DURATION_SECONDS

	local fromRotation, toRotation
	if self.currentAnimation == ANIMATION_OPEN then
		fromRotation = self.OPENED_ROTATION
		toRotation = self.CLOSED_ROTATION
	else
		fromRotation = self.CLOSED_ROTATION
		toRotation = self.OPENED_ROTATION
	end

	local rotation = fromRotation:slerp(toRotation, Tween.sineEaseOut(delta)):getNormal()
	self.topNode:getTransform():setLocalRotation(rotation)
end

return ChestView
