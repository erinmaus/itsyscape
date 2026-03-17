--------------------------------------------------------------------------------
-- ItsyScape/Game/Power.lua
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
local OldOneDescriptionBehavior = require "ItsyScape.Peep.Behaviors.OldOneDescriptionBehavior"

local Power = Class()
Power.RITE_CIRCLE_ELEVATION     = 0.1
Power.RITE_CIRCLE_SIZE_BUMP     = 3
Power.RITE_CIRCLE_MIN_SIZE      = 8
Power.RITE_CIRCLE_FADE_DELAY    = 2
Power.RITE_CIRCLE_FADE_DURATION = 0.5

function Power:new(game, resource, ...)
	self.game = game
	self.resource = resource

	local gameDB = game:getGameDB()
	self.name = Utility.getName(resource, gameDB)
	self.description = Utility.getDescription(resource, gameDB)

	local spec = gameDB:getRecord("PowerSpec", {
		Resource = resource
	})

	if spec then
		self.isInstant = false
		self.isQuick = false
		self.requiresTarget = spec:get("NoTarget") == 0
	end

	local actions = Utility.getActions(game, resource, 'self')
	for i = 1, #actions do
		if actions[i].instance:is("Activate") then
			self.action = actions[i].instance
		end
	end
end

function Power:getGame()
	return self.game
end

function Power:getResource()
	return self.resource
end

function Power:getName()
	return self.name
end

function Power:getDescription()
	return self.description
end

function Power:getAction()
	return self.action or false
end

-- Returns true if there should be no weapon cooldown applied,
-- false otherwise. Defaults to false.
function Power:getIsQuick()
	return self.isQuick or false
end

-- Returns true if the power should be instantly activated, regardless of weapon cooldown,
-- or false otherwise. Defaults to false.
function Power:getIsInstant()
	return self.isInstant or false
end

-- Returns true if the power requires a target, false otherwise.
function Power:getRequiresTarget()
	if self.requiresTarget == nil then
		return true
	else
		return self.requiresTarget
	end
end

function Power:perform(activator, target)
	if not self:getAction():perform(activator:getState(), activator, target) then
		self:getAction():fail(activator:getState(), activator)
		return false
	end

	return true
end

function Power:showRiteCircle(activator, target)
	local mapScript = Utility.Peep.getMapScript(activator)
	if not mapScript then
		return false
	end

	local position = Utility.Peep.getPosition(activator)

	local glyphProp = Utility.spawnPropAtPosition(
		mapScript,
		"ProjectedGlyph",
		position.x, position.y + self.RITE_CIRCLE_ELEVATION, position.z)
	if not glyphProp then
		return false
	end

	local glyphPeep = glyphProp:getPeep()

	local size = Utility.Peep.getSize(activator)
	size = size + self.RITE_CIRCLE_SIZE_BUMP
	size = size:max(Vector(self.RITE_CIRCLE_MIN_SIZE))
	Utility.Peep.setSize(glyphPeep, size)

	local _, description = glyphPeep:addBehavior(OldOneDescriptionBehavior)
	description.description = Utility.getOldOneDescription(
		self.resource,
		self.game:getGameDB())

	glyphPeep:listen("finalize", function()
		glyphPeep:pushPoke("fade", self.RITE_CIRCLE_FADE_DURATION, self.RITE_CIRCLE_FADE_DELAY)
	end)

	return true
end

function Power:activate(activator, target)
	activator:poke('powerActivated', {
		power = self,
		target = target,
		action = self:getAction()
	})

	if target then
		target:poke('powerApplied', {
			power = self,
			activator = activator,
			action = self:getAction()
		})
	end

	self:showRiteCircle(activator, target)
end

function Power:getCost(peep)
	return 1
end

return Power
