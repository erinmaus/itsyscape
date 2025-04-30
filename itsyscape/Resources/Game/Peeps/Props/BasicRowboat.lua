--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicRowboat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BasicRowboat = Class(Prop)

function BasicRowboat:update(director, game)
	Prop.update(self, director, game)

	if not self._initialRotation then
		self._initialRotation = Utility.Peep.getRotation(self)
	end

	local oceanWorldPosition, oceanRotation
	if Sailing.Ocean.hasOcean(self) then
		oceanWorldPosition, oceanRotation = Sailing.Ocean.getPositionRotation(self)
	else
		oceanWorldPosition = Utility.Peep.getPosition(self)
		oceanRotation = Quaternion.IDENTITY
	end

	Utility.Peep.setPosition(self, oceanWorldPosition + Vector(0, 0.25, 0))
	Utility.Peep.setRotation(self, self._initialRotation * oceanRotation)
end

return BasicRowboat
