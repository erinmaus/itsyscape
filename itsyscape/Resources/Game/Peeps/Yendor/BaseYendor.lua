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
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local BaseYendor = Class(Creep)

function BaseYendor:new(resource, name, ...)
	Creep.new(self, resource, name or 'Yendor', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(15, 15, 40)

	self:addBehavior(RotationBehavior)
end

function BaseYendor:onResurrect()
	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendor_Idle_Alive/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local riseAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendor_Rise/Script.lua")
	self:addResource("animation-idle", riseAnimation)

	local actor = self:getBehavior(ActorReferenceBehavior)
	actor = actor and actor.actor
	if actor then
		actor:playAnimation('combat', 1000, riseAnimation, true, 0)
		actor:playAnimation('main', 1, idleAnimation)
	end
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

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Yendor_Attack_Magic/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	Creep.ready(self, director, game)
end

return BaseYendor
