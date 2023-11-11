--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Flowers/DeadDandy.lua
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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local BaseVeggie = require "Resources.Game.Peeps.Veggies.BaseVeggie"

local DeadDandy = Class(BaseVeggie)

function DeadDandy:new(...)
	BaseVeggie.new(self, ...)

	self:addBehavior(RotationBehavior)
end

function DeadDandy:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Veggie_Attack_Magic/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local body = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Dandy/DeadDandy.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, body)

	Utility.Peep.equipXWeapon(self, "Dandy_Attack_Magic")

	BaseVeggie.ready(self, director, game)
end

function DeadDandy:update(...)
	BaseVeggie.update(self, ...)

	Utility.Peep.face3D(self)
end

return DeadDandy
