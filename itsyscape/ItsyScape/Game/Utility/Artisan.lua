--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Artisan.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local ArtisanStationBehavior = require "ItsyScape.Peep.Behaviors.ArtisanStationBehavior"
local ActiveArtisanStationBehavior = require "ItsyScape.Peep.Behaviors.ActiveArtisanStationBehavior"

local Artisan = {}

function Artisan.setProperty(peep, property, value)
	if not peep then
		return false
	end

	if type(property) == "string" then
		local gameDB = peep:getDirector():getGameDB()
		property = gameDB:getResource(property, "ArtisanProperty")
	end

	if not property then
		return
	end

	local station = peep:getBehavior(ArtisanStationBehavior)
	if not station then
		return false
	end

	local name = property.name
	if not value or value <= 0 then
		station.properties[name] = nil
	else
		station.properties[name] = value
	end

	return true
end

function Artisan.removeProperty(peep, property, value)
	Artisan.setProperty(peep, property, 0)
end

function Artisan.giveProperty(peep, property, value)
	return Artisan.setProperty(peep, Artisan.countProperty(peep, property) + value)
end

function Artisan.takeProperty(peep, property, value)
	return Artisan.setProperty(peep, Artisan.countProperty(peep, property) - value)
end

function Artisan.countProperty(peep, property)
	if not peep then
		return 0
	end

	if type(property) == "string" then
		local gameDB = peep:getDirector():getGameDB()
		property = gameDB:getResource(property, "ArtisanProperty")
	end

	if not property then
		return
	end

	local station = peep:getBehavior(ArtisanStationBehavior)
	if not station then
		return 0
	end

	local name = property.name
	return station.properties[name] or 0
end

function Artisan.makeArtisanStation(peep)
	peep:addBehavior(ArtisanStationBehavior)
	peep:addPoke("craft")

	peep:listen("finalize", Artisan.Station.onFinalize)
end

Artisan.Peep = {}

function Artisan.Peep:onRemoveItem(e)
	local gameDB = self:getDirector():getGameDB()

	local items
	if e.action ~= "unnoteItem" then
		items = { e.item }
	else
		items = e.items
	end

	for _, item in ipairs(items) do
		local resource = gameDB:getRecord(e.item:getID(), "Item")
		if resource then
			local properties = gameDB:getRecords("ArtisanProperty", {
				Resource = resource
			})

			for _, property in ipairs(properties) do
				local count = property:get("Count")
				if count >= 1 and count < math.huge then
					Artisan.takeProperty(self, property:get("Property"), count)
				end
			end
		end
	end
end

function Artisan.Peep:onAddItem(e)
	local gameDB = self:getDirector():getGameDB()

	local items
	if e.action ~= "noteItem" then
		items = { e.item }
	else
		items = e.items
	end

	for _, item in ipairs(items) do
		local resource = gameDB:getRecord(e.item:getID(), "Item")
		if resource then
			local properties = gameDB:getRecords("ArtisanProperty", {
				Resource = resource
			})

			for _, property in ipairs(properties) do
				local count = property:get("Count")
				if count >= 1 and count < math.huge then
					Artisan.giveProperty(self, property:get("Property"), count)
				end
			end
		end
	end
end

function Artisan.makeArtisan(peep)
	peep:addBehavior(ArtisanStationBehavior)

	peep:listen("consumeItem", Artisan.Peep.onRemoveItem)
	peep:listen("destroyItem", Artisan.Peep.onRemoveItem)
	peep:listen("noteItem", Artisan.Peep.onRemoveItem)
	peep:listen("unnoteItem", Artisan.Peep.onRemoveItem)
	peep:listen("spawnItem", Artisan.Peep.onAddItem)
	peep:listen("transferItemTo", Artisan.Peep.onAddItem)
	peep:listen("transferItemFrom", Artisan.Peep.onRemoveItem)
end

Artisan.Station = {}

local function _populateArtisanProperties(self, resource)
	if not resource then
		return
	end

	local gameDB = self:getDirector():getGameDB()
	local records = gameDB:getRecords("ArtisanProperty", {
		Resource = resource
	})

	for _, record in ipairs(records) do
		Artisan.setProperty(self, record:get("Property"), record:get("Count"))
	end
end

function Artisan.Station:onFinalize()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	_populateArtisanProperties(self, resource)
	_populateArtisanProperties(self, mapObject)
end

return Artisan
