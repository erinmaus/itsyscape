--------------------------------------------------------------------------------
-- ItsyScape/Game/DreamStateProvider.lua
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

local DreamStateProvider = Class(StateProvider)

function DreamStateProvider:new(peep)
	local director = peep:getDirector()
	local storage = director:getPlayerStorage(peep)

	self.storage = storage:getRoot():getSection("Dreams")
	self.peep = peep
end

function DreamStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

function DreamStateProvider:has(name, count, flags)
	return (count or 1) <= self:count(name, flags)
end

function DreamStateProvider:take(name, count, flags)
	Log.error("Can't take dreams.")
	return false
end

function DreamStateProvider:give(name, count, flags)
	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "Dream")
	if not resource then
		return false
	end

	if not self.storage:get(name) then
		Log.analytic("PLAYER_DREAMED", name)
	end

	self.storage:set(name, true)
	return true
end

function DreamStateProvider:count(name, flags)
	if self.storage:get(name) == true then
		return math.huge
	else
		return 0
	end
end

return DreamStateProvider
