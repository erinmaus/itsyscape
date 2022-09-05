--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DebugTeleport.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Interface = require "ItsyScape.UI.Interface"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Widget = require "ItsyScape.UI.Widget"

local DebugTeleport = Class(Interface)
DebugTeleport.WIDTH = 480
DebugTeleport.HEIGHT = 480
DebugTeleport.PADDING = 8

function DebugTeleport:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.anchors = {}

	local w, h = love.graphics.getScaledMode()
	self:setSize(DebugTeleport.WIDTH, DebugTeleport.HEIGHT)
	self:setPosition(
		(w - DebugTeleport.WIDTH) / 2,
		(h - DebugTeleport.HEIGHT) / 2)

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

	self.anchorsPanel = ScrollablePanel(GridLayout)
	self.anchorsPanel:getInnerPanel():setUniformSize(
		true,
		DebugTeleport.WIDTH - DebugTeleport.PADDING * 2,
		24)
	self.anchorsPanel:getInnerPanel():setPadding(
		DebugTeleport.PADDING / 2,
		DebugTeleport.PADDING / 2)
	self.anchorsPanel:getInnerPanel():setWrapContents(true)
	self.anchorsPanel:setSize(
		DebugTeleport.WIDTH,
		DebugTeleport.HEIGHT / 2 - DebugTeleport.PADDING * 4)
	self.anchorsPanel:setPosition(
		DebugTeleport.PADDING,
		DebugTeleport.HEIGHT / 2 + DebugTeleport.PADDING * 2)
	self:addChild(self.anchorsPanel)

	self.locationsPanel = ScrollablePanel(GridLayout)
	self.locationsPanel:getInnerPanel():setUniformSize(
		true,
		DebugTeleport.WIDTH - DebugTeleport.PADDING * 2,
		24)
	self.locationsPanel:getInnerPanel():setPadding(
		DebugTeleport.PADDING / 2,
		DebugTeleport.PADDING / 2)
	self.locationsPanel:getInnerPanel():setWrapContents(true)
	self.locationsPanel:setSize(
		DebugTeleport.WIDTH,
		DebugTeleport.HEIGHT / 2 - DebugTeleport.PADDING * 4)
	self.locationsPanel:setPosition(
		0,
		DebugTeleport.PADDING)
	self:addChild(self.locationsPanel)

	do
		local state = self:getState()
		local gameDB = ui:getGame():getGameDB()

		local maps = {}
		for map in gameDB:getResources("Map") do
			table.insert(maps, map)
		end

		table.sort(maps, function(a, b) return a.name < b.name end)

		for i = 1, #maps do
			local map = maps[i]
			local button = Button()
			button:setText(map.name)
			button:setStyle(self.buttonStyle)
			button.onClick:register(self.populateAnchors, self, map)

			if map.name == state.currentMap then
				self:populateAnchors(map)
			end

			self.locationsPanel:addChild(button)
		end
		
		self.locationsPanel:setScrollSize(self.locationsPanel:getInnerPanel():getSize())
	end

	self.closeButton = Button()
	self.closeButton:setSize(48, 48)
	self.closeButton:setPosition(DebugTeleport.WIDTH - 48, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)
end

function DebugTeleport:populateAnchors(map)
	local gameDB = self:getView():getGame():getGameDB()
	local anchors = gameDB:getRecords("MapObjectLocation", {
		Map = map
	})

	table.sort(anchors, function (a, b)
		return a:get("Name") < b:get("Name")
	end)

	for i = 1, #self.anchors do
		self.anchorsPanel:removeChild(self.anchors[i])
	end
	self.anchors = {}

	for i = 1, #anchors do
		local noProp = not gameDB:getRecord("PropMapObject", { MapObject = anchors[i]:get("Resource") })

		if noProp then
			local button = Button()
			button:setText(anchors[i]:get("Name"))
			button:setStyle(self.buttonStyle)
			button.onClick:register(self.teleport, self, map.name, anchors[i]:get("Name"))

			self.anchorsPanel:addChild(button)

			table.insert(self.anchors, button)
		end
	end
	self.anchorsPanel:setScrollSize(self.anchorsPanel:getInnerPanel():getSize())
	self.anchorsPanel:setScroll(0, 0)
end

function DebugTeleport:teleport(map, anchor)
	self:sendPoke("teleport", nil, {
		map = map,
		anchor = anchor
	})
end

return DebugTeleport
