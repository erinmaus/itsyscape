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
local Weapon = require "ItsyScape.Game.Weapon"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "Resources.Game.Peeps.Maps.ShipMapPeep"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"

local Ship = Class(Map)
Ship.STATE_SQUID   = 0
Ship.STATE_PIRATES = 1
Ship.COMBAT_HINT = {
	{
		position = 'up',
		id = "Ribbon-PlayerInventory",
		message = "Click here to access your inventory.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerInventory")
			end
		end,
	},
	{
		position = 'up',
		id = "Inventory-RustyDagger",
		message = "Click on the rusty dagger to equip it.\nRight-click on the dagger to see additional options.",
		open = function(target)
			return function()
				return not target:getState():has('Item', "RustyDagger", 1, { ['item-inventory'] = true })
			end
		end,
	},
	{
		position = 'up',
		id = "Ribbon-PlayerEquipment",
		message = "Click here to see your equipment.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerEquipment")
			end
		end
	},
	{
		position = 'up',
		id = "PlayerEquipment",
		message = "View your bonuses and dequip items from here.\nYou can right-click on your equipment for additional options.",
		open = function(target)
			local time = love.timer.getTime()
			return function()
				return love.timer.getTime() > time + 10 
			end
		end
	},
	{
		position = 'up',
		id = "Ribbon-PlayerStance",
		message = "Click here to see your stance.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerStance")
			end
		end
	},
	{
		position = 'up',
		id = "PlayerStance",
		message = "Change your stance to 'Aggressive' to deal more damage.\nHover over the other stances to see what they do.",
		open = function(target)
			return function()
				return target:getBehavior(StanceBehavior).stance == Weapon.STANCE_AGGRESSIVE
			end
		end
	},
	{
		position = 'down',
		id = "StrategyBar",
		message = "This is your strategy bar.\nClick on the power 'Backstab' to activate it on your next attack.\n(Remember, right-click on a spot to bind different powers.)\nThen attack a pirate to continue!",
		open = function(target)
			return function()
				local power = target:getBehavior(PendingPowerBehavior)
				return power and power.power and power.power:getResource().name == "Backstab"
			end
		end
	},
}

function Ship.showTip(tips, target)
	target:addBehavior(DisabledBehavior)

	local index = 0
	local function after()
		index = index + 1
		if index <= #tips then
			Utility.UI.openInterface(
				target,
				"TutorialHint",
				false,
				tips[index].id,
				tips[index].message,
				tips[index].open(target),
				{ position = tips[index].position },
				after)
		else
			target:removeBehavior(DisabledBehavior)
		end
	end

	after()
end

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
					actions[i].instance:getAction(),
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

	if Utility.UI.isOpen(self.player, "VideoTutorial") then
		self.showedVideoTutorial = true
	elseif self.showedVideoTutorial then
		if not self.showedCombatHints then
			Ship.showTip(Ship.COMBAT_HINT, self.player)
			self.showedCombatHints = true
		end
	end
end

return Ship
