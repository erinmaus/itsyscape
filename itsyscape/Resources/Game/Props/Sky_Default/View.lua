--------------------------------------------------------------------------------
-- Resources/Game/Props/Sky_Default/View.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local SkyCubeSceneNode = require "ItsyScape.Graphics.SkyCubeSceneNode"

local Sky = Class(PropView)

function Sky:load()
	PropView.load(self)

	local root = self:getRoot()

	self.skyCube = SkyCubeSceneNode()
	self.skyCube:setParent(root)

	self:_updateColor()
end

function Sky:_updateColor()
	local state = self:getProp():getState()

	if state.currentSkyColor and state.previousSkyColor then
		local previousSkyColor = Color(unpack(state.previousSkyColor))
		local currentSkyColor = Color(unpack(state.currentSkyColor))

		self.skyCube:setTopClearColor(previousSkyColor)
		self.skyCube:setBottomClearColor(currentSkyColor)
	end
end

function Sky:tick()
	PropView.tick(self)

	self:_updateColor()
end

return Sky
