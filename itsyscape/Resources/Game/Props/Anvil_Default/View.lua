--------------------------------------------------------------------------------
-- Resources/Game/Props/Anvil_Default/View.lua
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

local AnvilView = Class(PropView)

function AnvilView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function AnvilView:getTextureFilename()
	return "Resources/Game/Props/Common/Rock/Texture.png"
end

function AnvilView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local mesh = resources:load(
		StaticMeshResource,
		"Resources/Game/Props/Anvil_Default/Anvil.lstatic")
	local texture = resources:load(
		TextureResource,
		"Resources/Game/Props/Anvil_Default/Texture.png")

	self.decoration = DecorationSceneNode()
	self.decoration:fromGroup(mesh:getResource(), "CommonAnvil")
	self.decoration:getMaterial():setTextures(texture)
	self.decoration:setParent(root)
end

return AnvilView
