--------------------------------------------------------------------------------
-- Resources/Game/Props/AncientDriftwood/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local AncientDriftwood = Class(PropView)

function AncientDriftwood:getTextureFilename()
	return "Resources/Game/Props/AncientDriftwood/Tree.png"
end

function AncientDriftwood:getModelFilename()
	return "Resources/Game/Props/AncientDriftwood/Tree.lstatic", "AncientDriftwood"
end

function AncientDriftwood:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.leaves = DecorationSceneNode()
	self.tree = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/AncientDriftwood/Tree.png",
		function(texture)
			self.treeTexture = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/AncientDriftwood/Leaves.png",
		function(texture)
			self.leavesTexture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/AncientDriftwood/Tree.lstatic",
		function(mesh)
			self.tree:fromGroup(mesh:getResource(), "AncientDriftwood")
			self.tree:getMaterial():setTextures(self.treeTexture)
			self.tree:setParent(root)
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/AncientDriftwood/Leaves.lstatic",
		function(mesh)
			self.leaves:fromGroup(mesh:getResource(), "Leaves")
			self.leaves:getMaterial():setTextures(self.leavesTexture)
			self.leaves:setParent(root)
		end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/TriPlanar",
		function(shader)
			local material = self.tree:getMaterial()
			material:setShader(shader)
			material:setOutlineThreshold(-0.01)
		end)

	resources:queue(
		ShaderResource,
		"Resources/Shaders/BendyLeaf",
		function(shader)
			local material = self.leaves:getMaterial()
			material:setShader(shader)
			material:setOutlineThreshold(-0.005)
			material:setOutlineColor(Color(0.5))

			self.leaves:onWillRender(function(renderer)
				local currentShader = renderer:getCurrentShader()
				if not currentShader then
					return
				end

				if currentShader:hasUniform("scape_BumpHeight") then
					currentShader:send("scape_BumpHeight", 1)
				end

				if currentShader:hasUniform("scape_EnableActorBump") then
					currentShader:send("scape_EnableActorBump", 0)
				end

				local _, layer = self:getProp():getPosition()
				local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

				if currentShader:hasUniform("scape_WindDirection") then
					currentShader:send("scape_WindDirection", { windDirection:get() })
				end

				if currentShader:hasUniform("scape_WindSpeed") then
					currentShader:send("scape_WindSpeed", windSpeed)
				end

				if currentShader:hasUniform("scape_WindPattern") then
					currentShader:send("scape_WindPattern", { windPattern:get() })
				end

				if currentShader:hasUniform("scape_WindMaxDistance") then
					currentShader:send("scape_WindMaxDistance", 0.25)
				end

				if currentShader:hasUniform("scape_WallHackWindow") then
					currentShader:send("scape_WallHackWindow", { 0, 0, 0, 0 })
				end
			end)
		end)
end

return AncientDriftwood
