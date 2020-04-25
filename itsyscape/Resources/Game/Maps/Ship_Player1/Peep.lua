--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_Player1/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "Resources.Game.Peeps.Maps.PlayerShipMapPeep"
local Color = require "ItsyScape.Graphics.Color"
local Decoration = require "ItsyScape.Graphics.Decoration"
local ColorBehavior = require "ItsyScape.Peep.Behaviors.ColorBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Ship = Class(Map)

function Ship:new(resource, name, ...)
	Map.new(self, resource, name or 'Ship_Player1', ...)

	self:addPoke('customize')

	self.props = {}

	self:addBehavior(ShipStatsBehavior)
end

function Ship:loadDecoration(storage, item, defaultItem, defaultColor)
	local itemStorage = storage:getSection("Ship"):getSection(item)
	local resourceName = itemStorage:get("resource") or defaultItem

	local group = "Resources/Game/SailingItems/" .. resourceName .. "/Decoration.ldeco"
	local lazyDecoration = Decoration(group)

	local color
	do
		local r, g, b, a = itemStorage:get("red1"), itemStorage:get("green1"), itemStorage:get("blue1"), 1
		if r and g and b then
			color = Color(r, g, b, a)
		else
			color = defaultColor
			itemStorage:set("red1", color.r)
			itemStorage:set("green1", color.g)
			itemStorage:set("blue1", color.b)
		end
	end

	for feature in lazyDecoration:iterate() do
		if not feature:getID():match("XOpaque") then
			feature:setColor(color)
		end
	end

	local stage = self:getDirector():getGameInstance():getStage()
	stage:decorate(item, lazyDecoration, self:getLayer())
end

function Ship:colorDeck(storage, defaultColor)
	local itemStorage = storage:getSection("Ship"):getSection("Hull")

	local r, g, b = itemStorage:get("red2"), itemStorage:get("green2"), itemStorage:get("blue2")
	r = r or defaultColor.r
	g = g or defaultColor.g
	b = b or defaultColor.b

	itemStorage:set("red2", r)
	itemStorage:set("green2", g)
	itemStorage:set("blue2", b)

	local map = self:getDirector():getMap(self:getLayer())
	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local tile = map:getTile(i, j)

			tile.red = r
			tile.green = g
			tile.blue = b
		end
	end

	local stage = self:getDirector():getGameInstance():getStage()
	stage:updateMap(self:getLayer(), map)
end

function Ship:loadProp(storage, item, defaultItem, ...)
	local anchors = { n = select('#', ...), ... }

	local itemStorage = storage:getSection("Ship"):getSection(item)
	local propResourceName = itemStorage:get("prop")
	if not propResourceName then
		itemStorage:set("prop", defaultItem)
		propResourceName = defaultItem
	end

	local color1, color2
	do
		do
			local r, g, b, a = itemStorage:get("red1"), itemStorage:get("green1"), itemStorage:get("blue1"), 1
			if r and g and b then
				color1 = Color(r, g, b, a)
			else
				color1 = Color(math.random(), math.random(), math.random(), 1)
				itemStorage:set("red1", color1.r)
				itemStorage:set("green1", color1.g)
				itemStorage:set("blue1", color1.b)
			end
		end
		do
			local r, g, b, a = itemStorage:get("red2"), itemStorage:get("green2"), itemStorage:get("blue2"), 1
			if r and g and b then
				color2 = Color(r, g, b, a)
			else
				color2 = Color(math.random(), math.random(), math.random(), 1)
				itemStorage:set("red2", color2.r)
				itemStorage:set("green2", color2.g)
				itemStorage:set("blue2", color2.b)
			end
		end
	end

	for i = 1, anchors.n do
		local anchor = anchors[i]
		if anchor then
			local p = Utility.spawnPropAtAnchor(self, propResourceName, anchor, 0)
			if p then
				p = p:getPeep()
				table.insert(self.props, p)
				p:listen('finalize', function()
					Utility.orientateToAnchor(p, Utility.Peep.getMapResource(self), anchor)

					local _, color = p:addBehavior(ColorBehavior)
					color.primary = color1
					color.secondaries[1] = color2

					local position = p:getBehavior(PositionBehavior)
					position.layer = self:getLayer()
				end)
			end	
		end
	end
end

function Ship:onLoad(...)
	Map.onLoad(self, ...)

	self:onCustomize()
end

function Ship:updateStats(storage, item, defaultResource)
	local stats = self:getBehavior(ShipStatsBehavior).bonuses
	local itemStorage = storage:getSection("Ship"):getSection(item)
	local resourceName = itemStorage:get("resource")

	if not resourceName then
		itemStorage:set("resource", defaultResource)
		resourceName = defaultResource
	end

	local gameDB = self:getDirector():getGameDB()
	local resource = gameDB:getResource(resourceName, "SailingItem")
	if resource then
		local record = gameDB:getRecord("SailingItemStats", { Resource = resource })
		if record then
			for i = 1, #ShipStatsBehavior.BASE_STATS do
				local stat = ShipStatsBehavior.BASE_STATS[i]
				local value = record:get(stat)

				stats[stat] = stats[stat] + value
			end
		end
	end

	local propResourceName = itemStorage:get("prop")
	if propResourceName then
		local propResource = gameDB:getResource(propResourceName, "Prop")
		if propResource then
			local cannonRecord = gameDB:getRecord("Cannon", { Resource = propResource })

			if cannonRecord then
				stats["OffenseRange"] = cannonRecord:get("Range")
				stats["OffenseMinDamage"] = cannonRecord:get("MinDamage")
				stats["OffenseMaxDamage"] = cannonRecord:get("MaxDamage")
			end
		end
	end
end

function Ship:onCustomize()
	for i = 1, #self.props do
		Utility.Peep.poof(self.props[i])
	end
	self.props = {}

	local director = self:getDirector()
	self.player = director:getGameInstance():getPlayer():getActor():getPeep()

	local storage = director:getPlayerStorage(self.player):getRoot()
	self:colorDeck(storage, Color(0.57, 0.40, 0.25))
	self:loadDecoration(storage, 'Hull', "Hull_Common", Color(0.57, 0.40, 0.25))
	self:loadDecoration(storage, 'Rigging', "Rigging_Common", Color(0.94, 0.90, 0.80))
	self:loadProp(storage, 'Sail', "Sailing_Player_CommonSail", 'Sail1', 'Sail2')
	self:loadProp(storage, 'Cannon', "Sailing_Player_IronCannon", 'Cannon1', 'Cannon2', 'Cannon3', 'Cannon4')
	self:loadProp(storage, 'Helm', "Sailing_Player_CommonHelm", 'Helm')

	local stats = self:getBehavior(ShipStatsBehavior).bonuses
	for stat in pairs(stats) do
		stats[stat] = 0
	end

	self:updateStats(storage, 'Hull', 'Hull_Common')
	self:updateStats(storage, 'Rigging', 'Rigging_Common')
	self:updateStats(storage, 'Helm', 'Helm_Common')
	self:updateStats(storage, 'Sail', 'Sail_Common')
	self:updateStats(storage, 'Cannon', 'Cannon_Iron')
	self:updateStats(storage, 'Storage', 'Storage_Crate')
	self:updateStats(storage, 'Figurehead', 'Figurehead_Common')
end

function Ship:getMaxHealth()
	return 200
end

return Ship
