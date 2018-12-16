--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"

local Map = Class(Peep)

function Map:new(resource, name, ...)
	Peep.new(self, name or 'Map', ...)

	Utility.Peep.setResource(self, resource)

	self:addPoke('load')
end

function Map:ready(director, game)
	Peep.ready(self, director, game)

	Utility.Peep.setNameMagically(self)
end

return Map
