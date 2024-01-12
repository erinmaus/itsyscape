--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MimicVomit_Planks/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local MimicVomit = require "Resources.Game.Projectiles.MimicVomit_Common.Projectile"

local Planks = Class(MimicVomit)

Planks.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/MimicVomit_Planks/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 2, 3 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.75, 1.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.75 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -180, 180 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.9 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 2, 4 },
		delay = { 1 / 32 },
		duration = { math.huge }
	}
}

Planks.LIGHT_COLOR = Color.fromHexString("000000")

return Planks
