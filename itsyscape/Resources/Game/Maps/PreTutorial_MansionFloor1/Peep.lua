--------------------------------------------------------------------------------
-- Resources/Game/Maps/PreTutorial_MansionFloor1/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Mansion = Class(Map)
Mansion.MIN_LIGHTNING_PERIOD = 3
Mansion.MAX_LIGHTNING_PERIOD = 6
Mansion.LIGHTNING_TIME = 0.5
Mansion.MAX_AMBIENCE = 2

function Mansion:new(resource, name, ...)
	Map.new(self, resource, name or 'PreTutorial_MansionFloor1', ...)
end

function Mansion:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'PreTutorial_MansionFloor1_Fungus', 'Fungal', {
		gravity = { 0, -1, 0 },
		wind = { -1, 0, 0 },
		colors = {
			{ 0.43, 0.54, 0.56, 1.0 },
			{ 0.63, 0.74, 0.76, 1.0 }
		},
		minHeight = 12,
		maxHeight = 20,
		heaviness = 0.25
	})

	self.lightning = self:getDirector():probe(
		self:getLayerName(),
		Probe.namedMapObject("Light_Lightning"))[1]
	self.lightningTime = 0

	if not args.isLayer then
		self.zombiButler = self:getDirector():probe(
			self:getLayerName(),
			Probe.namedMapObject("Hans"))[1]
	end

	self:zap()
end

function Mansion:onPlayerEnter(player)
	if not self.zombiButler then
		return
	end

	player = player:getActor():getPeep()

	if player:getState():has("KeyItem", "PreTutorial_TalkedToButler1") then
		if self.zombiButler:getCurrentTarget() then
			self.zombiButler:giveHint("Oh dear me, looks like someone else needs help!")
		end

		self.zombiButler:poke('followPlayer', player)
	end

	Utility.Quest.listenForAction(player, "Item", "CopperBar", "Smelt", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
		player:getState():give("KeyItem", "PreTutorial_SmeltCopperBar")
	end)

	Utility.Quest.listenForAction(player, "Item", "CopperAmulet", "Smith", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
		player:getState():give("KeyItem", "PreTutorial_SmeltCopperBar")
		player:getState():give("KeyItem", "PreTutorial_SmithCopperAmulet")
	end)

	Utility.Quest.listenForAction(player, "Item", "GhostspeakAmulet", "Enchant", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
		player:getState():give("KeyItem", "PreTutorial_SmeltCopperBar")
		player:getState():give("KeyItem", "PreTutorial_SmithCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_EnchantedCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_MadeGhostspeakAmulet")
	end)

	Utility.Quest.listenForItem(player, "GhostspeakAmulet", function()
		player:getState():give("KeyItem", "PreTutorial_MineCopper")
		player:getState():give("KeyItem", "PreTutorial_SmeltCopperBar")
		player:getState():give("KeyItem", "PreTutorial_SmithCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_EnchantedCopperAmulet")
		player:getState():give("KeyItem", "PreTutorial_MadeGhostspeakAmulet")
	end)
end

function Mansion:onPlayerLeave(player)
	if not self.zombiButler then
		return
	end

	if not player:getActor() then
		return
	end

	player = player:getActor():getPeep()

	if self.zombiButler:getCurrentTarget() == player then
		self.zombiButler:giveHint("Be seeing you later!")
		self.zombiButler:poke('followPlayer', nil)

		for _, player in Utility.Peep.getInstance(self):iteratePlayers() do
			self:onPlayerEnter(player)
			break
		end
	end
end

function Mansion:zap()
	self.wait = math.random() * (self.MAX_LIGHTNING_PERIOD - self.MIN_LIGHTNING_PERIOD) + self.MIN_LIGHTNING_PERIOD
end

function Mansion:boom()
	local instance = Utility.Peep.getInstance(self)
	for _, player in instance:iteratePlayers() do
		local actor = player:getActor()
		if actor then
			local animation = CacheRef(
				"ItsyScape.Graphics.AnimationResource",
				"Resources/Game/Animations/SFX_LightningStrike/Script.lua")
			actor:playAnimation(
				'x-haunted-mansion-lightning',
				math.huge,
				animation)
		end
	end
end

function Mansion:update(director, game)
	Map.update(self, director, game)

	local delta = game:getDelta()

	if self.lightningTime > 0 then
		self.lightningTime = self.lightningTime - delta

		local mu = math.min(math.max(self.lightningTime / self.LIGHTNING_TIME, 0), 1)

		self.lightning:setAmbience(self.MAX_AMBIENCE * mu)
	else
		self.wait = self.wait - delta
		if self.wait <= 0 then
			self:zap()
			self:boom()
			self.lightningTime = self.LIGHTNING_TIME
		end
	end
end

return Mansion
