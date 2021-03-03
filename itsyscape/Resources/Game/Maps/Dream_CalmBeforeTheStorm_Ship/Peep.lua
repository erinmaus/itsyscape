--------------------------------------------------------------------------------
-- Resources/Game/Maps/Dream_CalmBeforeTheStorm_Ship/Peep.lua
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
	Map.new(self, resource, name or 'Dream_CalmBeforeTheStorm_Ship', ...)
end

function Dream:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	local stage = self:getDirector():getGameInstance():getStage()
	stage:forecast(layer, 'Dream_CalmBeforeTheStorm_Ship_Bubbles', 'Fungal', {
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

	self:prepShip()
end

function Dream:prepShip()
	Utility.spawnMapAtAnchor(self, "Ship_IsabelleIsland_Pirate", "Anchor_Ship")
end

return Dream
