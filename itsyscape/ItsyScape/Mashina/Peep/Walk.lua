--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Walk.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Walk = B.Node("PeepWalk")
Walk.TARGET = B.Reference()
Walk.DISTANCE = B.Reference()
Walk.AS_CLOSE_AS_POSSIBLE = B.Reference()

function Walk:update(mashina, state, executor)
	local target = state[self.TARGET]
	if not target then
		return B.Status.Failure
	end

	local position
	if Class.isCompatibleType(target, Vector) then
		position = target
	elseif Class.isCompatibleType(target, Peep) then
		position = Utility.Peep.getPosition(target)
	elseif type(target) == "string" then
		local map = Utility.Peep.getMapResource(mashina)
		local game = mashina:getDirector():getGameInstance()

		position = Vector(Utility.Map.getAnchorPosition(game, map, target))
	else
		return B.Status.Failure
	end

	local map = Utility.Peep.getMap(mashina)
	if not map then
		return B.Status.Failure
	end

	local _, i, j = map:getTileAt(position.x, position.z)
	local k = Utility.Peep.getLayer(mashina)

	local s
	if not self.walk or self.i ~= i or self.j ~= j or self.k ~= k then
		self.i = i
		self.j = j
		self.k = k
		self.walk = coroutine.wrap(Utility.Peep.walk)

		s = self.walk(mashina, i, j, k, state[self.DISTANCE], {
			asCloseAsPossible = state[self.AS_CLOSE_AS_POSSIBLE],
			yield = true,
			isCutscene = true
		})
	else
		s = self.walk()
	end

	if s ~= nil then
		self.i = nil
		self.j = nil
		self.k = nil
		self.walk = nil

		if s then
			return B.Status.Success
		else
			return B.Status.Failure
		end
	else
		return B.Status.Working
	end
end

function Walk:deactivated()
	self.i = nil
	self.j = nil
	self.k = nil
	self.walk = nil
end

return Walk
