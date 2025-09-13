--------------------------------------------------------------------------------
-- Resources/Peeps/Props/CraftedItem.lua
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
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"

local CraftedItem = Class(Prop) 
CraftedItem.DURATION = 10

function CraftedItem:new(...)
	Prop.new(self, ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(0, 0, 0)

	local static = self:getBehavior(StaticBehavior)
	static.type = StaticBehavior.PASSABLE

	self.inputItemIDs = {}
	self.outputItemIDs = {}

	self.duration = math.huge

	self:addPoke("make")
end

function CraftedItem:onMake(e)
	local action = e and e.action
	if not action then
		return
	end

	local constraints = Utility.getActionConstraints(
		self:getDirector():getGameInstance(),
		e.action:getAction())

	table.clear(self.inputItemIDs)
	for _, input in ipairs(constraints.inputs) do
		if input.type == "Item" then
			for i = 1, math.min(input.count, 5) do
				table.insert(self.inputItemIDs, input.resource)
			end
		end
	end

	table.clear(self.outputItemIDs)
	for _, output in ipairs(constraints.outputs) do
		if output.type == "Item" then
			for i = 1, math.min(output.count, 5) do
				table.insert(self.outputItemIDs, output.resource)
			end
		end
	end

	self.duration = self.DURATION
end

function CraftedItem:spawnOrPoofTile(tile, i, j, mode)
	-- Nothing.
end

function CraftedItem:getPropState()
	local hasInputsOrOutputs = #self.inputItemIDs > 0 or #self.outputItemIDs > 0
	return {
		despawning = self.duration ~= math.huge or _APP,
		inputs = hasInputsOrOutputs and self.inputItemIDs,
		outputs = hasInputsOrOutputs and self.outputItemIDs
	}
end

function CraftedItem:update(...)
	Prop.update(self, ...)

	if self.duration ~= math.huge then
		local delta = self:getDirector():getGameInstance():getDelta()

		self.duration = math.max(self.duration - delta, 0)
		if self.duration <= 0 then
			Utility.Peep.poof(self)
		end
	end
end

return CraftedItem
