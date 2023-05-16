--------------------------------------------------------------------------------
-- Resources/Game/Props/ViziersRock_Sewers_Pipe/View.lua
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

local Pipe = Class(PropView)

function Pipe:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function Pipe:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.pipe = DecorationSceneNode()
	self.pipe:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/ViziersRock_Sewers_Pipe/Texture.png",
		function(texture)
			self.texture = texture
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/ViziersRock_Sewers_Pipe/Model.lstatic",
		function(mesh)
			self.pipe:fromGroup(mesh:getResource(), "Pipe")
			self.pipe:getMaterial():setTextures(self.texture)
			self.pipe:setParent(root)
		end)
end

return Pipe
