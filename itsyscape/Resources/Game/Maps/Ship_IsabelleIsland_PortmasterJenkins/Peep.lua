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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Probe = require "ItsyScape.Peep.Probe"
local ShipMapPeep = require "Resources.Game.Peeps.Maps.ShipMapPeep"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local StanceBehavior = require "ItsyScape.Peep.Behaviors.StanceBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Ship = Class(ShipMapPeep)
Ship.STATE_SQUID   = 0
Ship.STATE_PIRATES = 1
Ship.COMBAT_HINT = {
	{
		position = 'up',
		id = "Ribbon-PlayerInventory",
		message = not _MOBILE and "Click here to access your inventory." or "Tap here to access your inventory.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerInventory")
			end
		end,
	},
	{
		position = 'up',
		id = "Inventory-RustyDagger",
		message = not _MOBILE and "Click on the rusty dagger to equip it.\nRight-click on the dagger to see additional options." or "Tap on the rusty dagger to equip it.\nHold your tap on the dagger to see additional options.",
		open = function(target)
			return function()
				return not target:getState():has('Item', "RustyDagger", 1, { ['item-inventory'] = true })
			end
		end,
	},
	{
		position = 'up',
		id = "Ribbon-PlayerStance",
		message = not _MOBILE and "Click here to see your stance." or "Tap here to see your stance.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerStance")
			end
		end
	},
	{
		position = 'up',
		id = "PlayerStance",
		message = not _MOBILE and "Change your stance to 'Aggressive' to deal more damage.\nHover over the other stances to see what they do." or "Change your stance to 'Aggressive' to deal more damage.",
		open = function(target)
			return function()
				return target:getBehavior(StanceBehavior).stance == Weapon.STANCE_AGGRESSIVE
			end
		end
	},
	{
		position = 'up',
		id = "Ribbon-PlayerPowers",
		message = not _MOBILE and "Click here to see your powers." or "Tap here to see your powers.",
		open = function(target)
			return function()
				return Utility.UI.isOpen(target, "PlayerPowers")
			end
		end
	},
	{
		position = 'up',
		id = "PlayerPowers-PowerBackstab",
		message = not _MOBILE and "Click 'Backstab' then click on a pirate to attack.\nYou will deal a special attack!" or "Tap 'Backstab' then tap on a pirate to attack.\nYou will deal a special attack!",
		open = function(target)
			return function()
				local power = target:getBehavior(PendingPowerBehavior)
				return power and power.power and power.power:getResource().name == "Backstab"
			end
		end
	},
}

function Ship:showTip(tips, target)
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

			self:listenForAttack()
		end
	end

	after()
end

function Ship:listenForAttack(numTimesAttacked)
	self.numTimesAttacked = numTimesAttacked or 0
	self.previousTarget = nil

	local SPAM_MESSAGE_THRESHOLD = 3

	local notifiedPlayer = false

	local function performAttackAction(_, e)
		if e.action:is("Attack") then
			if self.numTimesAttacked == 0 then
				Utility.Peep.notify(self.player, "You'll automatically deal blows until the foe is slain.")
			end

			local target = self.player:getBehavior(CombatTargetBehavior)
			target = target and target.actor

			if self.previousTarget ~= target then
				self.previousTarget = target
				self.numTimesAttacked = 1
			else
				self.numTimesAttacked = self.numTimesAttacked + 1
			end

			if self.numTimesAttacked > SPAM_MESSAGE_THRESHOLD then
				self.numTimesAttacked = 1

				Utility.Peep.notify(self.player, _MOBILE and "You only need to tap once to attack!" or "You only need to click once to attack!", notifiedPlayer)
				notifiedPlayer = true
			end
		end
	end

	local function performInitiateAttack()
		if self.target then
			Utility.Peep.poof(self.target)
		end
	end

	local function travel()
		self.player:silence("actionPerformed", performAttackAction)
		self.player:silence("initiateAttack", performInitiateAttack)
		self.player:silence("travel", travel)
	end

	self.player:listen("actionPerformed", performAttackAction)
	self.player:listen("initiateAttack", performInitiateAttack)

	self:targetPirate(self.pirates[1]:getPeep())
end

function Ship:targetPirate(piratePeep)
	if piratePeep then
		local position = Utility.Peep.getPosition(piratePeep)
		local targetProp = Utility.spawnPropAtPosition(self, "Target_Default", position.x, position.y, position.z, 0)
		if targetProp then
			self.target = targetProp:getPeep()
			self.target:setTarget(piratePeep, _MOBILE and "Tap the pirate to fight!" or "Click the pirate to fight!")

			local _, position = self.target:addBehavior(PositionBehavior)
			position.offset = Vector.UNIT_Y * 2
		end
	end
end

function Ship:new(resource, name, ...)
	ShipMapPeep.new(self, resource, name or 'Ship_IsabelleIsland_PortmasterJenkins', ...)
end

function Ship:getMaxHealth()
	return 150
end

function Ship:onLoad(filename, arguments, layer)
	ShipMapPeep.onLoad(self, filename, arguments, layer)

	local behavior = self:getBehavior(ShipStatsBehavior)
	behavior.bonuses[ShipStatsBehavior.STAT_SPEED] = 300
	behavior.bonuses[ShipStatsBehavior.STAT_TURN]  = 20

	self.player = Utility.Peep.getPlayer(self)

	local state = tonumber(arguments['jenkins_state'] or Ship.STATE_SQUID)
	if state == Ship.STATE_SQUID then
		self:initSquidEncounter()
	else
		self:initPirateEncounter()
	end
end

function Ship:initSquidEncounter()
	local jenkins = Utility.spawnMapObjectAtAnchor(self, "Jenkins_Squid", "Anchor_Jenkins_Spawn")
	Sailing.setCaptain(self, jenkins:getPeep())

	local sailor1 = Utility.spawnMapObjectAtAnchor(self, "Sailor1", "Anchor_Sailor1_Spawn")
	Sailing.setCrewMember(self, sailor1:getPeep())

	local sailor2 = Utility.spawnMapObjectAtAnchor(self, "Sailor2", "Anchor_Sailor2_Spawn")
	Sailing.setCrewMember(self, sailor2:getPeep())
end

function Ship:onRaiseCthulhu()
	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(self:getLayer(), 'IsabelleIsland_FarOcean_HeavyRain_Cthulhu', 'Rain', {
		wind = { -15, 0, 0 },
		heaviness = 0.5
	})

	local instance = stage:getPeepInstance(self)
	local oceanMapScript = instance:getMapScriptByMapFilename("IsabelleIsland_FarOcean")
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
	local jenkins = Utility.spawnMapObjectAtAnchor(self, "Jenkins_Pirate", "Anchor_Jenkins_Spawn")
	Sailing.setCaptain(self, jenkins:getPeep())

	Utility.spawnMapObjectAtAnchor(self, "Sailor1", "Anchor_Sailor1_Spawn")
	Utility.spawnMapObjectAtAnchor(self, "Sailor2", "Anchor_Sailor2_Spawn")
	Utility.spawnMapObjectAtAnchor(self, "Rosalind", "Anchor_Rosalind_Spawn")
	Utility.spawnMapObjectAtAnchor(self, "Orlando", "Anchor_Orlando_Spawn")

	do
		local state = self.player:getState()
		local FLAGS = { ["item-inventory"] = true }
		state:give("Item", "RustyHelmet", 1, FLAGS)
		state:give("Item", "RustyPlatebody",  1,FLAGS)
		state:give("Item", "RustyGloves",  1,FLAGS)
		state:give("Item", "RustyBoots",  1,FLAGS)
		state:give("Item", "RustyDagger",  1,FLAGS)
	end

	-- self:pushPoke("openCharacterCustomization")
	-- self.player:addBehavior(DisabledBehavior)
	-- self.openedCharacterCustomization = false
end

function Ship:onOpenCharacterCustomization()
	local s, index = Utility.UI.openInterface(
		self.player,
		"CharacterCustomization",
		true)
	if s then
		self.blockingInterfaceID = "CharacterCustomization"
		self.blockingInterfaceIndex = index
	end

	self.openedCharacterCustomization = true
end

function Ship:onPirateDeath(pirate)
	local deadCount = 0

	local other
	for i = 1, #self.pirates do
		local p = self.pirates[i]

		local success = Utility.Peep.attack(p:getPeep(), self.player, math.huge)
		if not success or p:getPeep() == pirate then
			deadCount = deadCount + 1
		else
			other = p
			p:flash("Message", 1, "Arrr, ye'll pay, landlubber!")
		end
	end

	if deadCount >= #self.pirates then
		self:pushPoke("makePlayerListen")
	elseif other then
		self:targetPirate(other:getPeep())
	end
end

function Ship:onMakePlayerListen()
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
					actions[i].instance,
					capnRaven)
			end
		end
	end

	return false, nil
end

function Ship:showCameraZoomTutorial()
	self.isZoomPending = true

	local duration = 4
	local targetTime = love.timer.getTime() + duration

	self.blockingInterfaceID = "TutorialHint"

	local _
	_, self.blockingInterfaceIndex = Utility.UI.openInterface(
		self.player,
		"TutorialHint",
		false,
		"root",
		_MOBILE and "Use a pinching gesture to zoom in and out." or "Click the left mouse button and drag up or down to zoom in and out.\nYou can also use the middle scroll wheel.",
		function()
			return love.timer.getTime() > targetTime
		end,
		{ position = 'up' })

	local playerModel = Utility.Peep.getPlayerModel(self.player)
	if playerModel then
		playerModel:pokeCamera("showScroll", {
			0.0, 0.5,
			0.0, 1.0,
			0.0, 0.5
		}, duration)
	end
end

function Ship:showCameraMoveTutorial()
	self.isMovePending = true

	local duration = 4
	local targetTime = love.timer.getTime() + duration

	self.blockingInterfaceID = "TutorialHint"

	local _
	_, self.blockingInterfaceIndex = Utility.UI.openInterface(
		self.player,
		"TutorialHint",
		false,
		"root",
		_MOBILE and "Tap and drag on the screen to move the camera." or "Click the left mouse button and drag around the mouse to move the camera.\nYou can also use the middle mouse button to click and drag.",
		function()
			return love.timer.getTime() > targetTime
		end,
		{ position = 'up' })

	local playerModel = Utility.Peep.getPlayerModel(self.player)
	if playerModel then
		playerModel:pokeCamera("showMove", {
			0.5,         0.5 - 1 / 16,
			0.5 - 1 / 16, 0.5,
			0.5 - 2 / 16, 0.5 - 1 / 16,
			0.5 - 1 / 16, 0.5,
			0.5,         0.5 - 1 / 16
		}, duration)
	end
end

function Ship:update(director, game)
	ShipMapPeep.update(self, director, game)

	-- if self.blockingInterfaceID and self.blockingInterfaceIndex then
	-- 	local ui = game:getUI()
	-- 	local isOpen = ui:isOpen(self.blockingInterfaceID, self.blockingInterfaceIndex)
	-- 	if not isOpen then
	-- 		self.player:removeBehavior(DisabledBehavior)

	-- 		if self.blockingInterfaceID == "CharacterCustomization" then
	-- 			local s, index = self:onMakePlayerListen()

	-- 			if s then
	-- 				self.blockingInterfaceID = "DialogBox"
	-- 				self.blockingInterfaceIndex = index
	-- 			end
	-- 		elseif self.blockingInterfaceID == "DialogBox" then
	-- 			self:showCameraMoveTutorial()
	-- 		elseif self.blockingInterfaceID == "TutorialHint" then
	-- 			if self.isMovePending then
	-- 				self.isMovePending = false
	-- 				self:showCameraZoomTutorial()
	-- 			elseif self.isZoomPending then
	-- 				self.isZoomPending = false
	-- 			else
	-- 				self.blockingInterfaceID = nil
	-- 				self.blockingInterfaceIndex = nil
	-- 			end
	-- 		else
	-- 			self.blockingInterfaceID = nil
	-- 			self.blockingInterfaceIndex = nil
	-- 		end
	-- 	end
	-- elseif not self.showedCombatHints and self.openedCharacterCustomization then
	-- 	if self.player:getState():has("KeyItem", "CalmBeforeTheStorm_PirateEncounterInitiated", 1)
	-- 	   and not self.player:getState():has("Quest", "PreTutorial")
	-- 	then
	-- 		if not _DEBUG or _MOBILE then
	-- 			self:showTip(Ship.COMBAT_HINT, self.player)

	-- 			Utility.UI.openInterface(
	-- 				self.player,
	-- 				"TutorialHint",
	-- 				false,
	-- 				"root",
	-- 				not _MOBILE and "Look at the bottom right corner.\nClick on the flashing icon to continue." or "Look at the bottom right corner.\nTap on the flashing icon to continue.",
	-- 				function()
	-- 					return not self.player:hasBehavior(DisabledBehavior)
	-- 				end,
	-- 				{ position = 'center' })
	-- 		end
	-- 	end
		
	-- 	self.showedCombatHints = true
	-- end
end

return Ship
