--------------------------------------------------------------------------------
-- ItsyScape/Game/LocalModel/Prop.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Prop = require "ItsyScape.Game.Model.Prop"
local Utility = require "ItsyScape.Game.Utility"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local LocalProp = Class(Prop)

function LocalProp:new(game, peepType)
	Prop.new(self)

	self.game = game
	self.id = Prop.NIL_ID
	self.peepType = peepType
end

function LocalProp:getPeep()
	return self.peep
end

function LocalProp:place(id, group, resource, ...)
	assert(self.id == Prop.NIL_ID, "Prop already spawned")

	self.peep = self.game:getDirector():addPeep(group, self.peepType, resource, ...)
	local _, propReference = self.peep:addBehavior(PropReferenceBehavior)
	propReference.prop = self

	self.id = id
	self.resource = resource or false	
end

function LocalProp:remove()
	assert(self.id ~= Prop.NIL_ID, "Prop not spawned")

	self.game:getDirector():removePeep(self.peep)
	self.peep = nil

	self.id = Prop.NIL_ID
end

function LocalProp:getID()
	return self.id
end

function LocalProp:getName()
	return self.peep:getName()
end

function LocalProp:getDescription()
	return Utility.Peep.getDescription(self.peep)
end

function LocalProp:getResourceType()
	error("nyi")
end

function LocalProp:getResourceName()
	if self.peep then
		return Utility.Peep.getResource(self.peep).name
	end

	return nil
end

function LocalProp:setName(value)
	self.peep:setName(value)
end

function LocalProp:getPosition()
	if not self.peep then
		return Vector.ZERO
	end

	local position = self.peep:getBehavior(PositionBehavior)
	if position then
		return position.position
	else
		return Vector.ZERO
	end
end

function LocalProp:getRotation()
	return Quaternion.IDENTITY
end

function LocalProp:getScale()
	return Vector.ONE
end

function LocalProp:getTile()
	if not self.peep then
		return 0, 0, 0
	end

	local position = self.peep:getBehavior(PositionBehavior)
	if position then
		local map = self.game:getDirector():getMap(position.layer or 1)
		local i, j = map:getTileAt(position.position.x, position.position.z)

		return i, j, position.layer or 1
	else
		return 0, 0, 0
	end
end

-- Returns the bounds, as (min, max).
function LocalProp:getBounds()
	if not self.peep then
		return Vector.ZERO, Vector.ZERO
	end

	local position = self:getPosition()

	local size = self.peep:getBehavior(SizeBehavior)
	if size then
		local xzSize = Vector(size.size.x / 2, 0, size.size.z / 2)
		local ySize = Vector(0, size.size.y, 0)
		local min = position - xzSize
		local max = position + xzSize + ySize

		return min + size.offset, max + size.offset
	else
		return position, position
	end
end

function LocalProp:getActions(scope)
	if self.resource then
		local actions = Utility.getActions(self.game, self.resource, scope or 'world')
		if self.peep then
			local mapObject = Utility.Peep.getMapObject(self.peep)
			if mapObject then
				local proxyActions = Utility.getActions(self.game, mapObject, scope or 'world')

				for i = 1, #proxyActions do
					table.insert(actions, proxyActions[i])
				end
			end
		end

		return actions
	else
		return {}
	end
end

function LocalProp:poke(action, scope)
	if self.resource then
		local player = self.game:getPlayer():getActor():getPeep()
		local peep = self:getPeep()
		local s = Utility.performAction(
			self.game,
			self.resource,
			action,
			scope,
			player:getState(), player, peep)
		local m = Utility.Peep.getMapObject(peep)
		if not s and m then
			Utility.performAction(
				self.game,
				m,
				action,
				scope,
				player:getState(), player, peep)
		end
	end
end

function LocalProp:getState()
	local peep = self:getPeep()
	if peep and peep.getPropState then
		return peep:getPropState()
	else
		return {}
	end
end

return LocalProp
