--------------------------------------------------------------------------------
-- Resources/Game/Actions/Fire.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local Action = require "ItsyScape.Peep.Action"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local Fire = Class(Action)
Fire.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Fire.FLAGS = { ['item-inventory'] = true, ['item-equipment'] = true }
Fire.DURATION = 0.5

function Fire:perform(state, player, target, item)
	local gameDB = self:getGameDB()

	if target and self:canPerform(state) and self:canTransfer(state) then
		local i, j, k = Utility.Peep.getTileAnchor(target)

		local walk = Utility.Peep.getWalk(player, i, j, k, 2, { asCloseAsPossible = true })

		local health = target:getBehavior(PropResourceHealthBehavior)
		if not health then
			return false
		end

		if health.currentProgress ~= health.maxProgress then
			return false
		end

		local cannonResource = Utility.Peep.getResource(target)
		if not cannonResource then
			Log.warn("Cannon '%s' doesn't have a resource.", target:getName())
			return false
		end

		local cannonMeta = gameDB:getRecord("Cannon", {
			Resource = cannonResource
		})

		if not cannonMeta then
			Log.warn("Cannon %s (resource = %s) isn't a cannon!", target:getName(), cannonResource.name)
			return false
		end

		if not item then
			local items = Utility.Item.getItemsInPeepInventory(player, function(i)
				local itemResource = gameDB:getResource(i:getID(), "Item")
				if itemResource then
					local q = {
						AmmoType = cannonMeta:get("AmmoType") ~= Equipment.AMMO_ANY and cannonMeta:get("AmmoType") or nil,
						Resource = itemResource
					}

					local cannonballAmmo = gameDB:getRecord("CannonAmmo", q)

					if cannonballAmmo then
						return true
					end
				end

				return false
			end)

			local canUseItem = {}
			local itemBonus = {}
			local hits = {}
			for index, i in ipairs(items) do
				if not hits[i:getID()] then
					hits[i:getID()] = true

					local itemResource = gameDB:getResource(i:getID(), "Item")
					do
						local actions = Utility.getActions(self:getGame(), itemResource, 'sailing')

						local usable = true
						for j = 1, #actions do
							if actions[j].instance:is("SailingUnlock") then
								if not actions[j].instance:canPerform(player:getState(), nil, true) then
									usable = false
									break
								end
							end
						end

						if usable then
							Log.info("Peep '%s' can use ammo '%s' in their inventory.", player:getName(), i:getID())
						else
							Log.info("Peep '%s' CANNOT use ammo '%s' in their inventory.", player:getName(), i:getID())
						end

						canUseItem[i:getID()] = usable
					end

					local equipment = gameDB:getRecord("Equipment", {
						Resource = itemResource
					})

					if equipment then
						itemBonus[i:getID()] = equipment:get("StrengthSailing")
					else
						Log.info("Ammo '%s' has no bonuses, not usable.", i:getID())
						canUseItem[i:getID()] = false
					end
				end
			end

			for i = #items, 1, -1 do
				if not canUseItem[items[i]:getID()] then
					table.remove(items, i)
				end
			end

			table.sort(items, function(a, b)
				return itemBonus[a:getID()] > itemBonus[b:getID()]
			end)

			item = items[1]
		end

		if not item then
			Log.info("Peep '%s' has no cannonballs they can use.", player:getName())
			return false
		end

		do
			local itemResource = gameDB:getResource(item:getID(), "Item")
			if not itemResource then
				Log.info("Item '%s' isn't a valid item in GameDB!", item:getID())
				return false
			end

			local actions = Utility.getActions(self:getGame(), itemResource, 'sailing')		
			for i = 1, #actions do
				if actions[i].instance:is("SailingUnlock") then
					if not actions[i].instance:canPerform(player:getState()) then
						Log.info("Peep '%s' cannot use ammo '%s'.", player:getName(), itemResource.name)
						break
					end
				end
			end

			local ammo = gameDB:getRecord("CannonAmmo", {
				Resource = itemResource
			})

			if ammo:get("AmmoType") ~= cannonMeta:get("AmmoType") and cannonMeta:get("AmmoType") ~= Equipment.AMMO_ANY and ammo:get("AmmoType") ~= Equipment.AMMO_ANY then
				Log.warn("Incompatible ammo for cannon.")
				return false
			end
		end

		if walk then
			local transfer = CallbackCommand(self.transfer, self, state, player)
			local wait = WaitCommand(Fire.DURATION, false)
			local fire = CallbackCommand(target.poke, target, 'fire', player, item)
			local perform = CallbackCommand(Action.perform, self, state, player)
			local take = CallbackCommand(self.takeCannonball, self, player, item)
			local command = CompositeCommand(true, walk, wait, transfer, perform, take, fire)

			local queue = player:getCommandQueue()
			return queue:interrupt(command)
		end
	end

	return false
end

function Fire:takeCannonball(player, item)
	local flags = { ['item-inventory'] = true, ['item-instances'] = { item } }
	if not player:getState():take("Item", item:getID(), 1, flags) then
		Log.info("Player '%s' doesn't have cannonball '%s' anymore.", player:getName(), item:getID())
		player:getCommandQueue():clear()
	end
end

Fire.AMMO_TYPE = {
	[Equipment.AMMO_ARROW] = "IronArrow",
	[Equipment.AMMO_BOLT] = "IronBolt",
	[Equipment.AMMO_THROWN] = "IronThrowingKnife",
	[Equipment.AMMO_CANNONBALL] = "IronCannonball"
}

function Fire:getFailureReason(state, player, target)
	local reason = Action.getFailureReason(self, state, player)

	local cannonResource = Utility.Peep.getResource(target)
	if cannonResource then
		local gameDB = self:getGameDB()
		local cannonMeta = gameDB:getRecord("Cannon", {
			Resource = cannonResource
		})

		if cannonMeta then
			local item = self.AMMO_TYPE[cannonMeta:get("AmmoType")]

			if item then
				table.insert(reason.requirements, {
					type = "Item",
					resource = item,
					name = "Proper ammo (any kind you can use)",
					count = 1
				})
			end
		end
	end

	return reason
end

return Fire
