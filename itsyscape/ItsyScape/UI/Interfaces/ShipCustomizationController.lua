--------------------------------------------------------------------------------
-- ItsyScape/UI/ShipCustomizationController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local ShipCustomizationController = Class(Controller)
ShipCustomizationController.COLOR_CHANNELS = {
	["red1"] = true,
	["green1"] = true,
	["blue1"] = true,
	["red2"] = true,
	["green2"] = true,
	["blue2"] = true
}

function ShipCustomizationController:new(peep, director)
	Controller.new(self, peep, director)

	self.storage = director:getPlayerStorage(peep):getRoot():getSection("Ship")

	self:refreshState()
	self:refreshCurrentItems()
end

function ShipCustomizationController:refreshState()
	self.state = { tabs = {}, items = {}, current = {} }
	self.actions = {}

	local director = self:getDirector()
	local gameDB = director:getGameDB()
	local parts = gameDB:getRecords("SailingItemGroupNameDescription", {
		Language = "en-US"
	})

	for i = 1, #parts do
		local part = parts[i]
		local name, description, item = part:get("Name"), part:get("Description"), part:get("ItemGroup")

		table.insert(self.state.tabs, {
			name = name,
			description = description,
			item = item
		})

		local items = {}
		do
			local itemRecords
			do
				local query
				if _DEBUG then
					query = { ItemGroup = item }
				else
					query = { ItemGroup = item, IsPirate = 0 }
				end

				itemRecords = gameDB:getRecords("SailingItemDetails", query)
			end

			for j = 1, #itemRecords do
				local resource = itemRecords[j]:get("Resource")
				local hasItemUnlocked = self:getPeep():getState():has('SailingItem', resource.name)

				local action
				do
					local actions = Utility.getActions(director:getGameInstance(), resource, 'sailing')
					for k = 1, #actions do
						if actions[k].instance:is('SailingBuy') or actions[k].instance:is('SailingUnlock') then
							action = actions[k].instance
							break
						end
					end
				end

				if action then
					local constraints = Utility.getActionConstraints(
						director:getGameInstance(),
						action:getAction())

					table.insert(items, {
						category = item,
						resource = resource.name,
						name = Utility.getName(resource, gameDB),
						description = Utility.getDescription(resource, gameDB, nil, 1),
						constraints = constraints,
						unlocked = hasItemUnlocked,
						purchasable = action:is('SailingBuy') or _DEBUG
					})

					self.actions[resource.name] = {
						resource = resource,
						action = action,
						info = items[#items]
					}
				end
			end
		end

		self.state.items[item] = items
	end
end

function ShipCustomizationController:refreshCurrentItems()
	local tabs = self.state.tabs
	local current = self.state.current
	for i = 1, #tabs do
		local item = tabs[i].item
		local section = self.storage:getSection(item)
		current[item] = {
			prop = section:get("prop"),
			resource = section:get("resource"),
			primary = {
				red = section:get("red1") or 1,
				green = section:get("green1") or 1,
				blue = section:get("blue1") or 1
			},
			accent = {
				red = section:get("red1") or 1,
				green = section:get("green2") or 1,
				blue = section:get("blue2") or 1
			}
		}
	end
end

function ShipCustomizationController:poke(actionID, actionIndex, e)
	if actionID == "activate" then
		self:activate(e)
	elseif actionID == "buy" then
		self:buy(e)
	elseif actionID == "changeColorComponent" then
		self:changeColorComponent(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function ShipCustomizationController:getShipPeep()
	local hits = self:getDirector():probe(self:getPeep():getLayerName(), function(peep)
		return peep:isCompatibleType(require "Resources.Game.Peeps.Maps.PlayerShipMapPeep")
	end)

	return hits[1]
end

function ShipCustomizationController:changeColorComponent(e)
	assert(type(e.color) == 'string', "color must be string")
	assert(ShipCustomizationController.COLOR_CHANNELS[e.color], "color must be a valid channel / index")
	assert(e.value >= 0 and e.value <= 1, "value out of range of [0, 1]")
	assert(type(e.item) == 'string', "item group must be string")
	assert(self.state.current[e.item], "item group must exist")

	local itemStorage = self.storage:get(e.item)
	itemStorage:set(e.color, e.value)

	self:refreshCurrentItems()

	local ship = self:getShipPeep()
	if ship then
		ship:poke('customize')
	end
end

function ShipCustomizationController:buy(e)
	assert(type(e.resource) == 'string', "resource must be string")
	assert(self.actions[e.resource], "resource not found")
	assert(self.actions[e.resource].action:is('SailingBuy') or _DEBUG, "resource not purchasable")

	local resource = self.actions[e.resource].resource
	local action = self.actions[e.resource].action
	local itemInfo = self.actions[e.resource].info

	local success = itemInfo.unlocked or Utility.performAction(
		self:getGame(),
		resource,
		action:getAction().id.value,
		'sailing',
		self:getPeep():getState(), self:getPeep())
	if success then
		itemInfo.unlocked = true
	end

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"onBought",
		nil,
		{ success, resource.name })
end

function ShipCustomizationController:activate(e)
	assert(type(e.resource) == 'string', "resource must be string")
	assert(self.actions[e.resource], "resource not found")

	local resource = self.actions[e.resource].resource
	local itemInfo = self.actions[e.resource].info

	local prop
	do
		local gameDB = self:getDirector():getGameDB()
		local record = gameDB:getRecord("SailingItemDetails", { Resource = resource })
		if record then
			prop = record:get("Prop")
		end
	end

	local itemStorage = self.storage:getSection(itemInfo.category)
	itemStorage:set("prop", prop)
	itemStorage:set("resource", resource.name)

	self:refreshCurrentItems()

	self:getDirector():getGameInstance():getUI():sendPoke(
		self,
		"onActivated",
		nil,
		{ true, resource.name })
end

function ShipCustomizationController:pull()
	local shipStats = {}
	local shipLayer
	do
		local shipPeep = self:getShipPeep()
		if shipPeep then
			shipLayer = shipPeep:getLayer()

			local stats = shipPeep:getBehavior(ShipStatsBehavior)
			if stats then
				stats = stats.bonuses
				for stat, value in pairs(stats) do
					shipStats[stat] = value
				end
			end
		end
	end

	self.state.layer = shipLayer
	self.state.stats = shipStats

	return self.state
end

return ShipCustomizationController
