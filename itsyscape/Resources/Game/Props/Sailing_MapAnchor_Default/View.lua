--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/View.lua
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

local AnchorView = Class(PropView)

function AnchorView:new(prop, gameView)
	PropView.new(self, prop, gameView)
end

function AnchorView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()
end

function PropView:attach()
	self.sprite = self:getGameView():getSpriteManager():add(
		"SailingMapAnchor",
		self:getRoot(),
		Vector(0, 1, 0),
		self:getProp())
end

function AnchorView:remove()
	PropView.remove(self)

	if self.sprite then
		self:getGameView():getSpriteManager():poof(self.sprite)
	end
end

return AnchorView
