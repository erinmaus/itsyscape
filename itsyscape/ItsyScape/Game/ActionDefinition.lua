--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionDefinition.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local ActionDefinition = Class()

function ActionDefinition:new(verb, id)
	self.verb = verb or "???"
	self.id = id or false
end

function ActionDefinition:getVerb()
	return self.verb
end

function ActionDefinition:getID()
	return self.id
end

return ActionDefinition
