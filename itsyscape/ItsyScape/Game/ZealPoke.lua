--------------------------------------------------------------------------------
-- ItsyScape/Game/ZealPoke.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require ("ItsyScape.Common.Class")

local ZealPoke = Class()

ZealPoke.TYPE_TARGET_SWITCH = "TARGET_SWITCH"
ZealPoke.TYPE_TARGET_LOST   = "TARGET_LOST"
ZealPoke.TYPE_STANCE_SWITCH = "STANCE_SWITCH"
ZealPoke.TYPE_USEP_POWER    = "USE_POWER"

function ZealPoke:new(zealPokeType)
	self.type = zealPokeType
	self.zeal = 0
end

function ZealPoke:getType()
	return self.type
end

function ZealPoke:getZeal()
	return self.zeal
end

function ZealPoke.onTargetSwitch(t)
	assert(type(t) == "table")

	local event = ZealPoke(ZealPoke.TYPE_TARGET_SWITCH)
	event.previousTarget = t.previousTarget or false
	event.currentTarget = t.currentTarget or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke:getPreviousTarget()
	return self.previousTarget
end

function ZealPoke:getCurrentTarget()
	return self.currentTarget
end

function ZealPoke.onTargetLost(t)
	local event = ZealPoke(ZealPoke.TYPE_TARGET_LOST)
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke.onStanceSwitch(t)
	assert(type(t) == "table")

	local event = ZealPoke(ZealPoke.TYPE_TARGET_SWITCH)
	event.previousStance = t.previousStance or false
	event.currentStance = t.currentStance or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke:getPreviousStance()
	return self.previousStance
end

function ZealPoke:getCurrentStance()
	return self.currentStance
end

function ZealPoke.onUsePower(t)
	assert(type(t) == "table")

	local event = ZealPoke(ZealPoke.TYPE_USEP_POWER)
	event.power = t.power or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke:getPower()
	return self.power
end

return ZealPoke
