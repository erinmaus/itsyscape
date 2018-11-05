--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicFire.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local BlockingProp = require "Resources.Game.Peeps.Props.BlockingProp"

local BasicFire = Class(BlockingProp)
function BasicFire:new(resource, name, ...)
	BlockingProp.new(self, resource, 'Fire', ...)

	self.duration = math.huge
end

function BasicFire:onSpawnedByAction(instigator)
	local resource = Utility.Peep.getResource(self)
	if resource then
		local gameDB = self:getDirector():getGameDB()
		local record = gameDB:getRecord("GatherableProp", {
			Resource = resource
		})

		if record then
			local spawnTime = record:get("SpawnTime")
			local level = Curve.XP_CURVE:getLevel(instigator:getState():count("Skill", "Firemaking"))
			level = level / 20
			if spawnTime then
				self.duration = spawnTime * (level + 1)
			end
		end
	end
end

function BasicFire:update(director, game)
	BlockingProp.update(self, director, game)

	self.duration = self.duration - game:getDelta()
	if self.duration < 0 then
		Utility.Peep.poof(self)
	end
end

function BasicFire:getPropState()
	return {
		duration = self.duration
	}
end

return BasicFire
