--------------------------------------------------------------------------------
-- Resources/Game/Props/BoatFoamTrail_Small_Default/View.lua
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

local BoatFoamTrail = Class(SimpleStaticView)

function BoatFoamTrail:getTextureFilename()
	return "Resources/Game/Props/BoatFoam_Small_Common/Default.png"
end

function BoatFoamTrail:getModelFilename()
	return "Resources/Game/Props/BoatFoam_Small_Common/Default.lstatic", "BoatFoam-Trail"
end

function BoatFoamTrail:load(...)
	SimpleStaticView.load(self, ...)

	local resources = self:getResources()
	resources:queue(ShaderResource, "Resources/Shaders/StaticModel_BoatFoamTrail", function(shader)
		self.decoration:getMaterial():setShader(shader)
	end)
end

function BoatFoamTrail:getIsStatic()
	return false
end

return BoatFoamTrail
