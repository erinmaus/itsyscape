--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Fish/AncientKaradon.lua
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
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local AncientKaradon = Class(Creep)

function AncientKaradon:new(resource, name, ...)
	Creep.new(self, resource, name or 'AncientKaradon', ...)
end

function AncientKaradon:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(6.5, 8.5, 6.5)
	size.offset = Vector.UNIT_Y * 4

	local status = self:getBehavior(CombatStatusBehavior)
	status.currentHitpoints = 400
	status.maximumHitpoints = 400
	status.maxChaseDistance = math.huge

	self:addBehavior(RotationBehavior)

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/AncientKaradon.lskel")
	actor:setBody(body)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Fish/AncientKaradon.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, skin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/AncientKaradon_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	Creep.ready(self, director, game)
end

function AncientKaradon:update(...)
	Creep.update(self, ...)

	Utility.Peep.face3D(self)
end

return AncientKaradon