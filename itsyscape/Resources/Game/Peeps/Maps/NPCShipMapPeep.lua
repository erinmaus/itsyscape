--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/NPCShipMapPeep.lua
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

function Ship:loadDecoration(sailingItem, defaultProp, defaultColor)
	local propResourceName
	do
		local gameDB = self:getDirector():getGameDB()
		local sailingItemDetails = gameDB:getRecord("SailingItemDetails", {
			Resource = sailingItem:get("SailingItem")
		})

		if not sailingItemDetails then
			Log.warn(
				"No sailing item details for '%s'.",
				sailingItem:get("SailingItem").name)
			propResourceName = defaultProp
		else
			propResourceName = sailingItemDetails:get("Prop")
		end
	end

	local group = "Resources/Game/SailingItems/" .. propResourceName .. "/Decoration.ldeco"
	local lazyDecoration = Decoration(group)

	local color
	do
		local r, g, b
		if sailingItem:get("IsColorCustomized") ~= 0 then
			r = sailingItem:get("Red1") / 255
			g = sailingItem:get("Green1") / 255
			b = sailingItem:get("Blue1") / 255
		else
			r = defaultColor.r
			g = defaultColor.g
			b = defaultColor.b
		end

		color = Color(r, g, b)
		print('s', sailingItem:get("IsColorCustomized"))
	end

	for feature in lazyDecoration:iterate() do
		if not feature:getID():match("XOpaque") then
			feature:setColor(color)
		end
	end

	local stage = self:getDirector():getGameInstance():getStage()
	stage:decorate(propResourceName, lazyDecoration, self:getLayer())
end

function Ship:colorDeck(sailingItem, defaultColor)
	local r, g, b
	if sailingItem:get("IsColorCustomized") ~= 0 then
		r = sailingItem:get("Red2") / 255
		g = sailingItem:get("Green2") / 255
		b = sailingItem:get("Blue2") / 255
	else
		r = defaultColor.r
		g = defaultColor.g
		b = defaultColor.b
	end

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

function Ship:loadProp(sailingItem, item, defaultItem, ...)
	local anchors = { n = select('#', ...), ... }

	local propResourceName
	do
		local gameDB = self:getDirector():getGameDB()
		local sailingItemDetails = gameDB:getRecord("SailingItemDetails", {
			Resource = sailingItem:get("SailingItem")
		})

		if not sailingItemDetails then
			Log.warn(
				"No sailing item details for '%s'.",
				sailingItem:get("SailingItem").name)
			propResourceName = defaultItem
		else
			propResourceName = sailingItemDetails:get("Prop")
		end
	end

	local color1, color2
	do
		if sailingItem:get("IsColorCustomized") ~= 0 then
			color1 = Color(
				sailingItem:get("Red1") / 255,
				sailingItem:get("Green1") / 255,
				sailingItem:get("Blue1") / 255)
			color2 = Color(
				sailingItem:get("Red2") / 255,
				sailingItem:get("Green2") / 255,
				sailingItem:get("Blue2") / 255)
		else
			color1 = Color(1, 0, 0)
			color2 = Color(1, 0, 0)
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
			else
				Log.warn("Couldn't spawn prop '%s' for slot '%s'.", propResourceName, item)
			end	
		end
	end
end

function Ship:onLoad(...)
	Map.onLoad(self, ...)

	self:onCustomize()
end

function Ship:updateStats(sailingItem, defaultResource)
	local stats = self:getBehavior(ShipStatsBehavior).bonuses

	local gameDB = self:getDirector():getGameDB()
	local resource = gameDB:getResource(sailingItem:get("SailingItem").name, "SailingItem")
	if resource then
		local record = gameDB:getRecord("SailingItemStats", {
			Resource = sailingItem:get("SailingItem")
		})

		if record then
			for i = 1, #ShipStatsBehavior.BASE_STATS do
				local stat = ShipStatsBehavior.BASE_STATS[i]
				local value = record:get(stat)

				stats[stat] = stats[stat] + value
			end
		end
	end

	local propResourceName
	do
		local gameDB = self:getDirector():getGameDB()
		local sailingItemDetails = gameDB:getRecord("SailingItemDetails", {
			Resource = sailingItem:get("SailingItem")
		})

		if sailingItemDetails then
			propResourceName = sailingItemDetails:get("Prop")
		end
	end

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

Ship.PART_TYPE_DECO = 1
Ship.PART_TYPE_PROP = 2
Ship.PART_TYPE_HULL = 3

Ship.DEFAULTS = {
	['Hull'] = {
		prop = "Hull_Common",
		colorHull = Color(0.57, 0.40, 0.25),
		colorDeck = Color(0.57, 0.40, 0.25),
		type = Ship.PART_TYPE_HULL
	},
	['Rigging'] = {
		prop = "Rigging_Common",
		color = Color(0.94, 0.90, 0.80),
		type = Ship.PART_TYPE_DECO
	},
	['Sail'] = {
		prop = "Sailing_Player_CommonSail",
		anchors = { 'Sail1', 'Sail2' },
		type = Ship.PART_TYPE_PROP
	},
	['Cannon'] = {
		prop = "Sailing_Player_IronCannon",
		anchors = { 'Cannon1', 'Cannon2', 'Cannon3', 'Cannon4' },
		type = Ship.PART_TYPE_PROP
	},
	['Helm'] = {
		prop = "Sailing_Player_CommonHelm",
		anchors = { 'Helm' },
		type = Ship.PART_TYPE_PROP
	},
	['Figurehead'] = {
		prop = "Figurehead_Common",
		anchors = { 'Figurehead' },
		type = Ship.PART_TYPE_PROP
	}
}

function Ship:onCustomize(ship)
	for i = 1, #self.props do
		Utility.Peep.poof(self.props[i])
	end
	self.props = {}

	local gameDB = self:getDirector():getGameDB()
	local items = gameDB:getRecords("ShipSailingItem", {
		Ship = ship
	})

	local stats = self:getBehavior(ShipStatsBehavior).bonuses
	for stat in pairs(stats) do
		stats[stat] = 0
	end

	for i = 1, #items do
		local item = items[i]

		local sailingItemDetails = gameDB:getRecord("SailingItemDetails", {
			Resource = item:get("SailingItem")
		})

		if not sailingItemDetails then
			Log.warn("Ship item %s does not have details.", items[i]:get("SailingItem").name)
		else
			local group = sailingItemDetails:get("ItemGroup")
			local default = Ship.DEFAULTS[group]
			if not default then
				Log.warn("No defaults for slot %s.", group)
			else
				if default.type == Ship.PART_TYPE_HULL then
					self:colorDeck(item, default.colorDeck)
					self:loadDecoration(item, group, default.prop, default.colorHull)
				elseif default.type == Ship.PART_TYPE_DECO then
					self:loadDecoration(item, group, default.prop, default.color)
				elseif default.type == Ship.PART_TYPE_PROP then
					self:loadProp(item, group, default.prop, unpack(default.anchors))
				end

				self:updateStats(item, group, default.prop)
			end
		end
	end
end

function Ship:getMaxHealth()
	return 200
end

return Ship
