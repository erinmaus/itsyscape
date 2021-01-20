--------------------------------------------------------------------------------
-- Resources/Game/Maps/Trailer_Svalbard/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Map = require "ItsyScape.Peep.Peeps.Map"

local Svalbard = Class(Map)

function Svalbard:new(resource, name, ...)
	Map.new(self, resource, name or 'Trailer_Svalbard', ...)
end

function Svalbard:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Trailer_Svalbard_Base', 'Fungal', {
		gravity = { 0, -10, 0 },
		wind = { -6, 0, 0 },
		colors = {
			{ 1, 1, 1, 1 }
		},
		minHeight = 20,
		maxHeight = 25,
		heaviness = 0.25
	})
end

return Svalbard
