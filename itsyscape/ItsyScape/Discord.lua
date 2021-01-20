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

function Discord:new()
	local s, r = pcall(NDiscord)
	if not s then
		Log.warn("%s", r)
		self._handle = false
	else
		self._handle = r
	end
end

function Discord:updateActivity(details, state)
	if self._handle then
		self._handle:updateActivity(details, state)
	end
end

function Discord:tick()
	if self._handle then
		self._handle:tick()
	end
end

return Discord
