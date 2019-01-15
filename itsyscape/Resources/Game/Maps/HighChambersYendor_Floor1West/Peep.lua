--------------------------------------------------------------------------------
-- Resources/Game/Maps/HighChambersYendor_Floor1West/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BossStat = require "ItsyScape.Game.BossStat"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local Probe = require "ItsyScape.Peep.Probe"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local BossStatsBehavior = require "ItsyScape.Peep.Behaviors.BossStatsBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local ChestMimicCommon = require "Resources.Game.Peeps.ChestMimic.Common"

local HighChambersYendor = Class(Map)

HighChambersYendor.MIMIC_ANCHOR = "Anchor_Mimic"
HighChambersYendor.MIMICS = {
	{ peep = "Mimic_Angry", chance = 3 / 4 }
}
HighChambersYendor.MIMIC_CHANCE = 0.5

HighChambersYendor.MINIBOSS_CHANT_PERIOD = 10
HighChambersYendor.MINIBOSS_SOUL_SIPHON_STEP_DURATION = 2

HighChambersYendor.MINIBOSS_HEAL_PERIOD = 2

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor1West', ...)

	self:addBehavior(BossStatsBehavior)
end

function HighChambersYendor:onFinalize(director, game)
	ChestMimicCommon.spawn(
		self,
		"Anchor_MimicSpawn",
		"Anchor_AliceSpawn",
		self.MIMICS,
		self.MIMIC_CHANCE)

	self:initTorchPuzzle()
	self:initDoubleLock()
	self:initMiniboss()
end

function HighChambersYendor:initTorchPuzzle()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local torches = gameDB:getRecords("MapObjectGroup", {
		MapObjectGroup = "Puzzle_Torch",
		Map = Utility.Peep.getMap(self)
	})

	for i = 1, #torches do
		local torch = director:probe(
			self:getLayerName(),
			Probe.mapObject(torches[i]:get("MapObject")))[1]

		if torch then
			torch:poke('snuff')
			torch:listen('light', self.onTorchPuzzleLight, self, torch)
			torch:listen('snuff', self.onTorchPuzzleSnuff, self, torch)
		end
	end

	self.numTorches = #torches
	self.torchPuzzleTorchesLit = 0
end

function HighChambersYendor:initDoubleLock()
	self.doubleLockPuzzle = {}

	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local function snuffTorch(name)
		local torchMeta = gameDB:getRecord("MapObjectLocation", {
			Name = name,
			Map = Utility.Peep.getMap(self)
		})

		local torch = director:probe(
			self:getLayerName(),
			Probe.mapObject(torchMeta:get("Resource")))[1]

		if torch then
			torch:poke('snuff')
		end
	end

	snuffTorch("DoubleLockDoor_PuzzleTorch")
	snuffTorch("DoubleLockDoor_CreepRoomTorch")

	do
		local doorMeta = gameDB:getRecord("MapObjectLocation", {
			Name = "Door_DoubleLockWest",
			Map = Utility.Peep.getMap(self)
		})

		local door = director:probe(
			self:getLayerName(),
			Probe.mapObject(doorMeta:get("Resource")))[1]

		door:listen('open', self.activateDoubleLock, self, "DoubleLockDoor_CreepRoomTorch")
	end
end

function HighChambersYendor:onTorchPuzzleLight(torch)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local ghostMeta = gameDB:getRecord("MapObjectLocation", {
		Name = "PuzzleTorch_Ghost",
		Map = Utility.Peep.getMap(self)
	})

	local ghost = director:probe(
		self:getLayerName(),
		Probe.mapObject(ghostMeta:get("Resource")))[1]
	if ghost then
		ghost:poke('torchLit', { torch = torch })
	end

	self.torchPuzzleTorchesLit = self.torchPuzzleTorchesLit + 1

	if self.torchPuzzleTorchesLit >= self.numTorches then
		ghost:poke('die')

		self:activateDoubleLock("DoubleLockDoor_PuzzleTorch")
	end
end

function HighChambersYendor:activateDoubleLock(torchName)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local torchMeta = gameDB:getRecord("MapObjectLocation", {
		Name = torchName,
		Map = Utility.Peep.getMap(self)
	})

	local torch = director:probe(
		self:getLayerName(),
		Probe.mapObject(torchMeta:get("Resource")))[1]
	if torch then
		torch:poke('light')

		if not self.doubleLockPuzzle[torch] then
			Log.info("Double-lock puzzle torch '%s' lit.", torchName)

			self.doubleLockPuzzle[torch] = true
			table.insert(self.doubleLockPuzzle, torch)

			if #self.doubleLockPuzzle >= 2 then
				local doorMeta = gameDB:getRecord("MapObjectLocation", {
					Name = "Door_DoubleLockEast",
					Map = Utility.Peep.getMap(self)
				})

				local door = director:probe(
					self:getLayerName(),
					Probe.mapObject(doorMeta:get("Resource")))[1]
				if door then
					door:poke('open')
				end
			end
		end
	end
end

function HighChambersYendor:onTorchPuzzleSnuff(torch)
	self.torchPuzzleTorchesLit = self.torchPuzzleTorchesLit - 1
end

function HighChambersYendor:onDiningTableFoodEaten(e)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local chefs = gameDB:getRecords("MapObjectGroup", {
		MapObjectGroup = "Kitchen_Staff",
		Map = Utility.Peep.getMap(self)
	})

	local chefPeeps = {}
	for i = 1, #chefs do
		local chef = director:probe(
			self:getLayerName(),
			Probe.mapObject(chefs[i]:get("MapObject")))[1]
		if chef then
			local status = chef:getBehavior("CombatStatus")
			if status and status.currentHitpoints > 0 then
				table.insert(chefPeeps, chef)
			end
		end
	end

	local chef = chefPeeps[math.random(#chefPeeps)]
	if chef then
		local mashina = chef:getBehavior("MashinaBehavior")
		if mashina then
			mashina.currentState = false
		end


		local i, j, k = Utility.Peep.getTile(e.prop)

		local walk = Utility.Peep.getWalk(chef, i, j, k, 2, { asCloseAsPossible = true })
		if walk then
			local poke = CallbackCommand(e.prop.poke, e.prop, 'serve', { peep = chef })
			local idle = CallbackCommand(function()
				if mashina then
					mashina.currentState = 'idle'
				end
			end)
			local s, t, r = Utility.Peep.getTile(chef)
			local walkBack = CallbackCommand(function()
				local walk = Utility.Peep.getWalk(chef, s, t, r, 0, { asCloseAsPossible = false })
				chef:getCommandQueue():push(walk)
				chef:getCommandQueue():push(idle)
			end)
			local command = CompositeCommand(true, walk, poke, walkBack)

			if chef:getCommandQueue():interrupt(command) then
				chef:listen('die', self.tryServeTableAgain, self, chef, e)
				return
			end
		end
	end

	-- We return early if we're able to send off a chef, otherwise we try again
	-- next tick.
	self:pushPoke('diningTableFoodEaten', e)
end

function HighChambersYendor:tryServeTableAgain(chef, e)
	chef:silence('die', self.tryServeTableAgain)

	self:onDiningTableFoodEaten(e)
end

function HighChambersYendor:getMiniboss()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local cthulhuians = gameDB:getRecords("MapObjectGroup", {
		MapObjectGroup = "CthulhuianMiniboss",
		Map = Utility.Peep.getMap(self)
	})

	for i = 1, #cthulhuians do
		cthulhuians[i] = director:probe(
			self:getLayerName(),
			Probe.mapObject(cthulhuians[i]:get("MapObject")))[1]
	end

	return cthulhuians
end

function HighChambersYendor:initMiniboss()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local cthulhuians = self:getMiniboss()
	for i = 1, #cthulhuians do
		cthulhuians[i]:listen('initiateAttack', self.startMiniboss, self)
		cthulhuians[i]:listen('die', self.minibossKilled, self)
	end

	self.minibossSoulChantStat = BossStat({
		icon = 'Resources/Game/UI/Icons/Concepts/Rage.png',
		text = "Soul Siphon",
		inColor = { 0.78, 0.21, 0.21, 1.0 },
		outColor = { 0.21, 0.67, 0.78, 1.0 },
		current = 0,
		max = 5
	})

	local stats = self:getBehavior(BossStatsBehavior)
	table.insert(stats.stats, self.minibossSoulChantStat)

	self.minibossEngaged = false
	self.deadCthulhians = {}
end

function HighChambersYendor:startMiniboss(cthulhuian)
	if self.minibossEngaged then
		return
	end

	Log.info("Miniboss engaged.")

	local target = cthulhuian:getBehavior(CombatTargetBehavior)
	if target and target.actor then
		target = target.actor:getPeep()
	end

	local cthulhuians = self:getMiniboss()
	for i = 1, #cthulhuians do
		if cthulhuians[i] ~= cthulhuian then
			Utility.Peep.attack(cthulhuians[i], target)
		end
	end

	local director = self:getDirector()
	local game = director:getGameInstance()

	local _, _, interface = Utility.UI.openInterface(
		game:getPlayer():getActor():getPeep(),
		"BossHUD",
		false,
		unpack(cthulhuians))
	self.bossHUD = interface

	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local cthulhuians = self:getMiniboss()
	for i = 1, #cthulhuians do
		cthulhuians[i]:silence('initiateAttack', self.startMiniboss)
	end

	self.minibossEngaged = true
	self.minibossChantTimer = HighChambersYendor.MINIBOSS_CHANT_PERIOD
end

function HighChambersYendor:minibossBeginChanting()
	Log.info("Starting chant...")

	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local center = gameDB:getRecord("MapObjectLocation", {
		Name = "Anchor_SoulSiphon",
		Map = Utility.Peep.getMap(self)
	})

	local stage = director:getGameInstance():getStage()

	if center then
		local centerX, centerZ = center:get("PositionX"), center:get("PositionZ")

		local i, j, k
		do
			local map
			do
				local _, layer = stage:getMapScript(Utility.Peep.getMap(self).name)
				map = director:getMap(layer)

				k = layer
			end

			local _, s, t = map:getTileAt(centerX, centerZ)
			i = s
			j = t
		end

		if i and j and k then
			local cthulhuians = self:getMiniboss()
			for i = 1, #cthulhuians do
				local status = cthulhuians[i]:getBehavior(CombatStatusBehavior)
				if status.currentHitpoints <= 0 then
					self.minibossChantTimer = HighChambersYendor.MINIBOSS_CHANT_PERIOD
					return
				end
			end

			for index = 1, #cthulhuians do
				local angle = (index / #cthulhuians) * math.pi * 2
				local s = math.cos(angle) * 3
				local t = math.sin(angle) * 3

				cthulhuians[index]:removeBehavior(CombatTargetBehavior)

				local doneWalking = function()
					if self.currentWalking then
						self.currentWalking = self.currentWalking - 1
					end
				end

				local walk, m = Utility.Peep.getWalk(cthulhuians[index], i + s, t + j, k, 1)
				if not walk then
					Log.warn('Cthulhuian pathing failed: %s', m)
				else
					local path = walk:getPath()
					for i = 1, path:getNumNodes() do
						local node = path:getNodeAtIndex(i)
						node.onInterrupt:register(doneWalking)
					end

					cthulhuians[index]:getCommandQueue():push(walk)
				end

				cthulhuians[index]:listen('initiateAttack', self.minibossStopChanting, self, false)

				cthulhuians[index]:getCommandQueue():push(CallbackCommand(doneWalking))

				Log.info("Moving Cthulhuian %d to %d, %d.", index, i + s, t + j)
			end

			self.currentWalking = #cthulhuians
			self.currentPulledAway = 0
		end
	end

	self.minibossChantTimer = math.huge
	self.minibossSoulSiphonTick = HighChambersYendor.MINIBOSS_SOUL_SIPHON_STEP_DURATION
end

function HighChambersYendor:minibossStopChanting(force, cthulhuian)
	self.currentPulledAway = self.currentPulledAway + 1

	cthulhuian:silence('initiateAttack', self.minibossStopChanting, self)
end

function HighChambersYendor:minibossContinueChanting()
	local director = self:getDirector()

	if self.currentWalking and self.currentWalking > 0 then
		self.minibossSoulSiphonTick = HighChambersYendor.MINIBOSS_SOUL_SIPHON_STEP_DURATION
		return
	end

	self.currentWalking = nil

	local cthulhuians = self:getMiniboss()

	if self.currentPulledAway >= #cthulhuians then
		self.minibossSoulChantStat.currentValue = 0
		Log.info("Soul siphon prevented!")

		self.minibossChantTimer = HighChambersYendor.MINIBOSS_CHANT_PERIOD

		self.minibossSoulSiphonTick = nil

		return
	end

	if self.minibossSoulChantStat.currentValue >= self.minibossSoulChantStat.maxValue then
		self.minibossSoulChantStat.currentValue = 0
		Log.info("SOUL SIPHON!!!")

		for i = 1, #cthulhuians do
			local actor = cthulhuians[i]:getBehavior(ActorReferenceBehavior)
			if actor and actor.actor then
				actor = actor.actor
				actor:flash("Message", 1, "SOUL SIPHON!")
			end
		end

		self.minibossChantTimer = HighChambersYendor.MINIBOSS_CHANT_PERIOD

		self.minibossSoulSiphonTick = nil

		local peeps = director:probe(
			self:getLayerName(),
			function(p)
				return p:hasBehavior(PlayerBehavior)
			end)
		for i = 1, #peeps do
			local health = peeps[i]:getBehavior(CombatStatusBehavior)
			if health then
				health = math.max(math.floor(health.currentHitpoints / 2) - 1, 1)
			end

			peeps[i]:poke('hit', AttackPoke({
				damage = health
			}))
		end

		for i = 1, #cthulhuians do
			Utility.Peep.attack(cthulhuians[i], peeps[math.random(#peeps)])
		end

		return
	end

	self.minibossSoulChantStat.currentValue = math.min(
		self.minibossSoulChantStat.currentValue + 1,
		self.minibossSoulChantStat.maxValue)

	local MESSAGES = {
		"...ph'nglui mglw'nafh...",
		"...Cthulhu R'lyeh...",
		"...wgah'nagl fhtagn..."
	}

	for i = 1, #cthulhuians do
		local actor = cthulhuians[i]:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			actor = actor.actor
			actor:flash("Message", 1, MESSAGES[(i - 1 + self.minibossSoulChantStat.currentValue - 1) % #MESSAGES + 1])
		end
	end

	self.minibossSoulSiphonTick = HighChambersYendor.MINIBOSS_SOUL_SIPHON_STEP_DURATION
end

function HighChambersYendor:minibossKilled(cthulhuian)
	-- Prevent the siphon
	self.minibossSoulSiphonTick = nil

	self.minibossRezzTick = math.min(
		self.minibossRezzTick or math.huge,
		HighChambersYendor.MINIBOSS_HEAL_PERIOD)
	self.deadCthulhians[cthulhuian] = true
end

function HighChambersYendor:performMinibossRezz()
	local cthulhuians = self:getMiniboss()

	local dead = { n = 0 }
	do
		for cthulhuian in pairs(self.deadCthulhians) do
			local status = cthulhuian:getBehavior(CombatStatusBehavior)
			if status.currentHitpoints >= status.maximumHitpoints then
				status.currentHitpoints = status.maximumHitpoints
				cthulhuian:poke('resurrect')

				Log.info("Cthulhuian parasite resurrected.")
			else
				dead[cthulhuian] = true
				dead.n = dead.n + 1
			end
		end
	end

	if dead.n == #cthulhuians then
		Log.info("All Cthulhuian parasites slain. Victory!")

		self.minibossRezzTick = nil
		self.minibossChantTimer = math.huge

		self:getDirector():getGameInstance():getUI():closeInstance(self.bossHUD)

		self:giveMinibossLoot()
	else
		local hitPoints = (#cthulhuians - dead.n) * 2
		for i = 1, #cthulhuians do
			if dead[cthulhuians[i]] then
				cthulhuians[i]:poke('heal', {
					hitPoints = hitPoints
				})
			end
		end

		for i = 1, #cthulhuians do
			if not dead[cthulhuians[i]] then
				local actor = cthulhuians[i]:getBehavior(ActorReferenceBehavior)
				if actor and actor.actor then
					actor = actor.actor
					actor:flash("Message", 1, "Cthulhu h'th mgul'ln...")
				end
			end
		end

		if dead.n ~= 0 then
			self.minibossRezzTick = HighChambersYendor.MINIBOSS_HEAL_PERIOD
		else
			self.minibossRezzTick = false
		end

		self.minibossChantTimer = HighChambersYendor.MINIBOSS_CHANT_PERIOD / 2
	end

	dead.n = nil
	self.deadCthulhians = dead
end

function HighChambersYendor:giveMinibossLoot()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local siphon = gameDB:getRecord("MapObjectLocation", {
		Name = "SoulSiphon",
		Map = Utility.Peep.getMap(self)
	})

	if siphon then
		siphon = director:probe(
			self:getLayerName(),
			Probe.mapObject(siphon:get("Resource")))[1]

		if siphon then
			siphon:poke('materialize', {
				count = math.random(20, 30),
				dropTable = gameDB:getResource("HighChambersYendor_SoulSiphon_Rewards", "DropTable"),
				peep = director:getGameInstance():getPlayer():getActor():getPeep(),
				chest = siphon
			})
		end
	end

	local player = director:getGameInstance():getPlayer():getActor():getPeep()
	player:getState():give(
		"Item",
		"HighChambersYendor_BloodyIronKey",
		1,
		{ ['item-inventory'] = true, ['item-drop-excess'] = true })
end

function HighChambersYendor:update(director, game)
	Map.update(self, director, game)

	if self.minibossEngaged then
		self.minibossChantTimer = self.minibossChantTimer - game:getDelta()
		if self.minibossChantTimer <= 0 then
			self:minibossBeginChanting()
		end

		if self.minibossSoulSiphonTick then
			self.minibossSoulSiphonTick = self.minibossSoulSiphonTick - game:getDelta()
			if self.minibossSoulSiphonTick <= 0 then
				self:minibossContinueChanting()
			end
		end

		if self.minibossRezzTick then
			self.minibossRezzTick = self.minibossRezzTick - game:getDelta()
			if self.minibossRezzTick < 0 then
				self:performMinibossRezz()
			end
		end
	end
end

return HighChambersYendor
