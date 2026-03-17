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
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local DoorBehavior = require "ItsyScape.Peep.Behaviors.DoorBehavior"

local BasicDoor = Class(Prop)

function BasicDoor:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3.5, 3, 1.5)

	self:addPoke("open")
	self:addPoke("close")
	self:addPoke("stuck")

	local static = self:getBehavior(StaticBehavior)
	static.type = StaticBehavior.BLOCKING

	self:addBehavior(DoorBehavior)
end

function BasicDoor:getIsOpen()
	return self:hasBehavior(DoorBehavior) and self:getBehavior(DoorBehavior).isOpen
end

function BasicDoor:canOpen(peep)
	return true
end

function BasicDoor:canClose(peep)
	return true
end

function BasicDoor:previewOpen(peep, action, force)
	if self:canOpen(peep) or force then
		local door = self:getBehavior(DoorBehavior)
		if door then
			door.openLock = door.openLock + 1
			door.isOpen = door.openLock >= 1
			return
		end
	end

	self:poke("stuck", peep, action)
end

function BasicDoor:previewClose(peep, action, force)
	if self:canClose(peep) or force then
		local door = self:getBehavior(DoorBehavior)
		if door then
			door.openLock = door.openLock - 1
			door.isOpen = door.openLock <= 0
		end
	end

	self:poke("stuck", peep, action)
end

function BasicDoor:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:setRuntimeFlag('door')
		tile:addLink(self)
	else
		tile:unsetRuntimeFlag('door')
		tile:removeLink(self)
	end
end

function BasicDoor:getPropState()
	return { open = self:getIsOpen() }
end

return BasicDoor
