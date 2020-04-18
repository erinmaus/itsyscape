--------------------------------------------------------------------------------
-- Resources/Game/Props/Rowboat_Default/View.lua
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
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Rowboat = Class(PropView)

function Rowboat:new(...)
	PropView.new(self, ...)

	self.time = 0
end

function Rowboat:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Rowboat_Default/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Rowboat_Default/Model.lstatic",
		function(mesh)
			self.decoration:fromGroup(mesh:getResource(), "Rowboat")
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)
end

function Rowboat:update(delta)
	PropView.update(self, delta)

	if self.decoration then
		self.time = self.time + delta
		local position = Vector(0, math.sin(self.time * math.pi / 4) * 0.25, 0)
		local rotation = Quaternion.fromAxisAngle(
			Vector.UNIT_Z,
			math.sin(self.time * math.pi / 4) * math.pi / 32)

		self.decoration:getTransform():setLocalTranslation(position)
		self.decoration:getTransform():setLocalRotation(rotation)
	end
end

return Rowboat
