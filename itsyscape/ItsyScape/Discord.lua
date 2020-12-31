--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Game.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NDiscord = require "nbunny.discord"

local Discord = Class()

function NDiscord:new()
	self._handle = NDiscord()
end

function NDiscord:updateActivity(details, state)
	self._handle:updateActivity(details, state)
end

function NDiscord:tick()
	self._handle:tick()
end

return NDiscord
