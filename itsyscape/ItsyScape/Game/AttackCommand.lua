--------------------------------------------------------------------------------
-- ItsyScape/Game/AttackCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local AttackCommand = Class(Command)

function AttackCommand:new()
	Command.new(self)

	self.finished = false
end

function AttackCommand:getIsFinished()
	return self.finished
end

function AttackCommand:onInterrupt(peep)
	peep:removeBehavior(CombatTargetBehavior)
end

function AttackCommand:update(delta, peep)
	self.finished = not peep:hasBehavior(CombatTargetBehavior)
end

return AttackCommand
