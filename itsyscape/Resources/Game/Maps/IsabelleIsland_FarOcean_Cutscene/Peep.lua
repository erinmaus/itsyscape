--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_FarOcean_Cutscene/Peep.lua
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
local Cutscene = require "ItsyScape.Game.Cutscene"
local Color = require "ItsyScape.Graphics.Color"
local Probe = require "ItsyScape.Peep.Probe"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local FarOcean = Class(Map)

function FarOcean:new(resource, name, ...)
	Map.new(self, resource, name or 'IsabelleIsland_FarOcean_Cutscene', ...)
end

function FarOcean:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	self:prepShip()

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'IsabelleIsland_FarOcean_Cutscene_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 3, 0, 0 },
		colors = {
			{ 0.3, 0.3, 0.6, 0.5 }
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})
end

function FarOcean:prepShip()
	local ship = Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_Ship_Spawn")
	ship:listen('ready', function()
		Utility.Map.playCutscene(self, "IsabelleIsland_FarOcean_Sink")
	end)
end

function FarOcean:prepHans()
	local actor = Utility.spawnMapObjectAtAnchor(self, "Hans", "Anchor_Hans_Spawn", 0)
	actor:getPeep():poke('changeFloor', -1) -- Disable his area-aware talking
end

function FarOcean:onPrepAzathoth()
	self:prepHans()

	local layer, azathoth = Utility.Map.spawnMap(
		self, "PreTutorial_MansionFloor1", Vector(1000, 0, 0))
	azathoth:listen('ready', function()
		azathoth:addBehavior(DisabledBehavior)

		self:pushPoke('openPortal', layer)
	end)
end

function FarOcean:onOpenPortal(layer)
	local _, prop = Utility.spawnMapObjectAtAnchor(self, "AzathothPortal", "Anchor_Portal", 0)
	local portal = prop:getPeep()
	portal:setColor(Color(1, 0.4, 0.4, 1))

	local tele = portal:getBehavior(TeleportalBehavior)
	tele.i = 21
	tele.j = 28
	tele.layer = layer

	Utility.Map.playCutscene(self, "IsabelleIsland_FarOcean_Portal")
end

function FarOcean:onMovePlayer()
	local player = Utility.Peep.getPlayer(self)

	-- Kurse the player for failing to teleport.
	player:getState():give("KeyItem", "CalmBeforeTheStorm_KursedByCthulhu", 1)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:movePeep(player, "PreTutorial_MansionFloor1?kursed=1", "Anchor_Spawn")
end

function FarOcean:onDarken(num)
	local director = self:getDirector()
	local hits = director:probe(self:getLayerName(), Probe.namedMapObject("Light_Fog"))
	local fog = hits[1]
	if fog then
		fog:setNearDistance(math.max(fog:getNearDistance() - num, 1))
		fog:setFarDistance(math.max(fog:getFarDistance() - num, 1))
	else
		Log.warn("Couldn't find fog; can't darken map for kurse.")
	end
end

function FarOcean:update(...)
	Map.update(self, ...)
end

return FarOcean
