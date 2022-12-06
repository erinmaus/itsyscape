--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugAntilogikaWarp.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Antilogika = require "ItsyScape.Game.Skills.Antilogika"
local Button = require "ItsyScape.UI.Button"
local Drawable = require "ItsyScape.UI.Drawable"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"

local DebugAntilogikaWarp = Class(Interface)
DebugAntilogikaWarp.WIDTH = 480
DebugAntilogikaWarp.HEIGHT = 480
DebugAntilogikaWarp.PANEL_HEIGHT = DebugAntilogikaWarp.WIDTH / 4
DebugAntilogikaWarp.PADDING = 8

DebugAntilogikaWarp.Graph = Class(Drawable)
DebugAntilogikaWarp.Graph.STEPS_CURVE = 100
DebugAntilogikaWarp.Graph.STEPS_NOISE = 200

function DebugAntilogikaWarp.Graph:setZone(zone)
	do
		local s, r = pcall(Antilogika.Zone, zone)
		if not s then
			Log.warn("Error creating zone: %s", r)
			self.zone = nil
		else
			self.zone = r
		end
	end

	do
		local s, r = pcall(love.math.newBezierCurve, unpack(zone.curve or {}))
		if not s then
			Log.warn("Error creating curve: %s.", r)
			self.curve = nil
		else
			self.curve = r
		end
	end
end

function DebugAntilogikaWarp.Graph:drawCurve(x, y, w, h)
	local points = {}

	for i = 1, DebugAntilogikaWarp.Graph.STEPS_CURVE do
		local delta = (i - 1) / (DebugAntilogikaWarp.Graph.STEPS_CURVE - 1)
		local currentX = delta * w

		local s, t = pcall(self.curve, self.curve.evaluate, self, delta)
		if not s then
			t = 0
		end

		local currentY = h - (((t + 1) / 2)  * h)
		
		table.insert(points, currentX + x)
		table.insert(points, currentY + y)
	end

	itsyrealm.graphics.line(unpack(points))
end

function DebugAntilogikaWarp.Graph:drawNoise(x, y, w, h)
	local noise = Antilogika.NoiseBuilder.TERRAIN
	local points = {}

	local maxHeight = self.zone:getBedrockHeight() + self.zone:getAmplitude()

	for i = 1, DebugAntilogikaWarp.Graph.STEPS_NOISE do
		local delta = (i - 1) / (DebugAntilogikaWarp.Graph.STEPS_NOISE - 1)
		local currentX = delta * w
		local sample = (noise:sample1D(1 + delta) + 1) / 2
		local currentY = h - ((sample / maxHeight) * h)

		table.insert(points, currentX + x)
		table.insert(points, currentY + y)
	end

	itsyrealm.graphics.line(unpack(points))
end

function DebugAntilogikaWarp.Graph:drawSampledNoise(x, y, w, h)
	local points = {}

	local heightDifference = self.zone:getAmplitude()

	for i = 1, DebugAntilogikaWarp.Graph.STEPS_NOISE do
		local delta = (i - 1) / (DebugAntilogikaWarp.Graph.STEPS_NOISE - 1)
		local currentX = delta * w
		local sample = (self.zone:sample(1 + delta, 0, 0, 0) + heightDifference - self.zone:getBedrockHeight()) / (heightDifference * 2)
		local currentY = h - (sample * h)

		table.insert(points, currentX + x)
		table.insert(points, currentY + y)
	end

	itsyrealm.graphics.line(unpack(points))
end

function DebugAntilogikaWarp.Graph:draw(...)
	Drawable.draw(self, ...)

	local w, h = self:getSize()

	if self.curve then
		love.graphics.setLineWidth(4)

		love.graphics.setColor(0, 0, 0, 1)
		self:drawCurve(2, 2, h, h)

		love.graphics.setColor(1, 0.5, 0, 1)
		self:drawCurve(0, 0, h, h)

		love.graphics.setLineWidth(1)
		love.graphics.setColor(1, 1, 1, 1)
	end

	if self.zone then
		love.graphics.setLineWidth(4)

		do
			love.graphics.setColor(0, 0, 0, 1)
			self:drawNoise(h + 2, 2, w - h, h)

			love.graphics.setColor(0.39, 0.58, 0.93, 1)
			self:drawNoise(h + 0, 0, w - h, h)
		end

		do
			love.graphics.setColor(0, 0, 0, 1)
			self:drawSampledNoise(h + 2, 2, w - h, h)

			love.graphics.setColor(1, 0.5, 0, 1)
			self:drawSampledNoise(h + 0, 0, w - h, h)
		end

		love.graphics.setLineWidth(1)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function DebugAntilogikaWarp:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.anchors = {}

	local w, h = love.graphics.getScaledMode()
	self:setSize(DebugAntilogikaWarp.WIDTH, DebugAntilogikaWarp.HEIGHT)
	self:setPosition(
		(w - DebugAntilogikaWarp.WIDTH) / 2,
		(h - DebugAntilogikaWarp.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.buttonStyle = ButtonStyle({
		inactive = Color(0, 0, 0, 0),
		pressed = Color(29 / 255, 25 / 255, 19 / 255, 1),
		hover = Color(147 / 255, 124 / 255, 94 / 255, 1),
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 16,
		textX = 0.0,
		textY = 0.5,
		textAlign = 'left'
	}, self:getView():getResources())

	self.zonesPanel = ScrollablePanel(GridLayout)
	self.zonesPanel:getInnerPanel():setUniformSize(
		true,
		DebugAntilogikaWarp.WIDTH - DebugAntilogikaWarp.PADDING * 2,
		24)
	self.zonesPanel:getInnerPanel():setPadding(
		DebugAntilogikaWarp.PADDING / 2,
		DebugAntilogikaWarp.PADDING / 2)
	self.zonesPanel:getInnerPanel():setWrapContents(true)
	self.zonesPanel:setSize(
		DebugAntilogikaWarp.WIDTH,
		DebugAntilogikaWarp.PANEL_HEIGHT - DebugAntilogikaWarp.PADDING * 4)
	self.zonesPanel:setPosition(
		DebugAntilogikaWarp.PADDING,
		DebugAntilogikaWarp.PANEL_HEIGHT + DebugAntilogikaWarp.PADDING * 2)
	self:addChild(self.zonesPanel)

	self.dimensionsPanel = ScrollablePanel(GridLayout)
	self.dimensionsPanel:getInnerPanel():setUniformSize(
		true,
		DebugAntilogikaWarp.WIDTH - DebugAntilogikaWarp.PADDING * 2,
		24)
	self.dimensionsPanel:getInnerPanel():setPadding(
		DebugAntilogikaWarp.PADDING / 2,
		DebugAntilogikaWarp.PADDING / 2)
	self.dimensionsPanel:getInnerPanel():setWrapContents(true)
	self.dimensionsPanel:setSize(
		DebugAntilogikaWarp.WIDTH,
		DebugAntilogikaWarp.PANEL_HEIGHT - DebugAntilogikaWarp.PADDING * 4)
	self.dimensionsPanel:setPosition(
		0,
		DebugAntilogikaWarp.PADDING)
	self:addChild(self.dimensionsPanel)

	self.graph = DebugAntilogikaWarp.Graph()
	self.graph:setPosition(
		DebugAntilogikaWarp.PADDING / 2,
		DebugAntilogikaWarp.PANEL_HEIGHT * 2 + DebugAntilogikaWarp.PADDING * 5)
	self.graph:setSize(
		DebugAntilogikaWarp.WIDTH - DebugAntilogikaWarp.PADDING,
		DebugAntilogikaWarp.PANEL_HEIGHT)
	self:addChild(self.graph)

	self.closeButton = Button()
	self.closeButton:setSize(48, 48)
	self.closeButton:setPosition(DebugAntilogikaWarp.WIDTH - 48, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)
end

function DebugAntilogikaWarp:clearDimensions()
	while self.dimensionsPanel:getInnerPanel():getNumChildren() > 0 do
		self.dimensionsPanel:removeChild(self.dimensionsPanel:getInnerPanel():getChildAt(1))
	end
end

function DebugAntilogikaWarp:clearZones()
	while self.zonesPanel:getInnerPanel():getNumChildren() > 0 do
		self.zonesPanel:removeChild(self.zonesPanel:getInnerPanel():getChildAt(1))
	end
end

function DebugAntilogikaWarp:updateDimensions(dimensions)
	self:clearDimensions()
	self:clearZones()

	for i = 1, #dimensions do
		local dimension = dimensions[i]

		local button = Button()
		button:setText(dimension.id)
		button:setStyle(self.buttonStyle)
		button.onClick:register(self.populateZones, self, dimension.id, dimension.zones)
		self.dimensionsPanel:addChild(button)

		if self.currentDimensionID == dimension.id then
			self:populateZones(dimension.id, dimension)
		end
	end

	self.dimensionsPanel:setScroll(0, 0)
end

function DebugAntilogikaWarp:populateZones(dimensionID, zones)
	self.currentDimensionID = dimensionID

	for i = 1, #zones do
		local zone = zones[i]

		local button = Button()
		button:setText(zone.id)
		button:setStyle(self.buttonStyle)
		button.onClick:register(self.showZone, self, zone.id, zone)

		self.zonesPanel:addChild(button)

		if self.currentZoneID == zone.id then
			self:showZone(zone.id, zone)
		end

		self.zonesPanel:addChild(button)
	end

	self.zonesPanel:setScroll(0, 0)
end

function DebugAntilogikaWarp:showZone(zoneID, zone)
	self.currentZoneID = zoneID

	self.graph:setZone(zone)
end

function DebugAntilogikaWarp:update(delta)
	Interface.update(self, delta)

	local state = self:getState()
	if self.lastUpdateTime ~= state.lastUpdateTime then
		self:updateDimensions(state.dimensions)

		self.lastUpdateTime = state.lastUpdateTime
	end
end

return DebugAntilogikaWarp
