--------------------------------------------------------------------------------
-- Resources/Game/Actions/Eat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Action = require "ItsyScape.Peep.Action"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Eat = Class(Action)
Eat.SCOPES = { ['inventory'] = true }

function Eat:canPerform(state)
	return Action.canPerform(self, state, { ["item-inventory"] = true })
end

function Eat:perform(state, peep, item)
	if not self:canPerform(state) then
		return false
	end

	local director = peep:getDirector()
	local inventory = peep:getBehavior(InventoryBehavior)
	if not inventory or not inventory.inventory then
		return false, "no inventory"
	else
		inventory = inventory.inventory
	end

	local broker = director:getItemBroker()
	local transaction = broker:createTransaction()
	transaction:addParty(inventory)
	transaction:consume(item, 1)
	do
		local gameDB = self:getGameDB()
		local healingPower = gameDB:getRecord("HealingPower", { Action = self:getAction() })
		if healingPower then
			local hitPoints = healingPower:get("HitPoints")

			if hitPoints < 0 then
				peep:poke('hit', AttackPoke({
					weaponType = 'item',
					damage = math.abs(hitPoints)
				}))
			else
				peep:poke('heal', { item = item, hitPoints = hitPoints })
			end
		end
	end

	local s, r = transaction:commit()
	if not s then
		io.stderr:write("error: ", r, "\n")
		return false, "transaction failed"
	end

	Action.perform(self, state, peep)
	return true
end

return Eat
