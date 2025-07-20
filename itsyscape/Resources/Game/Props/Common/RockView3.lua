--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/RockView3.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local SceneTemplateResource = require "ItsyScape.Graphics.SceneTemplateResource"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local RockView = Class(PropView)

function RockView:new(...)
	PropView.new(self, ...)
end

function RockView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		SceneTemplateResource,
		"Resources/Game/Props/Common/Rock/Exterior.lscene",
		function(scene)
			self.scene = scene:getResource()
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Common/Rock/Exterior.lstatic",
		function(mesh)
			self.mesh = mesh:getResource()
		end)

	resources:queueEvent(function()
		local decoration = Decoration()

		for _, node in self.scene:iterate() do
			local position = MathCommon.decomposeTransform(node:getGlobalTransform())
			--position = (-Quaternion.X_90):getNormal():transformVector(position)

			decoration:add(
				node:getName(),
				position,
				Quaternion.IDENTITY,
				Vector.ONE,
				Color.fromHSL(love.math.random(), 0.8, 0.6))
			print(">>> add", node:getName(), position:get())
		end

		local textureResource = self:getGameView():getWhiteTexture()
		local exteriorNode = DecorationSceneNode()
		exteriorNode:getMaterial():setTextures(textureResource)
		exteriorNode:fromDecoration(decoration, self.mesh)
		exteriorNode:setParent(root)
	end)
end

return RockView
