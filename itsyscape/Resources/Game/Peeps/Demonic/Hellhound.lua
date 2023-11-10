--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Demonic/Hellhound.lua
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
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Hellhound = Class(Creep)

function Hellhound:new(resource, name, ...)
	Creep.new(self, resource, name or 'Hellhound', ...)

	local size = self:getBehavior(SizeBehavior)
	size.size = Vector(2.5, 2, 1)
	size.pan = Vector(-1, 1, 0)
	size.zoom = 2
end

function Hellhound:ready(director, game)
	local actor = self:getBehavior(ActorReferenceBehavior)
	if actor and actor.actor then
		actor = actor.actor
	end

	local body = CacheRef(
		"ItsyScape.Game.Body",
		"Resources/Game/Bodies/Dog.lskel")
	actor:setBody(body)

	local idleAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_IdleStand/Script.lua")
	self:addResource("animation-idle", idleAnimation)

	local idleStandAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_IdleStand/Script.lua")
	self:addResource("animation-idle-stand", idleStandAnimation)

	local idleSitAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_IdleSit/Script.lua")
	self:addResource("animation-idle-sit", idleSitAnimation)

	local walkAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_Walk/Script.lua")
	self:addResource("animation-walk", walkAnimation)

	local dieAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_Die/Script.lua")
	self:addResource("animation-die", dieAnimation)

	local attackAnimation = CacheRef(
		"ItsyScape.Graphics.AnimationResource",
		"Resources/Game/Animations/Dog_Attack/Script.lua")
	self:addResource("animation-attack", attackAnimation)

	local skin = CacheRef(
		"ItsyScape.Game.Skin.ModelSkin",
		"Resources/Game/Skins/Hellhound/Hellhound.lua")
	actor:setSkin(Equipment.PLAYER_SLOT_BODY, 0, skin)

	Utility.Peep.equipXWeapon(self, "Hellhound_Attack")

	Creep.ready(self, director, game)
end

return Hellhound
