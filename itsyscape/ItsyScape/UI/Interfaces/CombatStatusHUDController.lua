--------------------------------------------------------------------------------
-- ItsyScape/UI/CombatStatusHUDController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local Effect = require "ItsyScape.Peep.Effect"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"

local CombatStatusHUDController = Class(Controller)
CombatStatusHUDController.VIEW_SELF = 1
CombatStatusHUDController.VIEW_TARGET = 2

function CombatStatusHUDController:new(peep, director)
	Controller.new(self, peep, director)

	self.currentInterfaceID = false
	self.currentInterfaceIndex = false

	self:updateState()
end

function CombatStatusHUDController:poke(actionID, actionIndex, e)
	if actionID == "toggle" then
		self:toggle()
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CombatStatusHUDController:pull(e)
	return self.state
end

function CombatStatusHUDController:toggle()
	if self.view == CombatStatusHUDController.VIEW_TARGET then
		self.view = CombatStatusHUDController.VIEW_SELF
	elseif self.view == CombatStatusHUDController.VIEW_SELF then
		self.view = CombatStatusHUDController.VIEW_TARGET
	else
		Log.warn("Unknown combat bar target view enum (%d); defaulting to self.", self.view)
		self.view = CombatStatusHUDController.VIEW_SELF
	end
end

function CombatStatusHUDController:updateState()
	local gameDB = self:getDirector():getGameDB()

	local result = {
		effects = {},
		stats = {}
	}

	local peep = self:getPeep()
	if self.view == CombatStatusHUDController.VIEW_TARGET then
		local target = peep:getBehavior(CombatTargetBehavior)
		if target and target.actor then
			peep = target.actor:getPeep()
		else
			self.view = CombatStatusHUDController.VIEW_SELF
		end
	end

	do
		local actor = peep:getBehavior(ActorReferenceBehavior)
		if actor and actor.actor then
			result.actor = actor.actor:getID()
		end
	end

	-- Effects.
	do
		local peep = self:getPeep()
		for effect in peep:getEffects() do
			local resource = effect:getResource()
			local e = {
				id = resource.name,
				name = Utility.getName(resource, gameDB),
				description = Utility.getDescription(resource, gameDB),
				duration = effect:getDuration(),
				debuff = effect:getBuffType() == Effect.BUFF_TYPE_NEGATIVE,
				buff = effect:getBuffType() == Effect.BUFF_TYPE_POSITIVE
			}

			table.insert(result.effects, e)
		end
	end

	-- Stats
	do
		local status = peep:getBehavior(CombatStatusBehavior)
		if status then
			result.stats.prayer = {
				current = status.currentPrayer,
				max = status.maximumPrayer
			}

			result.stats.hitpoints = {
				current = status.currentHitpoints,
				max = status.maximumHitpoints
			}
		else
			result.stats = {
				prayer = { current = 0, max = 0 },
				hitpoints = { current = 0, max = 0 }
			}
		end
	end

	self.state = result
end

function CombatStatusHUDController:update(delta)
	Controller.update(self, delta)

	self:updateState()
end

return CombatStatusHUDController
