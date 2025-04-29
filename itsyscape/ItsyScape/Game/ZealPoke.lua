--------------------------------------------------------------------------------
-- ItsyScape/Game/ZealPoke.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local ZealPoke = Class()

ZealPoke.TYPE_TARGET_SWITCH = "TARGET_SWITCH"
ZealPoke.TYPE_TARGET_LOST   = "TARGET_LOST"
ZealPoke.TYPE_STANCE_SWITCH = "STANCE_SWITCH"
ZealPoke.TYPE_USE_POWER     = "USE_POWER"
ZealPoke.TYPE_LOST_POWER    = "LOST_POWER"
ZealPoke.TYPE_ATTACK        = "ATTACK"
ZealPoke.TYPE_DEFEND        = "DEFEND"

function ZealPoke:new(zealPokeType)
	self.type = zealPokeType
	self.zeal = 0
	self.multiplier = 1
	self.offset = 0
end

function ZealPoke:getType()
	return self.type
end

function ZealPoke:setZeal(value)
	self.zeal = value
end

function ZealPoke:getZeal()
	return self.zeal
end

function ZealPoke:getEffectiveZeal()
	return math.clamp(self.zeal * self.multiplier + self.offset, -1, 1)
end

function ZealPoke:addMultiplier(value)
	self.multiplier = self.multiplier + value
end

function ZealPoke:addOffset(value)
	self.offset = self.offset + value
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

	local event = ZealPoke(ZealPoke.TYPE_USE_POWER)
	event.power = t.power or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke.onLosePower(t)
	assert(type(t) == "table")

	local event = ZealPoke(ZealPoke.TYPE_LOSE_POWER)
	event.power = t.power or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke.onAttack(t)
	assert(type(t) == "table")

	local event = ZealPoke(ZealPoke.TYPE_ATTACK)
	event.accuracyRoll = t.accuracyRoll or false
	event.damageRoll = t.damageRoll or false
	event.attack = t.attack or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke.onDefend(t)
	assert(type(t) == "table")

	local event = ZealPoke(ZealPoke.TYPE_DEFEND)
	event.accuracyRoll = t.accuracyRoll or false
	event.damageRoll = t.damageRoll or false
	event.attack = t.attack or false
	event.zeal = t.zeal or 0

	return event
end

function ZealPoke:getAccuracyRoll()
	return self.accuracyRoll
end

function ZealPoke:getDamageRoll()
	return self.damageRoll
end

function ZealPoke:getAttack()
	return self.attack
end

function ZealPoke:getPower()
	return self.power
end

return ZealPoke
