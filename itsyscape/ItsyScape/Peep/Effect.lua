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

function Effect:new()
	self.peep = false
	self.resource = false
end

function Effect:setResource(value)
	self.resource = value or self.resource
end

function Effect:getResource()
	return self.resource
end

function Effect:isApplied()
	return self.peep ~= false
end

function Effect:enchant(peep)
	self.peep = peep
end

function Effect:sizzle()
	self.peep = false
end

function Effect:update()
	return true
end

return Effect
