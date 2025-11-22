--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Component = require "ItsyScape.Game.ActionCommands.Component"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"

local Peep = Class(Component)
Peep.TYPE = "peep"

function Peep:new()
	Component.new(self)

	self.peep = false
	self.offset = Vector.UNIT_Y
end

function Peep:setPeep(value)
	self.peep = value or false
end

function Peep:getPeep()
	return self.peep
end

function Peep:setOffset(value)
	self.offset = value
end

function Peep:getOffset()
	return self.offset
end

function Peep:serialize(t)
	Component.serialize(self, t)

	t.peepType = false
	t.peepID = false
	t.offset = { self.offset:get() }

	if not self.peep then
		return
	end

	local actor = self.peep:getBehavior(ActorReferenceBehavior)
	local prop = self.peep:getBehavior(PropReferenceBehavior)

	if actor and actor.actor then
		t.peepType = "actor"
		t.peepID = actor.actor:getID()
	elseif prop and prop.prop then
		t.peepType = "prop"
		t.peepID = prop.prop:getID()
	end
end

return Peep
