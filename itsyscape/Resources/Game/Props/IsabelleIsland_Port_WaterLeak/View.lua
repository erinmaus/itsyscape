--------------------------------------------------------------------------------
-- Resources/Game/Props/IsabelleIsland_Port_WaterLeak/View.lua
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

local WaterLeakView = Class(PropView)
WaterLeakView.MIN_TIME = 10 / 60
WaterLeakView.MAX_TIME = 20 / 60
WaterLeakView.MIN_SCALE = 0.4
WaterLeakView.MAX_SCALE = 1.2

function WaterLeakView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.time = 0
end

function WaterLeakView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/IsabelleIsland_Port_WaterLeak/WaterLeak.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/IsabelleIsland_Port_WaterLeak/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.decoration = DecorationSceneNode()
		self.decoration:fromGroup(self.mesh:getResource(), "WaterLeak")
		self.decoration:getMaterial():setTextures(self.texture)
		self.decoration:setParent(root)

		self:flicker()
	end)
end

function WaterLeakView:flicker()
	if self.decoration then
		local scaleWidth = WaterLeakView.MAX_SCALE - WaterLeakView.MIN_SCALE
		local scale = math.abs(math.sin(self.time * math.pi)) * scaleWidth + WaterLeakView.MIN_SCALE
		self.decoration:getTransform():setLocalScale(Vector(1, scale, 1))
		self.decoration:getTransform():setPreviousTransform(nil, nil, Vector(1, scale, 1))
	end
end

function WaterLeakView:update(delta)
	self:flicker()

	PropView.update(self, delta)
	self.time = self.time + delta
end

return WaterLeakView
