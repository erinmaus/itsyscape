--------------------------------------------------------------------------------
-- Resources/Game/Maps/ViziersRock_Sewers_Floor3/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local Common = require "Resources.Game.Peeps.ViziersRock.SewersCommon"

local Sewers = Class(Map)

function Sewers:new(resource, name, ...)
	Map.new(self, resource, name or 'ViziersRock_Sewers_Floor3', ...)
end

function Sewers:onLoad(...)
	Map.onLoad(self, ...)

	self:initBoss()

	-- This needs to be a push because the rotation of the valve in the boss room is NOT identity.
	-- The logic to settle the initial direction of the valve, THEN we can initialize the default
	-- state of the valves and resume updating the valves.
	--
	-- **This does not apply to any other sewers map because the valves ARE identity.**
	self:pushPoke('initValves')
	self.areValvesReady = false
end

function Sewers:onInitValves()
	if not Common.hasValveBeenOpenedOrClosed(self, Common.MARK_CIRCLE) then
		Common.closeValve(self, Common.MARK_CIRCLE)
	end

	-- First floor triangle/square valve
	do
		if not Common.hasValveBeenOpenedOrClosed(self, Common.MARK_TRIANGLE) then
			Common.openValve(self, Common.MARK_TRIANGLE)
		end

		if not Common.hasValveBeenOpenedOrClosed(self, Common.MARK_SQUARE) then
			Common.closeValve(self, Common.MARK_SQUARE)
		end
	end

	self.areValvesReady = true
end

function Sewers:initBoss()
	local bossActor = Utility.spawnMapObjectAtAnchor(self, "AncientKaradon", "Anchor_AncientKaradon_Spawn", 0)
	if not bossActor then
		Log.error("Couldn't spawn ancient karadon boss!")
		return
	end

	local bossPeep = bossActor:getPeep()
	bossPeep:listen("swim", self.moveBoss, self)
	bossPeep:listen("die", self.onBossDie, self)
end

function Sewers:moveBoss(boss)
	local gameDB = self:getDirector():getGameDB()

	local anchors = gameDB:getRecords("MapObjectGroup", {
		MapObjectGroup = "AncientKaradon_Spawns",
		Map = Utility.Peep.getMapResource(self)
	})

	for i = 1, #anchors do
		local mapObject = gameDB:getRecord("MapObjectLocation", {
			Map = Utility.Peep.getMapResource(self),
			Resource = anchors[i]:get("MapObject")
		})

		anchors[i] = mapObject
	end

	if self.lastBossMapObject then
		for i = 1, #anchors do
			if anchors[i]:get("Resource").id.value == self.lastBossMapObject.id.value then
				table.remove(anchors, i)
				break
			end
		end
	end

	local targetAnchor = anchors[love.math.random(#anchors)]
	self.lastBossMapObject = targetAnchor:get("Resource")

	local fishingSpotPosition = Vector(Utility.Map.getAnchorPosition(
		self:getDirector():getGameInstance(),
		Utility.Peep.getMapResource(self),
		targetAnchor:get("Name")))

	Utility.Peep.setPosition(boss, fishingSpotPosition)

	local bossMap = Utility.Peep.getMap(boss)
	local bossPosition = bossMap:getTileCenter(Utility.Peep.getTile(boss))

	Utility.Peep.setPosition(boss, Vector(bossPosition.x, bossPosition.y - boss.DIVE_OFFSET_Y, bossPosition.z))

	local fishSpotProp = Utility.spawnPropAtPosition(self, "AncientKaradonFishingSpotProxy", fishingSpotPosition.x, fishingSpotPosition.y, fishingSpotPosition.z, 0)
	if not fishSpotProp then
		Log.warn("Couldn't spawn ancient karadon fishing spot!")
	end

	fishSpotProp:getPeep():listen('resourceObtained', self.angerBoss, self, boss)

	Utility.Peep.setResource(boss, gameDB:getResource("AncientKaradon_Unattackable", "Peep"))
	Utility.Peep.setNameMagically(boss)
end

function Sewers:angerBoss(boss, fishingSpot, p)
	local gameDB = self:getDirector():getGameDB()

	boss:poke("rise", p.peep)

	local function onBossTarget()
		Utility.Peep.setResource(boss, gameDB:getResource("AncientKaradon", "Peep"))
		Utility.Peep.setNameMagically(boss)

		Utility.Peep.attack(boss, p.peep)

		boss:silence('target', onBossTarget)
	end
	boss:listen('target', onBossTarget)

	Utility.Peep.poof(fishingSpot)
end

function Sewers:onBossDie(boss)
	local instance = Utility.Peep.getInstance(self)
	Utility.Peep.notify(instance, "The ancient karadon spit up an adamant key...")
	Utility.Peep.notify(instance, "The chest to the north has items in it for you!")

	local chest = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("RewardChest"))[1]
	if not chest then
		Log.warn("Reward chest not found; cannot reward players!")
	end

	for _, player in instance:iteratePlayers() do
		local playerPeep = player:getActor():getPeep()

		playerPeep:getState():give("KeyItem", "ViziersRock_Sewers_KilledKaradon")

		playerPeep:getState():give(
			"Item",
			"ViziersRock_Sewers_AdamantKey",
			1,
			{ ['item-inventory'] = true, ['item-drop-excess'] = true, ['force-item-drop'] = true })

		if chest then
			local gameDB = self:getDirector():getGameDB()

			chest:poke('materialize', {
				count = love.math.random(75, 125),
				dropTable = gameDB:getResource("AncientKaradon_Primary", "DropTable"),
				peep = playerPeep,
				boss = boss,
				chest = chest
			})

			chest:poke('materialize', {
				count = love.math.random(4, 8),
				dropTable = gameDB:getResource("AncientKaradon_Secondary", "DropTable"),
				peep = playerPeep,
				boss = boss,
				chest = chest
			})
		end
	end
end

function Sewers:update(...)
	Map.update(self, ...)

	if self.areValvesReady then
		Common.updateValve(self, "Valve_Circle", Common.MARK_CIRCLE, Common.MARK_NONE)
	end
end

return Sewers
