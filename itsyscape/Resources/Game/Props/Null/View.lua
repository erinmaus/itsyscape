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
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local DebugCubeSceneNode = require "ItsyScape.Graphics.DebugCubeSceneNode"

local NullView = Class(PropView)

function NullView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.cube = DebugCubeSceneNode()

	local min, max = self:getProp():getBounds()
	local scale = (max - min) / 2
	self.cube:getTransform():setLocalScale(scale)
	self.cube:getTransform():setLocalTranslation(Vector(0, scale.y, 0))

	self.cube:setParent(root)
end

function NullView:tick()
	local min, max = self:getProp():getBounds()
	local scale = (max - min) / 2

	self.cube:getTransform():setLocalScale(scale)
	self.cube:getTransform():setLocalTranslation(Vector(0, scale.y, 0))

	PropView.tick(self)
end

return NullView
