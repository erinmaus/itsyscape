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
	size.size = Vector(3.5, 3, 1)

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

function BasicDoor:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:setFlag('door')
		tile:addLink(self)
	else
		tile:unsetFlag('door')
		tile:removeLink(self)
	end
end

function BasicDoor:getPropState()
	return { open = self.isOpen }
end

return BasicDoor
