--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Chicken/HaruChicken.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local BaseChicken = require "Resources.Game.Peeps.Chicken.BaseChicken"

local HaruChicken = Class(BaseChicken)
HaruChicken.SIZES = {
	1,
	1.5,
	2,
	3,
	4
}

HaruChicken.HATS = {
	"Resources/Game/Skins/Chicken/Hat_Pirate.lua",
	"Resources/Game/Skins/Chicken/Hat_Sailor.lua"
}

function HaruChicken:new(resource, name, ...)
	BaseChicken.new(self, resource, name or 'Chicken_Haru', ...)

	local factor = HaruChicken.SIZES[math.random(#HaruChicken.SIZES)]
	local size = self:getBehavior(SizeBehavior)
	size.size = size.size * factor

	local _, scale = self:addBehavior(ScaleBehavior)
	scale.scale = Vector(factor)

	local movement = self:getBehavior(MovementBehavior)
	movement.bounce = 0.9
	movement.bounceThreshold = 2.5
	movement.maxSpeed = math.huge
	movement.maxAcceleration = math.huge
	movement.maxStepHeight = math.huge
end

function HaruChicken:ready(director, game)
	BaseChicken.ready(self, director, game)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local hat = HaruChicken.HATS[math.random(#HaruChicken.HATS)]
	if hat then
		local hat = CacheRef("ItsyScape.Game.Skin.ModelSkin", hat)
		actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_EQUIPMENT, hat)
	end
end

return HaruChicken
