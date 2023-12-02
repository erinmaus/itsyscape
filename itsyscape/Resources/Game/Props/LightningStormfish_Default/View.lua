--------------------------------------------------------------------------------
-- Resources/Game/Props/LightningStormfish_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local FishView = require "Resources.Game.Props.Common.FishView"

local LightningStormfishView = Class(FishView)
LightningStormfishView.MIN_ATTENUATION = 10
LightningStormfishView.MAX_ATTENUATION = 17.5
LightningStormfishView.TIME_RADIUS     = math.pi / 2
LightningStormfishView.INTERVAL        = 2.75
LightningStormfishView.COLOR = Color(1, 1, 0, 1)

function LightningStormfishView:getTextureFilename()
	return "Resources/Game/Props/LightningStormfish_Default/Texture.png"
end

function LightningStormfishView:load()
	FishView.load(self)

	self.light = PointLightSceneNode()
	self.light:setColor(LightningStormfishView.COLOR)
	self.light:setAttenuation(0)
	self.light:setParent(self.decoration)
end

function LightningStormfishView:update(delta)
	FishView.update(self, delta)

	local delta = math.abs(math.sin(self.time * LightningStormfishView.TIME_RADIUS)) * LightningStormfishView.INTERVAL
	delta = math.max(math.min(delta, 1, 0))

	self.light:setAttenuation(delta * (LightningStormfishView.MAX_ATTENUATION - LightningStormfishView.MIN_ATTENUATION) + LightningStormfishView.MIN_ATTENUATION)
end

return LightningStormfishView
