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
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local ChestMimicCommon = require "Resources.Game.Peeps.ChestMimic.Common"

local HighChambersYendor = Class(Map)

HighChambersYendor.MIMIC_ANCHOR = "Anchor_Mimic"
HighChambersYendor.MIMICS = {
	{ peep = "Mimic_Angry", chance = 3 / 4 }
}
HighChambersYendor.MIMIC_CHANCE = 0.5

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor1West', ...)
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

return HighChambersYendor
