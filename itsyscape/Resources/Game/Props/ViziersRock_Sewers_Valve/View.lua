--------------------------------------------------------------------------------
-- Resources/Game/Props/ViziersRock_Sewers_Valve/View.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Valve = Class(PropView)

function Valve:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.targetRotation = Quaternion.IDENTITY
	self.currentRotation = Quaternion.IDENTITY
end

function Valve:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.pipe = DecorationSceneNode()
	self.valve = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/ViziersRock_Sewers_Valve/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ViziersRock_Sewers_Valve/Model.lstatic",
		function(mesh)
			self.pipe:fromGroup(mesh:getResource(), "Pipe")
			self.pipe:getMaterial():setTextures(self.texture)
			self.pipe:setParent(root)

			self.valve:fromGroup(mesh:getResource(), "Valve")
			self.valve:getMaterial():setTextures(self.texture)
			self.valve:setParent(root)

			self.targetRotation = Quaternion(unpack(state.rotation or {})):getNormal()
			self.currentRotation = self.targetRotation
		end)
end

function Valve:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	self.targetRotation = Quaternion(unpack(state.rotation or {})):getNormal()
end

function Valve:update(delta)
	PropView.update(self, delta)

	self.currentRotation = self.currentRotation:slerp(self.targetRotation, delta):getNormal()
	self.valve:getTransform():setLocalRotation(self.currentRotation)
end

return Valve
