--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/MimicVomit_Coins/Projectile.lua
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

local Coins = Class(MimicVomit)

Coins.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/MimicVomit_Coins/Particle.png",
	rows = 2,
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 2, 2.5 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ Color.fromHexString("ffcc00", 0):get() },
				{ Color.fromHexString("ffcc00", 0):get() },
				{ Color.fromHexString("ffcc00", 0):get() },
				{ Color.fromHexString("fff6d5", 0):get() },
				{ Color.fromHexString("ffaa00", 0):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1.5, 2.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.5, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.05 },
			fadeOutPercent = { 0.95 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 8 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 5, 8 },
		delay = { 1 / 16 },
		duration = { math.huge }
	}
}

Coins.LIGHT_COLOR = Color.fromHexString("ffaa00")

Coins.ANIMATION = "SFX_Mimic_Coins"

return Coins
