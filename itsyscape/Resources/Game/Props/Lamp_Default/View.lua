--------------------------------------------------------------------------------
-- Resources/Game/Props/Lamp_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local Lamp = Class(PropView)

function Lamp:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Lamp_Default/Lamp.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Lamp_Default/Lamp.lstatic",
		function(mesh)
			self.mesh = mesh
			self.node:fromGroup(mesh:getResource(), "Lamp")
			self.node:getMaterial():setTextures(self.texture)
			self.node:setParent(root)

			self.light = PointLightSceneNode()
			self.light:setParent(root)
			self.light:setAttenuation(4.0)
		end)
end

return Lamp
