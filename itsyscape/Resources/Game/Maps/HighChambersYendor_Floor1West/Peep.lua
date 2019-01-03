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

function HighChambersYendor:onTorchPuzzleLight(torch)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local ghost = gameDB:getRecord("MapObjectLocation", {
		Name = "PuzzleTorch_Ghost",
		Map = Utility.Peep.getMap(self)
	})

	local ghost = director:probe(
		self:getLayerName(),
		Probe.mapObject(ghost:get("Resource")))[1]
	if ghost then
		ghost:poke('torchLit', { torch = torch })
	end

	self.torchPuzzleTorchesLit = self.torchPuzzleTorchesLit + 1

	if self.torchPuzzleTorchesLit >= self.numTorches then
		Log.info("All torches lit!")
		ghost:poke('die')
	end
end

function HighChambersYendor:onTorchPuzzleSnuff(torch)
	self.torchPuzzleTorchesLit = self.torchPuzzleTorchesLit - 1
end

return HighChambersYendor
