--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/CutscenePeep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Cutscene = require "ItsyScape.Game.Cutscene"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"

local CutscenePeep = Class(Peep)

function CutscenePeep:new(resource, ...)
	Peep.new(self, ...)

	if not resource then
		Log.error("No cutscene resource.")
	else
		self:setName(resource.name)
		Utility.Peep.setResource(self, resource)
	end

	self:addPoke('done')
end

function CutscenePeep:onReady()
	local resource = Utility.Peep.getResource(self)

	if resource then
		self.cutscene = Cutscene(
			Utility.Peep.getResource(self),
			Utility.Peep.getPlayer(self),
			self:getDirector(),
			self:getLayerName())
	end
end

function CutscenePeep:update(...)
	Peep.update(self, ...)

	if self.cutscene then
		if not self.cutscene:update() then
			self:poke('done')
			Utility.Peep.poof(self)
		end
	else
		Utility.Peep.poof(self)
	end
end

return CutscenePeep
