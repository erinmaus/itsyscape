--------------------------------------------------------------------------------
-- ItsyScape/Game/KeyItemStateProvider.lua
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

local KeyItemStateProvider = Class(StateProvider)

function KeyItemStateProvider:new(peep)
	local director = peep:getDirector()
	local storage = director:getPlayerStorage(peep)

	self.storage = storage:getRoot():getSection("KeyItems")
	self.peep = peep
end

function KeyItemStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

function KeyItemStateProvider:has(name, count, flags)
	return (count or 1) <= self:count(name, flags)
end

function KeyItemStateProvider:take(name, count, flags)
	Log.error("Can't take a key item: '%s'!", name)
end

function KeyItemStateProvider:give(name, count, flags)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "KeyItem")
	if not resource then
		return false
	end

	self.storage:set(name, true)
	return true
end

function KeyItemStateProvider:count(name, flags)
	if self.storage:get(name) == true then
		return math.huge
	else
		return 0
	end
end

return KeyItemStateProvider
