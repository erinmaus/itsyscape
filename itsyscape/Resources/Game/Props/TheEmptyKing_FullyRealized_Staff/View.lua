--------------------------------------------------------------------------------
-- Resources/Game/Props/TheEmptyKing_FullyRealized_Staff/View.lua
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

local Staff = Class(SimpleStaticView)
Staff.OFFSET   = Vector(0, 2, 0)
Staff.ROTATION = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 4 + math.pi / 2)

function Staff:getTextureFilename()
	return "Resources/Game/Props/TheEmptyKing_FullyRealized_Staff/Texture.png"
end

function Staff:getModelFilename()
	return "Resources/Game/Props/TheEmptyKing_FullyRealized_Staff/Model.lstatic", "Staff"
end

function Staff:load()
	SimpleStaticView.load(self)

	local resources = self:getResources()
	resources:queueEvent(function()
		local transform = self.decoration:getTransform()
		transform:setLocalTranslation(self.OFFSET)
		transform:setLocalRotation(self.ROTATION)
	end)
end

function Staff:disable()
	self.isDisabled = true
end

function Staff:tick()
	SimpleStaticView.tick(self)

	if self.isDisabled then
		self:getRoot():setParent(nil)
	end
end

return Staff
