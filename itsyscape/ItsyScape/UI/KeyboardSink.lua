--------------------------------------------------------------------------------
-- ItsyScape/UI/KeyboardSink.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local KeyboardSink = Class()

KeyboardSink.DEFAULT_OPTIONS = {
	isBlocking = true,
	isBlockingCamera = true,
	isBlockingRibbon = true
}

function KeyboardSink:new(t)
	t = t or self.DEFAULT_OPTIONS

	self.isBlocking = t.isBlocking == nil and self.DEFAULT_OPTIONS.isBlocking or t.isBlocking
	self.isBlockingCamera = t.isBlockingCamera == nil and self.DEFAULT_OPTIONS.isBlockingCamera or t.isBlockingCamera
	self.isBlockingRibbon = t.isBlockingRibbon == nil and self.DEFAULT_OPTIONS.isBlockingRibbon or t.isBlockingRibbon
end

function KeyboardSink:setIsBlocking(value)
	self.isBlocking = not not value
end

function KeyboardSink:getIsBlocking()
	return self.isBlocking
end

function KeyboardSink:setIsBlockingCamera(value)
	self.isBlockingCamera = not not value
end

function KeyboardSink:getIsBlockingCamera()
	return self.isBlockingCamera
end

function KeyboardSink:setIsBlockingRibbon(value)
	self.isBlockingRibbon = not not value
end

function KeyboardSink:getIsBlockingRibbon()
	return self.isBlockingRibbon
end

return KeyboardSink
