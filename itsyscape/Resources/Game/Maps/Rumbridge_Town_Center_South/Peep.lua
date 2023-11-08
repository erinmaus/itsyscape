--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Town_Center_South/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local FollowerCortex = require "ItsyScape.Peep.Cortexes.FollowerCortex"

local Town = Class(Map)

function Town:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Town_Center_South', ...)
end

function Town:onPlayerEnter(player)
	self:trySpawnLyra(player)
end

function Town:trySpawnLyra(player)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local gameDB = self:getDirector():getGameDB()
	local lyraResource, oliverResource = gameDB:getResource("Lyra", "Peep"), gameDB:getResource("Oliver", "Peep")
	if not lyraResource or not oliverResource then
		Log.warn(
			"Couldn't get resource in Rumbridge Town Shade District (Lyra = %s, Oliver = %s).",
			Log.boolean(lyraResource),
			Log.boolean(oliverResource))
		return
	end

	local followerCortex = self:getDirector():getCortex(FollowerCortex)
	local lyraPeep, oliverPeep
	for peep in followerCortex:iterateFollowers(player) do
		local resource = Utility.Peep.getResource(peep)
		if resource then
			if resource.id.value == lyraResource.id.value then
				lyraPeep = peep
			end

			if resource.id.value == oliverResource.id.value then
				oliverPeep = peep
			end
		end
	end

	if lyraPeep and oliverPeep then
		Log.info("Lyra and Oliver are following player '%s', not respawning.", player:getActor():getName())
	elseif not lyraPeep or not oliverPeep then
		if not lyraPeep and not oliverPeep then
			Log.info("Lyra and Oliver are not following player '%s, spawning.", player:getActor():getName())
		else
			Log.warn("Just one of either Lyra or Oliver is following player '%s'!", player:getActor():getName())
		end

		if not lyraPeep then
			local lyraActor = Utility.spawnMapObjectAtAnchor(self, "Lyra", "Anchor_Lyra", 0)

			local _, instance = lyraActor:getPeep():addBehavior(InstancedBehavior)
			instance.playerID = player:getID()

			if oliverPeep then
				local _, follower = lyraActor:getPeep():addBehavior(FollowerBehavior)

				follower.playerID = player:getID()
				follower.followAcrossMaps = true
			end
		end

		if not oliverPeep then
			local oliverActor = Utility.spawnMapObjectAtAnchor(self, "Oliver", "Anchor_Oliver", 0)

			local _, instance = oliverActor:getPeep():addBehavior(InstancedBehavior)
			instance.playerID = player:getID()

			if lyraPeep then
				local _, follower = oliverActor:getPeep():addBehavior(FollowerBehavior)

				follower.playerID = player:getID()
				follower.followAcrossMaps = true
			end
		end
	end
end

return Town
