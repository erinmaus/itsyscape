--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Port/Peep.lua
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

local Port = Class(Map)

function Port:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_Port', ...)

	self.spawnedSailor = false
end

function Port:spawnSailor()
	local actor = Utility.spawnMapObjectAtAnchor(
		self,
		"Sailor",
		"Anchor_Sailor",
		0)
	local peep = actor:getPeep()
	local tripAnimation = peep:getResource("animation-resurrect", "ItsyScape.Graphics.AnimationResource")
	if tripAnimation then
		actor:playAnimation('x-fall', math.huge, tripAnimation)
	end
end

function Port:update(...)
	Map.update(self, ...)

	local player = Utility.Peep.getPlayer(self)
	if not player then
		return
	end

	local playerState = player:getState()
	local talkedToJenkins = playerState:has("KeyItem", "CalmBeforeTheStorm_TalkedToJenkins")
	local hasCompletedQuest = playerState:has("Quest", "CalmBeforeTheStorm")

	local shouldSpawnSailor = talkedToJenkins and not hasCompletedQuest
	shouldSpawnSailor = _DEBUG or shouldSpawnSailor

	if shouldSpawnSailor and not self.spawnedSailor then
		self:spawnSailor()
		self.spawnedSailor = true
	end
end

return Port
