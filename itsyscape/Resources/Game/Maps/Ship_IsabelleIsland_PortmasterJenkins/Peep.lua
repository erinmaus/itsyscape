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
	Utility.spawnMapObjectAtAnchor(
		self,
		"Pirate1",
		"Anchor_Pirate1_Spawn",
		0)
	Utility.spawnMapObjectAtAnchor(
		self,
		"Pirate2",
		"Anchor_Pirate2_Spawn",
		0)
	Utility.spawnMapObjectAtAnchor(
		self,
		"CapnRaven",
		"Anchor_CapnRaven_Spawn",
		0)

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

function Ship:update(director, game)
	Map.update(self, director, game)

	if self.blockingInterfaceID and self.blockingInterfaceIndex then
		local ui = game:getUI()
		local isOpen = ui:isOpen(self.blockingInterfaceID, self.blockingInterfaceIndex)
		if not isOpen then
			self.player:removeBehavior(DisabledBehavior)

			self.blockingInterfaceID = nil
			self.blockingInterfaceIndex = nil
		end
	end
end

return Ship
