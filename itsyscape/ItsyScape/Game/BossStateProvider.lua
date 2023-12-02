--------------------------------------------------------------------------------
-- ItsyScape/Game/BossStateProvider.lua
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

local BossStateProvider = Class(StateProvider)

function BossStateProvider:new(peep)
	StateProvider.new(self)

	self.peep = peep
end

function BossStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

function BossStateProvider:has(name, count, flags)
	return (count or 1) <= self:count(name, flags)
end

function BossStateProvider:take(name, count, flags)
	Log.error("Can't give boss '%s'.", name)
end

function BossStateProvider:give(name, count, flags)
	Log.error("Can't give boss '%s'.", name)
end

function BossStateProvider:count(name, flags)
	return Utility.Boss.getKillCount(self.peep, name) or 0
end

return BossStateProvider
