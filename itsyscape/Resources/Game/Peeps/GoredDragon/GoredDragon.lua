--------------------------------------------------------------------------------
-- Resources/Peeps/GoredDragon/GoredDragon.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Probe = require "ItsyScape.Peep.Probe"
local BaseDragon = require "Resources.Game.Peeps.Dragon.BaseDragon"

local GoredDragon = Class(BaseDragon)
GoredDragon.EQUIPMENT_SLOT_BONES      = "bones"
GoredDragon.EQUIPMENT_SLOT_MUSCLE     = "muscle"

function GoredDragon:new(...)
	BaseDragon.new(self, ...)

	Utility.Peep.makeArtisanStation(self)
end

function GoredDragon:ready(director, game)
	BaseDragon.ready(self, director, game)

	Utility.Peep.Creep.applySkin(
		self,
		self.EQUIPMENT_SLOT_BONES,
		Equipment.SKIN_PRIORITY_BASE,
		"GoredDragon/Bones.lua")

	Utility.Peep.Creep.applySkin(
		self,
		self.EQUIPMENT_SLOT_MUSCLE,
		Equipment.SKIN_PRIORITY_BASE,
		"GoredDragon/Muscle.lua")

	self:pushPoke("spawnGuts")

	Utility.Peep.equipXWeapon(self, "Dragon_ChargedDragonfyre")
end

function GoredDragon:onSpawnGuts()
	local mapScript = Utility.Peep.getMapScript(self)

	local gutsLayer, gutsMapScript = Utility.Map.spawnMap(mapScript, "GoredDragon", Vector(0, 1000, 0))
	Utility.Peep.disable(gutsMapScript)

	gutsMapScript:listen("load", function()
		self.gutsLayer = gutsLayer
		self.gutsMapScript = gutsMapScript
		self:pushPoke("gutsSpawned")
	end)
end

function GoredDragon:onGutsSpawned()
	Utility.Map.setTeleportal(
		self,
		self.gutsMapScript,
		"Anchor_Spawn")

	local instance = Utility.Peep.getInstance(self)
	local group = instance:getMapGroup(self.gutsLayer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:updateSky(instance, group, {
		hasSkybox = false
	})
end

function GoredDragon:onPoof()
	if self.gutsLayer then
		self:getDirector():getGameInstance():getStage():unloadLayer(self.gutsLayer)
		self.gutsLayer = nil
	end
end

function GoredDragon:updateTeleportal()
	if not self.gutsLayer then
		return
	end

	local hits = self:getDirector():probe(
		self:getLayerName(),
		Probe.layer(self.gutsLayer),
		Probe.namedMapObject("GoredDragonIntestines"))

	for _, hit in ipairs(hits) do
		Utility.Map.setTeleportal(
			hit,
			Utility.Peep.getMapScript(self),
			Utility.Peep.getPosition(self))
	end
end

function GoredDragon:update(...)
	BaseDragon.update(self, ...)

	self:updateTeleportal()
end

return GoredDragon
