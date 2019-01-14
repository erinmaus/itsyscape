--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_SoulSiphon/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local SoulSiphon = Class(PropView)
SoulSiphon.PUMP_TIME = math.pi * 2
SoulSiphon.MIN_SCALE_XZ = 0.8
SoulSiphon.MAX_SCALE_XZ = 1.0
SoulSiphon.MIN_SCALE_Y = 0.8
SoulSiphon.MAX_SCALE_Y = 1.1

function SoulSiphon:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.pumpTime = 0
end

function SoulSiphon:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/HighChambersYendor_SoulSiphon/Model.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/HighChambersYendor_SoulSiphon/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.decoration = DecorationSceneNode()
		self.decoration:fromGroup(self.mesh:getResource(), "Siphon")
		self.decoration:getMaterial():setTextures(self.texture)
		self.decoration:setParent(root)
	end)
end

function SoulSiphon:update(delta)
	PropView.update(self, delta)

	self.pumpTime = self.pumpTime + delta
	if self.decoration then
		local delta = (math.sin(self.pumpTime * SoulSiphon.PUMP_TIME) + 1) / 2
		local mu = Tween.powerEaseInOut(delta, 3)

		local xzWidth = SoulSiphon.MAX_SCALE_XZ - SoulSiphon.MIN_SCALE_XZ
		local yWidth = SoulSiphon.MAX_SCALE_Y - SoulSiphon.MIN_SCALE_Y

		local scale = Vector(
			xzWidth * mu + SoulSiphon.MIN_SCALE_XZ,
			yWidth * mu + SoulSiphon.MIN_SCALE_Y,
			xzWidth * mu + SoulSiphon.MIN_SCALE_XZ)

		self.decoration:getTransform():setLocalScale(scale)
		self.decoration:getTransform():setPreviousTransform(nil, nil, scale)
	end
end

return SoulSiphon
