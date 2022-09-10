--------------------------------------------------------------------------------
-- Resources/Game/Props/Sailing_Player_CommonSail/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PropView = require "ItsyScape.Graphics.PropView"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Color = require "ItsyScape.Graphics.Color"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local BasicSail = Class(PropView)

function BasicSail:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Sailing_Player_CommonSail/Texture1.png",
		function(texture)
			self.texture1 = texture
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Sailing_Player_CommonSail/Texture2.png",
		function(texture)
			self.texture2 = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Sailing_Player_CommonSail/Model.lstatic",
		function(mesh)
			self.decoration1 = DecorationSceneNode()
			self.decoration1:fromGroup(mesh:getResource(), "Sail")
			self.decoration1:getMaterial():setTextures(self.texture1)
			self.decoration1:setParent(root)

			self.decoration2 = DecorationSceneNode()
			self.decoration2:fromGroup(mesh:getResource(), "Sail")
			self.decoration2:getMaterial():setTextures(self.texture2)
			self.decoration2:setParent(root)
		end)
end

function BasicSail:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	local color1 = Color(unpack(state.primary or {}))
	local color2 = Color(unpack(state.secondary or {}))

	if self.decoration1 then
		self.decoration1:getMaterial():setColor(color1)
	end

	if self.decoration2 then
		self.decoration2:getMaterial():setColor(color2)
	end
end

return BasicSail
