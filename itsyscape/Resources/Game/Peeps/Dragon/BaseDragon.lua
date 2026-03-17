--------------------------------------------------------------------------------
-- Resources/Peeps/Dragon/BaseDragon.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local DynamicBehavior = require "ItsyScape.Peep.Behaviors.DynamicBehavior"

local Dragon = Class(Creep)

function Dragon:new(...)
	Creep.new(self, ...)

	self:addBehavior(RotationBehavior)
end

function Dragon:ready(director, game)
	Creep.ready(self, director, game)

	local _, dynamic = self:addBehavior(DynamicBehavior)
	dynamic.radius = 8
	dynamic.margin = 0.5

	Utility.Peep.setSize(self, Vector(16, 6, 16))

	Utility.Peep.Creep.setBody(self, "Dragon")

	Utility.Peep.Creep.addAnimation(self, "animation-idle", "Dragon_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-walk", "Dragon_Idle")
	Utility.Peep.Creep.addAnimation(self, "animation-die", "Dragon_Idle")
end

function Dragon:update(director, game)
	Creep.update(self, director, game)

	Utility.Peep.face3D(self)
end

return Dragon
