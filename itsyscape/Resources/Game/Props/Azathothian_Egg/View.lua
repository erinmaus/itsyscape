--------------------------------------------------------------------------------
-- Resources/Game/Props/Azathothian_Egg/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Egg = Class(SimpleStaticView)

function Egg:getTextureFilename()
	return "Resources/Game/Props/Azathothian_Egg/Texture.png"
end

function Egg:getModelFilename()
	return "Resources/Game/Props/Azathothian_Egg/Model.lstatic", "Egg"
end

function Egg:load()
	SimpleStaticView.load(self)

	local resources = self:getResources()
	resources:queueEvent(function()
		local model = self:getModelNode()
		local transform = model:getTransform()

		transform:setPreviousTransform(nil, nil, Vector(0, 0, 0))
		transform:setLocalScale(Vector(1, 1, 1))
	end)
end

return Egg
