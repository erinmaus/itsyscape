--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Boss.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"

local Boss = {}

function Boss.getBoss(target)
	local resource = Utility.Peep.getResource(target)

	local boss = resource and target:getDirector():getGameDB():getRecord("Boss", {
		Target = resource
	})

	return boss and boss:get("Boss")
end

function Boss.isBoss(target)
	return Boss.getBoss(target) ~= nil
end

function Boss.isLegendary(gameDB, itemID)
	local legendaryLootCategory = gameDB:getResource("Legendary", "LootCategory")
	local itemResource = gameDB:getResource(itemID, "Item")
	local isLegendary = gameDB:getRecord("LootCategory", {
		Item = itemResource,
		Category = legendaryLootCategory
	})

	return legendaryLootCategory and itemResource and isLegendary
end

function Boss.isSpecial(gameDB, itemID)
	local specialLootCategory = gameDB:getResource("Special", "LootCategory")
	local itemResource = gameDB:getResource(itemID, "Item")
	local isSpecial = gameDB:getRecord("LootCategory", {
		Item = itemResource,
		Category = specialLootCategory
	})

	return specialLootCategory and itemResource and isSpecial
end

function Boss.recordKill(peep, target)
	local boss = Boss.getBoss(target)
	if not boss then
		return
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)

	bossStorage:set("count", (bossStorage:get("count") or 0) + 1)
end

function Boss.recordDrop(peep, target, itemID, itemCount)
	local boss = Boss.getBoss(target)
	if not boss then
		return
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)
	local dropStorage = bossStorage:getSection("Drops"):getSection(itemID)

	dropStorage:set({ count = (dropStorage:get("count") or 0) + itemCount })
end

function Boss.getDrops(peep, boss)
	if type(boss) == 'string' then
		boss = peep:getDirector():getGameDB():getResource(boss, "Boss")
	end

	if not boss then
		return {}
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)
	return bossStorage:getSection("Drops"):get()
end

function Boss.getKillCount(peep, boss)
	if type(boss) == 'string' then
		boss = peep:getDirector():getGameDB():getResource(boss, "Boss")
	end

	if not boss then
		return 0
	end

	local storage = Utility.Peep.getStorage(peep):getSection("Bosses")
	local bossStorage = storage:getSection(boss.name)
	return bossStorage:get("count") or 0
end

return Boss
