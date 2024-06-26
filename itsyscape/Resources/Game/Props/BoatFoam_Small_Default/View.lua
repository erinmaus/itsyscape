--------------------------------------------------------------------------------
-- Resources/Game/Props/BoatFoam_Small_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local BoatFoam = Class(SimpleStaticView)

function BoatFoam:getTextureFilename()
	return "Resources/Game/Props/BoatFoam_Small_Common/Default.png"
end

function BoatFoam:getModelFilename()
	return "Resources/Game/Props/BoatFoam_Small_Common/Default.lstatic", "BoatFoam"
end

function BoatFoam:load(...)
	SimpleStaticView.load(self, ...)

	local resources = self:getResources()
	resources:queue(ShaderResource, "Resources/Shaders/StaticModel_BoatFoam", function(shader)
		self.decoration:getMaterial():setShader(shader)
	end)
end

function BoatFoam:tick()
	SimpleStaticView.tick(self)

	local state = self:getProp():getState()
	if not state.visible then
		self:getRoot():setParent(nil)
	end
end

function BoatFoam:getIsStatic()
	return false
end

return BoatFoam
