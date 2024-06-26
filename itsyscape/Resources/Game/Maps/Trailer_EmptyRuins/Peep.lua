--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_EmptyRuins/Peep.lua
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
local Map = require "ItsyScape.Peep.Peeps.Map"

local Trailer = Class(Map)
Trailer.SISTINE_LOCATION = Vector(0, 0, -64)

function Trailer:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_Trailer', ...)
end

function Trailer:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'EmptyRuins_Trailer_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.7, 0.8, 0.2, 1.0 },
			{ 0.4, 0.2, 0.8, 1.0 }
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})

	local sistineLayer, sistineScript = Utility.Map.spawnMap(
		self, "EmptyRuins_SistineOfTheSimulacrum_Outside", Trailer.SISTINE_LOCATION, { isLayer = true })
	self.sistineLayer = sistineLayer
end

return Trailer
