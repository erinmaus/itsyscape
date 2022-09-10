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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
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
HaruChicken.HEALTH = {
	10,
	15,
	20,
	30,
	40
}

HaruChicken.DIRECTIONS = {
	MovementBehavior.FACING_LEFT,
	MovementBehavior.FACING_RIGHT
}

HaruChicken.HATS = {
	"Resources/Game/Skins/Chicken/Hat_Pirate.lua",
	"Resources/Game/Skins/Chicken/Hat_Sailor.lua"
}

function HaruChicken:new(resource, name, ...)
	BaseChicken.new(self, resource, name or 'Chicken_Haru', ...)

	local index = math.random(#HaruChicken.SIZES)
	local factor = HaruChicken.SIZES[index]
	local size = self:getBehavior(SizeBehavior)
	size.size = size.size * factor

	local _, scale = self:addBehavior(ScaleBehavior)
	scale.scale = Vector(factor)

	local movement = self:getBehavior(MovementBehavior)
	movement.bounce = 0.9
	movement.bounceThreshold = 2.5
	movement.maxSpeed = 8
	movement.maxAcceleration = 8
	movement.maxStepHeight = math.huge

	local combatStatus = self:getBehavior(CombatStatusBehavior)
	combatStatus.currentHitpoints = HaruChicken.HEALTH[index]
	combatStatus.maximumHitpoints = HaruChicken.HEALTH[index]
	
	self:silence('receiveAttack', Utility.Peep.Attackable.aggressiveOnReceiveAttack)
	self:listen('receiveAttack', Utility.Peep.Attackable.onReceiveAttack)
end

function HaruChicken:onHit()
	local map = Utility.Peep.getMap(self)

	local i, j, k
	repeat
		local testI = math.random(1, map:getWidth())
		local testJ = math.random(1, map:getHeight())
		local tile = map:getTile(testI, testJ)

		if not tile:hasFlag('impassable') then
			i, j = testI, testJ

			local currentI, currentJ, currentK = Utility.Peep.getTile(self)
			k = currentK
		end
	until i and j

	Utility.Peep.walk(self, i, j, k)

	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
		actor:flash("Message", 1, "BWAK BWAK BWAK!")

		local bwakAnimation = CacheRef(
			"ItsyScape.Graphics.AnimationResource",
			"Resources/Game/Animations/SFX_ChickenQuack/Script.lua")
		actor:playAnimation(
			'minigame-chicken-dash',
			1,
			bwakAnimation,
			true)
	end
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

	local movement = self:getBehavior(MovementBehavior)
	movement.facing = HaruChicken.DIRECTIONS[math.random(#HaruChicken.DIRECTIONS)]
	movement.targetFacing = movement.facing
end

return HaruChicken
