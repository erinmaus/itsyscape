--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_Downtown/Peep.lua
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
local Probe = require "ItsyScape.Peep.Probe"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TeleportalBehavior = require "ItsyScape.Peep.Behaviors.TeleportalBehavior"

local Downtown = Class(Map)
Downtown.SISTINE_LOCATION = Vector(0, 0, -128)

function Downtown:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_Downtown', ...)
end

function Downtown:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'EmptyRuins_Downtown_Bubbles', 'Fungal', {
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
		self, "EmptyRuins_SistineOfTheSimulacrum_Outside", Downtown.SISTINE_LOCATION, { isLayer = true })
	self.sistineLayer = sistineLayer

	Utility.Map.spawnMap(self, "EmptyRuins_Downtown_Floor2", Vector(0, 4, 0), { isLayer = true })
	Utility.Map.spawnMap(self, "EmptyRuins_Downtown_Floor3", Vector(0, 7, 0), { isLayer = true })
end

return Downtown
