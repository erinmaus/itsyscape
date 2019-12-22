--------------------------------------------------------------------------------
-- Resources/Game/Props/Dresser_Default/View.lua
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

local DresserView = Class(PropView)

function DresserView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.open = DecorationSceneNode()
	self.closed = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Dresser_Default/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Dresser_Default/Dresser.lstatic",
		function(mesh)
			self.mesh = mesh
			self.open:fromGroup(mesh:getResource(), "DresserOpen")
			self.open:getMaterial():setTextures(self.texture)
			self.open:setParent(root)

			self.closed:fromGroup(mesh:getResource(), "DresserClosed")
			self.closed:getMaterial():setTextures(self.texture)
		end)
end

function DresserView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.open then
		self.open:setParent(self:getRoot())
		self.closed:setParent(nil)
	else
		self.open:setParent(nil)
		self.closed:setParent(self:getRoot())
	end
end

return DresserView
