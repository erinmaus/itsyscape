--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadSink.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local GamepadSink = Class()

GamepadSink.DEFAULT_OPTIONS = {
	isBlocking = true
}

function GamepadSink:new(t)
	t = t or self.DEFAULT_OPTIONS

	self.isBlocking = t.isBlocking == nil and self.DEFAULT_OPTIONS.isBlocking or t.isBlocking
end

function GamepadSink:setIsBlocking(value)
	self.isBlocking = not not value
end

function GamepadSink:getIsBlocking()
	return self.isBlocking
end

return GamepadSink
