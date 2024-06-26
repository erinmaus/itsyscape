--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/Cloud.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local Cloud = Class(Prop)
Cloud.MIN_NUM_LUMPS = 4
Cloud.MAX_NUM_LUMPS = 12

Cloud.MIN_LUMP_RADIUS = 4
Cloud.MAX_LUMP_RADIUS = 8

Cloud.MIN_LUMP_OFFSET = 0
Cloud.MAX_LUMP_OFFSET = 4

function Cloud:new(...)
	Prop.new(self, ...)

	self:addBehavior(MovementBehavior)
end

function Cloud:ready(...)
	Prop.ready(self, ...)

	self.cloudState = { id = 0 }

	local numLumps = love.math.random(self.MIN_NUM_LUMPS, self.MAX_NUM_LUMPS)
	for i = 1, #numLumps do
		table.insert(self.cloudState, self:generateLump())
	end
end

function Cloud:generateLump()
	local id = self.cloudState.id + 1
	self.cloudState.id = id

	local position = 
	local radius = (self.MAX_LUMP_RADIUS - self.MIN_NUM_RADIUS) * love.math.random() + self.MIN_NUM_RADIUS
end

function Cloud:spawnOrPoofTile()
	-- Nothing.
end

return Cloud
