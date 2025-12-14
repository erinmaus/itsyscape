--------------------------------------------------------------------------------
-- Resources/Game/Props/IsabelleIslandTowerSpiralStaircase/View.lua
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
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local Staircase = Class(PropView)
Staircase.START_ANGLE = math.pi / 2
Staircase.END_ANGLE   = 0

Staircase.HEIGHT = 18
Staircase.RADIUS = 9
Staircase.STEPS  = Staircase.HEIGHT * 1.5

Staircase.CELL_SIZE = 2

Staircase.RUNE_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/FloatingSpecularTriplanar",
	texture = "Resources/Game/Props/IsabelleIslandTowerSpiralStaircase/Texture.png",

	uniforms = {
		scape_TriplanarScale = { "float", 0 },
		scape_TriplanarExponent = { "float", 0 },
		scape_TriplanarOffset = { "float", 0 },
		scape_SpecularWeight = { "float", 0 },
		scape_NumPatterns = { "integer", 4 },
		scape_Pattern = {
			"float",
			0.3, math.pi / 3, 0.1,
			0.2, math.pi / 4, 0.15,
			0.4, math.pi / 7, 0.05,
			0.5, math.pi / 5, 0.1,
		},
	},

	properties = {
		outlineThreshold = -0.01,
		color = "b5b3c4"
	}
})

function Staircase:new(...)
	PropView.new(self, ...)
end

function Staircase:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local decoration = Decoration()

	local radius = self.RADIUS * self.CELL_SIZE

	for i = 2, self.STEPS do
		local delta = (i - 1) / (self.STEPS - 1)
		local angle = math.lerp(self.START_ANGLE, self.END_ANGLE, delta)

		local x = math.cos(angle) * radius
		local y = math.lerp(0, self.HEIGHT, delta)
		local z = math.sin(angle) * radius - radius

		local rng = love.math.newRandomGenerator(i)
		local spin = math.lerp(0, math.pi * 2, rng:random())

		decoration:add(
			"rune",
			Vector(x, y, z),
			Quaternion.fromAxisAngle(Vector.UNIT_Y, spin))

		self:addGreeble(FlickerGreeble, {
			MIN_ATTENUATION = 1,
			MAX_ATTENUATION = 2,

			COLORS = {
				Color.fromHexString("463779"),
				Color.fromHexString("2e2257"),
				Color.fromHexString("604ba5")
			}
		}, {
			translation = Vector(x, y, z)
		})
	end

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/IsabelleIslandTowerSpiralStaircase/Model.lstatic",
		function(mesh)
			self.mesh = mesh

			self.decorationNode = DecorationSceneNode()
			self.decorationNode:fromDecoration(decoration, mesh:getResource())
			self.decorationNode:setParent(root)

			self.RUNE_MATERIAL:apply(self.decorationNode, self:getResources())
		end)
end

return Staircase
