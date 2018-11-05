--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BlockingProp.lua
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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local BlockingProp = Class(Prop) 

function BlockingProp:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(1, 2, 1)
end

function BlockingProp:spawnOrPoof(mode)
	local game = self:getDirector():getGameInstance()
	local position = self:getBehavior(PositionBehavior)
	local size = self:getBehavior(SizeBehavior)
	if position then
		local map = self:getDirector():getMap(position.layer or 1)
		if map then
			local p = position.position
			local halfSize = size.size / 2

			for x = p.x - halfSize.x, p.x + halfSize.x do
				for z = p.z - halfSize.z, p.z + halfSize.z do
					local tile, i, j = map:getTileAt(x, z)

					if mode == 'spawn' then
						tile:pushBlocking()
					elseif mode == 'poof' then
						tile:popBlocking()
					end
				end
			end
		end
	end
end

return BlockingProp
