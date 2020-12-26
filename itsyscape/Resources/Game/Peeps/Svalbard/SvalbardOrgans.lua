--------------------------------------------------------------------------------
-- Resources/Peeps/Svalbard/SvalbardsOrgans.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local SvalbardsOrgans = Class(Creep)

function SvalbardsOrgans:new(resource, name, ...)
	Creep.new(self, resource, name or 'SvalbardsOrgans', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 1.5, 7)

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 2000
	status.maximumHitpoints = 2000
end

function SvalbardsOrgans:onHit()
	local status = self:getBehavior(CombatStatusBehavior)

	if self.svalbard then
		self.svalbard:poke('organsHit', status.maximumHitpoints - status.currentHitpoints)
	end
end

function SvalbardsOrgans:onSvalbardDead()
	Utility.Peep.poof(self)
end

function SvalbardsOrgans:onDie()
	if self.svalbard then
		self.svalbard:poke('organsDie')
	end

	Utility.Peep.poof(self)
end

function SvalbardsOrgans:onBoss(svalbard)
	self.svalbard = svalbard

	self.svalbard:listen('onDie', self.onSvalbardDead, self)
end

function SvalbardsOrgans:update(...)
	Creep.update(self, ...)

	if self.svalbard then
		local selfPosition = self:getBehavior(PositionBehavior)
		local svalbardPosition = self.svalbard:getBehavior(PositionBehavior)
		selfPosition.position = Vector(svalbardPosition.position:get())
	end
end

return SvalbardsOrgans
