--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/FollowerCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"

local FollowerCortex = Class(Cortex)

function FollowerCortex:new()
	Cortex.new(self)

	self:require(FollowerBehavior)
	self.followersByPlayer = setmetatable({}, { __mode = "k" })
	self.hadPeep = setmetatable({}, { __mode = "k" })
end

function FollowerCortex:previewPeep(peep)
	Cortex.previewPeep(self, peep)
end

function FollowerCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	local player = Utility.Peep.getPlayerModel(peep)
	local followers = self.followersByPlayer[player] or setmetatable({}, { __mode = "k" })
	followers[peep] = peep

	self.followersByPlayer[player] = followers
	self.hadPeep[peep] = player
end

function FollowerCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	if self.hadPeep[peep] then
		local player = self.hadPeep[peep]
		local followers = self.followersByPlayer[player]
		if followers then
			followers[peep] = nil
		end

		self.hadPeep[peep] = nil
	end
end

function FollowerCortex:iterateFollowers(player)
	return pairs(self.followersByPlayer[player] or {})
end

return FollowerCortex
