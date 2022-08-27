--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_HexagramVsPlayer/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Hexagram = require "Resources.Game.Projectiles.Power_Hexagram.Projectile"

local PlayerHexagram = Class(Projectile)
PlayerHexagram.DURATION = 10

return PlayerHexagram
