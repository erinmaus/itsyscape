--------------------------------------------------------------------------------
-- Resources/Peeps/Props/FurnitureProp.lua
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

local FurnitureProp = Class(Prop) 

function FurnitureProp:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)
end

function FurnitureProp:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:pushFlag('impassable')
		tile:pushFlag('shoot')
	elseif mode == 'poof' then
		tile:popFlag('impassable')
		tile:popFlag('shoot')
	end
end

return FurnitureProp
