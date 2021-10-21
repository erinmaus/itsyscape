--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle_Floor2/Peep.lua
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
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"

local Castle = Class(Map)

function Castle:new(resource, name, ...)
	Map.new(self, resource, name or 'Rumbridge_Castle_Floor2', ...)

	self:addBehavior(MapOffsetBehavior)
end

function Castle:onLoad(filename, args, layer)
	Map.onLoad(self, filename, args, layer)

	Utility.Map.spawnMap(self, "Rumbridge_Castle_Floor1", Vector.ZERO, { isLayer = true })

	local offset = self:getBehavior(MapOffsetBehavior)
	offset.offset = Vector(0, 12.2, 0)
end

return Castle
