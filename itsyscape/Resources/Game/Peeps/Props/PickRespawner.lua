--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Props/PickRespawner.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"

local PickRespawner = Class(Peep)
PickRespawner.DEFAULT_TIME = 20

function PickRespawner:new(prop, time, ...)
	Peep.new(self, ...)

	self.mapObject = Utility.Peep.getMapObject(prop)
	self.layer = Utility.Peep.getLayer(prop)
	self.instance = Utility.Peep.getInstance(prop)

	self.remainingTime = time or self.DEFAULT_TIME
end

function PickRespawner:update(director, game)
	Peep.update(self, director, game)

	self.remainingTime = self.remainingTime - game:getDelta()
	if self.remainingTime <= 0 then
		local stage = game:getStage()

		if self.mapObject and self.layer and self.instance then
			stage:instantiateMapObject(
				self.mapObject,
				self.layer,
				stage:buildLayerNameFromInstanceIDAndFilename(self.instance:getID(), self.instance:getFilename()))
		end

		Utility.Peep.poof(self)
	end
end

return PickRespawner
