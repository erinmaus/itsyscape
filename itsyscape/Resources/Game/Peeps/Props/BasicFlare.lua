--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicFlare.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PassableProp = require "Resources.Game.Peeps.Props.PassableProp"

local BasicFlare = Class(PassableProp)
BasicFlare.DRAG = 1 / 20

function BasicFlare:new(...)
	PassableProp.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 1, 1)
end

function BasicFlare:update(director, game)
	PassableProp.update(self, director, game)

	local windDirection, windSpeed = Utility.Map.getWind(game, Utility.Peep.getLayer(self))
	local position = Utility.Peep.getPosition(self) + windDirection * windSpeed * self.DRAG * game:getDelta()
	Utility.Peep.setPosition(self, position)
end

return BasicFlare
