--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_Tower/Peep.lua
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

local Tower = Class(Map)

function Tower:new(name, ...)
	Map.new(self, name or 'Tower', ...)
end

function Tower:ready(director, game)
	local player = game:getPlayer():getActor():getPeep()
	local state = player:getState()

	if not state:has("KeyItem", "CalmBeforeTheStorm_Start") then
		Utility.UI.openInterface(player, "CharacterCustomization", true)
	end
end

return Tower
