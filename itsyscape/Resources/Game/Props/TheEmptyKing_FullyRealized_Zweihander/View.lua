--------------------------------------------------------------------------------
-- Resources/Game/Props/TheEmptyKing_FullyRealized_Zweihander/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local AncientZweihander = Class(SimpleStaticView)
AncientZweihander.OFFSET   = Vector(0, 2, 0)
AncientZweihander.ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 4 + math.pi / 2)

function AncientZweihander:getTextureFilename()
	return "Resources/Game/Props/TheEmptyKing_FullyRealized_Zweihander/Texture.png"
end

function AncientZweihander:getModelFilename()
	return "Resources/Game/Props/TheEmptyKing_FullyRealized_Zweihander/Model.lstatic", "Zweihander"
end

function AncientZweihander:load()
	SimpleStaticView.load(self)

	local resources = self:getResources()
	resources:queueEvent(function()
		local transform = self.decoration:getTransform()
		transform:setLocalTranslation(self.OFFSET)
		transform:setLocalRotation(self.ROTATION)
	end)
end

function AncientZweihander:disable()
	self.isDisabled = true
end

function AncientZweihander:tick()
	SimpleStaticView.tick(self)

	if self.isDisabled then
		self:getRoot():setParent(nil)
	end
end

return AncientZweihander
