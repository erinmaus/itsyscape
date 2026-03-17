--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Gatherable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DropTable = require "ItsyScape.Game.DropTable"
local GatherableInstance = require "ItsyScape.Game.GatherableInstance"
local Utility = require "ItsyScape.Game.Utility"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local GatherableBehavior = require "ItsyScape.Peep.Behaviors.GatherableBehavior"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"

local Gatherable = {}

Gatherable.DEFAULT_PROPS = {
	minRadius = 0.5,
	maxRadius = 1,
	minScale = 0.25,
	maxScale = 0.5
}

function Gatherable.generate(propPeep, playerPeep, dropTable, maxRolls, props)
	props = props or Gatherable.DEFAULT_PROPS

	if not maxRolls then
		local numerator = math.max(propPeep:hasBehavior(PropResourceHealthBehavior) and propPeep:getBehavior(PropResourceHealthBehavior).maxProgress or 1, 1)
		local denominator = 10

		maxRolls = math.max(math.ceil(numerator / denominator), 1)
	end

	if not dropTable then
		dropTable = DropTable()
		dropTable:fromGatherables(propPeep, playerPeep)
	end

	local gatherable = propPeep:getBehavior(GatherableBehavior)
	if gatherable then
		gatherable.generation = gatherable.generation + 1
		table.clear(gatherable.instances)
	else
		local _, b = propPeep:addBehavior(GatherableBehavior)
		gatherable = b
	end

	local baseGatherable = Gatherable(
		propPeep:getDirector():getGameInstance(),
		Utility.Peep.getResource(propPeep))

	for _, model in baseGatherable:iterateModels() do
		local baseGatherableInstance = GatherableInstance(propPeep, false, baseGatherable, model)
		table.insert(gatherable.instances, gatherableInstance)
	end

	local gameDB = propPeep:getDirector():getGameInstance()

	local rolls = love.math.random(0, maxRolls)
	for i = 1, rolls do
		local entry = dropTable:roll()
		local drop = entry and entry:getDrop()

		if Class.isCompatibleType(drop, DropTable.ActionDrop) then
			local gatherableAction = gameDB:getRecord("GatherableAction", {
				Action = drop:getActionInstance():getAction()
			})

			if gatherableAction then
				local secondaryGatherable = Gatherable(
					propPeep:getDirector():getGameInstance(),
					gatherableAction:get("Gatherable"))

				local rotationYAngle = love.math.random() * math.pi * 2
				local rotationXAngle = love.math.random() * math.pi

				local position
				do
					local rotationY = Quaternion.fromAxisAngle(Vector.UNIT_Y, rotationYAngle)
					local rotationX = Quaternion.fromAxisAngle(Vector.UNIT_X, rotationXAngle)
					local rotation = (rotationY * rotationX):getNormal()

					local up = Vector(
						0,
						love.math.random() * (props.maxRadius - props.minRadius) + props.minRadius,
						0)

					position = rotation:transformVector(up)
				end

				local rotation = Quaternion.lookAt(Vector.ZERO, position, Vector.UNIT_Y)
				local scale = Vector(love.math.random() * (props.maxScale - props.minScale) + props.minScale)

				local transform = Gatherable.Transform(
					position,
					rotation,
					scale)

				local secondaryGatherableInstance = GatherableInstance(
					propPeep,
					drop:getActionInstance(),
					secondaryGatherable)

				table.insert(gatherable.instances, secondaryGatherableInstance)
			end
		end
	end
end

return Gatherable
