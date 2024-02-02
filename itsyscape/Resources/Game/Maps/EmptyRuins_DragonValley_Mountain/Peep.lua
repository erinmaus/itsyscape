--------------------------------------------------------------------------------
-- Resources/Game/Maps/EmptyRuins_DragonValley_Mountain/Peep.lua
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

local DragonValley = Class(Map)

function DragonValley:new(resource, name, ...)
	Map.new(self, resource, name or 'EmptyRuins_DragonValley_Mountain', ...)
end

function DragonValley:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_DragonValley_Mountain_Snow', 'Fungal', {
		gravity = { 0, -10, 0 },
		wind = { -12, 0, -12 },
		colors = {
			{ 1, 1, 1, 1 }
		},
		minHeight = 10,
		maxHeight = 50,
		heaviness = 0.25
	})
end

return DragonValley
