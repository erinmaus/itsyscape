--------------------------------------------------------------------------------
-- Resources/Game/Props/Schism/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local ParticleGreeble = require "Resources.Game.Props.Common.Greeble.ParticleGreeble"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Schism = Class(SimpleStaticView)

Schism.GREEBLE = {
	{
		type = ParticleGreeble,
		config = {
			MATERIAL = ParticleGreeble.MATERIAL:replace(DecorationMaterial({
				shader = false,
				texture = false,

				properties = {
					isShadowCaster = true,
					glassThickness = 1,
				}
			})),

			PARTICLES = {
				numParticles = 500,
				texture = "Resources/Game/Props/Schism/Particle.png",
				
				columns = 4,
				soft = true,

				emitters = {
					{
						type = "RadialEmitter",
						radius = { 6.5 },
						position = { 0, 6, 0 },
						zRange = { 0, 0 },
						speed = { 0 },
						acceleration = { 4, 5 },
					},
					{
						type = "RandomColorEmitter",
						colors = {
							{ 0.31, 0.53, 0.47, 1.0 },
							{ 0.2, 0.62, 0.5, 1.0 },
							{ 0.14, 0.42, 0.34, 1.0 }
						}
					},
					{
						type = "RandomLifetimeEmitter",
						lifetime = { 0.5, 1 }
					},
					{
						type = "RandomScaleEmitter",
						scale = { 1, 2 }
					},
					{
						type = "RandomRotationEmitter",
						rotation = { 0, 360 }
					}
				},

				paths = {
					{
						type = "GravityPath",
						gravity = { 0, -5, 0 },
					},
					{
						type = "TextureIndexPath",
						textures = { 1, 4 }
					}
				},

				emissionStrategy = {
					type = "RandomDelayEmissionStrategy",
					count = { 20, 30 },
					delay = { 1 / 30 },
					duration = { math.huge }
				}
			}
		}
	},
	{
		type = StaticGreeble,
		config = {
			MESH = "Resources/Game/Props/Schism/Model.lstatic",
			GROUP = "schism",
			MATERIAL = DecorationMaterial({
				shader = "Resources/Shaders/Schism",
				texture = "Resources/Game/Props/Schism/Alpha.png",

				uniforms = {
					scape_YOffset = { "float", 0.25 },
					scape_WindDirection = { "float", -1, 0, -1 },
					scape_WindSpeed = { "float", 2 },
					scape_WindPattern = { "float", 5, 10, 15 },
					scape_SchismTexture = { "texture", "Resources/Game/Props/Schism/Schism.png" },
					scape_SchismRotationSpeed = { "float", math.pi / 16 },
					scape_SchismHoleSpeed = { "float", math.pi / 4 },
					scape_SchismRings = { "float", 0.25 },
					scape_AlphaCutoffSpeed = { "float", math.pi / 8 },
					scape_AlphaCutoffRange = { "float", 0.6, 1.0 },
				},

				properties = {
					color = "339d80",
					isFullLit = true,
					glassThickness = 1,
					outlineThreshold = -1
				}
			})
		}
	}
}

return Schism
