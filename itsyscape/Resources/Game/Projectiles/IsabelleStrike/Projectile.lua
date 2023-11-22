--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/AirStrike/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local AirStrike = require "ItsyScape.Resources.Game.Projectiles.AirStrike.Projectile"

local IsabelleStrike = Class(AirStrike)

IsabelleStrike.SEGMENT_LENGTH = 1 / 4
IsabelleStrike.RADIUS = 0.25
IsabelleStrike.COLOR = Color.fromHexString("584e7d")
IsabelleStrike.SPEED = 6

function IsabelleStrike:load()
	AirStrike.load(self)

	self.airWave:setBlendMode('add')
end

return IsabelleStrike
