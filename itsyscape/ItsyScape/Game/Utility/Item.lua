--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Item.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local EquipmentInventoryProvider = require "ItsyScape.Game.EquipmentInventoryProvider"
local Utility = require "ItsyScape.Game.Utility"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Item = {}

function Item._pullActions(game, item, scope)
	if item:isNoted() then
		return {}
	end

	local result = {}

	local gameDB = game:getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if itemResource then
		table.insert(result, Utility.getActions(game, itemResource, scope, true))
	end

	return result
end

function Item.pull(peep, item, scope)
	return {
		ref = item:getRef(),
		id = item:getID(),
		count = item:getCount(),
		noted = item:isNoted(),
		name = Item.getInstanceName(item),
		description = Item.getInstanceDescription(item),
		stats = Item.getInstanceStats(item, peep),
		slot = Item.getSlot(item),
		actions = peep and Item._pullActions(peep:getDirector():getGameInstance(), item, scope) or {}
	}
end

function Item.getStorage(peep, tag, clear, player)
	local director = peep:getDirector()
	local gameDB = director:getGameDB()

	local storage = Utility.Peep.getStorage(peep, player)
	if storage then
		if clear then
			storage:getSection("Inventory"):removeSection(tag)
		end

		return storage:getSection("Inventory"):getSection(tag)
	end

	return nil
end

-- Gets the shorthand count and color for 'count' using 'lang'.
--
-- 'lang' defaults to "en-US".
--
-- Values
--  * Under 10,000 remain as-is.
--  * Up to 100,000 (exclusive) is divided by 10,000 and suffixed is with a 'k' specifier.
--  * Up to a million are divided by 100,000 and suffixed with a 'k' specifier.
--  * Up to a billion are divided by the same and suffixed with an 'm' specifier.
--  * Up to a trillion are divided by the same and suffixed with an 'b' specifier.
--  * Up to a quadrillion are divided by the same and suffixed with an 'q' specifier.
--
-- Values are floored. Thus 100,999 becomes '100k' (or whatever it may be in
-- 'lang').
function Item.getItemCountShorthand(count, lang)
	lang = lang or "en-US"
	-- 'lang' is NYI.

	local TEN_THOUSAND     = 10000
	local HUNDRED_THOUSAND = 100000
	local MILLION          = 1000000
	local BILLION          = 1000000000
	local TRILLION         = 1000000000000
	local QUADRILLION      = 1000000000000000

	local text, color
	if count >= QUADRILLION then
		text = string.format("%dq", count / QUADRILLION)
		color = { 1, 0, 1, 1 }
	elseif count >= TRILLION then
		text = string.format("%dt", count / TRILLION)
		color = { 0, 1, 1, 1 }
	elseif count >= BILLION then
		text = string.format("%db", count / BILLION)
		color = { 1, 0.5, 0, 1 }
	elseif count >= MILLION then
		text = string.format("%dm", count / MILLION)
		color = { 0, 1, 0.5, 1 }
	elseif count >= HUNDRED_THOUSAND then
		text = string.format("%dk", count / HUNDRED_THOUSAND * 100)
		color = { 1, 1, 1, 1 }
	elseif count >= TEN_THOUSAND then
		text = string.format("%dk", count / TEN_THOUSAND * 10)
		color = { 1, 1, 0, 1 }
	else
		text = string.format("%d", count)
		color = { 1, 1, 0, 1 }
	end

	return text, color
end

function Item.parseItemCountInput(value)
	value = value:gsub("%s*(.*)%s*", "%1"):gsub(",", ""):lower()

	local num, modifier = value:match("^(%d*)([kmbq]?)$")
	if num then
		num = tonumber(num)
		if modifier then
			if modifier == 'k' then
				num = num * 100
			elseif modifier == 'm' then
				num = num * 1000000
			elseif modifier == 'b' then
				num = num * 1000000000
			elseif modifier == 'q' then
				num = num * 1000000000000
			end
		end

		return true, num
	end

	return false, 0
end

function Item.getName(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecord("ResourceName", { Resource = itemResource, Language = lang }, 1)
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Item.getDescription(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	local nameRecord = gameDB:getRecord("ResourceDescription", { Resource = itemResource, Language = lang })
	if nameRecord then
		return nameRecord:get("Value")
	else
		return false
	end
end

function Item.getUserdataHints(id, gameDB, lang)
	lang = lang or "en-US"

	local itemResource = gameDB:getResource(id, "Item")
	if not itemResource then
		return {}
	end

	local result = {}
	local userdataTypes = gameDB:getRecords("ItemUserdata", { Item = itemResource })
	for _, userdataType in ipairs(userdataTypes) do
		local hint = gameDB:getRecord("UserdataHint", { Userdata = userdataType:get("Userdata"), Language = lang })
		if hint then
			hint = hint:get("Value")
		else
			hint = "*" .. userdataType:get("Userdata").name
		end

		table.insert(result, hint)
	end

	return result
end

function Item.getInstanceName(instance, lang)
	lang = lang or "en-US"

	local gameDB = instance:getManager():getGameDB()
	local itemResource = gameDB:getResource(instance:getID(), "Item")
	if not itemResource then
		return "*" .. instance:getID()
	end

	local nameRecord = gameDB:getRecord("ResourceName", { Resource = itemResource, Language = lang }, 1)
	if nameRecord then
		return nameRecord:get("Value")
	else
		return "*" .. instance:getID()
	end
end

function Item.getInstanceDescription(instance, lang)
	lang = lang or "en-US"

	local baseDescription
	do
		local gameDB = instance:getManager():getGameDB()
		local itemResource = gameDB:getResource(instance:getID(), "Item")
		local descriptionRecord = gameDB:getRecord("ResourceDescription", { Resource = itemResource, Language = lang })
		if itemResource and descriptionRecord then
			baseDescription = descriptionRecord:get("Value")
		else
			baseDescription = string.format("It's %s, as if you didn't know.", Item.getInstanceName(instance))
		end
	end

	local userdata = {}
	for name in instance:iterateUserdata() do
		table.insert(userdata, name)
	end
	table.sort(userdata)

	local result = {}
	for i = 1, #userdata do
		local description = instance:getUserdata(userdata[i]):getDescription()
		if description then
			table.insert(result, description)
		end
	end

	table.insert(result, 1, baseDescription)

	return table.concat(result, "\n")
end

function Item.getStats(id, gameDB)
	local itemResource = gameDB:getResource(id, "Item")
	local statsRecord = gameDB:getRecord("Equipment", { Resource = itemResource })

	if statsRecord then
		local stats = {}
		for i = 1, #EquipmentInventoryProvider.STATS do
			local statName = EquipmentInventoryProvider.STATS[i]
			local statValue = statsRecord:get(statName)
			if statValue ~= 0 then
				table.insert(stats, { name = statName, value = statValue })
			end
		end

		return stats
	end

	return nil
end

function Item.getSlot(item)
	local gameDB = item:getManager():getGameDB()
	local itemResource = gameDB:getResource(item:getID(), "Item")
	if not itemResource then
		return nil
	end

	local equipmentRecord = gameDB:getRecord("Equipment", { Resource = itemResource })
	if not equipmentRecord then
		return nil
	end

	return equipmentRecord:get("EquipSlot")
end

function Item.getInstanceStats(item, peep)
	local baseStats = Item.getStats(item:getID(), item:getManager():getGameDB())

	local calculatedStats
	do
		local logic = item:getManager():getLogic(item:getID())
		if peep and logic and Class.isCompatibleType(logic, require "ItsyScape.Game.Equipment") then
			calculatedStats = logic:getCalculatedBonuses(peep, item)
		else
			calculatedStats = {}
		end
	end

	for stat, value in pairs(calculatedStats) do
		local found = false
		for _, baseStat in ipairs(baseStats) do
			if baseStat.name == stat then
				baseStat.value = baseStat.value + value
				found = true
				break
			end
		end

		if not found then
			table.insert(baseStats, { name = stat, value = value })
		end
	end

	return baseStats
end

function Item.getInfo(id, gameDB, lang)
	lang = lang or "en-US"

	name = Item.getName(id, gameDB, lang)
	if not name then
		name = "*" .. id
	end

	description = Item.getDescription(id, gameDB, lang)
	if not description then
		description = string.format("It's %s, as if you didn't know.", object)
	end

	stats = Item.getStats(id, gameDB)

	return name, description, stats
end

function Item.groupStats(stats)
	local offensive, defensive, other = {}, {}, {}
	for i = 1, #stats do
		local stat = stats[i]

		if Equipment.OFFENSIVE_STATS[stat.name] then
			table.insert(offensive, stat)
			stat.niceName = Equipment.OFFENSIVE_STATS[stat.name]
		elseif Equipment.DEFENSIVE_STATS[stat.name] then
			table.insert(defensive, stat)
			stat.niceName = Equipment.DEFENSIVE_STATS[stat.name]
		else
			table.insert(other, stat)
			stat.niceName = Equipment.MISC_STATS[stat.name] or stat.name
		end
	end

	return {
		offensive = offensive,
		defensive = defensive,
		other = other
	}
end

function Item.spawnInPeepInventory(peep, item, quantity, noted, userdata)
	local flags = { ['item-inventory'] = true }

	if noted then
		flags['item-noted'] = true
	end

	if userdata then
		flags['item-userdata'] = userdata
	end

	return peep:getState():give("Item", item, quantity, flags)
end

function Item.getItemInPeepInventory(peep, itemID)
	return Item.getItemsInPeepInventory(peep, itemID)[1]
end

function Item.getItemsInPeepInventory(peep, itemID)
	local inventory = peep:getBehavior(InventoryBehavior)
	inventory = inventory and inventory.inventory

	if not inventory then
		return {}
	end

	local result = {}
	for item in inventory:getBroker():iterateItems(inventory) do
		if type(itemID) == "string" and item:getID() == itemID then
			table.insert(result, item)
		elseif type(itemID) == "table" or type(itemID) == "function" and itemID(item) then
			table.insert(result, item)
		elseif itemID == nil then
			table.insert(result, item)
		end
	end

	return result
end

return Item
