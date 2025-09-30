--------------------------------------------------------------------------------
-- Resources/Game/Props/Furnace_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local FlameGreeble = require "Resources.Game.Props.Common.Greeble.FlameGreeble"
local SmokeGreeble = require "Resources.Game.Props.Common.Greeble.SmokeGreeble"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Furnace = Class(PropView)

Furnace.ACTIVE_DURATION_SECONDS = 1

Furnace.SMALL_FLAME_IDLE = {
	FLAME_SCALE = Vector(2):keep(),
	FLAME_HEIGHT = 0.25,
	INNER_FLAME_SPEED = 0.1,
	OUTER_FLAME_SPEED = 0.2
}

Furnace.BIG_FLAME_IDLE = {
	FLAME_SCALE = Vector(2):keep(),
	FLAME_HEIGHT = 0.5,
	INNER_FLAME_SPEED = 0.2,
	OUTER_FLAME_SPEED = 0.3
}

Furnace.SMOKE_IDLE = {
	SMOKE_SCALE = Vector(2),
	SMOKE_SPEED = 0.5,
	SMOKE_HEIGHT = 0
}

Furnace.FLICKER_IDLE = {
	MIN_FLICKER_TIME = 10 / 60,
	MAX_FLICKER_TIME = 20 / 60,
	MIN_COLOR_BRIGHTNESS = 0.5,
	MIN_COLOR_BRIGHTNESS = 0.7,
	MIN_ATTENUATION = 8,
	MAX_ATTENUATION = 12,
	COLORS = {
		Color.fromHexString("ffd52a")
	}
}

Furnace.SMALL_FLAME_ACTIVE = {
	FLAME_SCALE = Vector(2):keep(),
	FLAME_HEIGHT = 1,
	INNER_FLAME_SPEED = 0.5,
	OUTER_FLAME_SPEED = 0.7
}

Furnace.BIG_FLAME_ACTIVE = {
	FLAME_SCALE = Vector(2):keep(),
	FLAME_HEIGHT = 1.5,
	INNER_FLAME_SPEED = 1,
	OUTER_FLAME_SPEED = 1.2
}

Furnace.SMOKE_ACTIVE = {
	SMOKE_SCALE = Vector(2),
	SMOKE_SPEED = 1.2,
	SMOKE_HEIGHT = 0
}

Furnace.FLICKER_ACTIVE = {
	MIN_FLICKER_TIME = 5 / 60,
	MAX_FLICKER_TIME = 10 / 60,

	MIN_COLOR_BRIGHTNESS = 0.9,
	MIN_COLOR_BRIGHTNESS = 1,

	MIN_ATTENUATION = 12,
	MAX_ATTENUATION = 14,
	COLORS = {
		Color.fromHexString("ffd52a")
	}
}

function Furnace:new(...)
	PropView.new(self, ...)

	self.smallFlames = {
		self:addGreeble(FlameGreeble, self.SMALL_FLAME_IDLE, {
			translation = Vector(-1, 0.75, -0.5)
		}),

		self:addGreeble(FlameGreeble, self.SMALL_FLAME_IDLE, {
			translation = Vector(1, 0.75, -0.5)
		})
	}

	self.bigFlames = {
		self:addGreeble(FlameGreeble, self.BIG_FLAME_IDLE, {
			translation = Vector(0, 0.75, -0.5)
		})
	}

	self.smoke = {
		self:addGreeble(SmokeGreeble, self.SMOKE_IDLE, {
			translation = Vector(0, 5, -0.5)
		})
	}

	self.flicker = {
		self:addGreeble(FlickerGreeble, self.FLICKER_IDLE, {
			translation = Vector(0, 0.5, 1)
		})
	}

	self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Furnace_Default/Model.lstatic",
		GROUP = "bricks",

		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/Furnace_Default/Bricks.png",
			uniforms = {
				scape_NumLayers = { "integer", 2 },
				scape_TriplanarScale = { "float", -0.25, 0.1 },
				scape_TriplanarOffset = { "float", 0, 0 },
				scape_TriplanarExponent = { "float", 0, 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/Furnace_Default/BricksDetail.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/Furnace_Default/SpecularBricksDetail.lua" },
				scape_SpecularWeight = { "float", 1 },
			},

			properties = {
				outlineThreshold = 0.5,
				color = "927552",
			}
		})
	})

	self:addGreeble(StaticGreeble, {
		MESH = "Resources/Game/Props/Furnace_Default/Model.lstatic",
		GROUP = "metal",

		MATERIAL = DecorationMaterial({
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Furnace_Default/Metal.png",

			properties = {
				outlineThreshold = 0.5,
				color = "42414b"
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0.5 }
			}
		})
	})

	self.activeTime = 0
end

function Furnace:load()
	PropView.load(self)

	local state = self:getProp():getState()
	self.generation = state and state.generation or 1
end

function Furnace:tick()
	PropView.tick(self)

	local state = self:getProp():getState()
	if state and self.generation ~= state.generation then
		if self.activeTime <= 0 then
			self:updateGreebles(self.smallFlames, self.SMALL_FLAME_ACTIVE)
			self:updateGreebles(self.bigFlames, self.BIG_FLAME_ACTIVE)
			self:updateGreebles(self.smoke, self.SMOKE_ACTIVE)
			self:updateGreebles(self.flicker, self.FLICKER_ACTIVE)

		end

		self.activeTime = self.ACTIVE_DURATION_SECONDS
		self.generation = state.generation
	end
end

function Furnace:update(delta)
	PropView.update(self, delta)

	local previousActiveTime = self.activeTime
	self.activeTime = math.max(self.activeTime - delta, 0)

	if self.activeTime <= 0 and previousActiveTime > 0 then
		self:updateGreebles(self.smallFlames, self.SMALL_FLAME_IDLE)
		self:updateGreebles(self.bigFlames, self.BIG_FLAME_IDLE)
		self:updateGreebles(self.smoke, self.SMOKE_IDLE)
		self:updateGreebles(self.flicker, self.FLICKER_IDLE)
	end
end

return Furnace
