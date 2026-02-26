--------------------------------------------------------------------------------
-- Resources/Game/Props/WoodcuttingCursor/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"
local ParticleGreeble = require "Resources.Game.Props.Common.Greeble.ParticleGreeble"

local WoodcuttingCursor = Class(PropView)

function WoodcuttingCursor:new(...)
	PropView.new(self, ...)

	self:addGreeble(ParticleGreeble, {
		PARTICLES = {
			numParticles = 200,
			texture = "Resources/Game/Props/WoodcuttingCursor/Particle.png",
			columns = 4,

			emitters = {
				{
					type = "RadialEmitter",
					radius = { 0, 1.5 },
					yRange = { 0.9, 0.1 },
					speed = { 2, 3 },
					acceleration = { -3, -4 },
					lifetime = { 0.5, 0.6 },
				},
				{
					type = "RandomColorEmitter",
					colors = {
						{ 0.92, 0.71, 0.12, 0.0 },
						{ 0.92, 0.71, 0.12, 0.0 },
						{ 0.97, 0.9, 0.67, 0.0 }
					}
				},
				{
					type = "RandomScaleEmitter",
					scale = { 0.5, 0.5 }
				},
				{
					type = "RandomRotationEmitter",
					rotation = { 0, 360 },
				},
			},

			paths = {
				{
					type = "FadeInOutPath",
					fadeInPercent = { 0.1 },
					fadeOutPercent = { 0.9 },
					tween = { 'sineEaseOut' }
				},
				{
					type = "TextureIndexPath",
					textures = { 1, 4 }
				}
			},

			emissionStrategy = {
				type = "RandomDelayEmissionStrategy",
				count = { 2, 4 },
				delay = { 1 / 5 },
				duration = { math.huge }
			}
		}
	})

	self:addGreeble(FlickerGreeble, {
		MIN_ATTENUATION = 1,
		MAX_ATTENUATION = 2.5,

		COLORS = {
			Color.fromHexString("f8e4ac")
		}
	})
end

function WoodcuttingCursor:getIsStatic()
	return false
end

return WoodcuttingCursor
