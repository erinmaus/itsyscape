--------------------------------------------------------------------------------
-- ItsyScape/Game/QuestStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local Utility = require "ItsyScape.Game.Utility"
local StateProvider = require "ItsyScape.Game.StateProvider"

local QuestStateProvider = Class(StateProvider)

function QuestStateProvider:new(peep)
	StateProvider.new(self)

	self.peep = peep
end

function QuestStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

function QuestStateProvider:has(name, count, flags)
	return (count or 1) <= self:count(name, flags)
end

function QuestStateProvider:take(name, count, flags)
	Log.error("Can't take quest '%s'.", name)
end

function QuestStateProvider:give(name, count, flags)
	Log.error("Can't give quest '%s'.", name)
end

function QuestStateProvider:count(name, flags)
	if flags['x-ignore-quest'] then
		Log.warn("Called with 'x-ignore-quest' flag; this likely means a 'quest complete' action depends on another quest.")
		return 0
	end

	if _DEBUG then
		return 1
	end

	local gameDB = self.peep:getDirector():getGameDB()
	local resource = gameDB:getResource(name, "Quest")
	if not resource then
		return 0
	end

	local actions = Utility.getActions(
		self.peep:getDirector():getGameInstance(),
		resource,
		'quest')
	for i = 1, #actions do
		local action = actions[i].instance
		if action:is('QuestComplete') and action:canPerform(self.peep:getState(), self.peep) then
			return 1
		end
	end

	return 0
end

return QuestStateProvider
