--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicBuilding.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BasicBuilding = Class(Prop) 

function BasicBuilding:new(...)
	Prop.new(self, ...)

	self.propState = {}
end

function BasicBuilding:spawnOrPoofTile()
	-- Nothing.
end

function BasicBuilding:setPropState(value)
	self.propState = value
end

function BasicBuilding:getPropState()
	return self.propState
end

return BasicBuilding
