--------------------------------------------------------------------------------
-- Resources/Peeps/Props/BasicDoor.lua
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

local BasicDoor = Class(Prop)

function BasicDoor:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(4, 4, 2)

	self:addPoke('open')
	self:addPoke('close')

	self.isOpen = false
end

function BasicDoor:getIsOpen()
	return self.isOpen
end

function BasicDoor:onOpen(...)
	self.isOpen = true

	self:spawnOrPoof('poof')
end

function BasicDoor:onClose(...)
	self.isOpen = false

	self:spawnOrPoof('spawn')
end

function BasicDoor:spawnOrPoof(mode)
	local game = self:getDirector():getGameInstance()
	local position = self:getBehavior(PositionBehavior)
	local size = self:getBehavior(SizeBehavior)
	if position then
		local map = game:getStage():getMap(position.layer or 1)
		if map then
			local p = position.position
			local halfSize = size.size / 2

			for x = p.x - halfSize.x, p.x + halfSize.x do
				if mode == 'spawn' then
					do
						local tile, i, j = map:getTileAt(x, p.z)
						tile:setFlag('wall-top')
					end

					do
						local tile, i, j = map:getTileAt(x, p.z)
						tile:setFlag('wall-bottom')
					end
				elseif mode == 'poof' then
					do
						local tile, i, j = map:getTileAt(x, p.z)
						tile:unsetFlag('wall-top')
					end

					do
						local tile, i, j = map:getTileAt(x, p.z)
						tile:unsetFlag('wall-bottom')
					end
					do
						local tile, i, j = map:getTileAt(x, p.z)

						for k in pairs(tile.flags) do
						end
					end
				end
			end
		end
	end
end

function BasicDoor:getPropState()
	return { open = self.isOpen }
end

return BasicDoor
