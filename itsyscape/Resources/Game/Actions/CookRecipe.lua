--------------------------------------------------------------------------------
-- Resources/Game/Actions/CookRecipe.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Action = require "ItsyScape.Peep.Action"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local CookRecipe = Class(Action)
CookRecipe.SCOPES = { ['craft'] = true }
CookRecipe.FLAGS = { ['item-inventory'] = false }

function CookRecipe:perform(state, peep, recipe)
	local itemID = recipe:getItemID()
	if not itemID then
		Log.error("Recipe '%s' does not have output item ID.", recipe:getResource().name)
		return false
	end

	if not recipe:getIsReady() then
		Log.warn("Recipe '%s' is not ready.", recipe:getResource().name)
	end

	local items = recipe:getSlots()
	local itemManager = peep:getDirector():getItemManager()
	local itemBroker = peep:getDirector():getItemBroker()

	local userdata = {}
	do
		for i = 1, #items do
			local item, itemResource = items[i]
			if not item then
				Log.error("Recipe '%s' claimed to be ready, but is not ready.", recipe:getResource().name)
				return false
			else
				itemResource = self:getGameDB():getResource(item:getID(), "Item")
			end

			for key, otherUserdata in item:iterateUserdata() do
				local u = userdata[key] or itemManager:newUserdata(key)
				u:combine(otherUserdata)

				userdata[key] = u
			end

			if not item:hasUserdata("ItemIngredientsUserdata") then
				local ingredientName = Utility.Item.getInstanceName(item)

				local u = userdata["ItemIngredientsUserdata"] or itemManager:newUserdata("ItemIngredientsUserdata")
				u:addIngredient(ingredientName, 1)

				userdata["ItemIngredientsUserdata"] = u
			end

			local userdataTypes = self:getGameDB():getRecords("ItemUserdata", { Item = itemResource })
			for j = 1, #userdataTypes do
				local userdataType = userdataTypes[j]:get("Userdata").name
				local userdataRecords = self:getGameDB():getRecords(userdataType, {
					Resource = itemResource
				})

				for k = 1, #userdataRecords do
					local otherUserdata = itemManager:newUserdata(userdataType)
					otherUserdata:fromRecord(userdataRecords[k])

					local u = userdata[userdataType] or itemManager:newUserdata(userdataType)
					u:combine(otherUserdata)

					userdata[userdataType] = u
				end
			end
		end

		local outputItemResource = self:getGameDB():getResource(itemID, "Item")
		local userdataTypes = self:getGameDB():getRecords("ItemUserdata", { Item = outputItemResource })
		for j = 1, #userdataTypes do
			local userdataType = userdataTypes[j]:get("Userdata").name
			local userdataRecords = self:getGameDB():getRecords(userdataType, {
				Resource = itemResource
			})

			for k = 1, #userdataRecords do
				local otherUserdata = itemManager:newUserdata(userdataType)
				otherUserdata:fromRecord(userdataRecords[k])

				local u = userdata[userdataType] or itemManager:newUserdata(userdataType)
				u:combine(otherUserdata)

				userdata[userdataType] = u
			end
		end
	end

	for key, u in pairs(userdata) do
		userdata[key] = u:serialize()
	end

	local inventory = peep:getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		Log.warn("Peep '%s' does not have inventory.", peep:getName())
		return false
	end

	local transaction = itemBroker:createTransaction()
	do
		transaction:addParty(inventory)

		for i = 1, #items do
			transaction:consume(items[i], 1)
		end

		transaction:spawn(inventory, itemID, 1, false, true, false, userdata)
	end

	local success = transaction:commit()
	if success then
		for i = 1, #items do
			local resource = self:getGameDB():getResource(items[i]:getID(), "Item")
			local actions = Utility.getActions(self:getGame(), resource, 'craft')
			for i = 1, #actions do
				if actions[i].instance:is("CookIngredient") then
					actions[i].instance:transfer(state, peep, self.FLAGS, true)
				end
			end
		end

		self:transfer(state, peep, self.FLAGS, true)
	else
		Log.info("Could not make recipe '%s' for peep '%s'; not enough inventory space?", recipe:getResource().name, peep:getName())
	end

	return success
end

return CookRecipe
