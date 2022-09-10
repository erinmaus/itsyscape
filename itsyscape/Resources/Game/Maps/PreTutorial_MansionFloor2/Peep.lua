--------------------------------------------------------------------------------
-- Resources/Game/Maps/PreTutorial_MansionFloor1/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Mansion = Class(Map)
Mansion.MIN_LIGHTNING_PERIOD = 3
Mansion.MAX_LIGHTNING_PERIOD = 6
Mansion.LIGHTNING_TIME = 0.5
Mansion.MAX_AMBIENCE = 2

function Mansion:new(resource, name, ...)
	Map.new(self, resource, name or 'PreTutorial_MansionFloor1', ...)
end

function Mansion:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self.zombiButler = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Hans"))[1]

	Utility.Map.spawnMap(self, "PreTutorial_MansionFloor1", Vector(0, -6.1, 0), { isLayer = true })
end

function Mansion:onPlayerEnter(player)
	player = player:getActor():getPeep()

	if self.zombiButler:getCurrentTarget() then
		self.zombiButler:giveHint("Oh dear me, looks like someone else needs help!")
	end

	self.zombiButler:poke('followPlayer', player)
	self.zombiButler:poke('floorChange', 2)
end

function Mansion:onPlayerLeave(player)
	if not player:getActor() then
		return
	end

	player = player:getActor():getPeep()

	if self.zombiButler:getCurrentTarget() == player then
		self.zombiButler:giveHint("Be seeing you later!")
		self.zombiButler:poke('followPlayer', nil)

		for _, player in Utility.Peep.getInstance(self):iteratePlayers() do
			self:onPlayerEnter(player)
			break
		end
	end
end

return Mansion
