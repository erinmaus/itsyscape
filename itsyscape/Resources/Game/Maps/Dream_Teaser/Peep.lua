--------------------------------------------------------------------------------
-- Resources/Game/Maps/Dream_Teaser/Peep.lua
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

local Dream = Class(Map)

function Dream:new(resource, name, ...)
	Map.new(self, resource, name or 'Dream_Teaser', ...)
end

function Dream:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Dream_Teaser_Bubbles', 'Fungal', {
		gravity = { 0, 3, 0 },
		wind = { 0, 0, 0 },
		colors = {
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 0.0, 0.0, 0.0, 1.0 },
			{ 1.0, 1.0, 1.0, 1.0 },
		},
		minHeight = -10,
		maxHeight = 0,
		ceiling = 20,
		heaviness = 0.5
	})
end

function Dream:update(...)
	Map.update(self, ...)

	if love.keyboard.isDown('space') then
		local director = self:getDirector()
		local stage = director:getGameInstance():getStage()
		local emptyKing = director:probe(self:getLayerName(), function(peep)
			local r = Utility.Peep.getResource(peep)
			return r and r.name == "TheEmptyKing_FullyRealized_Cutscene"
		end)[1]
		local axe = director:probe(self:getLayerName(), function(peep)
			local r = Utility.Peep.getResource(peep)
			return r and r.name == "TheEmptyKingsExecutionAxe"
		end)[1]

		stage:fireProjectile("TheEmptyKingsExecutionerAxe", emptyKing, axe)
	end
end

return Dream
