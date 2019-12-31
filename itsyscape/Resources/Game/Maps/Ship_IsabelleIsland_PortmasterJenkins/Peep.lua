--------------------------------------------------------------------------------
-- Resources/Game/Maps/Ship_IsabelleIsland_PortmasterJenkins/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "Resources.Game.Peeps.Maps.ShipMapPeep"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local Ship = Class(Map)
Ship.STATE_SQUID   = 0
Ship.STATE_PIRATES = 1

function Ship:new(resource, name, ...)
	Map.new(self, resource, name or 'Ship_IsabelleIsland_PortmasterJenkins', ...)
end

function Ship:getMaxHealth()
	return 150
end

function Ship:onLoad(filename, arguments, layer)
	Map.onLoad(self, filename, arguments, layer)

	self.player = self:getDirector():getGameInstance():getPlayer():getActor():getPeep()

	local state = tonumber(arguments['jenkins_state'] or Ship.STATE_SQUID)
	if state == Ship.STATE_SQUID then
		self:initSquidEncounter()
	else
		self:initPirateEncounter()
	end
end

function Ship:initSquidEncounter()
	Utility.spawnMapObjectAtAnchor(
		self,
		"Jenkins_Squid",
		"Anchor_Jenkins_Spawn",
		0)
	Utility.spawnMapObjectAtAnchor(
		self,
		"Sailor1",
		"Anchor_Sailor1_Spawn",
		0)
	Utility.spawnMapObjectAtAnchor(
		self,
		"Sailor2",
		"Anchor_Sailor2_Spawn",
		0)
end

function Ship:onRaiseCthulhu()
	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(self:getLayer(), 'IsabelleIsland_FarOcean_HeavyRain_Cthulhu', 'Rain', {
		wind = { -15, 0, 0 },
		heaviness = 0.5
	})

	local oceanMapScript = stage:getMapScript("IsabelleIsland_FarOcean")
	Utility.spawnMapObjectAtAnchor(
		oceanMapScript,
		"Cthulhu",
		"Cthulhu_Spawn")
	Utility.spawnMapObjectAtAnchor(
		oceanMapScript,
		"UndeadSquid",
		"Anchor_Squid_Spawn1")
	Utility.spawnMapObjectAtAnchor(
		oceanMapScript,
		"UndeadSquid",
		"Anchor_Squid_Spawn2")
	Utility.spawnMapObjectAtAnchor(
		oceanMapScript,
		"UndeadSquid",
		"Anchor_Squid_Spawn3")
end

function Ship:initPirateEncounter()
	Utility.spawnMapObjectAtAnchor(
		self,
		"Jenkins_Pirate",
		"Anchor_Jenkins_Spawn",
		0)
	Utility.spawnMapObjectAtAnchor(
		self,
		"Wizard",
		"Anchor_Sailor1_Spawn",
		0)
	Utility.spawnMapObjectAtAnchor(
		self,
		"Archer",
		"Anchor_Sailor2_Spawn",
		0)

	self.pirates = {}
	do
		local actor = Utility.spawnMapObjectAtAnchor(
			self,
			"Pirate1",
			"Anchor_Pirate1_Spawn",
			0)
		if actor then
			actor:getPeep():listen('die', self.onPirateDeath, self, "Pirate1")
			table.insert(self.pirates, actor)
		end
	end
	do
		local actor = Utility.spawnMapObjectAtAnchor(
			self,
			"Pirate2",
			"Anchor_Pirate2_Spawn",
			0)
		if actor then
			actor:getPeep():listen('die', self.onPirateDeath, self, "Pirate2")
			table.insert(self.pirates, actor)
		end
	end

	Utility.spawnMapObjectAtAnchor(
		self,
		"CapnRaven",
		"Anchor_CapnRaven_Spawn",
		0)

	do
		local state = self.player:getState()
		local FLAGS = { ["item-inventory"] = true }
		state:give("Item", "RustyHelmet", 1, FLAGS)
		state:give("Item", "RustyPlatebody",  1,FLAGS)
		state:give("Item", "RustyGloves",  1,FLAGS)
		state:give("Item", "RustyBoots",  1,FLAGS)
		state:give("Item", "RustyDagger",  1,FLAGS)
	end

	local s, index = Utility.UI.openInterface(
		self.player,
		"CharacterCustomization",
		true)
	if s then
		self.blockingInterfaceID = "CharacterCustomization"
		self.blockingInterfaceIndex = index
		self.player:addBehavior(DisabledBehavior)
	end
end

function Ship:onPirateDeath(pirate)
	local deadCount = 0

	for i = 1, #self.pirates do
		local p = self.pirates[i]

		local success = Utility.Peep.attack(p:getPeep(), self.player, math.huge)
		if not success or p:getPeep() == pirate then
			deadCount = deadCount + 1
		else
			p:flash("Message", 1, "Arrr, ye'll pay, landlubber!")
		end
	end

	if deadCount >= #self.pirates then
		self:makePlayerListen()
	end
end

function Ship:makePlayerListen()
	local director = self:getDirector()
	local game = director:getGameInstance()

	local capnRaven
	do
		local gameDB = director:getGameDB()
		local capnRavenResource = gameDB:getResource("IsabelleIsland_FarOcean_PirateCaptain", "Peep")
		local hits = director:probe(self:getLayerName(), Probe.resource(capnRavenResource))
		capnRaven = hits[1]
	end

	if capnRaven then
		local capnRavenMapObject = Utility.Peep.getMapObject(capnRaven)
		local actions = Utility.getActions(
			game,
			capnRavenMapObject,
			'world')
		for i = 1, #actions do
			if actions[i].instance:is("talk") then
				return Utility.UI.openInterface(
					self.player,
					"DialogBox",
					true,
					actions[i].instance:getAction().
					capnRaven)
			end
		end
	end

	return false, nil
end

function Ship:update(director, game)
	Map.update(self, director, game)

	if self.blockingInterfaceID and self.blockingInterfaceIndex then
		local ui = game:getUI()
		local isOpen = ui:isOpen(self.blockingInterfaceID, self.blockingInterfaceIndex)
		if not isOpen then
			self.player:removeBehavior(DisabledBehavior)

			if self.blockingInterfaceID == "CharacterCustomization" then
				local s, index = self:makePlayerListen()

				if s then
					self.blockingInterfaceID = "DialogBox"
					self.blockingInterfaceIndex = index
				end

				self.player:addBehavior(DisabledBehavior)
			else
				self.blockingInterfaceID = nil
				self.blockingInterfaceIndex = nil
			end
		end
	end
end

return Ship
