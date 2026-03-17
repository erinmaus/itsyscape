--------------------------------------------------------------------------------
-- Resources/Game/Props/GiantSquidTentacleExhibit/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Squid = Class(SimpleStaticView)

Squid.OFFSET_CENTER = Vector(0, 4, 0)
Squid.XYZ_SIN_MULTIPLIER = Vector(
	1 + 1 / 7,
	2 + 3 / 5,
	1 + 4 / 9)
Squid.XYZ_SIN_OFFSET = Vector(
	math.pi / 6,
	math.pi / 3,
	math.pi * (1 / 2 + 1 / 3))
Squid.XYZ_COS_MULTIPLIER = Vector(
	2 + 3 / 5,
	1 + 4 / 9,
	1 + 1 / 7)
Squid.XYZ_COS_OFFSET = Vector(
	math.pi * (1 / 2 + 1 / 3),
	math.pi / 3,
	math.pi / 6)
Squid.TIME_SCALE = 1 / 25
Squid.RADIUS = 0.25

Squid.X_RADIANS_PER_SECOND = math.pi / 16
Squid.Y_RADIANS_PER_SECOND = math.pi / 32
Squid.Z_RADIANS_PER_SECOND = math.pi / 8

Squid.MIN_ROTATION_RADIANS = Vector(
	-math.pi / 16,
	-math.pi / 4,
	-math.pi / 32)
Squid.MAX_ROTATION_RADIANS = Vector(
	math.pi / 16,
	math.pi / 4,
	math.pi / 32)

function Squid:new(...)
	SimpleStaticView.new(self, ...)

	self.squidGreeble = self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/GiantSquidTentacleExhibit/Model.lstatic",
		GROUP = "squid",
		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/GiantSquidTentacleExhibit/SquidDetail.png",
			uniforms = {
				scape_NumLayers = { "integer", 1 },
				scape_TriplanarScale = { "float", 0, 0 },
				scape_TriplanarOffset = { "float", 0, 0 },
				scape_TriplanarExponent = { "float", 0, 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/GiantSquidTentacleExhibit/SquidTexture.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/GiantSquidTentacleExhibit/SpecularSquidTexture.lua" },
				scape_SpecularWeight = { "float", 1 },
			},

			properties = {
				outlineThreshold = -0.01
			}
		})
	})
end

Squid.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/GiantSquidTentacleExhibit/Model.lstatic",
		group = "metal",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/GiantSquidTentacleExhibit/Metal.png",

			properties = {
				outlineThreshold = 0.5,
				color = "ffa100",
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/GiantSquidTentacleExhibit/Model.lstatic",
		group = "water",

		material = DecorationMaterial("Resources/Game/Water/LightFoamyWater1/Material.lua"):replace(DecorationMaterial({
			uniforms = {
				scape_YOffset = { "float", 0.125 },
				scape_SkyColor = { "color", "e3f2ff", 0.25 },
				scape_NearFoamDepth = { "float", 0, 0.5 },
				scape_FarFoamDepth = { "float", 0.25, 0.5 },
				scape_WaterDepth = { "float", 0.5, 1.0 },
				scape_WindDirection = { "float", -1, 0, -1 },
				scape_WindSpeed = { "float", 2 },
				scape_WindPattern = { "float", 5, 10, 15 },
			},
			properties = {
				alpha = 0.8,
				isFullLit = true,
				isReflectiveOrRefractive = true,
				reflectionPower = 0.5,
				reflectionDistance = 2,
				roughness = 0,
				glassThickness = 1
			}
		}))
	},
}

function Squid:update(delta)
	SimpleStaticView.update(self, delta)

	local time = love.timer.getTime()

	local positionDelta = time * self.TIME_SCALE
	local positionMu = Vector(
		math.sin(positionDelta * math.pi * self.XYZ_SIN_MULTIPLIER.x + self.XYZ_SIN_OFFSET.x) + math.cos(positionDelta * math.pi * self.XYZ_COS_MULTIPLIER.x + self.XYZ_COS_OFFSET.x),
		math.sin(positionDelta * math.pi * self.XYZ_SIN_MULTIPLIER.y + self.XYZ_SIN_OFFSET.y) + math.cos(positionDelta * math.pi * self.XYZ_COS_MULTIPLIER.y + self.XYZ_COS_OFFSET.y),
		math.sin(positionDelta * math.pi * self.XYZ_SIN_MULTIPLIER.z + self.XYZ_SIN_OFFSET.z) + math.cos(positionDelta * math.pi * self.XYZ_COS_MULTIPLIER.z + self.XYZ_COS_OFFSET.z))
	positionMu = ((positionMu / Vector(2)) + Vector(1)) / Vector(2)


	local relativePosition = Vector(
		math.sin(positionMu.x * math.pi * 2) * self.RADIUS,
		math.sin(positionMu.y * math.pi * 2) * self.RADIUS,
		math.sin(positionMu.z * math.pi * 2) * self.RADIUS)

	local position = relativePosition + self.OFFSET_CENTER

	local rotationAngles = math.lerp(self.MIN_ROTATION_RADIANS, self.MAX_ROTATION_RADIANS, positionMu)
	local rotation = Quaternion.fromEulerXYZ(rotationAngles:get())

	self.squidGreeble:getRoot():getTransform():setLocalTranslation(position)
	self.squidGreeble:getRoot():getTransform():setLocalRotation(rotation)
end

return Squid
