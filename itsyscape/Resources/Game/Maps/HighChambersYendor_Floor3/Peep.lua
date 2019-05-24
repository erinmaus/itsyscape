--------------------------------------------------------------------------------
-- Resources/Game/Maps/HighChambersYendor_Floor3/Peep.lua
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
local HighChambersYendorCommon = require "Resources.Game.Peeps.HighChambersYendor.Common"

local HighChambersYendor = Class(Map)

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor3', ...)
end

function HighChambersYendor:onFinalize(director, game)
	local director = self:getDirector()
	local hits = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("LightLock1"))
	if #hits >= 1 then
		hits[1]:listen('lightHit', self.openWaterfallRoom, self)
		hits[1]:listen('lightFade', self.closeWaterfallRoom, self)
	end

	HighChambersYendorCommon.initLever(self, "HighChambersYendor_Lever3")
end

function HighChambersYendor:openWaterfallRoom()
	Log.info('Opening waterfall room...')
	local director = self:getDirector()
	local hits = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("Door_Waterfall"))
	if #hits >= 1 then
		hits[1]:poke('open', true)
	end
end

function HighChambersYendor:closeWaterfallRoom()
	Log.info('Closing waterfall room...')
	local director = self:getDirector()
	local hits = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("Door_Waterfall"))
	if #hits >= 1 then
		hits[1]:poke('close')
	end
end

return HighChambersYendor
