--------------------------------------------------------------------------------
-- Resources/Peeps/Props/CutsceneDoor.lua
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

local CutsceneDoor = Class(Prop)

function CutsceneDoor:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(3.5, 3, 1.5)

	self:addPoke('open')
	self:addPoke('close')

	self.openLock = 0
end

function CutsceneDoor:getIsOpen()
	return self.openLock > 0
end

function CutsceneDoor:canOpen()
	return true
end

function CutsceneDoor:previewOpen(peep, force)
	if self:canOpen() or force then
		self.openLock = self.openLock + 1

		self:spawnOrPoof('poof')
	end
end

function CutsceneDoor:previewClose(...)
	self.openLock = self.openLock - 1

	self:spawnOrPoof('spawn')
end

function CutsceneDoor:spawnOrPoofTile(tile, i, j, mode)
	if mode == 'spawn' then
		tile:setRuntimeFlag('door')
		tile:addLink(self)
	else
		tile:unsetRuntimeFlag('door')
		tile:removeLink(self)
	end
end

function CutsceneDoor:getPropState()
	return { open = self.openLock > 0 }
end

return CutsceneDoor
