--------------------------------------------------------------------------------
-- Resources/Game/Props/HighChambersYendor_LightLock/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"
local Color = require "ItsyScape.Graphics.Color"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local LightLock = Class(SimpleStaticView)

function LightLock:load()
	SimpleStaticView.load(self)

	self.light = PointLightSceneNode()
	self.light:setAttenuation(10)
	self.light:setColor(Color(0, 1, 0, 1))
end

function LightLock:getTextureFilename()
	return "Resources/Game/Props/HighChambersYendor_LightLock/Texture.png"
end

function LightLock:getModelFilename()
	return "Resources/Game/Props/HighChambersYendor_LightLock/Model.lstatic", "LightSphere"
end

function LightLock:tick()
	SimpleStaticView.tick(self)

	if self.light then
		local isLit = self:getProp():getState().lit
		if isLit then
			self.light:setParent(self:getRoot())
		else
			self.light:setParent(nil)
		end
	end
end

return LightLock
