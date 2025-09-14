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
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local Color = require "ItsyScape.Graphics.Color"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Bars = Class(PropView)

Bars.MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/SpecularTriplanar",
	texture = "Resources/Game/Props/BronzeBars/Metal.png",
	uniforms = {
		scape_TriplanarScale = { "float", -0.5 },
		scape_TriplanarOffset = { "float", 0 },
		scape_TriplanarExponent = { "float", 0 },
		scape_SpecularWeight = { "float", 0.5 },
	},

	properties = {
		outlineThreshold = 0.5,
		color = "a05a2c",
	}
})

Bars.MESSY_GREEBLE = {
	MESH = "Resources/Game/Props/BronzeBars/Model.lstatic",
	GROUP = "bars.messy"
}

Bars.STABLE_GREEBLE = {
	MESH = "Resources/Game/Props/BronzeBars/Model.lstatic",
	GROUP = "bars"
}

function Bars:new(...)
	PropView.new(self, ...)

	self.barsGreeble = self:addGreeble(StaticGreeble)
end

function Bars:load()
	PropView.load(self)

	self:_tryLoad()
end

function Bars:_load()
	local a, b = self:getProp():getTile()
	local rng = love.math.newRandomGenerator(a, b)

	local types = {
		self.MESSY_GREEBLE,
		self.STABLE_GREEBLE
	}

	local t = types[rng:random(#types)]
	self.barsGreeble:regreebilize({
		MESH = t.MESH,
		GROUP = t.GROUP,
		MATERIAL = self.MATERIAL
	})
end

function Bars:_tryLoad()
	local currentI, currentJ = self:getProp():getTile()
	if self.currentI ~= currentI or self.currentJ ~= currentJ then
		self.currentI = currentI
		self.currentJ = currentJ
		self:_load()
	end
end

function Bars:updateTransform()
	PropView.updateTransform(self)
	self:_tryLoad()
end

return Bars
