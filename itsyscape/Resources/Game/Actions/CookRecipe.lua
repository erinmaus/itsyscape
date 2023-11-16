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
CookRecipe.FLAGS = { ['item-inventory'] = true, ['item-ignore'] = true }

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
				Log.info("Getting userdata '%s' from item '%s'.", key, item:getID())
				u:combine(otherUserdata)

				userdata[key] = u
			end

			if not item:hasUserdata("ItemIngredientsUserdata") then
				local ingredientName = Utility.Item.getInstanceName(item)
				Log.info("Adding item '%s' as ingredient.", item:getID())

				local u = userdata["ItemIngredientsUserdata"] or itemManager:newUserdata("ItemIngredientsUserdata")
				u:addIngredient(itemResource.name, ingredientName, 1)

				userdata["ItemIngredientsUserdata"] = u
			end

			-- We don't want to redupe userdata for recipe items.
			if not item:hasUserdata() then
				Log.info("Item '%s' has no userdata in instance; pulling userdata from GameDB.", item:getID())

				local userdataTypes = self:getGameDB():getRecords("ItemUserdata", { Item = itemResource })
				for j = 1, #userdataTypes do
					local userdataType = userdataTypes[j]:get("Userdata").name
					local userdataRecords = self:getGameDB():getRecords(userdataType, {
						Resource = itemResource
					})

					for k = 1, #userdataRecords do
						Log.info("Adding userdata '%s' from item '%s' (%d of %d).", userdataType, item:getID(), k, #userdataRecords)

						local otherUserdata = itemManager:newUserdata(userdataType)
						otherUserdata:fromRecord(userdataRecords[k])

						local u = userdata[userdataType] or itemManager:newUserdata(userdataType)
						u:combine(otherUserdata)

						userdata[userdataType] = u
					end
				end
			end
		end

		local outputItemResource = self:getGameDB():getResource(itemID, "Item")
		local userdataTypes = self:getGameDB():getRecords("ItemUserdata", { Item = outputItemResource })
		for j = 1, #userdataTypes do
			local userdataType = userdataTypes[j]:get("Userdata").name
			local userdataRecords = self:getGameDB():getRecords(userdataType, {
				Resource = outputItemResource
			})

			for k = 1, #userdataRecords do
				Log.info("Adding output userdata '%s' from item '%s' (%d of %d).", userdataType, outputItemResource.name, k, #userdataRecords)
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
			for j = 1, #actions do
				if actions[j].instance:is("CookIngredient") then
					actions[j].instance:transfer(state, peep, self.FLAGS, true)
				end
			end
		end

		local resultItemInstance
		for _, item in transaction:iterateItems() do
			if itemBroker:hasItem(item) and item:getID() == itemID then
				if resultItemInstance then
					Log.warn("Recipe output '%s' (ref = %d) was found again with another, different item (ref = %d) in broker.", itemID, resultItemInstance:getRef(), item:getRef())
				end

				resultItemInstance = item
			end
		end

		if not resultItemInstance then
			Log.warn("Couldn't find output item '%s' from cooking recipe.", item:getID())
		else
			recipe:setResult(resultItemInstance)
		end

		self:transfer(state, peep, self.FLAGS, true)
	else
		Log.info("Could not make recipe '%s' for peep '%s'; not enough inventory space?", recipe:getResource().name, peep:getName())
	end

	return success
end

return CookRecipe
