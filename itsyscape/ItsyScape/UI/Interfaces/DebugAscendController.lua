--------------------------------------------------------------------------------
-- ItsyScape/UI/DebugAscendController.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Controller = require "ItsyScape.UI.Controller"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local StatsBehavior = require "ItsyScape.Peep.Behaviors.StatsBehavior"

local DebugAscendController = Class(Controller)

function DebugAscendController:new(peep, director)
	Controller.new(self, peep, director)
end

function DebugAscendController:poke(actionID, actionIndex, e)
	if actionID == "ascend" then
		self:ascend(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function DebugAscendController:ascend(e)
	assert(type(e.level) == "number", "level must be number")
	assert(type(e.boost) == "number", "boost must be number")

	local stats = self:getPeep():getBehavior(StatsBehavior)
	stats = stats and stats.stats

	if not stats then
		return
	end

	if e.skill and stats:hasSkill(e.skill) then
		local skill = stats:getSkill(e.skill)
		skill:setXP(Curve.XP_CURVE(e.level))
		skill:setLevelBoost(e.boost)
	else
		for skill in stats:iterate() do
			skill:setXP(Curve.XP_CURVE(e.level))
			skill:setLevelBoost(e.boost)
		end
	end

	local status = self:getPeep():getBehavior(CombatStatusBehavior)
	if e.skill == "Constitution" then
		status.currentHitpoints = e.level + e.boost
		status.maximumHitpoints = e.level + e.boost
	else
		status.currentHitpoints = stats:getSkill("Constitution"):getWorkingLevel()
		status.maximumHitpoints = stats:getSkill("Constitution"):getWorkingLevel()
	end
end

function DebugAscendController:update(delta)
	Controller.update(self, delta)

	local status = self:getPeep():getBehavior(CombatStatusBehavior)
	if status then
		status.currentZeal = 1
	end
end

return DebugAscendController
