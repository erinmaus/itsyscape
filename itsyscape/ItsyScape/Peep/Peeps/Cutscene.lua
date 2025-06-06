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

function CutscenePeep:new(resource, cameraName, player, map, entities, ...)
	Peep.new(self, ...)

	if not resource then
		Log.error("No cutscene resource.")
	else
		self:setName(resource.name)
		Utility.Peep.setResource(self, resource)

		if cameraName then
			self.cameraName = cameraName
		end
	end

	local cutscenes = player:getDirector():probe(
		function(p)
			if Class.isCompatibleType(p, CutscenePeep) and p.player == player then
				return self.cameraName ~= nil
			end
		end)
	self.suppressCameraChange = #cutscenes >= 1

	if not player then
		Log.error("No player for cutscene '%s'!", resource and resource.name)
	else
		self.player = player
	end

	self.map = map
	self.entities = entities or {}

	self:addPoke('done')
end

function CutscenePeep:onReady()
	local resource = Utility.Peep.getResource(self)

	if resource then
		self.player = self.player or Utility.Peep.getPlayer(self)

		self.cutscene = Cutscene(
			Utility.Peep.getResource(self),
			self.player,
			self:getDirector(),
			self:getLayerName(),
			self.map,
			self.entities)

		if self.cameraName then
			local playerModel = Utility.Peep.getPlayerModel(self.player)
			playerModel:pushCamera(self.cameraName)
		end
	end
end

function CutscenePeep:update(...)
	Peep.update(self, ...)

	if self.cutscene then
		if not self.cutscene:update() then
			if self.cameraName and not self.suppressCameraChange then
				local player = Utility.Peep.getPlayerModel(self.player)
				player:popCamera()
			end

			self:poke('done')
			Utility.Peep.poof(self)
		end
	else
		Utility.Peep.poof(self)
	end
end

return CutscenePeep
