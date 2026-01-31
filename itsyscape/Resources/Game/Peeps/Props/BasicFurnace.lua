--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/BasicFurnace.lua
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
local BasicArtisanStation = require "Resources.Game.Peeps.Props.BasicArtisanStation"

local BasicFurnace = Class(BasicArtisanStation)

BasicFurnace.COLLISION_IS_TALL = true

function BasicFurnace:new(...)
	BasicArtisanStation.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4.5, 4, 3.5)

	self:addPoke("smelt")
end

return BasicFurnace
