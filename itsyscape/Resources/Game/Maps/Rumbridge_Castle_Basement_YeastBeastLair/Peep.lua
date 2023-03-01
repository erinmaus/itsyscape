--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle_Basement_YeastBeastLair/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Lair = Class(Map)

function Lair:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Castle_Basement_YeastBeastLair', ...)
end

function Lair:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self:initMites()
end

function Lair:initMites()
	local map = self:getDirector():getMap(self:getLayer())
	if not map then
		return
	end

	for i = 1, 20 do
		local position = map:getTileCenter(math.random(1, map:getWidth()), math.random(1, map:getHeight()))
		Utility.spawnActorAtPosition(self, "YeastMite", position:get())
	end
end

return Lair
