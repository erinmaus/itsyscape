--------------------------------------------------------------------------------
-- Resources/Peeps/Human/BaseHuman.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Player = require "ItsyScape.Peep.Peeps.Player"

local BaseHuman = Class(Player)

function BaseHuman:new(resource, name, ...)
	Player.new(self, resource, name or 'Human', ...)
end

return BaseHuman
