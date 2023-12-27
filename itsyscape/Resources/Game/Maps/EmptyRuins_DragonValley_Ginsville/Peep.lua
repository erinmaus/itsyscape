--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_DragonValley_Ginsville/Peep.lua
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
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Ginsville = Class(Map)

function Ginsville:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_DragonValley_Ginsville', ...)
end

function Ginsville:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'EmptyRuins_DragonValley_Ginsville_Ash', 'Fungal', {
		gravity = { 0, -0.5, 0 },
		wind = { 1, -2, 0 },
		colors = {
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 0.1, 0.1, 0.1, 1.0 },
			{ 1.0, 0.4, 0.0, 1.0 },
			{ 1.0, 0.5, 0.0, 1.0 },
			{ 0.9, 0.4, 0.0, 0.0 },
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.5,
		init = true
	})
end

return Ginsville
