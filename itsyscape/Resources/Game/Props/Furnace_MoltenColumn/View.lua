--------------------------------------------------------------------------------
-- Resources/Game/Props/Furnace_MoltenColumn/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local MoltenColumnView = Class(PropView)
MoltenColumnView.MIN_TIME = 30 / 60
MoltenColumnView.MAX_TIME = 40 / 60
MoltenColumnView.MIN_SCALE = 0.4
MoltenColumnView.MAX_SCALE = 1.2

function MoltenColumnView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.time = math.random()
end

function MoltenColumnView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Furnace_MoltenColumn/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Furnace_MoltenColumn/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.decoration = DecorationSceneNode()
		self.decoration:fromGroup(self.mesh:getResource(), "Column")
		self.decoration:getMaterial():setTextures(self.texture)
		self.decoration:setParent(root)

		self:flicker()
	end)
end

function MoltenColumnView:flicker()
	if self.decoration then
		local scaleWidth = MoltenColumnView.MAX_SCALE - MoltenColumnView.MIN_SCALE
		local scale = math.abs(math.sin(self.time * math.pi)) * scaleWidth + MoltenColumnView.MIN_SCALE
		self.decoration:getTransform():setLocalScale(Vector(1, scale, 1))
	end
end

function MoltenColumnView:update(delta)
	self:flicker()

	PropView.update(self, delta)
	self.time = self.time + delta
end

return MoltenColumnView
