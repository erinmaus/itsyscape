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
local Map = require "ItsyScape.Peep.Peeps.Map"

local Mine = Class(Map)

function Mine:onPlayerEnter(player)
	player:pokeCamera("mapRotationStick")
end

function Mine:onPlayerLeave(player)
	player:pokeCamera("mapRotationUnstick")
end

return Mine
