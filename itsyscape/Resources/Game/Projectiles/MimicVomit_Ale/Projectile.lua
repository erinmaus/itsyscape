--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MimicVomit_Ale/Projectile.lua
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

local Ale = Class(MimicVomit)

Ale.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/MimicVomit_Ale/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.5 },
			speed = { 2, 2.5 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("e3dedb"):get() },
				{ Color.fromHexString("e3dedb"):get() },
				{ Color.fromHexString("ac9d93"):get() },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.35, 0.45 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.4, 0.6 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 30, 60 },
			acceleration = { -40, -20 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 6, 12 },
		delay = { 1 / 16 },
		duration = { math.huge }
	}
}

Ale.LIGHT_COLOR = Color.fromHexString("e3dedb")

return Ale
