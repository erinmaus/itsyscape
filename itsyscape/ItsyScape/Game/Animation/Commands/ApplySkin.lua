--------------------------------------------------------------------------------
-- ItsyScape/Game/Animation/Commands/ApplySkin.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local Command = require "ItsyScape.Game.Animation.Commands.Command"
local ApplySkinInstance = require "ItsyScape.Game.Animation.Commands.ApplySkinInstance"

-- Command to wait.
--
-- Takes the form:
--
-- ApplySkin "<Filename>" {
--   [duration = number (0)]
--   [type = string (ItsyScape.Game.Skin.ModelSkin)]
--   [slot = number (Equipment.PLAYER_SLOT_SELF)]
--   [priority = number (Equipment.SKIN_PRIORITY_EQUIPMENT_OVERRIDE)]
-- }
local ApplySkin, Metatable = Class(Command)

-- Constructs a new ApplySkin command.
function ApplySkin:new(filename)
	self.skinFilename = filename
	self.type = "ItsyScape.Game.Skin.ModelSkin"
	self.slot = Equipment.PLAYER_SLOT_SELF
	self.priority = Equipment.SKIN_PRIORITY_EQUIPMENT_OVERRIDE
	self.duration = duration or 0
end

function Metatable:__call(t)
	t = t or {}

	self:setSkinType(t.type)
	self:setSlot(t.slot)
	self:setPriority(t.priority)
	self:setDuration(t.duration)

	return self
end

function ApplySkin:instantiate()
	return ApplySkinInstance(self)
end

function ApplySkin:getFilename()
	return self.skinFilename
end

function ApplySkin:setSkinType(value)
	self.type = value or self.type
end

function ApplySkin:getSkinType()
	return self.type
end

function ApplySkin:setSlot(value)
	self.slot = value or self.slot
end

function ApplySkin:getSlot()
	return self.slot
end

function ApplySkin:setPriority(value)
	self.priority = value or self.priority
end

function ApplySkin:getPriority()
	return self.priority
end

function ApplySkin:setDuration(value)
	self.duration = value or self.duration
end

function ApplySkin:getDuration()
	return self.duration
end

return ApplySkin
