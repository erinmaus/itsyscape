--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Veggies/GreenPepper.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local BaseVeggie = require "Resources.Game.Peeps.Veggies.BaseVeggie"

local GreenPepper = Class(BaseVeggie)

function GreenPepper:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Veggie_Attack_Melee/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Veggies/GreenPepper.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Utility.Peep.equipXWeapon(self, "GreenPepper_Attack_Melee")

	BaseVeggie.ready(self, director, game)
end

return GreenPepper
