--------------------------------------------------------------------------------
-- ItsyScape/Peep/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Effect = Class()
Effect.BUFF_TYPE_NONE     = 0
Effect.BUFF_TYPE_POSITIVE = 1
Effect.BUFF_TYPE_NEGATIVE = 2

function Effect:new()
	self.peep = false
	self.resource = false
	self.duration = self.DURATION or math.huge
end

function Effect:setResource(value)
	self.resource = value or self.resource
end

function Effect:getResource()
	return self.resource
end

function Effect:setDuration(value)
	self.duration = value
end

function Effect:getDuration()
	return self.duration
end

function Effect:isApplied()
	return self.peep ~= false
end

function Effect:getPeep()
	return self.peep
end

function Effect:enchant(peep)
	self.peep = peep
end

function Effect:sizzle()
	self.peep = false
end

function Effect:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function Effect:getDescription()
	return nil
end

function Effect:update(delta)
	self.duration = self.duration - delta
	if self.duration <= 0 then
		self:getPeep():removeEffect(self)
	end
end

return Effect
