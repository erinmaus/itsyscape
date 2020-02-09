--------------------------------------------------------------------------------
-- ItsyScape/Game/SailingItemStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local StateProvider = require "ItsyScape.Game.StateProvider"

local SailingItemStateProvider = Class(StateProvider)

function SailingItemStateProvider:new(peep)
	local director = peep:getDirector()
	local storage = director:getPlayerStorage(peep)

	self.storage = storage:getRoot():getSection("Player"):getSection("SailingItems")
	self.peep = peep
end

function SailingItemStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

function SailingItemStateProvider:has(name, count, flags)
	return (count or 1) <= self:count(name, flags)
end

function SailingItemStateProvider:take(name, count, flags)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "SailingItem")
	if not resource then
		return false
	end

	self.storage:set(name, nil)
end

function SailingItemStateProvider:give(name, count, flags)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "SailingItem")
	if not resource then
		return false
	end

	if not self.storage:get(name) then
		Log.analytic("PLAYER_GOT_SAILING_ITEM", name)
	end

	self.storage:set(name, true)
	return true
end

function SailingItemStateProvider:count(name, flags)
	if self.storage:get(name) == true then
		return math.huge
	else
		return 0
	end
end

return SailingItemStateProvider
