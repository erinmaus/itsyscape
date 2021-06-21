--------------------------------------------------------------------------------
-- Resources/Game/Props/Building_SistineOfSimulacrum/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local PropView = require "ItsyScape.Graphics.PropView"
local Shape4DView = require "Resources.Game.Props.Common.Shape4DView"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local function onWillRender(renderer, scaleMin)
	local shader = renderer:getCurrentShader()

	local scale = math.abs(math.sin(math.pi * love.timer.getTime() / 32)) + scaleMin

	if shader:hasUniform("scape_TextureDepthScale") then
		shader:send("scape_TextureDepthScale", scale)
	end
end

local Building = Class(Shape4DView)

Building.GROUPS = { "Building" }

Building.SCALES = { Vector.ONE }

Building.STEP = 1

Building.OFFSET_TWEEN = Tween.constantZero
Building.OFFSETS = { Vector.ZERO }

function Building:onWillRender(renderer)
	onWillRender(renderer, 16)
end

function Building:getTextureFilename()
	return "Resources/Game/Props/Building_SistineOfSimulacrum/Texture_Building.lua"
end

function Building:getModelFilename()
	return "Resources/Game/Props/Building_SistineOfSimulacrum/Sistine.lstatic"
end

local Roof = Class(Shape4DView)

Roof.GROUPS = { "Roof" }

Roof.SCALES = { Vector.ONE }

Roof.STEP = 1

Roof.OFFSET_TWEEN = Tween.constantZero
Roof.OFFSETS = { Vector.ZERO }

function Roof:getTextureFilename()
	return "Resources/Game/Props/Building_SistineOfSimulacrum/Texture_Roof.lua"
end

function Roof:getModelFilename()
	return "Resources/Game/Props/Building_SistineOfSimulacrum/Sistine.lstatic"
end

function Roof:onWillRender(renderer)
	onWillRender(renderer, 8)
end

local BuildingWindows = Class(SimpleStaticView)

function BuildingWindows:getTextureFilename()
	return "Resources/Game/Props/Building_SistineOfSimulacrum/Window.png"
end

function BuildingWindows:getModelFilename()
	return "Resources/Game/Props/Building_SistineOfSimulacrum/Sistine.lstatic", "Windows"
end

local Sistine = Class(PropView)
Sistine.SCALE = Vector(40)

function Sistine:load()
	PropView.load(self)

	local root = self:getRoot()
	local prop = self:getProp()
	local gameView = self:getGameView()

	self.props = {
		Building(prop, gameView),
		Roof(prop, gameView),
		BuildingWindows(prop, gameView)
	}

	for i = 1, #self.props do
		self.props[i]:load()
		self.props[i]:getRoot():setParent(root)
	end
end

function Sistine:tick()
	PropView.tick(self)

	for i = 1, #self.props do
		self.props[i]:tick()
	end

	local root = self:getRoot()
	root:getTransform():setLocalScale(Sistine.SCALE)
	root:getTransform():setPreviousTransform(nil, nil, Sistine.SCALE)
end

function Sistine:update(delta)
	PropView.update(self, delta)

	for i = 1, #self.props do
		self.props[i]:update(delta)
	end
end

return Sistine
