--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Port/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local FollowerBehavior = require "ItsyScape.Peep.Behaviors.FollowerBehavior"
local InstancedBehavior = require "ItsyScape.Peep.Behaviors.InstancedBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SailorsCommon = require "Resources.Game.Peeps.Sailors.Common"

local Port = Class(Map)
Port.CREW_PASSAGE = {
	i1 = 21,
	j1 = 18,
	i2 = 24,
	j2 = 28
}

function Port:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Port', ...)

	self:addPoke('spawnShip')
	self:addPoke('recruit')
	self:addPoke('rollFirstMate')

	self.firstMate = {}
end

function Port:updateTime(player)
	local playerStorage = self:getDirector():getPlayerStorage(player:getID()):getRoot()
	local firstMateStorage = playerStorage:getSection("Ship"):getSection("FirstMate")
	local referenceTime = firstMateStorage:get("time") or (Utility.Time.BIRTHDAY_TIME - Utility.Time.DAY)
	local currentTime = Utility.Time.getAndUpdateTime(playerStorage)

	local referenceDays = Utility.Time.getDays(referenceTime)
	local currentDays = Utility.Time.getDays(currentTime)

	if currentDays > referenceDays then
		self:poke('rollFirstMate', true, player)
		firstMateStorage:set("time", currentTime)
	end
end

function Port:onRollFirstMate(reroll, player)
	if self.firstMate[player] then
		Utility.Peep.poof(self.firstMate[player]:getPeep())
		self.firstMate[player] = nil
	end

	local playerPeep = player:getActor():getPeep()

	local firstMate, pending = SailorsCommon.getActiveFirstMateResource(playerPeep)
	if not firstMate or (pending and reroll) then
		local firstMates = SailorsCommon.getUnlockableFirstMates(playerPeep, "SailingBuy")
		firstMate = firstMates[math.random(#firstMates)]

		SailorsCommon.setActiveFirstMateResource(playerPeep, firstMate, true)
		Utility.save(playerPeep)

		local name = Utility.getName(firstMate, self:getDirector():getGameDB())
		Log.info("First mate of the day: '%s'.", name)
	end

	if pending then
		self.firstMate[player] = Utility.spawnActorAtAnchor(self, firstMate, "Anchor_FirstMateLocked", 0)
	else
		self.firstMate[player] = Utility.spawnActorAtAnchor(self, firstMate, "Anchor_FirstMateUnlocked", 0)
	end

	local _, instancedBehavior = self.firstMate[player]:getPeep():addBehavior(InstancedBehavior)
	instancedBehavior.playerID = player:getID()
end

function Port:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)
end

function Port:onPlayerEnter(player)
	local playerStorage = self:getDirector():getPlayerStorage(player:getID()):getRoot()
	local followersStorage = playerStorage:getSection("Follower"):getSection("SailingCrew")
	for i = 1, followersStorage:length() do
		self:poke('recruit', followersStorage:getSection(i):get("id"), player)
	end

	self:poke('spawnShip', player)
	self:poke('rollFirstMate', false, player)
end

function Port:onPlayerLeave(player)
	self.firstMate[player] = nil
end

function Port:onSpawnShip(player)
	local playerPeep = player:getActor() and player:getActor():getPeep()
	if playerPeep and playerPeep:getState():has("SailingItem", "Ship") then
		local _, ship = Utility.Map.spawnMap(self, "Ship_Player1", Vector(12, 0, 48), {
			isInstancedToPlayer = true,
			player = player
		})
		local rotation = ship:getBehavior(RotationBehavior)
		rotation.rotation = Quaternion.Y_90
		local position = ship:getBehavior(PositionBehavior)
		position.offset = Vector(0, 2, 0)
	end
end

function Port:onRecruit(id, player)
	local stage = self:getDirector():getGameInstance():getStage()
	local success, actor = stage:spawnActor(
		"Resources.Game.Peeps.Sailors.BaseSailor",
		self:getLayer(),
		self:getLayerName())

	if success then
		local peep = actor:getPeep()
		peep:listen('finalize', function()
			local map = self:getDirector():getMap(self:getLayer())

			local position
			repeat
				local i = math.random(Port.CREW_PASSAGE.i1, Port.CREW_PASSAGE.i2)
				local j = math.random(Port.CREW_PASSAGE.j1, Port.CREW_PASSAGE.j2)
				local tile = map:getTile(i, j)

				if not tile:hasFlag('impassable') then
					position = map:getTileCenter(i, j)
				end
			until position

			Utility.Peep.setPosition(peep, position)

			peep:pushPoke('place', id, player)
		end)

		local follower = peep:getBehavior(FollowerBehavior)
		follower.id = id
		follower.playerID = player:getID()

		local instance = peep:getBehavior(InstancedBehavior)
		instance.playerID = player:getID()
	end
end

function Port:update(...)
	Map.update(self, ...)

	local instance = Utility.Peep.getInstance(self)
	for _, player in instance:iteratePlayers() do
		self:updateTime(player)
	end
end

return Port
