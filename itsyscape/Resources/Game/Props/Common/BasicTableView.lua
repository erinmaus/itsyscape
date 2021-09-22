--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/BasicTableView.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local BasicTableView = Class(PropView)

function BasicTableView:getTextureFilename()
	return Class.ABSTRACT()
end

function BasicTableView:getModelFilename()
	return Class.ABSTRACT()
end

function BasicTableView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.table = DecorationSceneNode()
	self.plates = DecorationSceneNode()
	self.food = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			self.mesh = mesh
			self.table:fromGroup(mesh:getResource(), "Table")
			self.table:getMaterial():setTextures(self.texture)
			self.table:setParent(root)

			self.plates:fromGroup(mesh:getResource(), "Plates")
			self.plates:getMaterial():setTextures(self.texture)

			self.food:fromGroup(mesh:getResource(), "Food")
			self.food:getMaterial():setTextures(self.texture)
		end)
end

function BasicTableView:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state.hasPlates then
		self.plates:setParent(self:getRoot())
	else
		self.plates:setParent(nil)
	end

	if state.hasFood then
		self.food:setParent(self:getRoot())
	else
		self.food:setParent(nil)
	end
end

return BasicTableView
