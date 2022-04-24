--------------------------------------------------------------------------------
-- Resources/Peeps/Yendor/BaseYendor.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Equipment = require "ItsyScape.Game.Equipment"
local Creep = require "ItsyScape.Peep.Peeps.Creep"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseYendor = Class(Creep)

function BaseYendor:new(resource, name, ...)
	Creep.new(self, resource, name or 'Yendor', ...)
end

function BaseYendor:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local status = self:getBehavior(CombatStatusBehavior)
	status.maximumHitpoints = 40000
	status.currentHitpoints = 40000	

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Yendor.lskel")
	actor:setBody(body)

	local bodySkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendor/Yendor_Body.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, Equipment.SKIN_PRIORITY_BASE, bodySkin)

	local skullSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendor/Yendor_Skull.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_BASE, skullSkin)

	local brainSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendor/Yendor_Brain.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_HEAD, Equipment.SKIN_PRIORITY_EQUIPMENT, brainSkin)

	local crystalSkin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Yendor/Yendor_Crystal.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_NECK, Equipment.SKIN_PRIORITY_BASE, crystalSkin)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendor_Idle/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	Creep.ready(self, director, game)
end

return BaseYendor
